# File: vrule.rb
# Time-stamp: <2014-10-01 21:19:19 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Hrul class for PRRD

module PRRD
  class Graph
    # PRRD Graph Vrule class
    class Vrule < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :time,
          :color,
          :legend,
          :dashes,
          :dashes_offset
        ]

        super values
      end

      # Transform to a VRULE formatted string
      def to_s
        fail 'Empty vrule object' if @data.empty?

        validate_presence :time, :color

        chunks = []

        @keys.each do |k|
          next unless @data.key?(k)
          case k
          when :time
            chunks << "VRULE:%s%s" % [@data[k], @data[:color]]
          when :color
            # nope
          when :dashes
            chunks << "dashes=\"%s\"" % @data[k]
          when :dashes_offset
            chunks << "dashes-offset=\"%s\"" % @data[k]
          else
            chunks << @data[k]
          end
        end

        chunks.join ':'
      end
    end
  end
end
