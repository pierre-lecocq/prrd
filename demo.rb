#!/usr/bin/env ruby

# File: test.rb
# Time-stamp: <2014-09-23 10:53:25 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Test file for PRRD library

require_relative 'lib/prrd'

############################################
# Database

database = PRRD::Database.new
database.path = File.expand_path './dummy.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 86_400
  database.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new
  ds.name = 'ds1'
  ds.type = 'GAUGE'
  ds.heartbeat = 600
  ds.min = 0
  ds.max = 'U'
  database.add_datasource ds

  ds = PRRD::Database::Datasource.new
  ds.name = 'ds2'
  ds.type = 'GAUGE'
  ds.heartbeat = 600
  ds.min = 0
  ds.max = 'U'
  database.add_datasource ds

  # Set archives

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 1
  ar.rows = 288
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 3
  ar.rows = 672
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 12
  ar.rows = 774
  database.add_archive ar

  # Create

  puts database.create

end

# Update database with fake data

timestamp = database.start + 1
while timestamp < Time.now.to_i
  value1 = 30 + Random.rand(70)
  value2 = Random.rand(40)

  puts database.update(timestamp, value1, value2)

  timestamp += 300
end

############################################
# Graph

graph = PRRD::Graph.new
graph.path = File.expand_path './dummy.png'
graph.database = database

# Set infos

graph.title = 'Dummy graph'
graph.vertical_label = '%'
graph.lower_limit = 0
graph.upper_limit = 100
graph.rigid = true

# Set definitions

definition = PRRD::Graph::Definition.new
definition.vname = 'ds1'
definition.rrdfile = database.path
definition.ds_name = 'ds1'
definition.cf = 'AVERAGE'
graph.add_definition definition

definition = PRRD::Graph::Definition.new
definition.vname = 'ds2'
definition.rrdfile = database.path
definition.ds_name = 'ds2'
definition.cf = 'AVERAGE'
graph.add_definition definition

# Set areas

=begin

area = PRRD::Graph::Area.new
area.value = "ds1"
area.color = PRRD.color(:green)
area.legend = "Dataset 1"
graph.add_area area

area = PRRD::Graph::Area.new
area.value = "ds2"
area.color = PRRD.color(:red)
area.legend = "Dataset 2"
graph.add_area area

=end

# Set lines

line = PRRD::Graph::Line.new
line.width = 3
line.value = "ds1"
line.color = PRRD.color(:green)
line.legend = "Dataset 1"
graph.add_line line

line = PRRD::Graph::Line.new
line.width = 1
line.value = "ds2"
line.color = PRRD.color(:red)
line.legend = "Dataset 2"
graph.add_line line

# Create graph

puts graph.generate
