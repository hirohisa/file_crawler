require_relative 'finder/command'

module FileCrawler

  class Finder
    attr_accessor :path
    attr_reader :rows

    include Command::Move
    include Command::Collect
    include Command::Search

    def initialize(path = nil)
      @path = path
      @rows = []
      select_in_path(path) unless path.nil?
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

  # conditions
  # - if dont have extension_in_directory, directory true
  # - move check? if include, need condition[:force]
  def self.move(path, destination, conditions = {})
    raise ArgumentError unless File.directory?(destination)

    search_conditions = {
      directory: true,
      extension_in_directory: conditions[:extension_in_directory]
    }
    search_conditions[:directory] = nil unless search_conditions[:extension_in_directory].nil?

    directories = search(path, search_conditions)

    finder = FileCrawler::Finder.new
    finder.move(directories, destination)
  end

  # conditions
  # - if dont have extension_in_directory, directory true
  def self.collect(directories, conditions = {})
    search_conditions = {
      directory: true,
      extension_in_directory: conditions[:extension_in_directory]
    }
    search_conditions[:directory] = nil unless search_conditions[:extension_in_directory].nil?

    files = directories.map {|path|
      search(path, search_conditions)
    }.flatten

    finder = FileCrawler::Finder.new
    finder.collect(files)
  end

end
