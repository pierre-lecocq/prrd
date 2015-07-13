# PRRD

A (simple) rrdtool ruby interface

## Disclaimer

Hold on please, work in progress ...

## Install

To install PRRD, you can simply install the gem

```
sudo gem install prrd
```

*OR*, to install PRRD the traditional way, install dependencies and clone this repository:

```
sudo gem install bundler
git clone https://github.com/pierre-lecocq/prrd
cd prrd
bundle install
```

## Usage

### Require the library

`require '/path/to/prrd/lib/prdd.rb'`

### Define a database

```
database = PRRD::Database.new
database.path = '/path/to/your/directory/sample.rrd'

unless database.exists?

  database.start = Time.now.to_i
  database.step = 300

  # Add datasources

  ds = PRRD::Database::Datasource.new
  ds.name = 'ds1'
  ds.type = 'GAUGE'
  ds.heartbeat = 600
  ds.min = 0
  ds.max = 'U'
  database.add_datasource ds

  ds = PRRD::Database::Datasource.new
  ds.name = 'ds2'
  ds.type = 'GAUGE'
  ds.heartbeat = 600
  ds.min = 0
  ds.max = 'U'
  database.add_datasource ds

  # Add archives

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 1
  ar.rows = 576
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 6
  ar.rows = 672
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 24
  ar.rows = 732
  database.add_archive ar

  ar = PRRD::Database::Archive.new
  ar.cf = 'AVERAGE'
  ar.xff = 0.5
  ar.steps = 144
  ar.rows = 1460
  database.add_archive ar

  # Create

  database.create

end
```

### Update the database

```
value_ds1 = 125
value_ds2 = 38

database.update Time.now.to_i, value_ds1, value_ds2

```

### Generate the graph

```
graph = PRRD::Graph.new
graph.path = '/path/to/your/directory/sample.png'
graph.database = database
graph.width = 600
graph.height = 300
graph.title = 'My graph'
graph.vertical_align = 'My vertical label'

# Optionally set colors

graph.add_color PRRD::Graph::Color.new colortag: 'BACK', color: '#151515'
graph.add_color PRRD::Graph::Color.new colortag: 'FONT', color: '#e5e5e5'
graph.add_color PRRD::Graph::Color.new colortag: 'CANVAS', color: '#252525'
graph.add_color PRRD::Graph::Color.new colortag: 'ARROW', color: '#ff0000'

# Set definitions

graph.add_definition PRRD::Graph::Definition.new vname: 'ds1', rrdfile: database.path, ds_name: 'ds1', cf: 'AVERAGE'
graph.add_definition PRRD::Graph::Definition.new vname: 'ds2', rrdfile: database.path, ds_name: 'ds2', cf: 'AVERAGE'

# Set lines

graph.add_line PRRD::Graph::Line.new value: 'ds1', width: 3, color: PRRD.color(:blue), legend: 'Ds1'
graph.add_line PRRD::Graph::Line.new value: 'ds2', color: PRRD.color(:blue), legend: 'Ds2'

# Create graph

graph.generate

```

## Syntaxes

For each element of a database or a graph, there are alternative syntaxes to create them.

Let's take an exemple with Datasources, but it is the same for Archives, Colors, Lines, Areas, ... and so on.

(Note: each example in the `scripts` folder use a different syntax as a showcase of all different ways to write PRRD scripts)

### Object properties

```
ds = PRRD::Database::Datasource.new
ds.name = 'ds1'
ds.type = 'GAUGE'
ds.heartbeat = 600
ds.min = 0
ds.max = 'U'
database.add_datasource ds

ds = PRRD::Database::Datasource.new
ds.name = 'ds2'
ds.type = 'GAUGE'
ds.heartbeat = 600
ds.min = 0
ds.max = 'U'
database.add_datasource ds
```

### Hashes

```
ds = PRRD::Database::Datasource.new name: = 'ds1', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
database.add_datasource ds

ds = PRRD::Database::Datasource.new name: = 'ds2', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'
database.add_datasource ds
```

### Array of hashes

```
dss = [
  PRRD::Database::Datasource.new({name: = 'ds1', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'}),
  PRRD::Database::Datasource.new({name: = 'ds2', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'}),
]

database.add_datasources dss
```

### Add objects

This syntax auto-detect the type and add it properly to the database or graph object

```
database << PRRD::Database::Datasource.new({name: = 'ds1', type: 'GAUGE', heartbeat: 600, min: 0, max: 'U'})
graph << PRRD::Graph::Line.new({width: 2, value: = 'ds1', color: PRRD.color(:blue), legend: 'DS1'})
```

## Sample scripts

PRRD provides some real-world sample scripts located in the `scripts` directory.

- A `memory` script that graphs the consumption of memory and swap on your system
- A `cpu` script that graphs the usage of your CPU
- A `process` script that graphs the user and system processes
- A `network` script that graphs the send and recv packaged on your network interface (eth0)

To run them, simply type:

```
ruby scripts/memory.rb
ruby scripts/cpu.rb
ruby scripts/process.rb
ruby scripts/network.rb
```

Before that, you may be ask to copy `scripts/config.rb-example` to `scripts/config.rb` and edit it to fit to your needs

If you want to run them permanently, add these lines to your crontab (adpat *paths* and *username*):

```
*/5 *   * * *   username ruby /home/username/prrd/scripts/memory.rb > /dev/null
*/5 *   * * *   username ruby /home/username/prrd/scripts/cpu.rb > /dev/null
*/5 *   * * *   username ruby /home/username/prrd/scripts/process.rb > /dev/null
*/5 *   * * *   username ruby /home/username/prrd/scripts/network.rb > /dev/null
```
