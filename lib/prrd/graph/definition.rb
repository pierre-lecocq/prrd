# File: definition.rb
# Time-stamp: <2014-10-01 21:14:18 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Definition class for PRRD

module PRRD
  class Graph
    # PRRD Graph Definition class
    class Definition < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :vname,
          :rrdfile,
          :ds_name,
          :cf,
          :step,
          :start,
          :end
        ]

        super values
      end

      # Transform to a DEF formatted string
      def to_s
        fail 'Empty definition object' if @data.empty?

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :vname
            chunks << "DEF:%s=%s" % [@data[k], @data[:rrdfile]]
          when :rrdfile
            # nope
          else
            chunks << @data[k]
          end
        end

        chunks.join ':'
      end
    end
  end
end
