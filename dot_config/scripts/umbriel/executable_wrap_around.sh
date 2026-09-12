#!/bin/bash
action="$1" is_left_monitor=$(umbriel workspaces --json | jq '.[] | select(.focused).output == "DP-2"')
$is_left_monitor && umbriel msg $action-right || umbriel msg $action-left 
 