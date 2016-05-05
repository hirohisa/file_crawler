module FileCrawler
  class Finder
    module Command
      module Search

        def select_in_path(path)
          tap {
            @rows = find_rows_in_path(path)
          }
        end

        def find_rows_in_path(path)
          Dir.entries(path).select {|item|
            !item.start_with?('.')
          }.map {|item|
            path + '/' + item
          }
        end

        def select_with_extension(extension)
          tap {
            @rows = find_rows_with_extension(extension, rows)
          }
        end

        def find_rows_with_extension(extension, resource)
          find_rows_files(resource).select {|item|
            extension.any? {|e|
              extname = File.extname(item).downcase
              extname == ".#{e.downcase}"
            }
          }
        end

        def select_files
          tap {
            @rows = find_rows_files(rows)
          }
        end

        def find_rows_files(resource)
          resource.select {|item|
            !File.directory?(item)
          }
        end

        def select_directories
          tap {
            @rows = find_rows_directories(rows)
          }
        end

        def find_rows_directories(resource)
          resource.select {|item|
            File.directory?(item)
          }
        end

        def select_with_extension_in_directory(extension)
          tap {
            @rows = find_rows_with_extension_in_directories(extension, find_rows_directories(rows))
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
