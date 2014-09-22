#!/usr/bin/env ruby

# File: test.rb
# Time-stamp: <2014-09-22 15:11:28 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Test file for PRRD class

require_relative 'lib/prrd'

# Setup a new prrd object
prrd = PRRD.new 'sample'

prrd.database_path = File.expand_path('~/work/prrd')
prrd.image_path = File.expand_path('~/work/prrd')

# ################
# Create database

prrd.start = (Time.now.to_i - 86_401)
prrd.step = 300

prrd.add_datasource name: 'ds1', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
prrd.add_datasource name: 'ds2', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'

prrd.add_archive cf: 'AVERAGE', xff: 0.5, step: 1, rows: 288
prrd.add_archive cf: 'AVERAGE', xff: 0.5, step: 3, rows: 672
prrd.add_archive cf: 'AVERAGE', xff: 0.5, step: 12, rows: 774

puts prrd.create

# ####################################################
# Update database with fake data

timestamp = Time.now.to_i

ts = prrd.start + 1
while ts < timestamp
  value1 = 30 + Random.rand(70)
  value2 = Random.rand(40)

  puts prrd.update(ts, value1, value2)

  ts += 300
end

# #########################
# Generate the final graph

prrd.add_definition vname: 'ds1', ds_name: 'ds1', cf: 'AVERAGE'
prrd.add_definition vname: 'ds2', ds_name: 'ds2', cf: 'AVERAGE'

# FIXME: if there is a space in the legend, we are fucked (because of _flatten)
prrd.add_area value: 'ds1#00FF00', legend: 'DS1'
prrd.add_area value: 'ds2#FF0000', legend: 'DS2'

options = {
  title: 'My sample graph',
  width: 600,
  height: 300,
  lower_limit: 0,
  upper_limit: 100,
  vertical_label: '%',
  color: [
    'GRID#aaaaaa',
    'MGRID#aaaaaa',
  ],
}

puts prrd.graph(options)
