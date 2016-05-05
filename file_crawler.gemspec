# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "file_crawler"
  spec.version       = FileCrawler::VERSION
  spec.authors       = ["Hirohisa Kawasaki"]
  spec.email         = ["hirohisa.kawasaki@gmail.com"]

  spec.description   = "FileCrawler searches and controls files in local directory"
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/hirohisa/file_crawler"
  spec.license       = "MIT"

  spec.files         = %w(LICENSE.txt README.md file_crawler.gemspec) + Dir['lib/**/*.rb']
  #spec.bindir        = "bin"
  #spec.executables   = ["file_crawler"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
