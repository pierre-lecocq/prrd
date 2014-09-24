#!/usr/bin/env ruby

# File: memory.rb
# Time-stamp: <2014-09-24 20:57:09 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - memory

require_relative '../lib/prrd'

begin
  require_relative './config.rb'
rescue LoadError
  puts '[WARNING] Config file "config.rb" not found. You should copy "config.rb-example" to "config.rb" and adapt it to your needs'
end

$prrd_database_root_path ||= Dir.home if $prrd_database_root_path.nil?
$prrd_image_root_path ||= Dir.home if $prrd_image_root_path.nil?
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

  ds = PRRD::Database::Datasource.new name: 'ram', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
  database.add_datasource ds

  ds = PRRD::Database::Datasource.new name: 'swap', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
  database.add_datasource ds

  # Set archives

  ar = PRRD::Database::Archive.new cf: 'AVERAGE', xff: 0.5, steps: 1, rows: 576
  database.add_archive ar

  ar = PRRD::Database::Archive.new cf: 'AVERAGE', xff: 0.5, steps: 6, rows: 672
  database.add_archive ar

  ar = PRRD::Database::Archive.new cf: 'AVERAGE', xff: 0.5, steps: 24, rows: 732
  database.add_archive ar

  ar = PRRD::Database::Archive.new cf: 'AVERAGE', xff: 0.5, steps: 144, rows: 1460
  database.add_archive ar

  # Create

  database.create

end

# Update database

ram = { total: 0, free: 0, used: 0 }
swap = { total: 0, free: 0, used: 0 }
File.open('/proc/meminfo', 'r') do |fd|
  fd.each_line do |line|
    ram[:total] = $1.to_i * 1024 if line =~ /MemTotal:\s*(\d+)/
    ram[:free] = $1.to_i * 1024 if line =~ /MemFree:\s*(\d+)/
    swap[:total] = $1.to_i * 1024 if line =~ /SwapTotal:\s*(\d+)/
    swap[:free] = $1.to_i * 1024 if line =~ /SwapFree:\s*(\d+)/
  end
end
ram[:used] = ram[:total] - ram[:free]
swap[:used] = swap[:total] - swap[:free]

database.update Time.now.to_i, ram[:used], swap[:used]

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/memory.png'
graph.database = database
graph.width = $prrd_graph_width
graph.height = $prrd_graph_height
graph.title = 'Memory usage'
graph.vertical_label = 'B'

# Set definitions

d = PRRD::Graph::Definition.new vname: 'ram', rrdfile: database.path, ds_name: 'ram', cf: 'AVERAGE'
graph.add_definition d

d = PRRD::Graph::Definition.new vname: 'swap', rrdfile: database.path, ds_name: 'swap', cf: 'AVERAGE'
graph.add_definition d

# Set area

area = PRRD::Graph::Area.new value: 'ram', color: PRRD.color(:blue, :dark), legend: 'RAM'
graph.add_area area

area = PRRD::Graph::Area.new value: 'swap', color: PRRD.color(:red, :dark), legend: 'Swap'
graph.add_area area

# Create graph

graph.generate
