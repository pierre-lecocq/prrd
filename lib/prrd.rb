#!/usr/bin/env ruby

# File: prrd.rb
# Time-stamp: <2014-10-01 21:25:26 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: RRD ruby module

$LOAD_PATH.unshift File.join(File.dirname(__FILE__))

# Main PRRD module
module PRRD
  # Version
  VERSION = [0, 2, 0].join('.')

  # Class variables
  @@debug_mode = false
  @@colors = nil
  @@bin = nil

  # Activate debug mode
  def self.activate_debug_mode
    @@debug_mode = true
  end

  # Activate debug mode
  def self.debug_mode
    @@debug_mode
  end

  # Get rrdtool binary
  # @return [String]
  def self.bin
    if @@bin.nil?
      @@bin = `which rrdtool`.chomp
      fail 'Install rrdtool. See http://oss.oetiker.ch/rrdtool/' if @@bin.nil?
    end

    @@bin
  end

  # Execute a command
  # @param cmd [String]
  # @param message [String, Nil]
  # @return [String, Nil]
  def self.execute(cmd, message = nil)
    puts cmd.gsub(' ', "\n\t") if PRRD.debug_mode
    `#{cmd}`

    message if $CHILD_STATUS.nil? && !message.nil?
  end

  # Color class
  class Color
    # Accessors
    attr_accessor :collection, :hexcode

    # Constructor
    # @param name [Symbol]
    # @param tint [Symbol, nil]
    # @param alpha [Symbol, nil]
    def initialize(name, tint = nil, alpha = nil)
      if name.is_a?(String) && name.include?('#')
        @hexcode = name
      else
        @hexcode = to_hex(name, tint, alpha)
      end
    end

    # Translate into hexcode
    # @param name [Symbol]
    # @param tint [Symbol, nil]
    # @param alpha [Symbol, nil]
    # @param [String]
    def to_hex(name, tint = nil, alpha = nil)
      if @collection.nil?
        @collection = {
          red: {light: '#EA644A', dark: '#CC3118'},
          orange: {light: '#EC9D48', dark: '#CC7016'},
          yellow: {light: '#ECD748', dark: '#C9B215'},
          green: {light: '#54EC48', dark: '#24BC14'},
          blue: {light: '#48C4EC', dark: '#1598C3'},
          pink: {light: '#DE48EC', dark: '#B415C7'},
          purple: {light: '#7648EC', dark: '#4D18E4'}
        }
      end

      name = name.to_sym
      tint = tint.nil? ? :light : tint.to_sym

      fail "Unknown color #{name}" unless @collection.key? name
      fail "Unknown tint #{tint}" unless @collection[name].key? tint

      alpha.nil? ? @collection[name][tint] : @collection[name][tint] + alpha
    end

    # Darken the color
    # @param percentage [Integer]
    # @return [String]
    def darken(percentage)
      fail 'Can not operate on a non-hexadecimal color' if @hexcode.nil?

      hexcode = @hexcode.gsub('#', '')
      percentage = percentage.to_f / 100
      rgb = hexcode.scan(/../).map { |c| c.hex }
      rgb.map! { |c| (c.to_i * percentage).round }

      "#%02x%02x%02x" % rgb
    end

    # Lighten the color
    # @param percentage [Integer]
    def lighten(percentage)
      fail 'Can not operate on a non-hexadecimal color' if @hexcode.nil?

      hexcode = @hexcode.gsub('#', '')
      percentage = percentage.to_f / 100
      rgb = hexcode.scan(/../).map { |c| c.hex }
      rgb.map! { |c| [(c.to_i + 255 * percentage).round, 255].min }

      "#%02x%02x%02x" % rgb
    end

    # String representation
    def to_s
      @hexcode
    end
  end

  # Entity base class
  class Entity
    # Accessors
    attr_accessor :data, :keys

    # Constructor
    def initialize(values = nil)
      @data = {}

      unless values.nil?
        values.each do |k, v|
          next unless @keys.include? k
          send "#{k}=".to_sym, v
        end
      end
    end

    # Validate presence of keys in data collection
    # @param keys [Array]
    def validate_presence(*keys)
      keys.each do |k|
        fail 'Define a "%s" option' % k if !@data.key?(k) || @data[k].nil?
      end
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
require 'prrd/graph/colors'
require 'prrd/graph/area'
require 'prrd/graph/line'
require 'prrd/graph/print'
require 'prrd/graph/comment'
require 'prrd/graph/hrule'
require 'prrd/graph/vrule'
require 'prrd/graph/shift'
require 'prrd/graph/textalign'
