require 'spec_helper'

describe FileCrawler::Finder::Command::Move do

  describe FileCrawler::Finder::Command::Move::Fixer do

    it 'fixes new paths' do
      destination = '/var'
      sources = {
        'abcd': ['/path/path1/[abcd ] defg', '/path/path2/(abcd) defg'],
        'test 123': ['/path/path1/test 123'],
        '123': ['/path/path1/[123] 456'],
        'あ': ['/path/path2/(あ) いうえお'],
        'あい': ['/path/path1/[あい] うえお'],
      }

      fixer = FileCrawler::Finder::Command::Move::Fixer.new
      result = fixer.make_new_path(sources, destination)

      expected = [
        ['/path/path1/[abcd ] defg', '/var/abcd/[abcd ] defg'],
        ['/path/path2/(abcd) defg', '/var/abcd/(abcd) defg'],
        ['/path/path1/test 123', '/var/test 123/test 123'],
        ['/path/path1/[123] 456', '/var/123/[123] 456'],
        ['/path/path2/(あ) いうえお', '/var/あ/(あ) いうえお'],
        ['/path/path1/[あい] うえお', '/var/あい/[あい] うえお'],
      ]

      expect(result.sort).to eq expected.sort
    end

    it 'fixes new paths' do
      destination = '/var'
      sources = [
        '/path/path1/[abcd ] defg',
        '/path/path2/(abcd) defg',
      ]

      fixer = FileCrawler::Finder::Command::Move::Fixer.new
      result = fixer.make_new_path(sources, destination)

      expected = [
        ['/path/path1/[abcd ] defg', '/var/[abcd ] defg'],
        ['/path/path2/(abcd) defg', '/var/(abcd) defg'],
      ]

      expect(result.sort).to eq expected.sort
    end

    it 'fixes path' do
      array = [
        '/var/b',
        '/var/c (1)',
        '/var/c (2)',
      ]

      fixer = FileCrawler::Finder::Command::Move::Fixer.new

      result = fixer.fix_path('/var/a', array)
      expected = '/var/a'
      expect(result).to eq expected
      result = fixer.fix_path('/var/b', array)
      expected = '/var/b (1)'
      expect(result).to eq expected

      result = fixer.fix_path('/var/c', array)
      expected = '/var/c'
      expect(result).to eq expected

      result = fixer.fix_path('/var/c', array + ['/var/c'])
      expected = '/var/c (3)'
      expect(result).to eq expected
    end

    it 'makes fixed paths' do
      array = [
        ['/temp/b', '/var/b'],
        ['/temp/a/b', '/var/b'],
        ['/temp/c/b', '/var/b'],
        ['/temp/d/b', '/var/b'],
      ]

      fixer = FileCrawler::Finder::Command::Move::Fixer.new

      result = fixer.make_fixed_paths(array)
      expected = [
        ["/temp/b", "/var/b"],
        ["/temp/a/b", "/var/b (1)"],
        ["/temp/c/b", "/var/b (2)"],
        ["/temp/d/b", "/var/b (3)"]
      ]

      expect(result).to eq expected
    end

    it 'makes mv commands' do
      array = [
        ['/temp/b', '/var/b'],
        ['/temp/a/b', '/var/b'],
      ]

      fixer = FileCrawler::Finder::Command::Move::Fixer.new

      result = fixer.make_mv(array)
      expected = [
        "mkdir -p /var",
        "mv /temp/b /var/b",
        "mv /temp/a/b /var/b (1)",
      ]
      expect(result).to eq expected
    end

  end

end
