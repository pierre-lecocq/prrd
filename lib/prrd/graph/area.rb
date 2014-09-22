# File: area.rb
# Time-stamp: <2014-09-22 22:19:14 pierre>
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

        chunks = [
          "AREA"
        ]

        @data.each do |k, v|
          if k == :value
            chunks << "#{v}#{@data[:color]}"
          elsif k == :color
            # nope
          elsif k == :legend
            chunks << "\"#{v}\""
          else
            chunks << v
          end
        end

        chunks.join ':'
      end
    end
  end
end
