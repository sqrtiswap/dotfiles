#!/bin/ksh

trap 'exec $0' HUP	# restart itself
trap 'tput cnorm; exit 1' INT QUIT TERM

_rset="\033[0m"
_hide="\033[2m"		# make colour less vibrant
_line="\033[9m"		# line through the output
_back="\033[22m"	# reverse _hide
_crit="\033[31m"	# red
_good="\033[32m"	# green
_warn="\033[33m"	# yellow
_alrt="\033[34m"	# blue
_norm="\033[39m"	# white

grey="${_norm}${_hide}"
pipe="${_back}${_norm} |"

red="\033[31m"

#black="\033[30m"
#magenta="\033[35m"
#cyan="\033[36m"
#white="\033[37m"

#brightblack="\033[90m"
#brightred="\033[91m"
#brightgreen="\033[92m"
#brightyellow="\033[93m"
#brightblue="\033[94m"
#brightmagenta="\033[95m"
#brightcyan="\033[96m"
#brightwhite="\033[97m"

set -A bat "${_good}" "${_warn}" "${_crit}" "${grey}" "${_alrt}"
set -A net "${_rset}${_good}" "${grey}" "${_crit}"
set -A nic "em0" "iwm0" "ure0"
set -A vol "${_good}" "${grey}"

battery() {
# apm -b: 0 high, 1 low, 2 critical, 3 charging, 4 absent, 255 unknown
	#_adapter=$(apm -a)
	_status=$(sysctl -n hw.sensors.acpiac0.indicator0 | grep -c On)
	_batpercent=$(printf "%3s" "$(apm -l)")
	_battime=$(printf "%3s" "$(apm -m)")
	[[ ${_status} -eq 1 ]] \
		&& echo -n "${bat[0]}AC: ${bat[$(apm -b)]}${_back}${_batpercent}%${pipe}" \
		|| echo -n "${bat[3]}AC: ${bat[$(apm -b)]}${_back}${_batpercent}% (${_battime}m)${pipe}"
}

calendar() {
	sep="${grey}&${_back}${red}"
	echo -n "${_norm}$(date "+${red}%A, %d %B %Y ${sep} %T %Z %z ${sep} %V ${sep} %j")${pipe}"
}

cpu() {
	_cpuload=$((100-$(iostat -C | awk -F " " 'NR == 3 { print $6 }')))
	_cputemp=$(sysctl -n hw.sensors.cpu0.temp0 | cut -d '.' -f 1)
	_cpuspeed=$(printf "%4s" "$(sysctl -n hw.cpuspeed)")
	_cpuperf=$(printf "%4s" "$(sysctl -n hw.setperf)%")
	#echo -n "${_cpuload}% ${_cputemp}°C ${_cpuspeed} MHz @ ${_cpuperf}${pipe}"
	if [ ${_cpuload} -ge 90 ] ; then
		echo -n "${_crit}${_cpuload}% "
	elif [ ${_cpuload} -ge 60 ] ; then
		echo -n "${_warn}${_cpuload}% "
	else
		echo -n "${_good}${_cpuload}% "
	fi
	if [[ ${_cputemp} -gt 70 ]] ; then
		echo -n "${_crit}${_cputemp}°C"
	elif [[ ${_cputemp} -gt 60 ]] ; then
		echo -n "${_warn}${_cputemp}°C"
	else
		echo -n "${_good}${_cputemp}°C"
	fi
	echo -n " ${grey}${_cpuspeed} MHz @ ${_cpuperf}${_rset}${pipe}"
}

group() {
	echo -n "${grey}$(xprop -root 32c '\t$0' _NET_CURRENT_DESKTOP | cut -f 2)${_rset}"
}

load() {
	_sysload=$(systat -b | awk 'NR==3 { print $4 }')
	if [[ "${_sysload}" > "4.00" ]] ; then
		echo -n "${_crit}${_sysload}${pipe}"
	elif [[ "${_sysload}" > "2.00" ]] ; then
		echo -n "${_warn}${_sysload}${pipe}"
	else
		echo -n "${_good}${_sysload}${pipe}"
	fi
}

memory() {
	_mem=$(printf "%6s" "$(top -n | awk -F "( |/)" 'NR == 7 { print $3 }')")
	if [[ "${_mem}" > "10000M" ]] ; then
		echo -n "${_crit}${_mem}${pipe}"
	elif [[ "${_mem}" > "5000M" ]] ; then
		echo -n "${_warn}${_mem}${pipe}"
	else
		echo -n "${_good}${_mem}${pipe}"
	fi
}

network() {
	_lanstat=$(ifconfig "${nic[0]}" | grep -c 'status: active')
	_wlanstat=$(ifconfig "${nic[1]}" | grep -c 'status: active')
	#_wlanid=$(ifconfig ${nic[1]} | awk '/(nwid|join)/ { print $3 }')
	#_wlansig=$(ifconfig ${nic[1]} | awk 'match($0, /.[0-9]%/) { print substr($0, RSTART, RLENGTH) }')
	_wlan=$(printf "%13s" "$(ifconfig "${nic[1]}" | awk '/ieee80211:/ { print $3 "(" $8 ")" }')")
	_hublanexist=$(ifconfig | grep -c "${nic[2]}:")
	if [[ ${_lanstat} -ne 1 && ${_wlanstat} -ne 1 ]] ; then
		if [[ ${_hublanexist} = 0 ]] ; then
			_hubnet=$(printf "%24s" "${net[2]}no network")
		else
			_hublanup=$(ifconfig "${nic[2]}" | grep -c UP)
			_hublanstat=$(ifconfig "${nic[2]}" | grep -c inet)
			[[ ${_hublanup} -eq 1 && ${_hublanstat} -gt 0 ]] \
				&& _hubnet="         ${net[1]}${nic[0]} ${nic[1]}${net[0]} ${nic[2]}" \
				|| _hubnet=$(printf "%24s" "${net[2]}no network")
		fi
		echo -n "${_hubnet}"
	else
		[[ ${_lanstat} -eq 1 ]] \
			&& echo -n "${net[0]}${nic[0]} " \
			|| echo -n "${net[1]}${nic[0]} "
		[[ ${_wlanstat} -eq 1 ]] \
			&& echo -n "${net[0]}${_wlan}" \
			|| echo -n "${net[1]}${nic[1]}"
		if [[ ${_hublanexist} -eq 1 ]] ; then
			_hublanup=$(ifconfig "${nic[2]}" | grep -c UP)
			_hublanstat=$(ifconfig "${nic[2]}" | grep -c inet)
			[[ ${_hublanup} -eq 1 && ${_hublanstat} -gt 0 ]] \
				&& echo -n " ${net[0]}${nic[2]}" \
				|| echo -n " ${net[1]}${nic[2]}"
		else
			echo -n " ${_line}${grey}${nic[2]}"
		fi
	fi
	echo -n "${_rset}${pipe}"
}

snapshot() {
	_snapshot=$(printf "%16s" "$(awk -F "( |:)" 'NR == 1 { print $2" "$4 }' /etc/motd)")
	_kernel=$(uname -v | grep -c 'GENERIC.MP')
	[[ ${_kernel} -eq 1 ]] \
		&& echo -n "${grey}${_snapshot}${pipe}" \
		|| echo -n "${_alrt}${_snapshot}${pipe}"
}

tasks() {
	_today=$(printf "%2s" "$(grep -c due:"$(date +%Y-%m-%d)" ~/todo/todo.txt)")
	[[ ${_today} != 0 ]] \
		&& echo -n "${red}${_today} " \
		|| echo -n "${grey}${_today} "
	_urgent=$(printf "%2s" "$(grep -c '_urgent' ~/todo/todo.txt)")
	[[ ${_urgent} != 0 ]] \
		&& echo -n "${_back}${red}${_urgent}${pipe}" \
		|| echo -n "${grey}${_urgent}${pipe}"
}

volume() {
	_volume=$(printf "%2s" "$(sndioctl -n output.level | awk '{ print int($0*100) }')")
	_omute=$(sndioctl -n output.mute)
	#_imute=$(sndioctl -n input.mute)
	#[[ ${_imute} -eq 1 ]] \
		#&& echo -n "${_crit}mic on "
	[[ ${_omute} -eq 1 ]] \
		&& echo -n "${vol[${_omute}]}${_volume}%${pipe}" \
		|| echo -n "${vol[${_omute}]}${_volume}%${pipe}"
}

window() {
	_wid=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
	_win=$(xprop -id "${_wid}" '\t$0' _NET_WM_NAME | cut -d '"' -f 2)
	echo -n "${_win}"
}

tput civis	# hide cursor

while true; do
	#tput clear cup 1 0
	tput cup 1 0
	_l=" $(calendar) $(tasks)"
	_r="| $(volume) $(network) $(cpu) $(memory) $(load) $(battery) $(snapshot) $(group)"
	printf "%-170.170s\r" "$_l"
	tput cup 1 96
	printf "%300.300s" "$_r"
	sleep 1
done

tput cnorm	# show cursor