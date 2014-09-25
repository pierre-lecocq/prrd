#!/usr/bin/env ruby

# File: apache.rb
# Time-stamp: <2014-09-25 13:10:44 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Sample PRRD usage - apache

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
database.path = $prrd_database_root_path + '/apache.rrd'

# Create database if needed

unless database.exists?

  # Set infos

  database.start = Time.now.to_i - 1
  database.step = 300

  # Set datasources
  datasources = [
    PRRD::Database::Datasource.new({name: 'status200', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'}),
    PRRD::Database::Datasource.new({name: 'status304', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'}),
    PRRD::Database::Datasource.new({name: 'status404', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'}),
    PRRD::Database::Datasource.new({name: 'status500', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'}),
    PRRD::Database::Datasource.new({name: 'others', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'})
  ]

  database.add_datasources datasources

  # Set archives

  archives = [
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 1, rows: 576}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 6, rows: 672}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 24, rows: 732}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 144, rows: 1460})
  ]

  database.add_archives archives

  # Create

  database.create

end

# Update database

log_file = '/home/www/logs/apache2-access.log'
tod = Time.now.strftime '%d/%b/%Y'
requests = { status200: 0, status304: 0, status404: 0, status500: 0, others: 0 }
File.open(log_file, 'r') do |fd|
  fd.each_line do |line|
    next unless line.include? tod
    if line =~ /(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3}) - - \[(.*)\] "([\w\/\s\.]+)" (\d+)/
      case $7.to_i
      when 200, 304, 404, 500
        requests["status#{$7}".to_sym] += 1
      else
        requests[:others] += 1
      end
    end
  end
end

database.update Time.now.to_i, requests[:status200], requests[:status304], requests[:status404], requests[:status500], requests[:others]

############################################
# Graph

graph = PRRD::Graph.new
graph.path = $prrd_image_root_path + '/apache.png'
graph.database = database
graph.width = $prrd_graph_width
graph.height = $prrd_graph_height
graph.title = 'HTTP request status codes'
graph.vertical_label = 'reqs'

# Set colors

colors = [
  PRRD::Graph::Color.new({colortag: 'BACK', color: '#151515'}),
  PRRD::Graph::Color.new({colortag: 'FONT', color: '#e5e5e5'}),
  PRRD::Graph::Color.new({colortag: 'CANVAS', color: '#252525'}),
  PRRD::Graph::Color.new({colortag: 'ARROW', color: '#ff0000'})
]

graph.add_colors colors

# Set definitions

definitions = [
  PRRD::Graph::Definition.new({vname: 'status200', rrdfile: database.path, ds_name: 'status200', cf: 'AVERAGE'}),
  PRRD::Graph::Definition.new({vname: 'status304', rrdfile: database.path, ds_name: 'status304', cf: 'AVERAGE'}),
  PRRD::Graph::Definition.new({vname: 'status404', rrdfile: database.path, ds_name: 'status404', cf: 'AVERAGE'}),
  PRRD::Graph::Definition.new({vname: 'status500', rrdfile: database.path, ds_name: 'status500', cf: 'AVERAGE'}),
  PRRD::Graph::Definition.new({vname: 'others', rrdfile: database.path, ds_name: 'others', cf: 'AVERAGE'})
]

graph.add_definitions definitions

# Set lines

areas = [
  PRRD::Graph::Area.new({value: 'status200', color: PRRD.color(:green), legend: '200'}),
  PRRD::Graph::Area.new({value: 'status304', color: PRRD.color(:orange), legend: '304'}),
  PRRD::Graph::Area.new({value: 'status404', color: PRRD.color(:red), legend: '404'}),
  PRRD::Graph::Area.new({value: 'status500', color: PRRD.color(:pink), legend: '500'}),
  PRRD::Graph::Area.new({value: 'others', color: PRRD.color(:yellow), legend: 'Others'})
]

graph.add_areas areas

# Create graph

graph.generate
