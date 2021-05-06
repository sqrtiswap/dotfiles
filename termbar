#!/bin/sh

trap 'exec $0' HUP	# restart itself
trap 'tput cnorm; exit 1' INT QUIT TERM

#standard="\033[39m"
reset="\033[0m"
red="\033[31m"
cyan="\033[36m";
purple="\033[35m"
grey="\033[2m"
pipe="${reset}${purple}|${reset}"

calendar() {
	sep="${reset}${grey}|${reset}${red}"
	DATE=$(date "+${red}%A, %d %B %Y ${sep} %T %Z %z ${sep} %V ${sep} %j")
}

group() {
	GROUP=$(xprop -root 32c '\t$0' _NET_CURRENT_DESKTOP | cut -f 2)
}

cpu() {
	CPUTEMP=$(sysctl -n hw.sensors.cpu0.temp0 | cut -d '.' -f 1)°C
	CPUSPEED=$(printf "%4s" "$(sysctl -n hw.cpuspeed)")
}

battery() {
	BAT=$(apm -l)
	STATUS=$(sysctl hw.sensors.acpiac0.indicator0 | grep -c On)
	if [ "${STATUS}" -eq "1" ]; then
		BAT_STATUS=Connected
	else
		BAT_STATUS=${red}Disconnected${reset}
	fi
}

memory() {
	MEM=$(top -n | awk -F "( |/)" 'NR == 7 { print $3 }')
}

network() {
	SSID=$(ifconfig | grep join | sed -e 's/.*join\(.*\)chan.*/\1/')
}

window() {
	WID=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
	WIN=$(xprop -id "$WID" '\t$0' _NET_WM_NAME | cut -d '"' -f 2)
}

tput civis	# hide cursor

while true; do
	calendar
	group
	cpu
	memory
	battery
	network
	window
	#_l="[ ${GROUP} ] ${DATE} ${pipe}"
	#_r="${cyan}CPU:${reset} ${CPUSPEED} MHz (${CPUTEMP}) ${pipe} ${cyan}Mem:${reset} ${MEM} ${pipe} ${cyan}Bat:${reset} $BAT - ${BAT_STATUS} ${pipe} ${cyan}SSID:${reset}${SSID}${pipe}"
	tput cup 1 0
	printf "[ ${GROUP} ] ${DATE} ${pipe} ${WIN} ${pipe} ${cyan}CPU:${reset} ${CPUSPEED} MHz (${CPUTEMP}) ${pipe} ${cyan}Mem:${reset} ${MEM} ${pipe} ${cyan}Bat:${reset} $BAT - ${BAT_STATUS} ${pipe} ${cyan}SSID:${reset}${SSID}${pipe}"
	#printf "%-120.120s\r" "$_l"
	#tput cup 1 100
	#printf "%110.110s" "$_r"
	sleep 1
done

tput cnorm	# show cursor