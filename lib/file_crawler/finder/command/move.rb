require 'fileutils'

module FileCrawler::Finder::Command

  module Move

    def move(destination, options={dry_run: true})
      tap {
        target = @collections.empty? ? @files : @collections
        fixer = Fixer.new
        @targets = fixer.make_new_path(target, destination)

        if !options[:dry_run]
          fixer.make_mv(@targets).each {|cmd|
            exec(cmd)
          }
        end
      }
    end

    def cmds
      return nil if @targets.nil?

      fixer = Fixer.new
      fixer.make_mv(@targets)
    end

    class Fixer

      def make_new_path(sources, destination)
        case sources
        when Hash
          return make_new_path_for_collection(sources, destination)
        when Array
          return make_new_path_for_array(sources, destination)
        when String
          return make_new_path_for_array([sources], destination)
        end

        ArgumentError
      end

      def make_mv(filepaths)
        cmds = []
        mkdirs = []
        make_fixed_paths(filepaths).map {|file|
          mkdirs << "mkdir -p #{File.dirname(file[1])}"
          cmds << "mv #{file[0]} #{file[1]}"
        }

        mkdirs.uniq + cmds
      end

      def make_fixed_paths(filepaths)
        dest = []
        filepaths.each {|filepath|
          fixed_path = fix_path(filepath[1], dest)
          filepath[1] = fixed_path
          dest << fixed_path
        }

        filepaths
      end

      def fix_path(filepath, check_array, index=0)
        newpath = filepath
        newpath = "#{filepath} (#{index})" if index > 0
        return fix_path(filepath, check_array, index + 1) if exist?(newpath, check_array)

        newpath
      end

      private
      def exist?(filepath, check_array)
        return true if File.exist?(filepath)

        check_array.include?(filepath)
      end

      def make_new_path_for_array(sources, destination)
        result = []
        sources.each {|path|
          result << [path, new_path(path, destination)]
        }

        result
      end

      def make_new_path_for_collection(sources, destination)
        result = []
        sources.each {|dirname, paths|
          new_dir = destination + '/' + dirname.to_s
          paths.each {|path|
            result << [path, new_path(path, new_dir)]
          }
        }

        result
      end

      def new_path(source, destination)
        destination + '/' + File.basename(source)
      end

    end

  end

end
