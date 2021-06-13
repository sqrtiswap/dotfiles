#!/bin/ksh

#_norm="%{F#d8d8d8}"	# white
_crit="%{F#b81313}"	# dark red
_good="%{F#18b218}"	# green
_warn="%{F#b4801e}"	# yellow
_alrt="%{F#3b48e3}"	# blue

_grey="%{F#656565}"
pipe="%{F-} |"

_dred="%%{F#b81313}"	# dark red

set -A bat "${_good}" "${_warn}" "${_crit}" "${_grey}" "${_alrt}"
set -A eta "($(apm -m)m)" ""
set -A net "${_good}" "${_grey}" "${_crit}"
set -A nic "em0" "iwm0" "ure0"
set -A vol "${_good}" "${_grey}"

battery() {
# apm -b: 0 high, 1 low, 2 critical, 3 charging, 4 absent, 255 unknown
	#_adapter=$(apm -a)
	_status=$(sysctl -n hw.sensors.acpiac0.indicator0 | grep -c On)
	_batpercent="$(apm -l)%%"
	[[ ${_status} -eq 1 ]] \
		&& echo -n "${bat[0]}AC: ${bat[$(apm -b)]}${_batpercent}${eta[1]}${pipe}" \
		|| echo -n "${bat[3]}AC: ${bat[$(apm -b)]}${_batpercent}${eta[0]}${pipe}"
}

calendar() {
	sep="%${_grey}•${_dred}"
	echo -n "$(date "+${_dred}%A, %d %B %Y ${sep} %T %Z %z ${sep} %V ${sep} %j")${pipe}"
}

cpu() {
	_cpuload=$(printf "%2s" "$((100-$(iostat -C | awk -F " " 'NR == 3 { print $6 }')))")
	_cputemp=$(sysctl -n hw.sensors.cpu0.temp0 | cut -d '.' -f 1)
	_cpuspeed=$(printf "%4s" "$(sysctl -n hw.cpuspeed)")
	_cpuperf=$(printf "%5s" "$(sysctl -n hw.setperf)%%")
	if [ "${_cpuload}" -ge 90 ] ; then
		echo -n "${_crit}${_cpuload}% "
	elif [ "${_cpuload}" -ge 60 ] ; then
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
	echo -n " ${_grey}${_cpuspeed} MHz @ ${_cpuperf}${pipe}"
}

group() {
	echo -n "${_grey}$(xprop -root 32c '\t$0' _NET_CURRENT_DESKTOP | cut -f 2)"
}

#Ifload() {
	#set -A if_load $(ifstat -n -i trunk0 -b 0.1 1 | sed '1,2d')
	#echo -n "In: %{F#BBBB00}${if_load[0]}%{F-} kb/s Out: %{F#0000BB}${if_load[1]}%{F-} kb/s "
#}

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
	_mem=$(printf "%5s" "$(top -n | awk -F "( |/)" 'NR == 7 { print $3 }')")
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
	_wlanstat=$(ifconfig "${nic[1]}" | grep -c 'status: active')
	_wlan=$(ifconfig "${nic[1]}" | awk '/ieee80211:/ { print $3 "(" $8 ")" }')
	_hublanexist=$(ifconfig | grep -c "${nic[2]}:")
	if [[ ${_lanstat} -ne 1 && ${_wlanstat} -ne 1 ]] ; then
		if [[ ${_hublanexist} -eq 0 ]] ; then
			_netstate="${net[2]}no network"
		else
			_hublanup=$(ifconfig "${nic[2]}" | grep -c UP)
			_hublanstat=$(ifconfig "${nic[2]}" | grep -c inet)
			[[ ${_hublanup} -eq 1 && ${_hublanstat} -gt 0 ]] \
				&& _netstate="${net[1]}${nic[0]} ${nic[1]}${net[0]} ${nic[2]}" \
				|| _netstate="${net[2]}no network"
		fi
	else
		[[ ${_lanstat} -eq 1 ]] \
			&& _lanstate="${net[0]}${nic[0]} " \
			|| _lanstate="${net[1]}${nic[0]} "
		[[ ${_wlanstat} -eq 1 ]] \
			&& _wlanstate="${net[0]}${_wlan}" \
			|| _wlanstate="${net[1]}${nic[1]}"
		if [[ ${_hublanexist} -eq 1 ]] ; then
			_hublanup=$(ifconfig "${nic[2]}" | grep -c UP)
			_hublanstat=$(ifconfig "${nic[2]}" | grep -c inet)
			[[ ${_hublanup} -eq 1 && ${_hublanstat} -gt 0 ]] \
				&& _hublanstate=" ${net[0]}${nic[2]}" \
				|| _hublanstate=" ${net[1]}${nic[2]}"
		else
			_hublanstate=""
		fi
		_netstate="${_lanstate}${_wlanstate}${_hublanstate}"
	fi
	echo -n "${_netstate}${pipe}"
}

snapshot() {
	_snapshot=$(printf "%16s" "$(awk -F "( |:)" 'NR == 1 { print $2" "$4 }' /etc/motd)")
	_kernel=$(uname -v | grep -c 'GENERIC.MP')
	[[ ${_kernel} -eq 1 ]] \
		&& echo -n "${_grey}${_snapshot}${pipe}" \
		|| echo -n "${_alrt}${_snapshot}${pipe}"
}

tasks() {
	_today=$(grep -c due:"$(date +%Y-%m-%d)" ~/todo/todo.txt)
	[[ ${_today} != 0 ]] \
		&& echo -n "${_crit}${_today} " \
		|| echo -n "${_grey}${_today} "
	_urgent=$(grep -c '_urgent' ~/todo/todo.txt)
	[[ ${_urgent} != 0 ]] \
		&& echo -n "${_crit}${_urgent}${pipe}" \
		|| echo -n "${_grey}${_urgent}${pipe}"
}

volume() {
	#mute=$(mixerctl outputs.master.mute | awk -F '=' '{ print $2 }')
	#lspk=$(($(mixerctl outputs.master | awk -F '(=|,)' '{ print $2 }')*100/255))
	#rspk=$(($(mixerctl outputs.master | awk -F '(=|,)' '{ print $3 }')*100/255))
	#_volume=$(printf "%2s" "$(sndioctl -n output.level | awk '{ print int($0*100) "%%" }')")
	_volume=$(sndioctl -n output.level)
	_omute=$(sndioctl -n output.mute)
	#_imute=$(sndioctl -n input.mute)
	#[[ ${_imute} -eq 1 ]] \
		#&& echo -n "${_crit}mic on "
	[[ ${_omute} -eq 1 ]] \
		&& echo -n "${vol[${_omute}]}${_volume}${pipe}" \
		|| echo -n "${vol[${_omute}]}${_volume}${pipe}"
}

#window() {
	#_wid=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
	#_win=$(xprop -id "${_wid}" '\t$0' _NET_WM_NAME | cut -d '"' -f 2)
	#echo -n "${_grey}${_win}"
#}

while true ; do
	echo "%{l} $(calendar) $(tasks) $(network) $(battery) $(music) %{r}$(volume) $(cpu) $(memory) $(load) $(snapshot) $(group) "
	sleep 5
done
