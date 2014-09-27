#!/usr/bin/env ruby

# File: vrule.rb
# Time-stamp: <2014-09-27 13:29:51 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Hrul class for PRRD

module PRRD
  class Graph
    # PRRD Graph Vrule class
    class Vrule < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :time,
          :color,
          :legend,
          :dashes,
          :dashes_offset
        ]

        super values
      end

      # Transform to a VRULE formatted string
      def to_s
        fail 'Empty vrule object' if @data.empty?

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :time
            chunks << "VRULE:#{@data[k]}#{@data[:color]}"
          when :dashes
            chunks << "dashes=\"#{@data[k]}\""
          when :dashes_offset
            chunks << "dashes-offset=\"#{@data[k]}\""
          when :color
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
