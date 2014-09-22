# File: archive.rb
# Time-stamp: <2014-09-22 20:52:28 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Archive class for PRRD

module PRRD
  class Database
    # PRRD Database Archive class
    class Archive < PRRD::Entity
      # Constructor
      def initialize
        super
        @keys = [
          :cf,
          :xff,
          :steps,
          :rows
        ]
      end

      # Transform to a RRA formatted string
      def to_s
        fail 'Empty archive object' if @data.empty?

        "RRA:#{@data.values.join ':'}"
      end
    end
  end
end
