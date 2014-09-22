# File: archive.rb
# Time-stamp: <2014-09-22 17:52:53 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Archive class for PRRD

module PRRD
  class Database
    class Archive
      attr_accessor :data

      def initialize
        @data = {}
      end

      def to_s
        fail 'Empty archive object' if @data.empty?

        "RRA:#{@data.values.join ':'}"
      end
    end
  end
end
