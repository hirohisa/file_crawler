require 'spec_helper'

describe FileCrawler::Finder do

  it 'searches current directory' do
    path = '/tmp'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]

    allow(Dir).to receive(:entries).with(path).and_return(files)

    result = FileCrawler.search(path)

    expect(result[0]).to eq path + '/' + files[3] # /tmp/file
    expect(result[1]).to eq path + '/' + files[4] # /tmp/directory
    expect(result[2]).to eq path + '/' + files[5] # /tmp/extension.jpg
  end

  it 'searches directories in current directory' do
    path = '/tmp'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)

    result = FileCrawler.search(path, directory: true)

    expect(result[0]).to eq path + '/' + files[4] # /tmp/directory
  end

  it 'searches jpg files in current directory' do
    path = '/tmp'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg', 'non-extensionjpg', 'upcase-extension.JPG',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)

    result = FileCrawler.search(path, extension: ['jpg'])

    expect(result[0]).to eq path + '/' + files[5] # /tmp/extension.jpg
    expect(result[1]).to eq path + '/' + files[7] # /tmp/upcase-extension.JPG
  end

  it 'searches directories that have jpg images' do
    path = '/tmp'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)

    subpath = '/tmp/directory'
    subfiles = [
      '.', '..', 'file', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(subpath).and_return(subfiles)

    result = FileCrawler.search(path, extension_in_directory: ['jpg'])

    expect(result[0]).to eq subpath # /tmp/directory
  end

  it 'searches sub directories that have jpg images' do
    path = '/tmp'
    files = [
      '.', '..', '.git', 'file', 'directory', 'extension.jpg',
    ]
    allow(Dir).to receive(:entries).with(path).and_return(files)
    allow(File).to receive(:directory?).and_return(false)
    allow(File).to receive(:directory?).with('/tmp/directory').and_return(true)

    subpath = '/tmp/directory'
    subfiles = [
      '.', '..', 'subdirectory', 'file'
    ]
    allow(Dir).to receive(:entries).with(subpath).and_return(subfiles)
    allow(File).to receive(:directory?).with('/tmp/directory/subdirectory').and_return(true)

    sub2path = '/tmp/directory/subdirectory'
    sub2files = [
      '.', '..', 'extension.jpg', 'file'
    ]
    allow(Dir).to receive(:entries).with(sub2path).and_return(sub2files)

    result = FileCrawler.search(path, extension_in_directory: ['jpg'])

    expect(result[0]).to eq subpath # /tmp/directory
  end

end
