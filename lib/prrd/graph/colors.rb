# File: color.rb
# Time-stamp: <2014-10-01 20:31:49 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Color class for PRRD

module PRRD
  class Graph
    # PRRD Graph Color class
    class Color < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :colortag,
          :color
        ]

        super values
      end

      # Transform to a COLOR formatted string
      def to_s
        fail 'Empty color object' if @data.empty?

        "--color %s%s " % [@data[:colortag], @data[:color]]
      end
    end
  end
end
