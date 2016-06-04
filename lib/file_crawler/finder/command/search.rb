module FileCrawler
  class Finder
    module Command
      module Search

        def search(path, conditions)
          case
          when !conditions[:extension].nil?
            select_in_path(path).select_with_extension(conditions[:extension])
          when !conditions[:extension_in_directory].nil?
            select_in_path(path).select_with_extension_in_directory(conditions[:extension_in_directory])
          when conditions[:directory] == true
            select_in_path(path).select_directories
          else
            select_in_path(path)
          end
        end

        def select_in_path(path)
          tap {
            @rows += find_rows_in_path(path)
          }
        end

        def select_with_extension(extension)
          tap {
            @rows = find_rows_with_extension(extension, rows)
          }
        end

        def select_directories
          tap {
            @rows = find_rows_directories(rows)
          }
        end

        def select_with_extension_in_directory(extension)
          tap {
            @rows = find_rows_with_extension_in_directories(extension, find_rows_directories(rows))
          }
        end

      private

        def find_rows_in_path(path)
          Dir.entries(path).select {|item|
            !item.start_with?('.')
          }.map {|item|
            path + '/' + item
          }
        end

        def find_rows_with_extension(extension, resource)
          resource.select {|item|
            !File.directory?(item) &&
            extension.any? {|e|
              extname = File.extname(item).downcase
              extname == ".#{e.downcase}"
            }
          }
        end

        def find_rows_directories(resource)
          resource.select {|item|
            File.directory?(item)
          }
        end

        def find_rows_with_extension_in_directories(extension, directories)
          directories.select {|directory|
            variable_to_exist_with_extension_in_directory(extension, directory)
          }
        end

        def variable_to_exist_with_extension_in_directory(extension, directory)
          subfiles = find_rows_in_path(directory)
          result = find_rows_with_extension(extension, subfiles)
          return true if result.size > 0

          subdirectories = find_rows_directories(subfiles).select {|subdirectory|
            variable_to_exist_with_extension_in_directory(extension, subdirectory)
          }
          subdirectories.size > 0
        end
      end
    end
  end

end
