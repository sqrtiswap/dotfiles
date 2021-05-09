#!/bin/ksh

trap 'exec $0' HUP # Restart itself
trap 'tput cnorm; exit 1' INT QUIT TERM

_norm="\033[39m"
_alrt="\033[34m"
_warn="\033[33m"
_rset="\033[0m"
_hide="\033[2m"
_back="\033[22m"

red="\033[31m"
grey="${_norm}${_hide}"

pipe="${_norm} |"

set -A _bat "${_norm}" "${_warn}" "${_alrt}"
set -A _pwr "${_norm}"
set -A _net "" "直"
set -A _nic "em0" "iwm0"
set -A _vol "奄" "奔" "墳"

battery() {
	[[ $(apm -a) -eq 1 ]] \
		&& echo -n "${_pwr[0]} " \
		|| echo -n "${_bat[$(apm -b)]} "
	echo -n "$(apm -l)%${_norm}"
}

calendar() {
	sep="${grey}&${_back}${red}"
	echo -n "${_norm}$(date "+${red}%A, %d %B %Y ${sep} %T %Z %z ${sep} %V ${sep} %j")${pipe}"
}

cpu() {
	echo -n "$(sysctl -n hw.setperf)% "
	echo -n "$(sysctl -n hw.sensors.cpu0.temp0 | cut -d '.' -f 1)°C"
}

group() {
	echo -n "${red}[ $(xprop -root 32c '\t$0' _NET_CURRENT_DESKTOP | cut -f 2) ]${_rset}"
}

network() {
	[[ -z "$(ifconfig "${_nic[0]}" | grep 'status: no carrier')" ]] \
		&& (echo -n "${_net[0]}" ; return)
	echo -n "$(ifconfig "${_nic[1]}" | awk '/ieee80211:/ { print "直" $3 "(" $8 ")" }')"
}

tasks() {
	TASKSTODAY=$(grep -c due:"$(date +%Y-%m-%d)" ~/todo/todo.txt)
	if [[ $TASKSTODAY != 0 ]] ; then
		echo -n "${red}$TASKSTODAY"
	else
		echo -n "${grey}$TASKSTODAY"
	fi
	TASKSURGENT=$(grep -c '_urgent' ~/todo/todo.txt)
	if [[ $TASKSURGENT != 0 ]] ; then
		echo -n " ${red}$TASKSURGENT${pipe}"
	else
		echo -n " ${grey}$TASKSURGENT${pipe}"
	fi
}

volume() {
	VOLUME=$(sndioctl -n output.level | awk '{ print int($0*100) }')
	[[ $(sndioctl -n input.mute) -eq 1 ]] \
		&& echo -n "${_norm}${_norm} " \
		|| echo -n "${_warn}${_norm} "
	[[ $(sndioctl -n output.mute) -eq 1 ]] \
		&& echo -n "婢" \
		|| echo -n "${_vol[$(($VOLUME*3/101))]}"
	echo -n "$VOLUME%"
}

#window() {
	#WID=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
	#WIN=$(xprop -id "$WID" '\t$0' _NET_WM_NAME | cut -d '"' -f 2)
	#echo -n "${WIN}"
#}

tput civis	# hide cursor

while true; do
	_l=" $(calendar) $(tasks)"
	_r="$(cpu) $(battery) $(network) $(volume) $(group) "

	#tput clear cup 1 0
	tput cup 1 0
	printf "%-150.150s\r" "$_l"
	tput cup 1 100
	printf "%100.100s" "$_r"
	sleep 1
done

tput cnorm	# show cursor
