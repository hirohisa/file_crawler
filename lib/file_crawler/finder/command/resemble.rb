module FileCrawler
  class Finder
    module Command
      module Resemble

        def resemble()
          tap {
            @rows = resemble_in_collection(@rows.values)
          }
        end

        # use rows after using #collect
        def resemble_in_collection(collection)
          files = []

          pattern = /\(\d+\)$/

          collection.each {|files_in_same_directory|
            files_in_same_directory.each {|file|
              filename = File.basename(file)
              files << file unless pattern.match(filename).nil?
            }
          }

          files
        end

      end
    end
  end
end
