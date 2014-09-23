# PRRD

A (simple) rrdtool ruby interface

## Disclaimer

Hold on please, work in progress ...

## Sample scripts

PRRD provides some real-world sample scripts located in the `samples` directory.

- A `memory` script that graph the consumption of memory and swap on your system (2 areas)
- A `cpu` script that graph the usage of your CPU (1 line)

To run them, simply type:

```
ruby samples/memory.rb
ruby samples/cpu.rb
```

Before that, you may be ask to copy `samples/config.rb-example` to `samples/config.rb` and edit it to fit to your needs

If you want to run them permanently, add these lines to your crontab (adpat paths and username):

```
*/5 *   * * *   username ruby /home/username/prrd/samples/memory.rb > /dev/null
*/5 *   * * *   usernaùe ruby /home/username/prrd/samples/cpu.rb > /dev/null
```
