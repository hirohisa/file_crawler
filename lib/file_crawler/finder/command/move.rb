require 'fileutils'

module FileCrawler
  class Finder
    module Command
      module Move

        def move(destination)
          tap {
            @rows = move_with_numbering(@rows, destination)
          }
        end

        def move_from_collection(destination)
          tap {
            @rows = move_from_collection_with_numbering(@rows, destination)
          }
        end

        def move_with_numbering(source, destination)
          move_targets = []
          not_move_targets = []
          rename_targets = []

          source.each {|directory|
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

          create_directory_if_needed(destination)
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

        def move_from_collection_with_numbering(source, destination)
          result = source.map {|key, value|
            directory = destination + '/' + key
            move_with_numbering(value, directory)
          }.flatten

          result
        end

        def create_directory_if_needed(directory)
          Dir.mkdir(directory, 0777) unless File.exist?(directory)
        end

        def find_free_filename(current, destination)
          filename = File.basename(current)

          index = 1
          new_filename = "#{filename} (#{index})"
          while exist_file?(new_filename, destination)
            index += 1
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
