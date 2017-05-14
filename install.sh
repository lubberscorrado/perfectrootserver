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
clear
echo "Preparing menu..."
apt-get -qq update

#-------------dialog
	if [ $(dpkg-query -l | grep dialog | wc -l) -ne 1 ]; then
		apt-get -qq install dialog >/dev/null 2>&1
	fi

HEIGHT=30
WIDTH=60
CHOICE_HEIGHT=6
BACKTITLE="Perfect Root Server"
TITLE="Perfect Root Server"
MENU="Choose one of the following options:"


	if [ ! -f /root/credentials.txt ]; then
	#Perfectrootserver is not installed
		OPTIONS=(1 "Install Perfect Root Server"
				 2 "Install Add-on"
				 3 "Exit")

		CHOICE=$(dialog --clear \
						--nocancel \
						--no-cancel \
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
					echo "You selected: Install Add-on"
					bash addonsinstall.sh
					;;
				3)
					echo "Exit"
					exit 1
					;;
		esac
		
	else
	#Perfectrootserver is installed!
			OPTIONS=(1 "Install Perfect Root Server"
				 2 "Update Perfect Root Server"
				 3 "Install Add-on"
				 4 "Exit")

		CHOICE=$(dialog --clear \
						--nocancel \
						--no-cancel \
						--backtitle "$BACKTITLE" \
						--title "$TITLE" \
						--menu "$MENU" \
						$HEIGHT $WIDTH $CHO
						ICE_HEIGHT \
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
	fi

