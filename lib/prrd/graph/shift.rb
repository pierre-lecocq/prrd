# File: shift.rb
# Time-stamp: <2014-10-01 21:17:51 pierre>
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

        "SHIFT:%s:%s" % [@data[:vname], @data[:offset]]
      end
    end
  end
end
