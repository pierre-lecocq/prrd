#!/usr/bin/env ruby

# File: prrd.rb
# Time-stamp: <2014-09-22 17:10:30 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: RRD ruby module

$LOAD_PATH.unshift File.join(File.dirname(__FILE__))

require 'prrd/database'
require 'prrd/database/datasource'
require 'prrd/database/archive'
require 'prrd/graph'
require 'prrd/graph/definition'

module PRRD
  VERSION = [0, 2, 0].join('.')
end
