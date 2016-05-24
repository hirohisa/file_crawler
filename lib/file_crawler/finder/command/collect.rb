module FileCrawler
  class Finder
    module Command
      module Collect

        def collect(file_paths, conditions = {})
          collection = collect_into_filename(file_paths)

          case
          when !conditions[:unique].nil?
            collection = unique_in_collection(collection)
          end

          collection
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

        def unique_in_collection(collection)
          hash = {}

          collection.sort {|(k1, v1), (k2, v2)|
            v2.size <=> v1.size && k1 <=> k2
          }.each {|term, file_paths|
            selection = file_paths.select {|v| !hash.values.flatten.include?(v) }
            hash[term] = selection unless selection.empty?
          }

          hash
        end

      end
    end
  end
end
