#!/usr/bin/env ruby

# File: prrd.rb
# Time-stamp: <2014-09-23 10:43:13 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: RRD ruby module

$LOAD_PATH.unshift File.join(File.dirname(__FILE__))

# Main PRRD module
module PRRD
  # Version
  VERSION = [0, 2, 0].join('.')

  # Class variables
  @@colors = nil
  @@bin = nil

  # Get rrdtool binary
  # @return [String]
  def self.bin
    if @@bin.nil?
      @@bin = `which rrdtool`.chomp
      fail 'Install rrdtool. See http://oss.oetiker.ch/rrdtool/' if @@bin.nil?
    end

    @@bin
  end

  # Get colors
  # @return [Hash]
  def self.colors
    if @@colors.nil?
      @@colors = {
        red: {
          light: '#EA644A',
          dark: '#CC3118'
        },
        orange: {
          light: '#EC9D48',
          dark: '#CC7016'
        },
        yellow: {
          light: '#ECD748',
          dark: '#C9B215'
        },
        green: {
          light: '#54EC48',
          dark: '#24BC14'
        },
        blue: {
          light: '#48C4EC',
          dark: '#1598C3'
        },
        pink: {
          light: '#DE48EC',
          dark: '#B415C7'
        },
        purple: {
          light: '#7648EC',
          dark: '#4D18E4'
        }
      }
    end

    @@colors
  end

  # Get a color
  # @param name [Symbol, String]
  # @return [String]
  def self.color(name, tint = :light)
    name = name.to_sym
    tint = tint.to_sym

    fail "Unknown color #{name}" unless colors.key? name
    fail "Unknown tint #{tint}" unless colors[name].key? tint

    colors[name][tint]
  end

  # Entity base class
  class Entity
    # Accessors
    attr_accessor :data, :keys

    # Constructor
    def initialize
      @data = {}
      @keys = []
    end

    # Method missing
    # @param m [Symbol]
    # @param args [Array]
    # @param block [Proc]
    # @return [Boolean]
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

# Requires
require 'prrd/database'
require 'prrd/database/datasource'
require 'prrd/database/archive'
require 'prrd/graph'
require 'prrd/graph/definition'
require 'prrd/graph/area'
require 'prrd/graph/line'
