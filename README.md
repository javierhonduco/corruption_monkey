### Corruption monkey [![Build Status](https://travis-ci.org/javierhonduco/corruption_monkey.svg?branch=master)](https://travis-ci.org/javierhonduco/corruption_monkey) [![Gem Version](https://badge.fury.io/rb/corruption_monkey.svg)](http://badge.fury.io/rb/corruption_monkey)

TL;DR: do 🔬  with backups (and 🐒)

This Ruby library (and CLI) provides an easy way to flip bits in a provided file.

It was built in order to corrupt database backups and test if our current and future tools work and calculate their coverage.

#### Local installation
```bash
$ gem install corruption_monkey
```
or
```bash
$ git clone https://github.com/Shopify/corruption_monkey && cd corruption_monkey
$ rake install
```

#### CLI
```bash
# flip a bit in a specific bit index
$ flip <file> <position>

# flip a bit in some part of the file
$ flip <file> <percent>%

# flip a bit... somewhere ¯\_(ツ)_/¯
$ flip <file> chaos

# show help message with this examples
$ flip [help]

```
#### API
```ruby
require 'tempfile'
require 'logger'
require 'corruption_monkey'

file = Tempfile.new('whatever')
file_path = file.path
logger = Logger.new(nil)

# flip a bit in a specific bit index
BitFlipper.random_bit_flip(file_path, bit: 40, logger: logger)

# flip a bit in some part of thefile
BitFlipper.flip_in_range(file_path, percentile: 4, logger: logger)

# flip a bit... somewhere ¯\_(ツ)_/¯
BitFlipper.random_bit_flip(file_path, logger: logger)

```

#### Extra
You can generate png glitch art, too.
![image](https://cloud.githubusercontent.com/assets/959128/17756485/235c13ae-64ae-11e6-8583-5e606bcb45f3.png)

(From https://en.wikipedia.org/wiki/Portable_Network_Graphics)

#### ⚠️Caution!
This lib may improve your bit flipping skills.
