#!/usr/bin/env ruby

# File: cpu.rb
# Time-stamp: <2014-09-24 21:10:41 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - cpu

require_relative '../lib/prrd'

begin
  require_relative './config.rb'
rescue LoadError
  puts '[WARNING] Config file "config.rb" not found. You should copy "config.rb-example" to "config.rb" and adapt it to your needs'
end

$prrd_database_root_path ||= Dir.home
$prrd_image_root_path ||= Dir.home
$prrd_graph_width ||= 600
$prrd_graph_height ||= 300

############################################
# Database

database = PRRD::Database.new
database.path = $prrd_database_root_path + '/cpu.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 1
  database.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new
  ds.name = 'cpu'
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

database.update Time.now.to_i, `vmstat 1 1 | tail -1 | awk '{print $13}'`

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/cpu.png'
graph.database = database
graph.width = $prrd_graph_width
graph.height = $prrd_graph_height

# Set infos

graph.title = 'CPU load'
graph.vertical_label = '%'
graph.lower_limit = 0
graph.upper_limit = 100

# Set definitions

definition = PRRD::Graph::Definition.new
definition.vname = 'cpu'
definition.rrdfile = database.path
definition.ds_name = 'cpu'
definition.cf = 'AVERAGE'
graph.add_definition definition

# Set lines

area = PRRD::Graph::Area.new
area.value = 'cpu'
area.color = PRRD.color(:yellow, :light)
area.legend = 'cpu'
graph.add_area area

# Create graph

graph.generate
