#!/bin/bash
set -o pipefail
sep=$'\x1f'
CONFIG_DEFAULT="$HOME/.config/proton.conf"
CONFIG_FILE="$1/proton.conf"
source "$CONFIG_DEFAULT" && source "$CONFIG_FILE"
OUTPUT=$(yad --title="Proton Launch Config" --form \
 --field="Disc":SFL "$DISC" \
 --field="Locale":CB "$(awk -v locale=$LOCALE 'NF && $1 !~ /^#/ {if (n++) printf "\\!"; if ($1 == locale) printf "^"; printf "%s", $1 } ' /etc/locale.gen)" \
 --field="Prefix":CB "$(find $PREFIXDIR/* -maxdepth 0 -type d -printf '%f\\!' | head -c -2 | sed 's/'"$PREFIX"'/^&/g')" \
 --field="Proton":CB "$({ find $COMPATDIR/* -maxdepth 0 -type d -printf '%f!'; [[ $(command -v wine) ]] && echo 'Wine'; } | sed "s/$PROTON/^&/g")" \
 --field="Native Wayland":CHK $WAYLAND \
 --field="Use D7VK":CHK $D7VK \
 --field="DLL Overrides (one per line)":TXT \
 --separator=$sep | sed 's/TRUE/1/g; s/FALSE/0/g') || exit 1
 
IFS=$sep read -r DISC LOCALE PREFIX PROTON WAYLAND D7VK DLL <<<"$OUTPUT"
DLLOVERRIDES=$(sed 's/\\n/\n/g' <<<"$DLL" | awk 'NF {print $0 "=n,b"}' | paste -sd ';')
declare -p DISC LOCALE PREFIX PROTON WAYLAND D7VK DLLOVERRIDES >"$1/proton.conf"
