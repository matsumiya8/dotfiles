#!/bin/bash
STRING="$1"
cdemu unload 0 && sleep 1.5
cdemu load 0 "$STRING"
