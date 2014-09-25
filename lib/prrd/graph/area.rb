# File: area.rb
# Time-stamp: <2014-09-25 23:53:55 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Area class for PRRD

module PRRD
  class Graph
    # PRRD Graph Area class
    class Area < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :value,
          :color,
          :legend,
          :stack
        ]

        super values
      end

      # Transform to a AREA formatted string
      def to_s
        fail 'Empty area object' if @data.empty?

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :value
            chunks << "AREA:#{@data[k]}#{@data[:color]}"
          when :legend
            chunks << "\"#{@data[k]}\""
          when :stack
            chunks << "STACK"
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
