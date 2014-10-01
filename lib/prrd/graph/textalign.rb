# File: textalign.rb
# Time-stamp: <2014-10-01 21:18:12 pierre>
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

        validate_presence :orientation
        unless ['left', 'right', 'justified', 'center'].include? @data[:orientation].to_s
          fail 'Orientation option muts be: left|right|justified|center'
        end

        "TEXTALIGN:\"%s\"" % @data[:orientation]
      end
    end
  end
end
