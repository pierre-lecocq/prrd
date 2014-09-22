# File: definition.rb
# Time-stamp: <2014-09-22 22:37:09 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Definition class for PRRD

module PRRD
  class Graph
    # PRRD Graph Definition class
    class Definition < PRRD::Entity
      # Constructor
      def initialize
        super
        @keys = [
          :vname,
          :rrdfile,
          :ds_name,
          :cf,
          :step,
          :start,
          :end
        ]
      end

      # Transform to a DEF formatted string
      def to_s
        fail 'Empty definition object' if @data.empty?

        chunks = [
          'DEF'
        ]

        @data.each do |k, v|
          if k == :vname
            chunks << "#{v}=#{@data[:rrdfile]}"
          elsif k == :rrdfile
            # nope
          else
            chunks << v
          end
        end

        chunks.join ':'
      end
    end
  end
end
