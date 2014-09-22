# File: database.rb
# Time-stamp: <2014-09-22 17:40:16 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Database class for PRRD

module PRRD
  class Database

    attr_accessor :path
    attr_accessor :start, :step
    attr_accessor :datasources, :archives

    def initialize
      @datasources = []
      @archives = []
    end

    def add_datasource(datasource)
      @datasources << datasource
    end

    def add_archive(archive)
      @archives << archive
    end

    def exists?
      File.exists? @path
    end

    def create
      p "Create database #{@path} with #{PRRD.bin}"
    end

    def update
      p "Update database #{@path} with #{PRRD.bin}"
    end

  end
end
