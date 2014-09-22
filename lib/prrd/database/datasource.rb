# File: datasource.rb
# Time-stamp: <2014-09-22 17:52:58 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Datasource class for PRRD

module PRRD
  class Database
    class Datasource
      attr_accessor :data

      def initialize
        @data = {}
      end

      def to_s
        fail 'Empty datasource object' if @data.empty?

        "DS:#{@data.values.join ':'}"
      end
    end
  end
end
