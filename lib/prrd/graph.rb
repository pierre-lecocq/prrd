# File: graph.rb
# Time-stamp: <2014-09-22 17:26:39 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Grapg class for PRRD

module PRRD
  class Graph

    attr_accessor :path
    attr_accessor :definitions
    attr_accessor :areas

    def initialize
      @definitions = []
      @areas = []
    end

    def add_definition(definition)
      @definitions << definition
    end

    def add_area(area)
      @areas << area
    end

    def generate
      p "Create graph #{@path}"
    end

  end
end
