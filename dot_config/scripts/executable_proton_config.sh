#!/bin/bash
set -o pipefail
sep=$'\x1f'

OUTPUT=$(yad --title="Proton Launch Config" --form \
 --field="Disc:SFL" "" \
 --field="Locale:":CB $(awk 'NF&&$1!~/^#/{print$1}' /etc/locale.gen|tac|sed ':a;N;$!ba;s/\n/!\\/g') \
 --field="Prefix:":CB "$(find $HOME/Games/umu/* -maxdepth 0 -type d -printf '%f\\!' | head -c -2)" \
 --field="Proton:":CB "$(find $HOME/.steam/steam/compatibilitytools.d/* -maxdepth 0 -type d -printf '%f\\!' | head -c -2; [[ $(command -v wine) ]] && echo '\!Wine')" \
 --field="Native Wayland":CHK 0 \
 --field="Use D7VK":CHK 0 \
 --field="DLL Overrides (one per line)":TXT \
 --separator=$sep | sed 's/TRUE/1/g; s/FALSE/0/g') || exit 1
 
IFS=$sep read -r DISC LOCALE PREFIX PROTON WAYLAND D7VK DLL <<<"$OUTPUT"
DLLOVERRIDES=$(sed 's/\\n/\n/g' <<<"$DLL" | awk 'NF {print $0 "=n,b"}' | paste -sd ';')
declare -p DISC LOCALE PREFIX PROTON WAYLAND D7VK DLLOVERRIDES >"$1/proton.conf"
