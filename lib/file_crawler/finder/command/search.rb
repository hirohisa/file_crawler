module FileCrawler
  class Finder
    module Command
      module Search

        def search(path, conditions = {})
          tap {
            @rows = search_directories(path)
          }
        end

        def search_directories(path)
          directories = search_directories_in_path(path)
          return [path] if directories.empty?

          result = []
          directories.each {|item|
            result += search_directories(item)
          }

          result
        end

        def search_directories_in_path(path)
          find_files_in_path(path).select {|item|
            File.directory?(item)
          }
        end

        def find_files_in_path(path)
          Dir.entries(path).select {|item|
            !item.start_with?('.')
          }.map {|item|
            path + '/' + item
          }
        end
      end
    end
  end

end
