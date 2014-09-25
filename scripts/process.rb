#!/usr/bin/env ruby

# File: process.rb
# Time-stamp: <2014-09-25 13:32:03 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - process

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
database.path = $prrd_database_root_path + '/process.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 1
  database.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new name: 'user', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'
  database.add_datasource ds

  ds = PRRD::Database::Datasource.new name: 'sys', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'
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
    if line =~ /cpu\s+(\d+)\s+(\d+)\s+(\d+)/
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

# Set colors

graph.add_color PRRD::Graph::Color.new colortag: 'BACK', color: '#151515'
graph.add_color PRRD::Graph::Color.new colortag: 'FONT', color: '#e5e5e5'
graph.add_color PRRD::Graph::Color.new colortag: 'CANVAS', color: '#252525'
graph.add_color PRRD::Graph::Color.new colortag: 'ARROW', color: '#ff0000'

# Set definitions

d = PRRD::Graph::Definition.new vname: 'user', rrdfile: database.path, ds_name: 'user', cf: 'AVERAGE'
graph.add_definition d

d = PRRD::Graph::Definition.new vname: 'sys', rrdfile: database.path, ds_name: 'sys', cf: 'AVERAGE'
graph.add_definition d

# Set lines

area = PRRD::Graph::Area.new value: 'user', color: PRRD.color(:blue), legend: 'User'
graph.add_area area

area = PRRD::Graph::Area.new value: 'sys', color: PRRD.color(:red), legend: 'System'
graph.add_area area

# Create graph

graph.generate
