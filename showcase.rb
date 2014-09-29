#!/usr/bin/env ruby

# File: showcase.rb
# Time-stamp: <2014-09-30 00:15:35 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Showcase

require_relative 'lib/prrd'

create = false

# PRRD.activate_debug_mode

dbpath = '/home/pierre/rrd/showcase.rrd'
imgpath = '/home/pierre/rrd/showcase.png'
start_ts = Time.now.to_i - 86_400

if create
  begin
    File.delete dbpath, imgpath
  rescue Exception
    puts 'Nothing to delete, but we do not care'
  end
end

# Db :: init

database = PRRD::Database.new({path: dbpath, start: start_ts, step: 300})

if create

  database.add_datasources [
    PRRD::Database::Datasource.new({name: 'ds1', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'}),
    PRRD::Database::Datasource.new({name: 'ds2', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'})
  ]

  database.add_archives [
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 1, rows: 576}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 6, rows: 672}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 24, rows: 732}),
    PRRD::Database::Archive.new({cf: 'AVERAGE', xff: 0.5, steps: 144, rows: 1460})
  ]

  database.create

  # Db :: update

  now_ts = Time.now.to_i
  update_ts = start_ts + 1
  while update_ts < now_ts
    value1 = 90 + Random.rand(20)
    value2 = 90 + Random.rand(5)

    database.update update_ts, value1, value2
    update_ts += 1
  end

end

# Graph :: init

graph = PRRD::Graph.new({path: imgpath, database: database, width: 1024, height: 768, title: 'Showcase'})

graph.add_colors [
  PRRD::Graph::Color.new({colortag: 'BACK', color: '#222222'}),
  PRRD::Graph::Color.new({colortag: 'FONT', color: '#777777'}),
  PRRD::Graph::Color.new({colortag: 'CANVAS', color: '#222222'}),
  PRRD::Graph::Color.new({colortag: 'ARROW', color: '#00ff00'}),
  PRRD::Graph::Color.new({colortag: 'GRID', color: '#444444'}),
  PRRD::Graph::Color.new({colortag: 'MGRID', color: '#333333'}),
]

graph.add_definitions [
  PRRD::Graph::Definition.new({vname: 'ds1', rrdfile: database.path, ds_name: 'ds1', cf: 'AVERAGE'}),
  PRRD::Graph::Definition.new({vname: 'ds2', rrdfile: database.path, ds_name: 'ds2', cf: 'AVERAGE'})
]

graph.add_comment PRRD::Graph::Comment.new({text: "This is a comment"})

graph.add_print PRRD::Graph::Print.new({gprint: true, vname: 'ds1', cf: 'AVERAGE', format: "%3.3le"})
graph.add_print PRRD::Graph::Print.new({gprint: true, vname: 'ds2', cf: 'AVERAGE', format: "%3.3le"})

color1 = PRRD::Color.new(:blue)
color2 = PRRD::Color.new(:red)

graph.add_areas [
  PRRD::Graph::Area.new({value: 'ds1', color: color1, legend: 'Ds1'}),
  PRRD::Graph::Area.new({value: 'ds2', color: color2, legend: 'Ds2'})
]

graph.add_lines [
  PRRD::Graph::Line.new({width: 1, value: 'ds1', color: color1.lighten(50), legend: 'Ds1'}),
  PRRD::Graph::Line.new({width: 1, value: 'ds2', color: color2.lighten(50), legend: 'Ds2'})
]

# Graph :: Generate

graph.generate
