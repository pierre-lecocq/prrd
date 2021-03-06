#!/usr/bin/env ruby

# File: apache.rb
# Time-stamp: <2014-09-27 12:02:35 pierre>
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
  database << PRRD::Database::Datasource.new({name: 'status200', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})
  database << PRRD::Database::Datasource.new({name: 'status304', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})
  database << PRRD::Database::Datasource.new({name: 'status404', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})
  database << PRRD::Database::Datasource.new({name: 'status500', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})
  database << PRRD::Database::Datasource.new({name: 'others', type: 'COUNTER', heartbeat: 600, min: 0, max: 'U'})

  # Set archives

  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 1, rows: 576})
  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 6, rows: 672})
  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 24, rows: 732})
  database << PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 144, rows: 1460})

  # Create

  database.create

end

# Update database

log_file = '/home/www/logs/apache2-access.log'
tod = (Time.now - 300).strftime '%d/%b/%Y:%H:%M'
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

values = {
  path: $prrd_image_root_path + '/apache.png',
  database: database,
  width: $prrd_graph_width,
  height: $prrd_graph_height,
  title: 'HTTP request status codes'
}

graph = PRRD::Graph.new(values)

# Set colors

graph << PRRD::Graph::Color.new({colortag: 'BACK', color: '#151515'})
graph << PRRD::Graph::Color.new({colortag: 'FONT', color: '#e5e5e5'})
graph << PRRD::Graph::Color.new({colortag: 'CANVAS', color: '#252525'})
graph << PRRD::Graph::Color.new({colortag: 'ARROW', color: '#ff0000'})

# Set definitions

graph << PRRD::Graph::Definition.new({vname: 'status200', rrdfile: database.path, ds_name: 'status200', cf: 'AVERAGE'})
graph << PRRD::Graph::Definition.new({vname: 'status304', rrdfile: database.path, ds_name: 'status304', cf: 'AVERAGE'})
graph << PRRD::Graph::Definition.new({vname: 'status404', rrdfile: database.path, ds_name: 'status404', cf: 'AVERAGE'})
graph << PRRD::Graph::Definition.new({vname: 'status500', rrdfile: database.path, ds_name: 'status500', cf: 'AVERAGE'})
graph << PRRD::Graph::Definition.new({vname: 'others', rrdfile: database.path, ds_name: 'others', cf: 'AVERAGE'})

# Set areas

graph << PRRD::Graph::Area.new({value: 'status200', color: PRRD::Color.new(:green), legend: '200'})
graph << PRRD::Graph::Area.new({value: 'status304', color: PRRD::Color.new(:orange), legend: '304'})
graph << PRRD::Graph::Area.new({value: 'status404', color: PRRD::Color.new(:red), legend: '404'})
graph << PRRD::Graph::Area.new({value: 'status500', color: PRRD::Color.new(:pink), legend: '500'})
graph << PRRD::Graph::Area.new({value: 'others', color: PRRD::Color.new(:yellow), legend: 'Others'})

# Create graph

graph.generate
