#!/usr/bin/env ruby

# File: test.rb
# Time-stamp: <2014-09-22 17:35:54 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Test file for PRRD library

require_relative 'lib/prrd'

############################################
# Database

db = PRRD::Database.new
db.path = File.expand_path './dummy.rrd'

# Create database if needed
unless db.exists?
  # Set datasources
  datasource = PRRD::Database::Datasource.new
  db.add_datasource datasource

  # Set archives
  archive = PRRD::Database::Archive.new
  db.add_archive archive

  # Create
  db.create
end

# Update database with fake data
db.update

############################################
# Graph

graph = PRRD::Graph.new
graph.path = File.expand_path './dummy.png'

# Set definitions
definition = PRRD::Graph::Definition.new
graph.add_definition definition

# Set areas
area = PRRD::Graph::Area.new
graph.add_area area

# Create graph
graph.generate
