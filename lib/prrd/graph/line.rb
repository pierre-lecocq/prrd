# File: line.rb
# Time-stamp: <2014-10-01 21:16:41 pierre>
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
          :legend,
          :stack
        ]

        super values
      end

      # Transform to a LINE formatted string
      def to_s
        fail 'Empty line object' if @data.empty?

        @data[:width] ||= 1

        validate_presence :value

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :value
            chunks << "LINE%s:%s%s" % [@data[:width], @data[k], @data[:color]]
          when :width, :color
            # nope
          when :legend
            chunks << "\"%s\"" % @data[k]
          when :stack
            chunks << "STACK"
          else
            chunks << @data[k]
          end
        end

        chunks.join ':'
      end
    end
  end
end
