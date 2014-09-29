#!/usr/bin/env ruby

# File: shift.rb
# Time-stamp: <2014-09-29 23:44:47 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Shift class for PRRD

module PRRD
  class Graph
    # PRRD Shift Line class
    class Shift < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :vname,
          :offset
        ]

        super values
      end

      # Transform to a SHIFT formatted string
      def to_s
        fail 'Empty shift object' if @data.empty?

        "SHIFT:#{@data[:vname]}:#{@data[:offset]}"
      end
    end
  end
end
