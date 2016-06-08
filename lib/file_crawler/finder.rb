require_relative 'finder/command'

module FileCrawler

  class Finder
    attr_reader :rows

    include Command::Collect
    include Command::Move
    include Command::Organize
    include Command::Search

    def initialize
      @rows = []
    end
  end

  # @param conditions
  #   directory [Boolean]
  #   exntesion [Array]
  #   extension_in_directory [Array]
  def self.search(path, conditions = {})
    finder = FileCrawler::Finder.new
    finder.search(path, conditions)

    finder.rows
  end

  # conditions
  # - if dont have extension_in_directory, directory true
  # - move check? if include, need condition[:force]
  def self.move(path, destination, conditions = {})
    raise ArgumentError unless File.directory?(destination)

    finder = FileCrawler::Finder.new
    finder.search(path).move(destination)

    finder.rows
  end

  # conditions
  # - if dont have extension_in_directory, directory true
  def self.collect(path, conditions = {})
    finder = FileCrawler::Finder.new
    unless conditions[:regexs].nil?
      conditions[:regexs].each {|regex|
        finder.regexs << regex
      }
    end

    finder.search(path).collect(conditions)

    finder.rows
  end

  def self.organize(directories, destination, conditions = {})
    finder = FileCrawler::Finder.new

    result = collect(directories, conditions).map {|key, value|
      directory = destination + '/' + key
      finder.move_directories_with_numbering(value, directory)
    }.flatten

    result
  end

end
