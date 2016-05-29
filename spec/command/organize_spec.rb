require 'spec_helper'

describe FileCrawler::Finder::Command::Organize do

  it 'organizes' do
    allow(Dir).to receive(:entries).and_return([])

    path1 = '/path1'
    files1 = [
      '[abcd] defg', '(あい) うえお', '[test] 123', '[123] 456',
    ]
    allow(Dir).to receive(:entries).with(path1).and_return(files1)

    path2 = '/path2'
    files2 = [
      '[abcd] defge', '[あ] いうえお'
    ]
    allow(Dir).to receive(:entries).with(path2).and_return(files2)
    allow(File).to receive(:directory?).and_return(true)

    destination = '/var'

    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:exist?).with('/var').and_return(true)
    allow(File).to receive(:exist?).with('/var/test').and_return(true)
    allow(File).to receive(:exist?).with('/var/123').and_return(true)
    allow(File).to receive(:exist?).with('/var/abcd').and_return(true)
    allow(File).to receive(:exist?).with('/var/あ').and_return(true)
    allow(File).to receive(:exist?).with('/var/あい').and_return(true)

    allow(FileCrawler).to receive(:create_directory_if_needed).and_return(nil)

    allow(FileUtils).to receive(:mv).and_return(nil)

    result = FileCrawler.organize([path1, path2], destination)

    expected = [
      '/var/123/[123] 456',
      '/var/abcd/[abcd] defg',
      '/var/abcd/[abcd] defge',
      '/var/test/[test] 123',
      '/var/あ/[あ] いうえお',
      '/var/あい/(あい) うえお',
    ].sort

    expect(result.size).to eq expected.size
    result.sort.each_with_index {|item, index|
      expect(item).to eq expected[index]
    }
  end

end
