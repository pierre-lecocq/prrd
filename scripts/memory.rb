#!/usr/bin/env ruby

# File: memory.rb
# Time-stamp: <2014-09-27 12:00:56 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - memory

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
database.path = $prrd_database_root_path + '/memory.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 1
  database.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new
  ds.name = 'ram'
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

ram = { total: 0, free: 0, used: 0 }
swap = { total: 0, free: 0, used: 0 }
File.open('/proc/meminfo', 'r') do |fd|
  fd.each_line do |line|
    ram[:total] = $1.to_i if line =~ /MemTotal:\s*(\d+)/
    ram[:free] = $1.to_i if line =~ /MemFree:\s*(\d+)/
    swap[:total] = $1.to_i if line =~ /SwapTotal:\s*(\d+)/
    swap[:free] = $1.to_i if line =~ /SwapFree:\s*(\d+)/
  end
end
ram[:used] = ram[:total] - ram[:free]
swap[:used] = swap[:total] - swap[:free]

database.update Time.now.to_i, ram[:used], swap[:used]

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/memory.png',
graph.database = database,
graph.width = $prrd_graph_width,
graph.height = $prrd_graph_height,
graph.title = 'Memory usage (B)'

# Set definitions

definition = PRRD::Graph::Definition.new
definition.vname = 'ram'
definition.rrdfile = database.path
definition.ds_name = 'ram'
definition.cf = 'AVERAGE'

graph.add_definition definition

definition = PRRD::Graph::Definition.new
definition.vname = 'swap'
definition.rrdfile = database.path
definition.ds_name = 'swap'
definition.cf = 'AVERAGE'

graph.add_definition definition

# Set area

area = PRRD::Graph::Area.new
area.value = 'ram'
area.color = PRRD::Color.new :blue
area.legend = 'RAM'

graph.add_area area

area = PRRD::Graph::Area.new
area.value = 'swap'
area.color = PRRD::Color.new :red
area.legend = 'Swap'

graph.add_area area

# Create graph

graph.generate
