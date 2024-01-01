#!/bin/ksh

trap 'exec $0' HUP	# restart itself
trap 'tput cnorm; exit 1' INT QUIT TERM

_rset="\033[0m"
_hide="\033[2m"		# make colour less vibrant
_line="\033[9m"		# line through the output
_back="\033[22m"	# reverse _hide
_crit="\033[31m"	# dark red
_good="\033[32m"	# green
_warn="\033[33m"	# yellow
_alrt="\033[34m"	# blue
_norm="\033[39m"	# white

_grey="${_norm}${_hide}"
pipe="${_back}${_norm} |"

_dred="\033[31m"	# dark red
#_pink="\033[35m"	# magenta
#_teal="\033[36m"	# teal

set -A bat "${_good}" "${_warn}" "${_crit}" "${_hide}" "${_alrt}"
set -A net "${_good}" "${_hide}" "${_crit}" "${_hide}${_line}"
set -A nic "em0" "iwm0" "ure0"
set -A vol "${_good}" "${_crit}"

battery() {
# apm -b: 0 high, 1 low, 2 critical, 3 charging, 4 absent, 255 unknown
	#_adapter=$(apm -a)
	_status=$(sysctl -n hw.sensors.acpiac0.indicator0)
	_batpercent="$(apm -l)%"
	_eta="($(apm -m)m)"
	[[ ${_status} = "On (power supply)" ]] \
		&& echo -n "${bat[0]}AC: ${bat[$(apm -b)]}${_back}${_batpercent}${pipe}" \
		|| echo -n "${bat[3]}AC: ${bat[$(apm -b)]}${_back}${_batpercent} ${_eta}${pipe}"
}

calendar() {
	sep="${_grey}•${_back}${_dred}"
	echo -n "${_rset}$(date "+${_dred}%A, %d %B %Y ${sep} %T %Z %z ${sep} %V ${sep} %j")${pipe}"
}

cpu() {
	#_cpuload=$(printf "%2s" "$((100-$(iostat -C | awk -F " " 'NR == 3 { print $6 }')))")
	_cpuload=$((100-$(iostat -C | awk -F " " 'NR == 3 { print $6 }')))
	if [ "${_cpuload}" -ge 50 ] ; then
		echo -n "${_crit}${_cpuload}% "
	elif [ "${_cpuload}" -ge 25 ] ; then
		echo -n "${_warn}${_cpuload}% "
	else
		echo -n "${_good}${_cpuload}% "
	fi

	_cputemp=$(sysctl -n hw.sensors.cpu0.temp0 | cut -d '.' -f 1)
	if [[ ${_cputemp} -gt 70 ]] ; then
		echo -n "${_crit}${_cputemp}°C"
	elif [[ ${_cputemp} -gt 60 ]] ; then
		echo -n "${_warn}${_cputemp}°C"
	else
		echo -n "${_good}${_cputemp}°C"
	fi

	#_cpuspeed=$(printf "%4s" "$(sysctl -n hw.cpuspeed)")
	#_cpuperf=$(printf "%4s" "$(sysctl -n hw.setperf)%")
	_cpuperf="$(sysctl -n hw.setperf)%"

	#echo -n " ${_grey}${_cpuspeed} MHz @ ${_cpuperf}${_rset}${pipe}"
	echo -n " ${_grey}@ ${_cpuperf}${_rset}${pipe}"
}

fan() {
	_fanspeed=$(sysctl -n hw.sensors.acpithinkpad0.fan0)
	echo -n "${_grey}${_fanspeed}${pipe}"
}

group() {
	echo -n "${_grey}$(xprop -root 32c '\t$0' _NET_CURRENT_DESKTOP | cut -f 2)"
}

kbd() {
	_kbd=$(setxkbmap -query | awk '/^layout:/ { print $2}')
	[[ "${_kbd}" = "de" ]] \
		&& echo -n "${_rset}${_good}${_kbd}${pipe}" \
		|| echo -n "${_rset}${_crit}${_kbd}${pipe}"
}

load() {
	_sysload=$(systat -b | awk 'NR==3 { print $4 }')
	if [[ "0${_sysload}" > "10.00" ]] ; then
		echo -n "${_alrt}${_sysload}${pipe}"
	elif [[ "0${_sysload}" > "04.00" ]] ; then
		echo -n "${_crit}${_sysload}${pipe}"
	elif [[ "0${_sysload}" > "02.00" ]] ; then
		echo -n "${_warn}${_sysload}${pipe}"
	else
		echo -n "${_good}${_sysload}${pipe}"
	fi
}

memory() {
	_mem=$(printf "%5s" "$(top -n | awk -F "( |/)" '/Memory:/ { print $3 }')")
	if [[ "0${_mem}" > "10000M" ]] ; then
		echo -n "${_crit}${_mem}${pipe}"
	elif [[ "0${_mem}" > "5000M" ]] ; then
		echo -n "${_warn}${_mem}${pipe}"
	else
		echo -n "${_good}${_mem}${pipe}"
	fi
}

music() {
	#♫▮▮
	_mpdstate=$(mpc | awk -F ' ' 'NR == 2 { gsub("#", "", $2); print $2" ("$3") mpd "$1 }')
	[[ -n ${_mpdstate} ]] \
		&& echo -n "${_grey}${_mpdstate}" \
		|| echo -n "${_grey}0/0 (0:00/0:00) mpd [-------]"
}

network() {
	_lanstat=$(ifconfig "${nic[0]}" | grep -c 'status: active')
	[[ ${_lanstat} -eq 1 ]] \
		&& _lanstate="${net[0]}${nic[0]}${_rset} " \
		|| _lanstate="${net[1]}${nic[0]}${_rset} "

	_wlanstat=$(ifconfig "${nic[1]}" | grep -c 'status: active')
	_wlan=$(ifconfig "${nic[1]}" | awk '/ieee80211:/ { print $3 "(" $8 ")" }')
	[[ ${_wlanstat} -eq 1 ]] \
		&& _wlanstate="${net[0]}${_wlan}${_rset}" \
		|| _wlanstate="${net[1]}${nic[1]}${_rset}"

	_hublanexist=$(ifconfig | grep -c "${nic[2]}:")
	#if ifconfig "${nic[2]}" > /dev/null ; then
	if [[ "${_hublanexist}" -eq 1 ]] ; then
		_hublanup=$(ifconfig "${nic[2]}" | grep -c UP)
		_hublanstat=$(ifconfig "${nic[2]}" | grep -c inet)
		[[ ${_hublanup} -eq 1 && ${_hublanstat} -gt 0 ]] \
			&& _hublanstate=" ${net[0]}${nic[2]}" \
			|| _hublanstate=" ${net[1]}${nic[2]}"
	else
		_hublanstate=" ${net[3]}${nic[2]}"
	fi
	echo -n "${_lanstate}${_wlanstate}${_hublanstate}${_rset}${pipe}"
}

snapshot() {
	#_snapshot=$(printf "%16s" "$(awk -F "( |:)" 'NR == 1 { print $2" "$4 }' /etc/motd)")
	_snapshot=$(awk -F "( |:)" 'NR == 1 { print $2" "$4 }' /etc/motd)
	_kernel=$(uname -v | grep -c 'GENERIC.MP')
	[[ ${_kernel} -eq 1 ]] \
		&& echo -n "${_grey}${_snapshot}${pipe}" \
		|| echo -n "${_alrt}${_snapshot}${pipe}"
}

tasks() {
	_todo=$(grep -c -e ' +urgent' -e due:"$(date +%Y-%m-%d)" "$TODODIR"/todo.txt)
	[[ ${_todo} -gt 0 ]] \
		&& echo -n "${_crit}${_todo}${pipe}" \
		|| echo -n "${_hide}${_todo}${pipe}"
}

volume() {
	#mute=$(mixerctl outputs.master.mute | awk -F '=' '{ print $2 }')
	#lspk=$(($(mixerctl outputs.master | awk -F '(=|,)' '{ print $2 }')*100/255))
	#rspk=$(($(mixerctl outputs.master | awk -F '(=|,)' '{ print $3 }')*100/255))
	#_volume=$(printf "%2s" "$(sndioctl -n output.level | awk '{ print int($0*100) "%" }')")
	_volume=$(sndioctl -n output.level)
	_omute=$(sndioctl -n output.mute)
	#_imute=$(sndioctl -n input.mute)
	#[[ ${_imute} -eq 1 ]] \
		#&& echo -n "${_crit}mic on "
	echo -n "${_rset}${vol[${_omute}]}${_volume}${pipe}"
}

window() {
	_wid=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
	_win=$(xprop -id "${_wid}" '\t$0' _NET_WM_NAME | cut -d '"' -f 2)
	echo -n "${_grey}${_win}${_back}"
}

tput civis	# hide cursor

while true; do
	#tput clear cup 1 0
	tput cup 1 0
	_l=" $(calendar) $(tasks) $(network) $(battery) $(music)"
	printf "%-300.300s\r" "$_l"
	tput cup 1 142
	#_r="$(volume) $(cpu) $(memory) $(load) $(snapshot) $(group)"
	#printf "%181.181s" "$_r"
	_r="$(volume) $(cpu) $(fan) $(load) $(snapshot) $(group)"
	printf "%185.185s" "$_r"
	sleep 1
done

tput cnorm	# show cursor
