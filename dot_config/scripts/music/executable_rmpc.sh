#/bin/bash
! pgrep -x "dyn" > /dev/null && exec $HOME/.config/scripts/music/dyn start 44 &
! pgrep -x "rmpcd" > /dev/null && exec $HOME/.cargo/bin/rmpcd &>/dev/null &
mpc play
[ -n "$1" ] && mpc insert "$1" && mpc next
rmpc
mpc stop
pkill -x dyn
pkill -x rmpcd

