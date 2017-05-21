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

# Known issues
# Prestashop not working

CONFIGHELPER_PATH="/root"
source $CONFIGHELPER_PATH/script/security.sh
source $CONFIGHELPER_PATH/script/functions.sh

# --- CONFIGHELPER ADDONCONFIG ---
confighelper_addonconfig() {

# --- GLOBAL MENU VARIABLES ---
BACKTITLE="Perfect Root Server Installation"
TITLE="Perfect Root Server Installation"
HEIGHT=30
WIDTH=60

# --- START ---

			MYOTHERDOMAIN="0"

			DISABLE_ROOT_LOGIN="0"

# --- TEAMSPEAK 3 ---
CHOICE_HEIGHT=2
MENU="Do you want use TeamSpeak 3?:"
OPTIONS=(1 "Yes"
			2 "No")
menu
clear
case $CHOICE in
		1)
			USE_TEAMSPEAK="1"
				;;
		2)
			USE_TEAMSPEAK="0"
			;;
esac

# --- MINECRAFT ---
CHOICE_HEIGHT=2
MENU="Do you want use Minecraft?:"
OPTIONS=(1 "Yes"
		2 "No")
menu
clear
case $CHOICE in
		1)
			USE_MINECRAFT="1"
			;;
		2)
			USE_MINECRAFT="0"
			;;
esac

# --- AJENI ---
if [ "$USE_VALID_SSL" = "1" ]; then
	CHOICE_HEIGHT=2
	MENU="Do you want use Ajenti?:"
	OPTIONS=(1 "Yes"
			2 "No")
	menu
	clear
	case $CHOICE in
			1)
				USE_AJENTI="1"
				AJENTI_PASS="$AJENTI_PASS"
				;;
			2)
				USE_AJENTI="0"
				;;
	esac
fi

			USE_PIWIK="0"

# --- VSFTPD ---
CHOICE_HEIGHT=2
MENU="Do you want use VSFTPd?"
OPTIONS=(1 "Yes"
		2 "No")
menu
clear
case $CHOICE in
		1)
			USE_VSFTPD="1"
			while true
			do
				FTP_USERNAME=$(dialog --clear \
					--inputbox "Please type your ftp User. Use only a-z!:" \
					$HEIGHT $WIDTH \
					3>&1 1>&2 2>&3 3>&- \
					)
					if [[ $FTP_USERNAME =~ ^[a-z]+$ ]]; then
						break
					else
						dialog --infobox "[Big Error] Should we perhaps learn something about lowercase letters?" $HEIGHT $WIDTH
						sleep 2
					fi
			done
			;;
		2)
			USE_VSFTPD="0"
			;;
esac

			USE_OPENVPN="0"


# --- PRETASHOP ---
# At the moment, prestashop addon is not working!
USE_PRESTASHOP="0"

ADDONCONFIG_COMPLETED="1"

rm -rf $CONFIGHELPER_PATH/configs/addonconfig.cfg
cat >> $CONFIGHELPER_PATH/configs/addonconfig.cfg <<END
#-----------------------------------------------------------#
############### Config File from Confighelper ###############
#-----------------------------------------------------------#
# This file was created on ${CURRENT_DATE}

ADDONCONFIG_COMPLETED="${CONFIG_COMPLETED}"

# ADD NEW SITE addon
ADD_NEW_SITE="${ADD_NEW_SITE}"
MYOTHERDOMAIN="${MYOTHERDOMAIN}"

# DISABLE ROOT LOGIN addon
DISABLE_ROOT_LOGIN="${DISABLE_ROOT_LOGIN}"
SSHUSER="${SSHUSER}"

# TEAMSPEAK addon
USE_TEAMSPEAK="${USE_TEAMSPEAK}"

# Minecraft addon
USE_MINECRAFT="${USE_MINECRAFT}"

# AJENTI addon
USE_AJENTI="${USE_AJENTI}"
AJENTI_PASS="generatepw"

# Piwik addon
USE_PIWIK="${USE_PIWIK}"

# FTP SERVER addon
USE_VSFTPD="${USE_VSFTPD}"
FTP_USERNAME="${FTP_USERNAME}"

# OPENVPN addon
USE_OPENVPN="${USE_OPENVPN}"
KEY_COUNTRY="${KEY_COUNTRY}"
KEY_PROVINCE="${KEY_PROVINCE}"
KEY_CITY="${KEY_CITY}"
KEY_EMAIL="${KEY_EMAIL}"
SERVER_IP="${SERVER_IP}"

# Prestashop addon
USE_PRESTASHOP="${USE_PRESTASHOP}"
PRESTASHOP_VERSION="${PRESTASHOP_VERSION}"
PRESTASHOPDOMAIN="${PRESTASHOPDOMAIN}"
PRESTASHOP_OWNER_FIRSTNAME="${PRESTASHOP_OWNER_FIRSTNAME}"
PRESTASHOP_OWNER_LASTNAME="${PRESTASHOP_OWNER_LASTNAME}"
PRESTASHOP_OWNER_EMAIL="${PRESTASHOP_OWNER_EMAIL}"
PRESTASHOPS_NAME="${PRESTASHOPS_NAME}"
PRESTASHOP_INSTALL_FOLDER_NAME="${PRESTASHOP_INSTALL_FOLDER_NAME}"
PRESTASHOP_LANGUAGE="${PRESTASHOP_LANGUAGE}"
PRESTASHOP_COUNTRY="${PRESTASHOP_COUNTRY}"
PRESTASHOP_DB_SERVER="localhost"
PRESTASHOP_TIMEZONE="${PRESTASHOP_TIMEZONE}"
PRESTASHOP_DB_CLEAR="${PRESTASHOP_DB_CLEAR}"
PRESTASHOP_CREATE_DB="${PRESTASHOP_CREATE_DB}"
PRESTASHOP_SHOW_LICENSE="${PRESTASHOP_SHOW_LICENSE}"
PRESTASHOP_NEWSLETTER="${PRESTASHOP_NEWSLETTER}"
PRESTASHOP_SEND_EMAIL="${PRESTASHOP_SEND_EMAIL}"
PRESTASHOP_DB_NAME="${PRESTASHOP_DB_NAME}"
PRESTASHOP_CRYPT_PRF="${PRESTASHOP_CRYPT_PRF}"
PRESTASHOP_DB_ENGINE="${chooseengine}"
#-----------------------------------------------------------#
############### Config File from Confighelper ###############
#-----------------------------------------------------------#
END

dialog --title "Addonconfig" --textbox $CONFIGHELPER_PATH/configs/addonconfig.cfg 50 250
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
			confighelper_addonconfig
            ;;
esac
}
