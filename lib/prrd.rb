#!/usr/bin/env ruby

# File: prrd.rb
# Time-stamp: <2014-09-22 14:02:24 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: RRD ruby class

class PRRD

  # Generic accessors
  attr_accessor :rrdtool
  attr_accessor :database, :image

  # Creation process accessor
  attr_accessor :start, :step
  attr_accessor :datasources, :archives

  # Graph process accessor
  attr_accessor :definitions, :areas

  # Initialize a PRRD object
  def initialize
    @datasources = []
    @archives = []

    @definitions = []
    @areas = []

    # rrdtool binary
    @rrdtool = `which rrdtool`.chomp
    if @rrdtool.empty?
      fail 'Install "rrdtool" before. See http://oss.oetiker.ch/rrdtool/'
    end
  end

  # Validate presence of an instance variable
  # @param keys [Array]
  def _validate(*keys)
    keys.each do |key|
      value = instance_variable_get("@#{key}")
      fail "Set a value for \"#{key}\"" if value.nil?
    end
  end

  private :_validate

  # Flatten values
  # @param name [String]
  # @param data [Array]
  def _flatten(name, data)
    data.map { |e| "#{name}:#{e.values.join ':'}" }
  end

  private :_flatten

  #######################################
  # Create

  # Add datasource for creation
  # @param datasource [Hash]
  def add_datasource(datasource)
    @datasources << datasource
  end

  # Add archive for creation
  # @param archive [Hash]
  def add_archive(archive)
    @archives << archive
  end

  # Create a database
  def create
    _validate 'start', 'step', 'database', 'datasources', 'archives'

    unless File.exists?(@database)
      require 'fileutils'
      FileUtils.touch @database
    end

    cmd = []
    cmd << "#{@rrdtool} create #{@database}"
    cmd << "--start #{@start} --step #{@step}"
    cmd << _flatten('DS', @datasources)
    cmd << _flatten('RRA', @archives)

    cmd.join ' '
  end

  #######################################
  # Update

  # Update a database
  # @param timestamp [Integer, Nil]
  # @param values [Array]
  def update(timestamp = nil, *values)
    _validate 'database'

    timestamp ||= Time.now.to_i

    "#{rrdtool} update #{@database} #{timestamp}:#{values.join ':'}"
  end

  #######################################
  # Graph

  # Add definiton for graph
  # @param definition [Hash]
  def add_definition(definition)
    @definitions << definition
  end

  # Add area for graph
  # @param area [Hash]
  def add_area(area)
    @areas << area
  end

  # Create a graph from the database
  # @param options [Hash]
  def graph(options)
    _validate 'image'

    cmd = []

    # Add options
    cmd << "#{@rrdtool} graph #{@image}"
    cmd << "--title=\"#{options[:title]}\"" if options.key?(:title)
    cmd << "--vertival-label=\"#{options[:vertical_label]}\"" if options.key?(:vertical_label)
    cmd << "--start=#{options[:start]}" if options.key?(:start)
    cmd << "--end=#{options[:end]}" if options.key?(:end)
    cmd << "--lower-limit=#{options[:lower_limit]}" if options.key?(:lower_limit)
    cmd << "--upper-limit=#{options[:upper_limit]}" if options.key?(:upper_limit)
    cmd << "--rigid" if options.key?(:rigid)
    cmd << "--base=#{options[:base]}" if options.key?(:base)
    if options.key?(:color)
      options[:color] = [options[:color]] unless options[:color].is_a? Array
      options[:color].map { |e| cmd << "--color #{e}" }
    end

    # Some adjustments
    @definitions.map do |e|
      if e.key?(:vname) && !e[:vname].include?(@database)
        e[:vname] = "#{e[:vname]}=#{@database}"
      end
    end

    # Add data
    cmd << _flatten('DEF', @definitions)
    cmd << _flatten('AREA', @areas)

    cmd.join ' '
  end
end
