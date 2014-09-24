#!/usr/bin/env ruby

# File: process.rb
# Time-stamp: <2014-09-24 15:39:38 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - process

require_relative '../lib/prrd'

begin
  require_relative './config.rb'
rescue LoadError
  puts '[WARNING] Config file "config.rb" not found. You should copy "config.rb-example" to "config.rb" and adapt it to your needs'
end

$prrd_database_root_path = Dir.home if $prrd_database_root_path.nil?
$prrd_image_root_path = Dir.home if $prrd_image_root_path.nil?
$prrd_graph_width ||= 600
$prrd_graph_height ||= 300

############################################
# Database

database = PRRD::Database.new
database.path = $prrd_database_root_path + '/process.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 1
  database.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new name: 'user', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
  database.add_datasource ds

  ds = PRRD::Database::Datasource.new name: 'sys', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
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

processes = { user: 0, sys: 0 }
File.open('/proc/stat', 'r') do |fd|
  fd.each_line do |line|
    if line =~ /processes\s+(\d+)\s+(\d+)\s+(\d+)/
      processes[:user] = $1.to_i
      processes[:sys] = $3.to_i
    end
  end
end

database.update Time.now.to_i, processes[:user], processes[:sys]

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/process.png'
graph.database = database
graph.width = $prrd_graph_width
graph.height = $prrd_graph_height
graph.title = 'Processes'
graph.base = 1024

# Set definitions

d = PRRD::Graph::Definition.new vname: 'user', rrdfile: database.path, ds_name: 'user', cf: 'AVERAGE'
graph.add_definition d

d = PRRD::Graph::Definition.new vname: 'sys', rrdfile: database.path, ds_name: 'sys', cf: 'AVERAGE'
graph.add_definition d

# Set lines

line = PRRD::Graph::Line.new value: 'user', width: 1, color: PRRD.color(:blue, :dark), legend: 'User'
graph.add_line line

line = PRRD::Graph::Line.new value: 'sys', width: 1, color: PRRD.color(:red, :dark), legend: 'System'
graph.add_line line

# Create graph

graph.generate
