#!/bin/bash
set -o pipefail
SEP=$'\x1f'
DEFAULTCONFIG="$HOME/.config/proton.conf"
source "$DEFAULTCONFIG" && source "$GAMECONFIG"
[ -z "$PROTON" ] && PROTON="$DEFAULTPROTON"

OUTPUT=$(yad --title="Proton Launch Config" --form \
 --field="Disc":SFL "$DISC" \
 --field="Locale":CB "$(awk -v locale=$LOCALE 'NF && $1 !~ /^#/ {if (n++) printf "\\!"; if ($1 == locale) printf "^"; printf "%s", $1 } ' /etc/locale.gen)" \
 --field="Prefix":CB "$(find $PREFIXDIR/* -maxdepth 0 -type d -printf '%f\\!' | head -c -2 | sed 's/'"$PREFIX"'/^&/g')" \
 --field="Proton":CB "$({ find $COMPATDIR/* -maxdepth 0 -type d -printf '%f!'; [[ $(command -v wine) ]] && echo 'Wine'; } | sed "s/$PROTON/^&/g")" \
 --field="D7VK":CHK $D7VK \
 --field="Wayland":CHK $WAYLAND \
 --field="DLL Overrides (; separated)":TXT "$GAMEOVERRIDES" \
 --separator=$SEP | sed 's/TRUE/1/g; s/FALSE/0/g') || exit 1

VARS=(DISC LOCALE PREFIX PROTON D7VK WAYLAND GAMEOVERRIDES) 
IFS=$SEP read -r "${VARS[@]}" <<<"$OUTPUT"
declare -p "${VARS[@]}" >"$GAMECONFIG"
