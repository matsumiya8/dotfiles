#!/bin/bash

stdbuf -i0 -e0 -o0 playerctl -p playerctld metadata --follow --format '{{ emoji(status) }} {{ artist }} - {{ title }}'
