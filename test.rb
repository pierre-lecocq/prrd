#!/usr/bin/env ruby

# File: test.rb
# Time-stamp: <2014-09-22 14:03:34 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Test file for PRRD class

require_relative 'lib/prrd'

# Setup a new prrd object
prrd = PRRD.new

prrd.database = File.expand_path('~/work/rrd/sample.rrd')
prrd.image = File.expand_path('/home/www/rrd/sample.png')

# ################
# Create database

prrd.start = (Time.now.to_i - 86_400)
prrd.step = 300

prrd.add_datasource name: 'data1', type: 'COUNTER', heartbeat: 120, min: 0, max: 'U'
prrd.add_datasource name: 'data2', type: 'COUNTER', heartbeat: 120, min: 0, max: 'U'

prrd.add_archive cf: 'LAST', xff: 0.5, step: 1, rows: 1440
prrd.add_archive cf: 'LAST', xff: 0.5, step: 5, rows: 2016

p prrd.create

# ####################################################
# Update database (with fake data, just for the demo)

timestamp = Time.now.to_i
value1 = 100
value2 = 200

p prrd.update timestamp, value1, value2

# #########################
# Generate the final graph

prrd.add_definition vname: "data1", ds_name: 'data2', cf: 'LAST'
prrd.add_definition vname: "data2", ds_name: 'data2', cf: 'LAST'

prrd.add_area value: 'data1#0000FF', legend: "Data 1"
prrd.add_area value: 'data2#FF0000', legend: "Data 2"

options = {
  title: 'My sample graph',
  width: 600,
  height: 300,
  lower_limit: 0,
  upper_limit: 100,
  vertical_label: '%',
  start: '0-6days',
  end: 'start+6days',
  color: [
    'GRID#aaaaaa',
    'MGRID#aaaaaa',
  ],
}

p prrd.graph options
