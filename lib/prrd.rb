#!/usr/bin/env ruby

# File: prrd.rb
# Time-stamp: <2014-09-22 20:29:34 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: RRD ruby module

$LOAD_PATH.unshift File.join(File.dirname(__FILE__))

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

  class Entity
    attr_accessor :data, :keys

    def initialize
      @data = {}
      @keys = []
    end

    def method_missing(m, *args, &block)
      ms = m.to_s
      if ms.include? '='
        ms = ms[0..-2]
        if @keys.include? ms.to_sym
          @data[ms.to_sym] = args[0]
          return true
        end
      end

      super
    end
  end
end

require 'prrd/database'
require 'prrd/database/datasource'
require 'prrd/database/archive'
require 'prrd/graph'
require 'prrd/graph/definition'
require 'prrd/graph/area'
