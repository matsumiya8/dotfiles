#!/bin/bash

umbriel subscribe workspaces | jq --unbuffered -r '.data[] | select(.focused) | "\(.output) \(.name)"' | while read -r display ws; do noctalia msg wallpaper-set $display ~/.cache/wallpapers/$ws; done