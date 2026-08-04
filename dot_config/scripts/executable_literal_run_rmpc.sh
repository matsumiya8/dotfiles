#/bin/bash
! pgrep -x "dyn" > /dev/null && exec $HOME/.config/scripts/dyn start 44 &
! pgrep -x "rmpcd" > /dev/null && exec $HOME/.cargo/bin/rmpcd &>/dev/null &
mpc play
rmpc
mpc stop
pkill -x dyn
pkill -x rmpcd

