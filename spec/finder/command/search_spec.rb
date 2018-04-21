require 'spec_helper'

describe FileCrawler::Finder::Command::Search do

  it 'searches directories in this repository' do
    path = '.'
    finder = FileCrawler::Finder.new
    finder.search(path, maxdepth: 1, exclude_invisible_file: true)
    result = finder.files

    expected = ["./bin", "./lib", "./spec"]
    expect(result).to eq expected
  end

  it 'searches directories in this repository' do
    path = '.'
    finder = FileCrawler::Finder.new
    finder.search(path, maxdepth: 1)
    result = finder.files

    expected = [".", "./.git", "./bin", "./lib", "./spec"]
    expect(result).to eq expected
  end

end
