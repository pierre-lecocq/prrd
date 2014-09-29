# -*- coding: utf-8 -*-
# File: graph.rb
# Time-stamp: <2014-09-29 23:13:47 pierre>
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
    attr_accessor :entities

    # Constructor
    def initialize(values = nil)
      @entities = {
        colors: [],
        definitions: [],
        areas: [],
        lines: [],
        prints: [],
        comments: [],
        hrules: [],
        vrules: []
      }

      unless values.nil?
        values.each do |k, v|
          m = "#{k}=".to_sym
          next unless respond_to? m
          send m, v
        end
      end
    end

    # Check image existence
    def check_file
      fail 'Image path is missing' if  @path.nil?
    end

    # Check database existence
    def check_database
      fail 'No database provided' if @database.nil?
    end

    def method_missing(m, *args, &block)
      entities = @entities.keys.map(&:to_s) + @entities.keys.map! { |e| e.to_s[0..-2] }
      ms = m.to_s.gsub 'add_', ''
      if entities.include? ms
        if ms[-1] == 's'
          @entities[ms.to_sym] = args[0]
        else
          @entities["#{ms}s".to_sym] << args[0]
        end

        return true
      end

      super
    end

    # Add an object
    # @param object [Object]
    def <<(object)
      if object.is_a? PRRD::Graph::Definition
        @entities[:definitions] << object
      elsif object.is_a? PRRD::Graph::Color
        @entities[:colors] << object
      elsif object.is_a? PRRD::Graph::Area
        @entities[:areas] << object
      elsif object.is_a? PRRD::Graph::Line
        @entities[:lines] << object
      elsif object.is_a? PRRD::Graph::Print
        @entities[:prints] << object
      elsif object.is_a? PRRD::Graph::Comment
        @entities[:comments] << object
      elsif object.is_a? PRRD::Graph::Hrule
        @entities[:hrules] << object
      elsif object.is_a? PRRD::Graph::Vrule
        @entities[:vrules] << object
      else
        fail 'Can not add this kind of object in PRRD::Graph'
      end
    end

    # Generate a graph
    # @return [String]
    def generate
      check_file
      check_database

      fail 'Definitions are missing' if @entities[:definitions].empty?

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

      @entities.each do |k, v|
        next if v.empty?
        v.each do |e|
          cmd << e.to_s
        end
      end

      # Exectute
      cmd = cmd.join ' '
      puts cmd.gsub(' ', "\n\t") if PRRD.debug_mode
      `#{cmd}`
      'Graph created successfully' if $CHILD_STATUS.nil?
    end
  end
end
