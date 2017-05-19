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

CONFIGHELPER_PATH="/root"
source $CONFIGHELPER_PATH/script/security.sh
source $CONFIGHELPER_PATH/script/functions.sh

# --- CONFIGHELPER USERCONFIG ---
confighelper_userconfig() {

# --- GLOBAL MENU VARIABLES ---
BACKTITLE="Perfect Root Server Installation"
TITLE="Perfect Root Server Installation"
HEIGHT=30
WIDTH=60

# --- START ---
CHOICE_HEIGHT=2
MENU="Are you an expert?:"
OPTIONS=(1 "Yes"
         2 "No")
menu
clear
case $CHOICE in
		1)
			IAMEXPERT="1"
            ;;
        2)
			IAMEXPERT="0"
            ;;
esac

# --- SSH PORT ---
if [ "$IAMEXPERT" = "1" ]; then
CHOICE_HEIGHT=2
MENU="Do you want choose and SSH Port? If you say \"No\" we generate a secure Port!"
OPTIONS=(1 "YES"
		 2 "NO")
menu
clear
case $CHOICE in
        1)
			while true
			do
				CHOOSE_OWN_SSH_PORT=$(dialog --clear \
					--backtitle "$BACKTITLE" \
					--inputbox "Enter your SSH Port (only max. 3 numbers!):" \
					$HEIGHT $WIDTH \
					3>&1 1>&2 2>&3 3>&- \
					)
				if [[ ${CHOOSE_OWN_SSH_PORT} =~ ^-?[0-9]+$ ]]; then

					if [[ -v BLOCKED_PORTS[$CHOOSE_OWN_SSH_PORT] ]]; then
						dialog --title "Perfectrootserver Confighelper" --msgbox "$CHOOSE_OWN_SSH_PORT is known. Choose an other Port!" $HEIGHT $WIDTH
						dialog --clear
					else
						#You can use this Port
						dialog --title "Perfectrootserver Confighelper" --msgbox "Your SSH Port is: $CHOOSE_OWN_SSH_PORT" $HEIGHT $WIDTH
						dialog --clear
						SSH_PORT="$CHOOSE_OWN_SSH_PORT"
						# Todo
						# Mybe its better to set the port direct. At them moment we set him in firewall script
						#sed -i "s/SSH_PORT=\"generateport\"/SSH_PORT=\"$CHOOSE_OWN_SSH_PORT\"/g" ~/configs/userconfig.cfg
						break
					fi

				else
				dialog --infobox "Maybe you do not know what a number is?" $HEIGHT $WIDTH

				dialog --clear
				fi
			done
            ;;
		2)
			#Generate SSH Port
			randomNumber="$(($RANDOM % 1023))"
			#return a string
			SSH_PORT=$([[ ! -n "${BLOCKED_PORTS["$randomNumber"]}" ]] && printf "%s\n" "$randomNumber")
			#sed -i "s/SSH_PORT=\"generateport\"/SSH_PORT=\"$SSH_PORT\"/g" ~/configs/userconfig.cfg
			dialog --title "Perfectrootserver Confighelper" --msgbox "Your SSH Port is: $SSH_PORT" $HEIGHT $WIDTH

			dialog --clear
            ;;
esac
fi

if [ "$IAMEXPERT" = "0" ]; then
	randomNumber="$(($RANDOM % 1023))"
	SSH_PORT=$([[ ! -n "${BLOCKED_PORTS["$randomNumber"]}" ]] && printf "%s\n" "$randomNumber")
	dialog --infobox "Your SSH Port is: $SSH_PORT" $HEIGHT $WIDTH
	sleep 2
	dialog --clear
fi

# --- TIMEZONE ---	
CHOICE_HEIGHT=6
MENU="Choose a timezone:"
OPTIONS=(1 "Europe/Berlin"
		 2 "Europe/Moscow"
		 3 "Australia/Sydney"
		 4 "Asia/Tokyo"
		 5 "America/Los_Angeles"
		 6 "America/New_York")
menu
clear
case $CHOICE in
        1)
			TIMEZONE="Europe/Berlin"
            ;;
		2)
			TIMEZONE="Europe/Moscow"
            ;;
		3)
			TIMEZONE="Australia/Sydney"
            ;;
		4)
			TIMEZONE="Asia/Tokyo"
            ;;
		5)
			TIMEZONE="America/Los_Angeles"
            ;;
        6)
			TIMEZONE="America/New_York"
            ;;
esac

# --- MYDOMAIN ---
while true
		do
			MYDOMAIN=$(dialog --clear \
			--backtitle "$BACKTITLE" \
			--inputbox "Enter your Domain without http:// (exmaple.org):" \
			$HEIGHT $WIDTH \
			3>&1 1>&2 2>&3 3>&- \
			)
				if [[ "$MYDOMAIN" =~ $CHECK_DOMAIN ]];then
					break
				else
					dialog --infobox "[ERROR] Should we again practice how a Domain address looks?" $HEIGHT $WIDTH
					sleep 1
				fi
		done

# --- SSL ---
CHOICE_HEIGHT=2
MENU="Do you want to Use SSL?:"
OPTIONS=(1 "Yes"
         2 "No")
menu
clear
case $CHOICE in
        1)
			USE_VALID_SSL="1"
			while true
			do
				SSLMAIL=$(dialog --clear \
				--backtitle "$BACKTITLE" \
				--inputbox "Enter your valid E-Mail address:" \
				$HEIGHT $WIDTH \
				3>&1 1>&2 2>&3 3>&- \
				)
					if [[ "$SSLMAIL" =~ $CHECK_E_MAIL ]];then
						break
					else
						dialog --infobox "[ERROR] Should we again practice how an e-mail address looks?" $HEIGHT $WIDTH
						sleep 1
					fi
			done
           ;;
        2)
			USE_VALID_SSL="0"
           ;;
esac

# --- MAILSERVER ---
CHOICE_HEIGHT=3
MENU="Do you want to Use Mailserver?:"
OPTIONS=(1 "Yes"
		 2 "Yes with Webmail"
         3 "No")
menu
clear
case $CHOICE in
        1)
			USE_MAILSERVER="1"
            ;;
        2)
			USE_MAILSERVER="1"
			USE_WEBMAIL="1"
            ;;
		3)
			USE_MAILSERVER="0"
			USE_WEBMAIL="0"
            ;;
esac

# --- PHP ---
CHOICE_HEIGHT=2
MENU="Do you want to Use PHP5 oder PHP7?:"
OPTIONS=(1 "PHP 5"
         2 "PHP 7")
menu
clear
case $CHOICE in
        1)
			USE_PHP5="1"
			USE_PHP7="0"
            ;;
        2)
			USE_PHP7="1"
			USE_PHP5="0"
            ;;
esac

# --- PHPMYADMIN ---
CHOICE_HEIGHT=3
MENU="Do you want to Use PHPMyAdmin?:"
OPTIONS=(1 "Yes"
		 2 "Yes, but restrcited"
         3 "No")
menu
clear
case $CHOICE in
        1)
			USE_PMA="1"
            ;;
        2)
			USE_PMA="1"
			PMA_RESTRICT="1"
            ;;
		3)
			USE_PMA="0"
			PMA_RESTRICT="0"
            ;;
esac

# --- HTTP CONNECTIONS ---
CHOICE_HEIGHT=2
MENU="Do you want allow http-connections?:"
OPTIONS=(1 "Yes"
         2 "No")
menu
clear
case $CHOICE in
        1)
			ALLOWHTTPCONNECTIONS="1"
            ;;
        2)
			ALLOWHTTPCONNECTIONS="0"
            ;;
esac

# --- PMA_HTTPAUTH_USER ---
if [ "$IAMEXPERT" = "1" ]; then
	PMA_HTTPAUTH_USER=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --inputbox "Please choose an user for HTTP-Auth login:" \
        $HEIGHT $WIDTH \
        3>&1 1>&2 2>&3 3>&- \
	)
	
# --- MYSQL_PMADB_USER ---
	MYSQL_PMADB_USER=$(dialog --clear \
        --backtitle "$BACKTITLE" \
		--inputbox "Please choose an user for MYSQL PHPMyAdmin Login:" \
        $HEIGHT $WIDTH \
        3>&1 1>&2 2>&3 3>&- \
	)
	
# --- MYSQL_PMADB_NAME ---
	MYSQL_PMADB_NAME=$(dialog --clear \
		--backtitle "$BACKTITLE" \
        --inputbox "Please choose an DB-Name for MYSQL PHPMyAdmin:" \
        $HEIGHT $WIDTH \
		3>&1 1>&2 2>&3 3>&- \
	)
else
	PMA_HTTPAUTH_USER="httpauth"
	MYSQL_PMADB_USER="phpmyadmin"
	MYSQL_PMADB_NAME="phpmyadmin"
fi

if [ "$IAMEXPERT" = "1" ]; then
	# --- CLOUDFLARE ---
	if [ "$IAMEXPERT" = "1" ]; then
		CHOICE_HEIGHT=2
		MENU="Do you want use Cloudflare?:"
		OPTIONS=(1 "Yes"
				2 "No")
		menu
		clear
		case $CHOICE in
				1)
					CLOUDFLARE="1"
					;;
				2)
					CLOUDFLARE="0"
					;;
		esac
	
	# --- HIGH SECURITY ---	
	if [ "$ALLOWHTTPCONNECTIONS" = "0" ]; then
		CHOICE_HEIGHT=2
		MENU="Do you want use HIGH SECURITY?:"
		OPTIONS=(1 "Yes"
				2 "No")
		menu
		clear
			case $CHOICE in
					1)
						HIGH_SECURITY="1"
						;;
					2)
						HIGH_SECURITY="0"
						;;
	esac
	fi

	# --- DEBUG ---	
	CHOICE_HEIGHT=2
	MENU="Do you want use Debug Mode?:"
	OPTIONS=(1 "Yes"
			2 "No")
	menu
	clear
	case $CHOICE in
			1)
				DEBUG_IS_SET="1"
				;;
			2)
				DEBUG_IS_SET="0"
				;;
	esac
fi

# --- IAMEXPERT 0 ---
if [ "$IAMEXPERT" = "0" ]; then
	CLOUDFLARE="0"
	HIGH_SECURITY="0"
	DEBUG_IS_SET="0"
fi

# --- ADDONCONFIG? ---
CHOICE_HEIGHT=2
MENU="Do You need Addonconfig?:"
OPTIONS=(1 "Yes"
         2 "No")
menu
clear
case $CHOICE in
        1)
			ADDONCONFIG_COMPLETED="0"
            ;;
        2)
			ADDONCONFIG_COMPLETED="2"
            ;;
esac

CONFIG_COMPLETED="1"

rm -rf $CONFIGHELPER_PATH/configs/userconfig.cfg
cat >> $CONFIGHELPER_PATH/configs/userconfig.cfg <<END
#-----------------------------------------------------------#
############### Config File from Confighelper ###############
#-----------------------------------------------------------#
# This file was created on ${CURRENT_DATE}

	CONFIG_COMPLETED="${CONFIG_COMPLETED}"
	TIMEZONE="${TIMEZONE}"
	MYDOMAIN="${MYDOMAIN}"
	SSH_PORT="${SSH_PORT}"
	USE_VALID_SSL="${USE_VALID_SSL}"
	SSLMAIL="${SSLMAIL}"
	USE_MAILSERVER="${USE_MAILSERVER}"
	USE_WEBMAIL="${USE_WEBMAIL}"
	USE_PHP5="${USE_PHP5}"
	USE_PHP7="${USE_PHP7}"
	USE_PMA="${USE_PMA}"
	PMA_RESTRICT="${PMA_RESTRICT}"
	ALLOWHTTPCONNECTIONS="${ALLOWHTTPCONNECTIONS}"
	CLOUDFLARE="${CLOUDFLARE}"
	HIGH_SECURITY="${HIGH_SECURITY}"
	DEBUG_IS_SET="${DEBUG_IS_SET}"
	PMA_HTTPAUTH_USER="${PMA_HTTPAUTH_USER}"
	MYSQL_PMADB_NAME="${MYSQL_PMADB_NAME}"
	MYSQL_PMADB_USER="${MYSQL_PMADB_USER}"

	# Passwords
	SSH_PASS="${SSH_PASS}"
	POSTFIX_ADMIN_PASS="${POSTFIX_ADMIN_PASS}"
	VIMB_MYSQL_PASS="${VIMB_MYSQL_PASS}"
	ROUNDCUBE_MYSQL_PASS="${ROUNDCUBE_MYSQL_PASS}"
	PMA_HTTPAUTH_PASS="${PMA_HTTPAUTH_PASS}"
	PMA_BFSECURE_PASS="${PMA_BFSECURE_PASS}"
	MYSQL_ROOT_PASS="${MYSQL_ROOT_PASS}"
	MYSQL_PMADB_PASS="${MYSQL_PMADB_PASS}"

	MYSQL_HOSTNAME="localhost"
#-----------------------------------------------------------#
############### Config File from Confighelper ###############
#-----------------------------------------------------------#
END

dialog --title "Userconfig" --textbox $CONFIGHELPER_PATH/configs/userconfig.cfg 50 250
clear

CHOICE_HEIGHT=2
MENU="Settings correct?"
OPTIONS=(1 "Yes"
         2 "No")
menu
clear
case $CHOICE in
        1)
			break
            ;;
        2)
			confighelper_userconfig
            ;;
esac
}

source $CONFIGHELPER_PATH/configs/userconfig.cfg
source $CONFIGHELPER_PATH/configs/addonconfig.cfg