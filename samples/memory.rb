#!/usr/bin/env ruby

# File: memory.rb
# Time-stamp: <2014-09-23 21:21:20 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - memory

require_relative '../lib/prrd'

begin
  require_relative './config.rb'
rescue LoadError
  fail 'Config file "config.rb" not found. You should copy "config.rb-example" to "config.rb" and adapt it to your needs'
end

############################################
# Database

database = PRRD::Database.new
database.path = $prrd_database_root_path + '/sample.memory.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 1
  database.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new
  ds.name = 'memory'
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
  ar.rows = 576
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 6
  ar.rows = 672
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 24
  ar.rows = 732
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 144
  ar.rows = 1460
  database.add_archive ar

  # Create

  database.create

end

# Update database

database.update Time.now.to_i, `free -b | grep "Mem:" | awk '{print $3}'`

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/sample.memory.png'
graph.database = database

# Set infos

graph.title = 'Memory usage'
graph.vertical_label = 'B'

# Set definitions

definition = PRRD::Graph::Definition.new
definition.vname = 'memory'
definition.rrdfile = database.path
definition.ds_name = 'memory'
definition.cf = 'AVERAGE'
graph.add_definition definition

# Set lines

line = PRRD::Graph::Line.new
line.width = 2
line.value = 'memory'
line.color = PRRD.color(:blue, :dark)
line.legend = 'memory'
graph.add_line line

# Create graph

graph.generate
