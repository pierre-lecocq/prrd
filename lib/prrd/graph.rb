# File: graph.rb
# Time-stamp: <2014-09-25 13:04:56 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Graph class for PRRD

module PRRD
  # PRRD Graph class
  class Graph
    # Accessors
    attr_accessor :path, :database

    attr_accessor :start, :end, :step
    attr_accessor :title, :vertical_label
    attr_accessor :width, :height, :only_graph, :full_size_mode
    attr_accessor :lower_limit, :upper_limit, :rigid
    attr_accessor :no_legend, :legend_position, :legend_direction
    attr_accessor :base, :border, :zoom, :imgformat, :watermark

    attr_accessor :colors
    attr_accessor :definitions
    attr_accessor :areas
    attr_accessor :lines
    attr_accessor :prints

    # Constructor
    def initialize
      @colors = []
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

    # Add a color object
    # @param color [PRRD::Graph::Color]
    def add_color(color)
      @colors << color
    end

    # Add color objects
    # @param colors [Array]
    def add_colors(colors)
      @colors = colors
    end

    # Add a definition object
    # @param definition [PRRD::Graph::Definition]
    def add_definition(definition)
      @definitions << definition
    end

    # Add definition objects
    # @param definitions [Array]
    def add_definitions(definitions)
      @definitions = definitions
    end

    # Add an area object
    # @param area [PRRD::Graph::Area]
    def add_area(area)
      @areas << area
    end

    # Add area objects
    # @param areas [Array]
    def add_areas(areas)
      @areas = areas
    end

    # Add a line object
    # @param line [PRRD::Graph::Line]
    def add_line(line)
      @lines << line
    end

    # Add line objects
    # @param lines [Array]
    def add_lines(lines)
      @lines = lines
    end

    # Add a print object
    # @param pr [PRRD::Graph::Print]
    def add_print(pr)
      @prints << pr
    end

    # Add print objects
    # @param prints [Array]
    def add_prints(prs)
      @prints = prs
    end

    # Generate a graph
    # @return [String]
    def generate
      check_file
      check_database

      fail 'Definitions are missing' if @definitions.empty?

      cmd = []
      cmd << "#{PRRD.bin} graph #{@path}"

      cmd << "--start=#{@start}" unless @start.nil?
      cmd << "--end=#{@end}" unless @end.nil?
      cmd << "--step=#{@step}" unless @step.nil?

      cmd << "--title=\"#{@title}\"" unless @title.nil?
      cmd << "--vertical-label=\"#{@vertical_label}\"" unless @vertical_label.nil?
      cmd << "--width=#{@width}" unless @width.nil?
      cmd << "--height=#{@height}" unless @height.nil?
      cmd << '--only-graph' unless @only_graph.nil?
      cmd << '--full-size-mode' unless @full_size_mode.nil?
      cmd << "--lower-limit=#{@lower_limit}" unless @lower_limit.nil?
      cmd << "--upper-limit=#{@upper_limit}" unless @upper_limit.nil?
      cmd << '--rigid' unless @rigid.nil?
      cmd << "--no-legend" unless @no_legend.nil?
      cmd << "--legend-position=\"#{@legend_position}\"" unless @legend_position.nil?
      cmd << "--legend-direction=\"#{@legend_direction}\"" unless @legend_direction.nil?
      cmd << "--base=#{@base}" unless @base.nil?
      cmd << "--border=#{@border}" unless @border.nil?
      cmd << "--zoom=#{@zoom}" unless @zoom.nil?
      cmd << "--imgformat=\"#{@imgformat}\"" unless @imgformat.nil?
      cmd << "--watermark=\"#{@watermark}\"" unless @watermark.nil?

      @colors.map { |e| cmd << e.to_s }
      @definitions.map { |e| cmd << e.to_s }
      @areas.map { |e| cmd << e.to_s }
      @lines.map { |e| cmd << e.to_s }
      @prints.map { |e| cmd << e.to_s }

      # Exectute
      cmd = cmd.join ' '
      puts cmd.gsub(' ', "\n\t") if PRRD.debug_mode
      `#{cmd}`
      'Graph created successfully' if $CHILD_STATUS.nil?
    end
  end
end
