# File: graph.rb
# Time-stamp: <2014-09-23 11:16:02 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Graph class for PRRD

module PRRD
  # PRRD Graph class
  class Graph
    # Accessors
    attr_accessor :path, :database
    attr_accessor :title, :vertical_label, :start, :end
    attr_accessor :width, :height
    attr_accessor :lower_limit, :upper_limit, :rigid, :base
    attr_accessor :definitions
    attr_accessor :areas
    attr_accessor :lines
    attr_accessor :prints

    # Constructor
    def initialize
      @definitions = []
      @areas = []
      @lines = []
      @prints = []
    end

    # Check image existence
    def check_file
      fail 'Image path is missing' if  @path.nil?
    end

    # Check database existence
    def check_database
      fail 'No database provided' if @database.nil?
    end

    # Add a definition object
    # @param definition [PRRD::Graph::Definition]
    def add_definition(definition)
      @definitions << definition
    end

    # Add an area object
    # @param area [PRRD::Graph::Area]
    def add_area(area)
      @areas << area
    end

    # Add a line object
    # @param line [PRRD::Graph::Line]
    def add_line(line)
      @lines << line
    end

    # Add a print object
    # @param pr [PRRD::Graph::Print]
    def add_print(pr)
      @prints << pr
    end

    # Generate a graph
    # @return [String]
    def generate
      check_file
      check_database

      fail 'Definitions are missing' if @definitions.empty?

      cmd = []
      cmd << "#{PRRD.bin} graph #{@path}"
      cmd << "--title=\"#{@title}\"" unless @title.nil?
      cmd << "--vertical-label=\"#{@vertical_label}\"" unless @vertical_label.nil?
      cmd << "--start=#{@start}" unless @start.nil?
      cmd << "--width=#{@width}" unless @width.nil?
      cmd << "--height=#{@height}" unless @height.nil?
      cmd << "--end=#{@end}" unless @end.nil?
      cmd << "--lower-limit=#{@lower_limit}" unless @lower_limit.nil?
      cmd << "--upper-limit=#{@upper_limit}" unless @upper_limit.nil?
      cmd << '--rigid' unless @rigid.nil?
      cmd << "--base=#{@base}" unless @base.nil?

      @definitions.map { |e| cmd << e.to_s }
      @areas.map { |e| cmd << e.to_s }
      @lines.map { |e| cmd << e.to_s }
      @prints.map { |e| cmd << e.to_s }

      # Exectute
      cmd = cmd.join ' '
      `#{cmd}`
      'Graph created successfully' if $CHILD_STATUS.nil?
    end
  end
end
