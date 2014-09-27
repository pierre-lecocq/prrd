#!/usr/bin/env ruby

# File: html.rb
# Time-stamp: <2014-09-27 14:17:55 pierre>
# Copyright (C) 2014 Pierre Lecocq
# Description: Generate HTML for PRRD graphs

machine = `hostname`.chomp

graphs = [
  'cpu',
  'memory',
  'process',
  'network',
  'apache'
]

chunks = []

chunks << "<html><head><title>#{machine} - RRD</title>"
chunks << '<meta http-equiv="refresh" content="300" />'
chunks << '<style>body { font-family: Arial; } img { margin: 10px; }</style>'
chunks << '</head><body>'

graphs.each do |g|
  chunks << "<img src=\"#{g}.png\" alt=\"Graph #{g}\" />"
end

chunks << '</body></html>'

File.write 'index.html', chunks.join("\n")
