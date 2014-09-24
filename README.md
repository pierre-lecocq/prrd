# PRRD

A (simple) rrdtool ruby interface

## Disclaimer

Hold on please, work in progress ...

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
*/5 *   * * *   usernaùe ruby /home/username/prrd/scripts/cpu.rb > /dev/null
*/5 *   * * *   usernaùe ruby /home/username/prrd/scripts/process.rb > /dev/null
*/5 *   * * *   usernaùe ruby /home/username/prrd/scripts/network.rb > /dev/null
```
