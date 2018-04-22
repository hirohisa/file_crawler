require 'spec_helper'

describe FileCrawler::Finder::Command::Search do

  it 'searches directories in this repository' do
    path = '.'
    finder = FileCrawler::Finder.new
    finder.search(path, maxdepth: 1, exclude_invisible_file: true)

    expected = ["./bin", "./lib", "./spec"]
    expect(finder.directories).to eq expected
    expect(finder.directories).to eq finder.dirs
  end

  it 'searches directories in this repository' do
    path = '.'
    finder = FileCrawler::Finder.new
    finder.search(path, maxdepth: 1, grep: 'git')

    expected = ["./.git"]
    expect(finder.directories).to eq expected
    expect(finder.directories).to eq finder.dirs
  end

end
