# FileCrawler

[![Gem-version](https://img.shields.io/gem/v/file_crawler.svg)](https://rubygems.org/gems/file_crawler) [![Build Status](https://travis-ci.org/hirohisa/file_crawler.svg?branch=master)](https://travis-ci.org/hirohisa/file_crawler)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'file_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install file_crawler

## Usage

- Create Instance

```ruby
finder = FileCrawler::Finder.new
```

- Find directories

```ruby
path = '.'

finder.search(path)
p finder.directories #=> ["./bin", "./lib", "./spec", ...]
p finder.dirs #=> ["./bin", "./lib", "./spec", ...] # directories's shortname

finder.search(path, maxdepth: 1)
p finder.dirs #=> ["./bin", "./lib", "./spec"]

finder.search(path, maxdepth: 1, grep: 'sample')
p finder.dirs #=> []

```

- Create groups per label decided by directory name

```ruby
# collect use `directories`
# directories = ['/path/path1/[abcd] defg', '/path/path2/(abcd) defg', '/path/path1/test 123', ...
finder.collect(regexs: ['[]', '()'])
p finder.collections
#=> { 'abcd': ['/path/path1/[abcd] defg', '/path/path2/(abcd) defg'], 'test 123': ['/path/path1/test 123'], ... }
```

- Move directory to destination

```ruby
# move use `directories` or `collections`
# files = #=> ["./bin", "./lib", ...]
destination = '/var'
finder.move(destination)

# ensure destination
# [ [from, to], ... ]
p finder.targets #=> [["./bin", "/var/bin"] , ["./lib", "/var/lib"], ...]

# command output
p finder.output_mv #=> [ "mv ./bin /var/bin", "mv ./lib /var/lib", ...]

# run
finder.move(destination, dry_run: false)
```

- Chain
```ruby
finder.search(source, grep: 'sample').collect(regexs: ['[]']).move(destination)
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hirohisa/file_crawler.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
