# File: archive.rb
# Time-stamp: <2014-09-30 00:04:06 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Archive class for PRRD

module PRRD
  class Database
    # PRRD Database Archive class
    class Archive < PRRD::Entity
      # Constructor
      def initialize(values = nil)
        @keys = [
          :cf,
          :xff,
          :steps,
          :rows
        ]

        super values
      end

      # Transform to a RRA formatted string
      def to_s
        fail 'Empty archive object' if @data.empty?

        validate_presence :cf, :xff, :steps, :rows

        chunks = ['RRA']

        @keys.each do |k|
          next unless @data.key?(k)
          chunks << @data[k]
        end

        chunks.join ':'
      end
    end
  end
end
