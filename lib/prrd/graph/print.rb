#!/usr/bin/env ruby

# File: print.rb
# Time-stamp: <2014-09-23 11:23:31 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Print class for PRRD

module PRRD
  class Graph
    # PRRD Graph Line class
    class Print < PRRD::Entity
      # Constructor
      def initialize
        super
        @keys = [
          :gprint,
          :vname,
          :cf,
          :format
        ]
      end

      # Transform to a PRINT formatted string
      def to_s
        fail 'Empty print object' if @data.empty?

        chunks = []

        if @data.key?(:gprint) && @data[:gprint] == true
          chunks << 'GPRINT'
        else
          chunks << 'PRINT'
        end

        chunks << "#{@data[:vname]}"
        chunks << "#{@data[:cf]}"
        chunks << "#{@data[:format]}"

        chunks.join ':'
      end
    end
  end
end
