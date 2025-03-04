#!/bin/bash

sf=~/Uploads/Screenshots
random=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 9 ; echo)

maim -s $sf/$random.png
~/.config/scripts/uploader.sh $sf/$random.png
