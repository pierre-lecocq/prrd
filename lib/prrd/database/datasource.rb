# File: datasource.rb
# Time-stamp: <2014-09-30 00:04:37 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Datasource class for PRRD

module PRRD
  class Database
    # PRRD Database Datasource class
    class Datasource < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :name,
          :type,
          :heartbeat,
          :min,
          :max
        ]

        super values
      end

      # Transform to a DS formatted string
      def to_s
        fail 'Empty datasource object' if @data.empty?

        validate_presence :name, :type, :heartbeat, :min, :max

        chunks = ['DS']

        @keys.each do |k|
          next unless @data.key?(k)
          chunks << @data[k]
        end

        chunks.join ':'
      end
    end
  end
end
