# File: graph.rb
# Time-stamp: <2014-09-22 20:12:49 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Graph class for PRRD

module PRRD
  class Graph

    attr_accessor :path, :db_path
    attr_accessor :definitions
    attr_accessor :areas

    def initialize(db_path)
      @db_path = db_path
      @definitions = []
      @areas = []
    end

    def exists?
      File.exists? @path
    end

    def check_file
      fail 'Image path is missing' if  @path.nil? || !exists?
    end

    def db_exists?
      File.exists? @db_path
    end

    def check_db_file
      fail 'Database is missing' if  @db_path.nil? || !db_exists?
    end

    def add_definition(definition)
      @definitions << definition
    end

    def add_area(area)
      @areas << area
    end

    def generate
      check_file
      check_db_file

      p "Create graph #{@path}"
    end

  end
end
