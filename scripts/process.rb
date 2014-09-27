#!/usr/bin/env ruby

# File: process.rb
# Time-stamp: <2014-09-27 13:38:28 pierre>
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

  dss = [
    PRRD::Database::Datasource.new({name: 'user', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'}),
    PRRD::Database::Datasource.new({name: 'sys', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})
  ]

  database.add_datasources dss

  # Set archives

  ars = [
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 1, rows: 576}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 6, rows: 672}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 24, rows: 732}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 144, rows: 1460})
  ]

  database.add_archives ars

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

cls = [
  PRRD::Graph::Color.new({colortag: 'BACK', color: '#151515'}),
  PRRD::Graph::Color.new({colortag: 'FONT', color: '#e5e5e5'}),
  PRRD::Graph::Color.new({colortag: 'CANVAS', color: '#252525'}),
  PRRD::Graph::Color.new({colortag: 'ARROW', color: '#ff0000'})
]

graph.add_colors cls

# Set definitions

dfs = [
  PRRD::Graph::Definition.new({vname: 'user', rrdfile: database.path, ds_name: 'user', cf: 'AVERAGE'}),
  PRRD::Graph::Definition.new({vname: 'sys', rrdfile: database.path, ds_name: 'sys', cf: 'AVERAGE'})
]

graph.add_definitions dfs

# Set areas

color1 = PRRD::Color.new(:green)
color2 = color1.darken(60)

ars = [
  PRRD::Graph::Area.new({value: 'user', color: color1, legend: 'User'}),
  PRRD::Graph::Area.new({value: 'sys', color: color2, legend: 'System', stack: true})
]

graph.add_areas ars

# Set [v|h]rules

hrs = [
  PRRD::Graph::Hrule.new({value: 20, color: '#666666'}),
  PRRD::Graph::Hrule.new({value: 40, color: '#666666'}),
  PRRD::Graph::Hrule.new({value: 60, color: '#666666'}),
  PRRD::Graph::Hrule.new({value: 80, color: '#666666'})
]

graph.add_hrules hrs

vrs = [
  PRRD::Graph::Vrule.new({time: (Time.now.to_i - 21_600), color: '#666666'}),
  PRRD::Graph::Vrule.new({time: (Time.now.to_i - 43_200), color: '#666666'}),
  PRRD::Graph::Vrule.new({time: (Time.now.to_i - 64_800), color: '#666666'})
]

graph.add_vrules vrs

# Create graph

graph.generate
