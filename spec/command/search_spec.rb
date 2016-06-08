require 'spec_helper'

describe FileCrawler::Finder::Command::Search do

  it 'searches directories in current directory' do
    path = '/tmp'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).and_return([])
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)

    result = FileCrawler.search(path)

    expect(result[0]).to eq path + '/' + files[4] # /tmp/directory
  end

end
