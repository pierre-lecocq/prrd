#!/usr/bin/env ruby

# File: shift.rb
# Time-stamp: <2014-09-30 00:00:35 pierre>
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

        validate_presence :vname, :offset

        "SHIFT:#{@data[:vname]}:#{@data[:offset]}"
      end
    end
  end
end
