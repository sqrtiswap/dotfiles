#!/bin/ksh

BLACK="#000000"
BLUE="#3b48e3"
GREEN="#18b218"
GREY="#656565"
RED="#b81313"
WHITE="#d8d8d8"
YELLOW="#b4801e"

Battery() {
	ADAPTER=$(apm -a)
	BATTERYTIME=$(apm -m)
	if [[ $ADAPTER = 0 ]] ; then
		echo -n "%{F$GREY}%{B$BLACK}AC: "
	elif [[ $ADAPTER = 1 ]] ; then
		if [[ "$BATTERYTIME" = "unknown" ]] ; then
			echo -n "%{F$BLUE}%{B$BLACK}!WARNING! AC: "
		else
			echo -n "%{F$GREEN}%{B$BLACK}AC: "
		fi
	else
		echo -n "%{F$BLUE}%{B$BLACK}AC: "
	fi
	BATTERY=$(apm -l)
	if [ "$BATTERY" -gt 50 ] ; then
		echo -n "%{F$GREEN}%{B$BLACK}$BATTERY%%"
	elif [ "$BATTERY" -gt 25 ] ; then
		echo -n "%{F$YELLOW}%{B$BLACK}$BATTERY%%"
	elif [ "$BATTERY" -gt 10 ] ; then
		echo -n "%{F$RED}%{B$BLACK}$BATTERY%%"
	else
		if [[ $ADAPTER = 0  && "$BATTERYTIME" != "unknown" ]] ; then
			echo -n "%{F$RED}%{B$BLACK}$BATTERY%%"
		else
			echo -n "%{F$RED}%{B$BLACK}$BATTERY%% CHARGE NOW!"
		fi
	fi
	[[ "$BATTERYTIME" != "unknown" ]] && echo -n " ($BATTERYTIME m)"
	echo -n "%{F-}%{B-}"
}

Clock() {
	#DATE=$(date "+%A, %d %B %Y")	# longform weekday, two-digit day of month, full-word month, four-digit year
	#TIME=$(date "+%T %Z %z")	# HH:MM:ss timezone difference-to-utc
	#WEEK=$(date "+%V")		# week of the year
	#DAY=$(date "+%j")		# day of the year
	SEPARATOR="%%{F$GREY}%%{$BLACK} ● %%{F$RED}%%{B$BLACK}"
	echo -n "%{F$RED}%{B$BLACK}$(date "+%A, %d %B %Y\
		$SEPARATOR\
		%T %Z %z\
		$SEPARATOR\
		%V\
		$SEPARATOR\
		%j")%{F-}%{B-}"
	#echo -n "%{F$RED}%{B$BLACK}$DATE%{F$GREY}%{B$BLACK} ● %{F$RED}%{B$BLACK}$TIME%{F$GREY}%{B$BLACK} ● %{F$RED}%{B$BLACK}$WEEK%{F$GREY}%{B$BLACK} ● %{F$RED}%{B$BLACK}$DAY%{F-}%{B-}"
}

Cpu() {
	#set -A cpu_values $(iostat -C | sed -n '3p')
	#CPULOAD=$((100-${cpu_values[5]}))
	CPULOAD=$((100-$(iostat -C | awk -F " " 'NR == 3 { print $6 }')))
	if [ $CPULOAD -ge 90 ] ; then
		echo -n "%{F$RED}%{B$BLACK}"
	elif [ $CPULOAD -ge 60 ] ; then
		echo -n "%{F$YELLOW}%{B$BLACK}"
	else
		echo -n "%{F$GREEN}%{B$BLACK}"
	fi
	echo -n "$CPULOAD%%%{F$GREY}%{B$BLACK} ● "
	CPUTEMP=$(sysctl hw.sensors.cpu0.temp0 | awk -F "=" '{ gsub(" degC", "", $2); print $2 }')
	if [[ "$CPUTEMP" > "70.00" ]] ; then
		echo -n "%{F$RED}%{B$BLACK}"
	elif [[ "$CPUTEMP" > "60.00" ]] ; then
		echo -n "%{F$YELLOW}%{B$BLACK}"
	else
		echo -n "%{F$GREEN}%{B$BLACK}"
	fi
	echo -n "$CPUTEMP °C%{F-}%{B-}"
	#CPUSPEED=$(apm | sed '1,2d;s/.*(//;s/)//')
}

#Ifload() {
	#set -A if_load $(ifstat -n -i trunk0 -b 0.1 1 | sed '1,2d')
	#echo -n "In: %{F#BBBB00}${if_load[0]}%{F-} kb/s Out: %{F#0000BB}${if_load[1]}%{F-} kb/s "
#}

Load() {
	SYSLOAD=$(systat -b | awk 'NR==3 { print $4 }')
	if [[ "$SYSLOAD" > "4.00" ]] ; then
		echo -n "%{F$RED}%{B$BLACK}"
	elif [[ "$SYSLOAD" > "2.00" ]] ; then
		echo -n "%{F$YELLOW}%{B$BLACK}"
	else
		echo -n "%{F$GREEN}%{B$BLACK}"
	fi
	echo -n "$SYSLOAD%{F-}%{B-}"
}

#Memory() {
	#RELATIVE=$((100*($(top | awk -F "( |M)" 'NR == 7 { print $4 }'))/15639))
	#ABSOLUTE=$(top | awk -F "( |/)" 'NR == 7 { print $3 }')
	#if [[ "0$ABSOLUTE" > "10000M" ]] ; then
		#echo -n "%{F$RED}%{B$BLACK}$ABSOLUTE%{F-}%{B-}"
	#elif [[ "0$ABSOLUTE" > "5000M" ]] ; then
		#echo -n "%{F$YELLOW}%{B$BLACK}$ABSOLUTE%{F-}%{B-}"
	#else
		#echo -n "%{F$GREEN}%{B$BLACK}$ABSOLUTE%{F-}%{B-}"
	#fi
#}

Music() {
	EXCHANGE=$(mpc -f %artist% current | grep -c 'Slash featuring Myles Kennedy & The Conspirators')
	if [ "$EXCHANGE" = 1 ] ; then
		PLAYING=$(mpc -f %artist%\ ♫\ %title% current | sed 's/Slash featuring Myles Kennedy & The Conspirators/SMKC/')
		PAUSED=$(mpc -f %artist%\ ▮▮\ %title% current | sed 's/Slash featuring Myles Kennedy & The Conspirators/SMKC/')
	else
		PLAYING=$(mpc -f %artist%\ ♫\ %title% current)
		PAUSED=$(mpc -f %artist%\ ▮▮\ %title% current)
	fi
	POSITION=$(mpc | awk -F ' ' 'NR == 2 { gsub("#", "", $2); print $2" ("$3") " }')
	PLAYSTATE=$(mpc | grep -c playing)
	PAUSESTATE=$(mpc | grep -c paused)
	if [ "$PLAYSTATE" = 1 ] ; then
		echo -n "%{F$GREY}%{B$BLACK}$POSITION$PLAYING%{F-}%{B-}"
	elif [ "$PAUSESTATE" = 1 ] ; then
		echo -n "%{F$GREY}%{B$BLACK}$POSITION$PAUSED%{F-}%{B-}"
	else
		echo -n "%{F$GREY}%{B$BLACK}0/0 (0:00/0:00) -------%{F-}%{B-}"
	fi
}

Volume() {
	#MUTE=$(mixerctl outputs.master.mute | awk -F '=' '{ print $2 }')
	#LSPK=$(($(mixerctl outputs.master | awk -F '(=|,)' '{ print $2 }')*100/255))
	#RSPK=$(($(mixerctl outputs.master | awk -F '(=|,)' '{ print $3 }')*100/255))
	MUTE=$(sndioctl output.mute | awk -F '=' '{ print $2 }')
	SPK=$(sndioctl output.level | awk -F '=' '{ print $2 }')
	if [[ $MUTE = 0 ]] ; then
		echo -n "%{F$GREEN}%{B$BLACK}$SPK%{F-}%{B-}"
		#echo -n "%{F$GREEN}%{B$BLACK}$LSPK,$RSPK%{F-}%{B-}"
	else
		echo -n "%{F$GREY}%{B$BLACK}$SPK%{F-}%{B-}"
		#echo -n "%{F$GREY}%{B$BLACK}$LSPK,$RSPK%{F-}%{B-}"
	fi
}

Network() {
	LANSTAT=$(ifconfig em0 | awk '/status:/ { print $2 }')
	WLANSTAT=$(ifconfig iwm0 | awk '/status:/ { print $2 }')
	HUBLANEXIST=$(ifconfig | grep -c 'ure0:')
	if [ "$LANSTAT" != "active" ] && [ "$WLANSTAT" != "active" ] ; then
		if [[ $HUBLANEXIST = 0 ]] ; then
			echo -n "%{F$RED}%{B$BLACK}no network%{F-}%{B-}"
		else
			HUBLANUP=$(ifconfig ure0 | grep -c UP)
			HUBLANSTAT=$(ifconfig ure0 | grep -c inet)
			if [[ $HUBLANUP = 1 ]] && [[ $HUBLANSTAT -gt 0 ]] ; then
				echo -n "%{F$GREY}%{B$BLACK}em0 iwm0%{F$GREEN}%{B$BLACK} ure0%{F-}%{B-}"
			else
				echo -n "%{F$RED}%{B$BLACK}no network%{F-}%{B-}"
			fi
		fi
	else
		if [ "$LANSTAT" = "active" ] ; then
			echo -n "%{F$GREEN}%{B$BLACK}em0 %{F-}%{B-}"
		else
			echo -n "%{F$GREY}%{B$BLACK}em0 %{F-}%{B-}"
		fi
		if [ "$WLANSTAT" = "active" ] ; then
			WLANID=$(ifconfig iwm0  | awk '/(nwid|join)/ { print $3 }')
			WLANSIG=$(ifconfig iwm0 | awk 'match($0, /.[0-9]%/) { print substr($0, RSTART, RLENGTH) }')
			echo -n "%{F$GREEN}%{B$BLACK}$WLANID($WLANSIG)%{F-}%{B-}"
		else
			echo -n "%{F$GREY}%{B$BLACK}iwm0%{F-}%{B-}"
		fi
		if [[ $HUBLANEXIST = 1 ]] ; then
			HUBLANUP=$(ifconfig ure0 | grep -c UP)
			HUBLANSTAT=$(ifconfig ure0 | grep -c inet)
			if [[ $HUBLANUP = 1 ]] && [[ $HUBLANSTAT -gt 0 ]] ; then
				echo -n "%{F$GREEN}%{B$BLACK} ure0%{F-}%{B-}"
			else
				echo -n "%{F$GREY}%{B$BLACK} ure0%{F-}%{B-}"
			fi
		fi
	fi
}

Snapshot() {
	SNAPSHOT=$(awk -F "( |:)" 'NR == 1 { print $2" "$4 }' /etc/motd)
	KERNEL=$(uname -v | grep -c 'GENERIC.MP')
	if [ "$KERNEL" = 1 ] ; then
		echo -n "%{F$GREY}%{B$BLACK}$SNAPSHOT%{F-}%{B-}"
	else
		echo -n "%{F$RED}%{B$WHITE}NOT GENERIC.MP %{F$RED}%{B$BLACK}$SNAPSHOT%{F-}%{B-}"
	fi
}

Tasks() {
	TASKSTODAY=$(grep -c due:"$(date +%Y-%m-%d)" ~/todo/todo.txt)
	if [[ $TASKSTODAY != 0 ]] ; then
		echo -n "%{F$RED}%{B$BLACK}$TASKSTODAY"
	else
		echo -n "%{F$GREY}%{B$BLACK}$TASKSTODAY"
	fi
	TASKSURGENT=$(grep -c '_urgent' ~/todo/todo.txt)
	if [[ $TASKSURGENT != 0 ]] ; then
		echo -n " %{F$RED}%{B$BLACK}$TASKSURGENT%{F-}%{B-}"
	else
		echo -n " %{F$GREY}%{B$BLACK}$TASKSURGENT%{F-}%{B-}"
	fi
}

Group() {
	CURRENTGROUP=$(xprop -root 32c '\t$0' _NET_CURRENT_DESKTOP | cut -f 2)
	echo -n "%{F$GREY}%{B$BLACK}$CURRENTGROUP%{F-}%{B-}"
}

while true ; do
	echo "%{l} $(Clock) | $(Tasks) | $(Music) %{r}| $(Volume) | $(Network) | $(Cpu) | $(Load) | $(Battery) | $(Snapshot) | $(Group) "
	sleep 5
done
