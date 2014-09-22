#!/usr/bin/env ruby

# File: test.rb
# Time-stamp: <2014-09-22 20:53:56 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Test file for PRRD library

require_relative 'lib/prrd'

############################################
# Database

db = PRRD::Database.new
db.path = File.expand_path './dummy.rrd'

# Create database if needed

unless db.exists?

  # Set infos

  db.start = Time.now.to_i - 86_400
  db.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new
  ds.name = 'ds1'
  ds.type = 'GAUGE'
  ds.heartbeat = 600
  ds.min = 0
  ds.max = 'U'
  db.add_datasource ds

  ds = PRRD::Database::Datasource.new
  ds.name = 'ds2'
  ds.type = 'GAUGE'
  ds.heartbeat = 600
  ds.min = 0
  ds.max = 'U'
  db.add_datasource ds

  # Set archives

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 1
  ar.rows = 288
  db.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 3
  ar.rows = 672
  db.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 12
  ar.rows = 774
  db.add_archive ar

  # Create

  puts db.create

end

# Update database with fake data

timestamp = db.start + 1
while timestamp < Time.now.to_i
  value1 = 30 + Random.rand(70)
  value2 = Random.rand(40)

  puts db.update(timestamp, value1, value2)

  timestamp += 300
end

############################################
# Graph

graph = PRRD::Graph.new db.path
graph.path = File.expand_path './dummy.png'

# Set definitions
definition = PRRD::Graph::Definition.new
graph.add_definition definition

# Set areas
area = PRRD::Graph::Area.new
graph.add_area area

# Create graph
graph.generate
