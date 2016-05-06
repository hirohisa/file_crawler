require 'fileutils'

module FileCrawler
  class Finder
    module Command
      module Move

        def move(directories, destination)
          move_targets = directories.select {|directory|
            valiable_to_move?(directory, destination)
          }
          not_move_targets = directories.select {|directory|
            !valiable_to_move?(directory, destination)
          }

          FileUtils.mv(move_targets, destination)

          move_targets.map {|path|
            destination + '/' + File.basename(path)
          } + not_move_targets
        end

        def valiable_to_move?(current_path, destination)
          return false if current_path == destination

          next_path = destination + '/' + File.basename(current_path)
          !File.exist?(next_path)
        end
      end
    end
  end
end
