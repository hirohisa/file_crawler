module FileCrawler

  class Finder
    attr_accessor :path

    # directory [Boolean]
    # exntesion [Array]
    def initialize(path)
      @path = path
      select_in_path(path)
    end

    def rows
      @rows ||= []
    end

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

  def self.search(path, conditions = {})
    finder = FileCrawler::Finder.new(path)

    case
    when !conditions[:extension].nil?
      finder.select_with_extension(conditions[:extension])
    when conditions[:directory] == true
      finder.select_directories
    when conditions[:directory] == false
      finder.select_files
    when !conditions[:extension_in_directory].nil?
      finder.select_with_extension_in_directory(conditions[:extension_in_directory])
    end

    finder.rows
  end

end
