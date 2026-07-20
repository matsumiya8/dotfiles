#/bin/bash
if ! pgrep -x "dyn" > /dev/null; then
	exec $HOME/.config/scripts/dyn start 44 &
fi
rmpc
pkill -x dyn
pkill -x rmpcd
mpc stop

