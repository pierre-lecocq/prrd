# File: print.rb
# Time-stamp: <2014-10-01 21:17:17 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Print class for PRRD

module PRRD
  class Graph
    # PRRD Graph Line class
    class Print < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :gprint,
          :vname,
          :cf,
          :format,
          :strftime
        ]

        super values
      end

      # Transform to a PRINT formatted string
      def to_s
        fail 'Empty print object' if @data.empty?

        validate_presence :vname, :cf, :format

        @data[:grpint] ||= false

        chunks = []

        if @data.key?(:gprint) && @data[:gprint] == true
          chunks << 'GPRINT'
        else
          chunks << 'PRINT'
        end

        chunks << @data[:vname]
        chunks << @data[:cf]
        chunks << @data[:format]
        chunks << @data[:strftime] if @data.key?(:strftime)

        chunks.join ':'
      end
    end
  end
end
