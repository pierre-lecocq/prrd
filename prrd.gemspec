# File: prrd.gemspec
# Time-stamp: <2015-07-13 10:48:12>
# Copyright (C) 2014 Pierre Lecocq
# Description: rrdtool ruby interface

require File.expand_path('../lib/prrd', __FILE__)

Gem::Specification.new do |gem|
  gem.name              = 'prrd'
  gem.require_paths     = ['lib']
  gem.version           = PRRD::VERSION
  gem.files             =
    %w(README.md Gemfile Rakefile showcase.rb prrd.gemspec) +
    `git ls-files lib spec`.split("\n")

  gem.authors           = ['Pierre Lecocq']
  gem.email             = ['pierre.lecocq@gmail.com']
  gem.summary           = 'rrdtool ruby interface'
  gem.description       = 'Graph your system with rrdtool in ruby'
  gem.homepage          = 'https://github.com/pierre-lecocq/prrd'
  gem.date              = Date.today.to_s
  gem.license           = 'MIT'
end
