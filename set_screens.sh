#!/bin/bash

sleep 1;

lap_only="--output eDP1 --primary --mode 1366x768 --output DP1-1 --off"
lap_ext="--output eDP1 --primary --mode 1366x768 --pos 0x1104 --output DP1-1 --noprimary --mode 1920x1200 --pos 1366x0 --rotate left"
ext_only="--output eDP1 --off --output DP1-1 --mode 1920x1200"
#two_ext="--output VIRTUAL1 --off --output eDP1 --off --output DP1-1 --primary --mode 1920x1200 --pos 0x400 --rotate normal --output DP1-2 --mode 1600x1200 --pos 1920x0 --rotate left"
two_ext="--output VIRTUAL1 --off --output eDP1 --off --output DP1-1 --primary --mode 1920x1200 --pos 0x720 --rotate normal --output DP1-2 --mode 1920x1200 --pos 1920x0 --rotate left"

 
fallback="--auto"

function setup_displays()
{
	declare -a get_displays=`xrandr -q | awk '($2 == "connected") {print $1;}'`;

	if [[ -n "$(echo ${get_displays[@]} | grep '^eDP1$')" ]];
	then
		xrandr $lap_only;
	elif [[ -n "$(echo ${get_displays[@]} | grep "^eDP1 DP1-1$")" ]];
	then
		xrandr $lap_ext;
	# not working, as lid closed does not report eDP1 to be disconnected
	# maybe tinker with --listmonitors,
	# or https://gist.github.com/seanf/e3be5bf745395d50e975
	elif [[ -n "$(echo ${get_displays[@]} | grep '^DP1-1$')" ]];
	then
		xrandr $ext_only;
	elif [[ -n "$(echo ${get_displays[@]} | grep "^eDP1 DP1-1 DP1-2$")" ]];
	then
		xrandr $two_ext;
	else
		xrandr $fallback;
	fi
};

setup_displays;
