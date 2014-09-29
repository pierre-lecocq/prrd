#!/usr/bin/env ruby

# File: textalign.rb
# Time-stamp: <2014-09-29 23:48:32 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Textalign class for PRRD

module PRRD
  class Graph
    # PRRD Textalign Line class
    class Textalign < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :orientation
        ]

        super values
      end

      # Transform to a TEXTALIGN formatted string
      def to_s
        fail 'Empty textalign object' if @data.empty?

        "TEXTALIGN:\"#{@data[:orientation]}\""
      end
    end
  end
end
