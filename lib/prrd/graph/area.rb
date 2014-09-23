# File: area.rb
# Time-stamp: <2014-09-23 10:31:27 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Area class for PRRD

module PRRD
  class Graph
    # PRRD Graph Area class
    class Area < PRRD::Entity
      # Constructor
      def initialize
        super
        @keys = [
          :value,
          :color,
          :legend
        ]
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
