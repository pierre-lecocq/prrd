#!/usr/bin/env ruby

# File: memory.rb
# Time-stamp: <2014-09-24 10:50:49 pierre>
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

ram_value = `free -b | grep 'Mem:' | awk '{print $3"-($5"-"$6)"}'`.chomp
swap_value = `free -b | grep "Swap:" | awk '{print $3}'`.chomp

database.update Time.now.to_i, ram_value, swap_value

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/memory.png'
graph.database = database
graph.width = 800
graph.height = 400
graph.title = 'Memory usage'
graph.vertical_label = 'B'

# Set definitions

d = PRRD::Graph::Definition.new vname: 'ram', rrdfile: database.path, ds_name: 'ram', cf: 'AVERAGE'
graph.add_definition d

d = PRRD::Graph::Definition.new vname: 'swap', rrdfile: database.path, ds_name: 'swap', cf: 'AVERAGE'
graph.add_definition d

# Set lines

line = PRRD::Graph::Line.new value: 'ram', width: 1, color: PRRD.color(:blue, :dark), legend: 'RAM'
graph.add_line line

line = PRRD::Graph::Line.new value: 'swap', width: 1, color: PRRD.color(:red, :dark), legend: 'SWAP'
graph.add_line line

# Create graph

graph.generate
