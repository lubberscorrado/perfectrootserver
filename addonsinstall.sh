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

HEIGHT=30
WIDTH=80
CHOICE_HEIGHT=6
BACKTITLE="Perfect Root Server Add-ons"
TITLE="Perfect Root Server Add-ons"
MENU="Choose one of the following options:"

OPTIONS=(1 "Install: Ajenti"
         2 "Install: Minecraft"
         3 "Install: Teamspeak 3"
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
			echo "You selected: Install Ajenti"
            bash addons/ajenti.sh
            ;;
        2)
			echo "You selected: Install Minecraft"
            bash addons/minecraft.sh
            ;;
        3)
            echo "You selected: Install Teamspeak 3"
			bash addons/teamspeak3.sh
            ;;
		4)
			echo "Exit"
			exit 1
            ;;
esac