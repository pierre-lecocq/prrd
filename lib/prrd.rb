#!/usr/bin/env ruby

# File: prrd.rb
# Time-stamp: <2014-09-22 17:41:04 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: RRD ruby module

$LOAD_PATH.unshift File.join(File.dirname(__FILE__))

require 'prrd/database'
require 'prrd/database/datasource'
require 'prrd/database/archive'
require 'prrd/graph'
require 'prrd/graph/definition'
require 'prrd/graph/area'

module PRRD
  VERSION = [0, 2, 0].join('.')

  @@bin = nil

  def self.bin
    if @@bin.nil?
      @@bin = `which rrdtool`.chomp
      fail 'Install rrdtool before. See http://oss.oetiker.ch/rrdtool/' if @@bin.nil?
    end

    @@bin
  end
end
