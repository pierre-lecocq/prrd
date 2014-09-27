#!/usr/bin/env ruby

# File: cpu.rb
# Time-stamp: <2014-09-27 10:39:29 pierre>
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

  values = {
    name: 'cpu',
    type: 'GAUGE',
    heartbeat: 600,
    min: 0,
    max: 'U'
  }

  database.add_datasource PRRD::Database::Datasource.new(values)

  # Set archives

  values = {
    cf: 'AVERAGE',
    xff: 0.5,
    steps: 1,
    rows: 576
  }

  database.add_archive PRRD::Database::Archive.new(values)

  values = {
    cf: 'AVERAGE',
    xff: 0.5,
    steps: 6,
    rows: 672
  }

  database.add_archive PRRD::Database::Archive.new(values)

  values = {
    cf: 'AVERAGE',
    xff: 0.5,
    steps: 24,
    rows: 732
  }

  database.add_archive PRRD::Database::Archive.new(values)

  values = {
    cf: 'AVERAGE',
    xff: 0.5,
    steps: 144,
    rows: 1460
  }

  database.add_archive PRRD::Database::Archive.new(values)

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
graph.title = 'CPU load (%)'
graph.lower_limit = 0
graph.upper_limit = 100

# Set definitions

values = {
  vname: 'cpu',
  rrdfile: database.path,
  ds_name: 'cpu',
  cf: 'AVERAGE'
}

graph.add_definition PRRD::Graph::Definition.new(values)

# Set lines

values = {
  width: 1,
  value: 'cpu',
  color: PRRD.color(:red),
  legend: 'cpu'
}

graph.add_line PRRD::Graph::Line.new(values)

# Create graph

graph.generate
