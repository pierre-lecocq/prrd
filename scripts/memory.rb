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
database.path = $prrd_database_root_path + '/memory.rrd'

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

  ds = PRRD::Database::Datasource.new
  ds.name = 'swap'
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

memory_value = `free -b | grep "Mem:" | awk '{print $3}'`.chomp
swap_value = `free -b | grep "Swap:" | awk '{print $3}'`.chomp

database.update Time.now.to_i, memory_value, swap_value

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/memory.png'
graph.database = database
graph.width = 800
graph.height = 400

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

definition = PRRD::Graph::Definition.new
definition.vname = 'swap'
definition.rrdfile = database.path
definition.ds_name = 'swap'
definition.cf = 'AVERAGE'
graph.add_definition definition

# Set areas

area = PRRD::Graph::Area.new
area.value = 'memory'
area.color = PRRD.color(:blue, :dark)
area.legend = 'memory'
graph.add_area area

area = PRRD::Graph::Area.new
area.value = 'swap'
area.color = PRRD.color(:red, :dark)
area.legend = 'swap'
graph.add_area area

# Create graph

graph.generate
