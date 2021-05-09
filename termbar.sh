#!/bin/sh

trap 'exec $0' HUP	# restart itself
trap 'tput cnorm; exit 1' INT QUIT TERM

esc="\033"
#standard="${esc}[39m"
reset="${esc}[0m"
grey="${esc}[2m"
#black="${esc}[30m"
red="${esc}[31m"
#green="${esc}[32m"
#yellow="${esc}[33m"
#blue="${esc}[34m"
#magenta="${esc}[35m"
#cyan="${esc}[36m"
#white="${esc}[37m"

#brightblack="${esc}[90m"
#brightred=${esc}[91m"
#brightgreen="${esc}[92m"
#brightyellow="${esc}[93m"
#brightblue="${esc}[94m"
#brightmagenta="${esc}[95m"
#brightcyan="${esc}[96m"
#brightwhite="${esc}[97m"

#pipe="${reset}|${reset}"

calendar() {
	sep="\033[0m\033[2m&\033[0m\033[31m"
	#sep="${reset}${grey}&${reset}${red}"
	DATE=$(date "+%A")
	printf "\033[31m%s\033[0m" "$DATE"
}

group() {
	GROUP=$(xprop -root 32c '\t$0' _NET_CURRENT_DESKTOP | cut -f 2)
	printf "%s" "$GROUP"
}

cpu() {
	CPUTEMP=$(sysctl -n hw.sensors.cpu0.temp0 | cut -d '.' -f 1)°C
	CPUSPEED=$(printf "%4s" "$(sysctl -n hw.cpuspeed)")
	printf "%s %s" "$CPUTEMP" "$CPUSPEED"
}

battery() {
	BAT=$(apm -l)
	STATUS=$(sysctl hw.sensors.acpiac0.indicator0 | grep -c On)
	if [ "${STATUS}" -eq "1" ]; then
		BAT_STATUS=connected
	else
		BAT_STATUS=${red}disconnected${reset}
	fi
	printf "%s (%s)" "$BAT" "$BAT_STATUS"
}

memory() {
	MEM=$(top -n | awk -F "( |/)" 'NR == 7 { print $3 }')
	printf "%s" "$MEM"
}

network() {
	SSID=$(ifconfig | grep join | sed -e 's/.*join\(.*\)chan.*/\1/')
	printf "%s" "$SSID"
}

#window() {
	#WID=$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)
	#WIN=$(xprop -id "$WID" '\t$0' _NET_WM_NAME | cut -d '"' -f 2)
#}

tput civis	# hide cursor

while true; do
	tput cup 1 0
	_l=" [ $(group) ] $(calendar)"
	_r="CPU:$(cpu) MHz Mem:$(memory) Bat:$(battery) Net:$(network)"
	printf "%-150.150s\r" "$_l"
	tput cup 1 100
	printf "%100.100s" "$_r"
	sleep 1
done

tput cnorm	# show cursor