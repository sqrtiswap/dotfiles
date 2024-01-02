#!/bin/sh
#
# Copyright (c) 2022 Alexander Möller <alexander.moeller@detmold.com>
#
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# <xbar.title>mpd-control</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>Alexander Möller</xbar.author>
# <xbar.desc>MPD control</xbar.desc>
# <xbar.dependencies>mpd, mpc, awk</xbar.dependencies>

PATH=/opt/homebrew/bin:$PATH

_fail='\033[31m'
_rset='\033[0m'

echo "♫"
if pgrep -q mpd && command -v mpc > /dev/null ; then
	echo "---"
	echo "Toggle playback | shell=/opt/homebrew/bin/mpc param1=toggle terminal=false refresh=true"
	echo "Clear playlist | shell=/opt/homebrew/bin/mpc param1=clear terminal=false refresh=true"
	mpc
	mpc playlist | awk '{ print NR"\t"$0, " | shell=/opt/homebrew/bin/mpc param1=play param2="NR" terminal=false refresh=true" }'
else
	echo "---"
	if ! pgrep -q mpd ; then
		printf "${_fail}mpd(1) is not running.${_rset}"
	elif ! command -v mpc > /dev/null ; then
		echo "${_fail}mpc(1) is not installed.${_rset}"
	else
		echo "${_fail}Unknown error${_rset}"
	fi
fi
