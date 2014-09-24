#!/usr/bin/env ruby

# File: network.rb
# Time-stamp: <2014-09-24 23:01:40 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - network

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
database.path = $prrd_database_root_path + '/network.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 1
  database.step = 300

  # Set datasources

  ds = PRRD::Database::Datasource.new name: 'recv', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
  database.add_datasource ds

  ds = PRRD::Database::Datasource.new name: 'send', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
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

recv_value = `cat /proc/net/dev | grep eth0 | awk '{print $2}'`.chomp
send_value = `cat /proc/net/dev | grep eth0 | awk '{print $9}'`.chomp

database.update Time.now.to_i, recv_value, send_value

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/network.png'
graph.database = database
graph.width = $prrd_graph_width
graph.height = $prrd_graph_height
graph.title = 'Network'

# Set definitions

d = PRRD::Graph::Definition.new vname: 'recv', rrdfile: database.path, ds_name: 'recv', cf: 'AVERAGE'
graph.add_definition d

d = PRRD::Graph::Definition.new vname: 'send', rrdfile: database.path, ds_name: 'send', cf: 'AVERAGE'
graph.add_definition d

# Set lines

area = PRRD::Graph::Area.new value: 'recv', color: PRRD.color(:blue, :dark), legend: 'Reveived'
graph.add_area area

area = PRRD::Graph::Area.new value: 'send', color: PRRD.color(:red, :dark), legend: 'Send'
graph.add_area area

# Create graph

graph.generate
