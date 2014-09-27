#!/usr/bin/env ruby

# File: network.rb
# Time-stamp: <2014-09-27 12:02:57 pierre>
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
$prrd_network_interface ||= 'eth0'

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

  database << PRRD::Database::Datasource.new({name: 'recv', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})
  database << PRRD::Database::Datasource.new({name: 'send', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})

  # Set archives

  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 1, rows: 576})
  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 6, rows: 672})
  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 24, rows: 732})
  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 144, rows: 1460})

  # Create

  database.create

end

# Update database

recv_value = `cat /proc/net/dev | grep #{$prrd_network_interface} | awk '{print $2}'`.chomp
send_value = `cat /proc/net/dev | grep #{$prrd_network_interface} | awk '{print $9}'`.chomp

database.update Time.now.to_i, recv_value, send_value

############################################
# Graph

values = {
  path: $prrd_image_root_path + '/network.png',
  database: database,
  width: $prrd_graph_width,
  height: $prrd_graph_height,
  title: 'Network'
}

graph = PRRD::Graph.new(values)

# Set definitions

graph << PRRD::Graph::Definition.new({vname: 'recv', rrdfile: database.path, ds_name: 'recv', cf: 'AVERAGE'})
graph << PRRD::Graph::Definition.new({vname: 'send', rrdfile: database.path, ds_name: 'send', cf: 'AVERAGE'})

# Set areas

graph << PRRD::Graph::Area.new({value: 'recv', color: PRRD::Color.new(:blue), legend: 'Reveived'})
graph << PRRD::Graph::Area.new({value: 'send', color: PRRD::Color.new(:red), legend: 'Sent'})

# Create graph

graph.generate
