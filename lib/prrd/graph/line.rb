#!/usr/bin/env ruby

# File: line.rb
# Time-stamp: <2014-09-24 10:41:57 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Line class for PRRD

module PRRD
  class Graph
    # PRRD Graph Line class
    class Line < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :value,
          :width,
          :color,
          :legend
        ]

        super values
      end

      # Transform to a LINE formatted string
      def to_s
        fail 'Empty line object' if @data.empty?

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :value
            chunks << "LINE#{@data[:width]}:#{@data[k]}#{@data[:color]}"
          when :legend
            chunks << "\"#{@data[k]}\""
          when :width, :color
            # nope
          else
            chunks << @data[k]
          end
        end

        chunks.join ':'
      end
    end
  end
end
