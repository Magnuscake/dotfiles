#!/bin/bash
if pgrep -x "picom" > /dev/null
then
	killall picom
else
  picom -b --experimental-backends --config $HOME/.config/picom/picom.conf
fi
