# File: definition.rb
# Time-stamp: <2014-09-23 10:20:46 pierre>
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

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :vname
            chunks << "DEF:#{@data[k]}=#{@data[:rrdfile]}"
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
