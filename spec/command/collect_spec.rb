require 'spec_helper'

describe FileCrawler::Finder::Command::Collect do

  it 'collects in file paths' do
    finder = FileCrawler::Finder.new
    finder.files = [
      '/path/path1/[abcd] defg',
      '/path/path1/[あい] うえお',
      '/path/path1/test 123',
      '/path/path1/[123] 456',
      '/path/path2/(abcd) defg',
      '/path/path2/(あ) いうえお',
    ]

    finder.collect(regexs: ['[]', '()'])
    result = finder.collections

    expected = {
      'abcd': ['/path/path1/[abcd] defg', '/path/path2/(abcd) defg'],
      'test 123': ['/path/path1/test 123'],
      '123': ['/path/path1/[123] 456'],
      'あ': ['/path/path2/(あ) いうえお'],
      'あい': ['/path/path1/[あい] うえお'],
    }.map {|k,v|
      [k.to_s, v]
    }.to_h

    expect(result.keys.size).to eq expected.keys.size
    result.each {|actual_key, actual_value|
      expect(actual_value.sort).to eq expected[actual_key].sort
    }
  end

  describe FileCrawler::Finder::Command::Collect::Organizer do

    it 'splits with symbols' do
      organizer = FileCrawler::Finder::Command::Collect::Organizer.new

      result = organizer.decide_index('[TEST] test')
      expect(result).to eq 'TEST'

      result = organizer.decide_index('【あいー】 うえお')
      expect(result).to eq 'あいー'

      result = organizer.decide_index('test2test')
      expect(result).to eq 'test2test'

      result = organizer.decide_index('t；e,s*t')
      expect(result).to eq 't'

      result = organizer.decide_index('   [test1] test2')
      expect(result).to eq 'test1'

      result = organizer.decide_index('---')
      expect(result).to eq '---'

      regexs = [ FileCrawler::Regex.new('(', ')') ]
      result = organizer.decide_index('t(e_s)t', regexs)
      expect(result).to eq 'e_s'

      regexs = [ FileCrawler::Regex.new('[', ']') ]
      result = organizer.decide_index('(abc) [def] ghij [klmn]', regexs)
      expect(result).to eq 'def'
    end

  end

end
