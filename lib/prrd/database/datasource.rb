# File: datasource.rb
# Time-stamp: <2014-09-23 10:31:33 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Datasource class for PRRD

module PRRD
  class Database
    # PRRD Database Datasource class
    class Datasource < PRRD::Entity
      # Constructor
      def initialize
        super
        @keys = [
          :name,
          :type,
          :heartbeat,
          :min,
          :max
        ]
      end

      # Transform to a DS formatted string
      def to_s
        fail 'Empty datasource object' if @data.empty?

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
