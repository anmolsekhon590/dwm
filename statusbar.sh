#!/bin/bash

cpu() {
	read -r cpu a b c previdle rest < /proc/stat
	prevtotal=$((a+b+c+previdle))
	sleep 0.5
	read -r cpu a b c idle rest < /proc/stat
	total=$((a+b+c+idle))
	cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
	echo  "$cpu"%
}

clock() {
    dte=$(date +"%D")
    time=$(date +"%l:%M %p")
    echo " $dte $time"
}

ram() {
    mem=$(free -h | awk '/Mem:/ { print $3 }' | cut -f1 -d 'i')
    echo  "$mem"
}

battery() {
    echo "$(acpower) $(cat /sys/class/power_supply/BAT0/capacity)%"
}

acpower() {
    ischarging="$(cat /sys/class/power_supply/ADP1/online)"
    if [ $ischarging = 1 ]; then
        echo ""
    else
        echo " "
    fi
}

network() {
	conntype=$(ip route | awk '/default/ { print substr($5,1,1) }')
    conntype="${conntype:0:1}${conntype:2:1}"

    if [ -z "$conntype" ]; then
        echo " down"
	elif [ "$conntype" = "e" ]; then
		echo " up"
	elif [ "$conntype" = "w" ]; then
		echo " up"
    elif [ "${conntype}" = "ew" ]; then
        echo " up |  up"
    fi
}

main() {
    xsetroot -name " $(cpu) | $(ram) | $(network) | $(battery) | $(clock) "
}

main
