require 'fileutils'

module FileCrawler
  class Finder
    module Command
      module Move

        def move_directories_not_exist_destination(directories, destination)
          move_targets = directories.select {|directory|
            valiable_to_move?(directory, destination)
          }
          not_move_targets = directories.select {|directory|
            !valiable_to_move?(directory, destination)
          }

          FileUtils.mv(move_targets, destination)

          move_targets.map {|directory|
            destination + '/' + File.basename(directory)
          } + not_move_targets
        end

        def move_directories_with_numbering(directories, destination)
          move_targets = []
          not_move_targets = []
          rename_targets = []

          directories.each {|directory|
            if is_same?(directory, destination)
              not_move_targets << directory
              next
            end

            if exist_file?(directory, destination)
              rename_targets << directory
              next
            end

            move_targets << directory
          }

          FileUtils.mv(move_targets, destination)

          renamed_targets = []
          rename_targets.each {|directory|
            filename = find_free_filename(directory, destination)
            to = destination + '/' + filename
            FileUtils.mv(directory, to)

            renamed_targets << to
          }

          move_targets.map {|directory|
            destination + '/' + File.basename(directory)
          } + not_move_targets + renamed_targets
        end

        def find_free_filename(current, destination)
          filename = File.basename(current)

          index = 1
          new_filename = "#{filename} (#{index})"
          while File.exist?(new_filename)
            i += 1
            new_filename = "#{filename} (#{index})"
          end

          new_filename
        end

        def valiable_to_move?(current, destination)
          return false if is_same?(current, destination)

          !exist_file?(current, destination)
        end

        def is_same?(current, destination)
          current == destination
        end

        def exist_file?(current, destination)
          next_path = destination + '/' + File.basename(current)
          File.exist?(next_path)
        end

      end
    end
  end
end
