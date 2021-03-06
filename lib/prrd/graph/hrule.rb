#!/usr/bin/env ruby

# File: hrule.rb
# Time-stamp: <2014-10-01 21:15:13 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Hrul class for PRRD

module PRRD
  class Graph
    # PRRD Graph Hrule class
    class Hrule < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :value,
          :color,
          :legend,
          :dashes,
          :dashes_offset
        ]

        super values
      end

      # Transform to a HRULE formatted string
      def to_s
        fail 'Empty hrule object' if @data.empty?

        validate_presence :value, :color

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :value
            chunks << "HRULE:%s%s" % [@data[k], @data[:color]]
          when :dashes
            chunks << "dashes=\"%s\"" % @data[k]
          when :dashes_offset
            chunks << "dashes-offset=\"%s\"" % @data[k]
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
