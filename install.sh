#!/bin/bash
# The perfect rootserver - Your Webserverinstallation Script!
# by shoujii | BoBBer446 > 2017
#####
# https://github.com/shoujii/perfectrootserver
# Compatible with Debian 8.x (jessie)
# Special thanks to Zypr!
#
	# This program is free software; you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation; either version 2 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License along
    # with this program; if not, write to the Free Software Foundation, Inc.,
    # 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#-------------------------------------------------------------------------------------------------------------

#################################
##  DO NOT MODIFY, JUST DON'T! ##
#################################
source script/functions.sh

prs_preinstall() {
	echo
	echo
	echo "$(date +"[%T]") | $(textb +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+)"
	echo "$(date +"[%T]") |  $(textb P) $(textb e) $(textb r) $(textb f) $(textb e) $(textb c) $(textb t)   $(textb R) $(textb o) $(textb o) $(textb t) $(textb s) $(textb e) $(textb r) $(textb v) $(textb e) $(textb r) "
	echo "$(date +"[%T]") | $(textb +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+)"
	echo
	echo "$(date +"[%T]") | ${info} Welcome to the Perfect Rootserver installation!"
	echo "$(date +"[%T]") | ${info} Please wait while the installer is preparing for the first use..."

apt-get -qq update >>"$main_log" 2>>"$err_log"
#-------------libcrack2
if [ $(dpkg-query -l | grep libcrack2 | wc -l) -ne 1 ]; then
	apt-get -y --force-yes install libcrack2 >>"$main_log" 2>>"$err_log"
fi
#-------------dnsutils
if [ $(dpkg-query -l | grep dnsutils | wc -l) -ne 1 ]; then
	apt-get -y --force-yes install dnsutils >>"$main_log" 2>>"$err_log" error_exit "Cannot install dnsutils! Aborting"
fi
#-------------openssl------TESTING
if [ $(dpkg-query -l | grep openssl | wc -l) -ne 1 ]; then
	apt-get install -f -y -t testing openssl >>"$main_log" 2>>"$err_log"
fi
#-------------dialog
if [ $(dpkg-query -l | grep dialog | wc -l) -ne 1 ]; then
		apt-get -qq install dialog >/dev/null 2>&1
fi
}

# Start Action
prs_preinstall

HEIGHT=30
WIDTH=60
CHOICE_HEIGHT=6
BACKTITLE="Perfect Root Server"
TITLE="Perfect Root Server"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install Perfect Root Server"
         2 "Update Perfect Root Server"
         3 "Install Add-on"
		 4 "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
			echo "You selected: Install Perfect Root Server"
            bash prsinstall.sh
            ;;
        2)
			echo "You selected: Update Perfect Root Server"
            bash addons/systemupdate.sh
            ;;
        3)
            echo "You selected: Install Add-on"
			bash addonsinstall.sh
            ;;
		4)
			echo "Exit"
			exit 1
            ;;
esac