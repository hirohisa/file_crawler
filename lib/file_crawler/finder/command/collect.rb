module FileCrawler
  class Finder
    module Command
      module Collect

        def collect(file_paths)
          collection = collect_into_filename(file_paths)
        end

        def split_for_collect(string)
          pattern = /[\p{Hiragana}|\p{Katakana}|\p{Han}|[a-zA-Z0-9]ー]+/
          return string.scan(pattern)
        end

        def collect_into_filename(file_paths)
          hash = {}

          file_paths.each {|file_path|
            filename = File.basename(file_path)
            split_for_collect(filename).each {|term|
              hash[term] ||= []
              hash[term] << file_path
            }
          }

          hash
        end
      end
    end
  end
end
