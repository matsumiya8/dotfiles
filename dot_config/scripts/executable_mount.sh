#!/bin/bash
STRING=$(echo $1 | tr -d "'")
cdemu unload 0 && sleep 1.5
cdemu load 0 "$STRING"
