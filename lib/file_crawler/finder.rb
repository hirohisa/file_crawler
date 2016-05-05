require_relative 'finder/command'

module FileCrawler

  class Finder
    attr_accessor :path
    attr_reader :rows

    include Command::Search

    def initialize(path)
      @path = path
      select_in_path(path)
    end
  end

  # @param conditions
  #   directory [Boolean]
  #   exntesion [Array]
  #   extension_in_directory [Array]
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
