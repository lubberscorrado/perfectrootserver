#!/bin/bash

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