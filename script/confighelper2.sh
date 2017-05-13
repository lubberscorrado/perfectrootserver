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
# DNS CHECK NOT WORKING!

source ~/script/security.sh
source ~/script/functions.sh
CONFIGHELPER_PATH="/root"

##############CONFIGHELPER USERCONFIG
menu() {
CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)	
}

confighelper_userconfig() {
# Global menu variables
BACKTITLE="Perfect Root Server Installation"
TITLE="Perfect Root Server Installation"	
HEIGHT=30
WIDTH=60	
			
### Start ###
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
           	
	# ----------------------------------------------------------------
	if [ "$IAMEXPERT" = "1" ]; then
	if prompt_confirm "Do you want choose and SSH Port? If you say \"No\" we generate a secure Port!"; then
			while true
			do
				read -p "Enter your SSH Port (only max. 3 numbers!):" CHOOSE_OWN_SSH_PORT
				if [[ ${CHOOSE_OWN_SSH_PORT} =~ ^-?[0-9]+$ ]]; then

					if [[ -v BLOCKED_PORTS[$CHOOSE_OWN_SSH_PORT] ]]; then
						echo "$CHOOSE_OWN_SSH_PORT is known. Choose an other Port!"
					else
						#You can use this Port
						echo "${finished} Your SSH Port is: $CHOOSE_OWN_SSH_PORT"
						SSH_PORT="$CHOOSE_OWN_SSH_PORT"
						# Todo
						# Mybe its better to set the port direct. At them moment we set him in firewall script
						#sed -i "s/SSH_PORT=\"generateport\"/SSH_PORT=\"$CHOOSE_OWN_SSH_PORT\"/g" ~/configs/userconfig.cfg
						break
					fi

				else
				echo "Maybe you do not know what a number is?"
				fi
			done
		else
			#Generate SSH Port
			randomNumber="$(($RANDOM % 1023))"
			#return a string
			SSH_PORT=$([[ ! -n "${BLOCKED_PORTS["$randomNumber"]}" ]] && printf "%s\n" "$randomNumber")
			#sed -i "s/SSH_PORT=\"generateport\"/SSH_PORT=\"$SSH_PORT\"/g" ~/configs/userconfig.cfg
			echo "${finished} Your SSH Port is: $SSH_PORT"
		fi
	fi

	if [ "$IAMEXPERT" = "0" ]; then
		#Generate SSH Port
		randomNumber="$(($RANDOM % 1023))"
		#return a string
		SSH_PORT=$([[ ! -n "${BLOCKED_PORTS["$randomNumber"]}" ]] && printf "%s\n" "$randomNumber")
		#sed -i "s/SSH_PORT=\"generateport\"/SSH_PORT=\"$SSH_PORT\"/g" ~/configs/userconfig.cfg
		echo "${finished} Your SSH Port is: $SSH_PORT"
	fi
	# ----------------------------------------------------------------
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
	# ----------------------------------------------------------------

	# Todo
	# Check valid Domain
	# Maybe function from functions.sh ;)

	MYDOMAIN=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --inputbox "Enter your Domain without http:// (exmaple.org):" \
                $HEIGHT $WIDTH \
                3>&1 1>&2 2>&3 3>&- \
	)					
	
	# ----------------------------------------------------------------
CHOICE_HEIGHT=2
MENU="Do you want to Use SSL?:"
OPTIONS=(1 "Yes"
         2 "No")
menu
clear
case $CHOICE in
        1)
			USE_VALID_SSL="1"
            echo "${finished} You use SSL"
			while true
				do
					read -p "Enter your valid E-Mail address: " SSLMAIL
					if [[ "$SSLMAIL" =~ $CHECK_E_MAIL ]];then
						echo "${finished} Your E-Mail address is $SSLMAIL"
						break
					else
						echo "[ERROR] Should we again practice how an e-mail address looks?"
					fi
			done
            ;;
        2)
			USE_VALID_SSL="0"
            echo "${finished} You dont use SSL"
            ;;
esac
	# ----------------------------------------------------------------
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
	# ----------------------------------------------------------------
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
	# ----------------------------------------------------------------
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

	# ----------------------------------------------------------------
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
	# ----------------------------------------------------------------
	PMA_HTTPAUTH_USER=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --inputbox "Please choose an user for HTTP-Auth login:" \
                $HEIGHT $WIDTH \
                3>&1 1>&2 2>&3 3>&- \
	)				
	# ----------------------------------------------------------------
	MYSQL_PMADB_USER=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --inputbox "Please choose an user for MYSQL PHPMyAdmin Login:" \
                $HEIGHT $WIDTH \
                3>&1 1>&2 2>&3 3>&- \
	)				
	# ----------------------------------------------------------------
	MYSQL_PMADB_NAME=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --inputbox "Please choose an DB-Name for MYSQL PHPMyAdmin:" \
                $HEIGHT $WIDTH \
                3>&1 1>&2 2>&3 3>&- \
	)				
	# ----------------------------------------------------------------
if [ "$IAMEXPERT" = "1" ]; then
		# ----------------------------------------------------------------
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
		# ----------------------------------------------------------------
if [ "$ALLOWHTTPCONNECTIONS" = "0" ]; then
			# ----------------------------------------------------------------
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
		# ----------------------------------------------------------------
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

	# ----------------------------------------------------------------
	if [ "$IAMEXPERT" = "0" ]; then
		# If no expert, we set default values
		CLOUDFLARE="0"
		HIGH_SECURITY="0"
		DEBUG_IS_SET="0"
	fi
	# ----------------------------------------------------------------
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
			ADDONCONFIG_COMPLETED="1"
            ;;
esac

CONFIG_COMPLETED="1"
# Write Vars to Config file:
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

} # END confighelper_userconfig
##############CONFIGHELPER ADDONCONFIG
confighelper_addonconfig() {
echo "Start Confighelper for Addonconfig"


	# ----------------------------------------------------------------
	if prompt_confirm "Do you want to Add a new Site?" ; then
		ADD_NEW_SITE="1"
		echo "${finished} You want to add a new Site."
			# --------------------------------
			read -p "Please Type your Domain without http://www.:" MYOTHERDOMAIN
			echo "${finished} Your second Domain is: $MYOTHERDOMAIN"
	else
		MYOTHERDOMAIN="0"
		echo "${finished} You dont add a new site"
	fi
	# ----------------------------------------------------------------
	if prompt_confirm "Do you want to disable root Login?" ; then
		DISABLE_ROOT_LOGIN="1"
		echo "${finished} You want to disable root login."
			# --------------------------------
			read -p "Please Type your new SSH User:" SSHUSER
			echo "${finished} Your new SSH USer is: $SSHUSER"
	else
		DISABLE_ROOT_LOGIN="0"
		echo "${finished} You dont disable root Login. Your User to login is: root"
	fi
	# ----------------------------------------------------------------
	if prompt_confirm "Do you want use TeamSpeak?" ; then
		USE_TEAMSPEAK="1"
		echo "${finished} You install Teamspeack."
	else
		USE_TEAMSPEAK="0"
		echo "${finished} You dont use Teamspeak"
	fi
	# ----------------------------------------------------------------
	if prompt_confirm "Do you want use Minecraft?" ; then
		USE_MINECRAFT="1"
		echo "${finished} You install Minecraft."
	else
		USE_MINECRAFT="0"
		echo "${finished} You dont use Minecraft"
	fi
	# ----------------------------------------------------------------
	if [ "$USE_VALID_SSL" = "1" ]; then
		if prompt_confirm "Do you want use Ajenti?" ; then
			USE_AJENTI="1"
			echo "${finished} You install Ajenti."
		else
			USE_AJENTI="0"
				echo "${finished} You dont use Ajenti"
		fi
	fi
	# ----------------------------------------------------------------
	if prompt_confirm "Do you want use Piwik?" ; then
		USE_PIWIK="1"
		echo "${finished} You install Piwik."
	else
		USE_PIWIK="0"
		echo "${finished} You dont use Piwik"
	fi
	# ----------------------------------------------------------------
	if prompt_confirm "Do you want use VSFTPd?" ; then
		USE_VSFTPD="1"
		echo "${finished} You install VSFTPd."
			# --------------------------------
			while true
			do
				read -p "Please type your ftp User. Use only a-z!:" FTP_USERNAME
					if [[ $FTP_USERNAME =~ ^[a-z]+$ ]]; then
						echo "${finished} Your FTP USername is $FTP_USERNAME."
						break
					else
						echo "[Big Error] Should we perhaps learn something about lowercase letters?"
					fi
			done
	else
		USE_VSFTPD="0"
		echo "${finished} You dont use VSFTPd"
	fi
	# ----------------------------------------------------------------
	if prompt_confirm "Do you want use OPENVPN?" ; then
		USE_OPENVPN="1"
		echo "${finished} You use OPENVPN"
			# --------------------------------
			SERVER_IP=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)

			while true
			do
				read -p "Enter your valid E-Mail address: " KEY_EMAIL
				if [[ "$KEY_EMAIL" =~ $CHECK_E_MAIL ]];then
					echo "${finished} Your E-Mail address is $KEY_EMAIL"
					break
				else
					echo "[ERROR] Should we again practice how an e-mail address looks?"
				fi
			done

			read -p "Please type your COUNTRY. Example: DE for Germany:" KEY_COUNTRY
			read -p "Please type your PROVINCE. Example: Hessen:" KEY_PROVINCE
			read -p "Please type your CITY. Example: Frankfurt:" KEY_CITY
	else
		USE_OPENVPN="0"
		echo "${finished} You dont use OPENVPN"
	fi

	# ----------------------------------------------------------------
	# NOT READY!
	# DO NOT USE PRESTASHOP with confighelper!
	# ---------------------------------------------------------------#
		#read -p "Do you want use Prestashop E-Commerce System? Please type y or n:" USE_PRESTASHOP
		USE_PRESTASHOP="0"
	#~ if [ "$USE_PRESTASHOP" = "y" ]; then
		#~ USE_PRESTASHOP="1"
		#~ echo "${finished} You use Prestashop E-Commerce System"
			#~ # --------------------------------
			#~ PRESTASHOP_VERSION="1.6.1.12"
			#~ PRESTASHOPDOMAIN="domain.tld"
			#~ PRESTASHOP_OWNER_FIRSTNAME="Perfect"
			#~ PRESTASHOP_OWNER_LASTNAME="Rootserver"
			#~ PRESTASHOP_OWNER_EMAIL="prestashop@perfectrootserver.de"
			#~ PRESTASHOPS_NAME="perfectrootserver script"
			#~ PRESTASHOP_INSTALL_FOLDER_NAME="CHANGEME"
			#~ PRESTASHOP_LANGUAGE="de"
			#~ PRESTASHOP_COUNTRY="de"

			#~ PRESTASHOP_DB_SERVER="localhost"


			#~ PRESTASHOP_TIMEZONE="berlin"
			#~ PRESTASHOP_DB_CLEAR="1"
			#~ PRESTASHOP_CRYPT_PRF="${PRESTASHOP_CRYPT_PRF}"
			#~ PRESTASHOP_DB_NAME="${PRESTASHOP_DB_NAME}"
			#~ PRESTASHOP_CREATE_DB="1"
			#~ PRESTASHOP_SHOW_LICENSE="0"
			#~ PRESTASHOP_NEWSLETTER="1"
			#~ PRESTASHOP_SEND_EMAIL="1"



			#~ # --------------------------------
			#~ read -p "Do you want clear DB? Please type y or n:" PRESTASHOP_DB_CLEAR
			#~ if [ "$PRESTASHOP_DB_CLEAR" = "y" ]; then
				#~ PRESTASHOP_DB_CLEAR="1"
				#~ echo "${finished} Deleting the database"
			#~ fi

			#~ if [ "$PRESTASHOP_DB_CLEAR" = "n" ]; then
				#~ PRESTASHOP_DB_CLEAR="0"
				#~ echo "${finished} Deleting no database"
			#~ fi

			#~ # --------------------------------
			#~ # Todo
			#~ # Check var after installation!
			#~ select choosetimezone in $timezones; do
				#~ if [ "$choosetimezone" = "Europe/Berlin" ]; then
				#~ PRESTASHOP_TIMEZONE="$choosetimezone"
					#~ break;
				#~ fi

				#~ if [ "$choosetimezone" = "America/New_York" ]; then
				#~ PRESTASHOP_TIMEZONE="$choosetimezone"
					#~ break;
				#~ fi
			#~ done
			#~ echo "${finished} Your Timezone is $choosetimezone"


			#~ # --------------------------------
			#~ # Todo
			#~ # Add function to check prf
			#~ PRESTASHOP_DB_ENGINE="
			#~ InnoDB
			#~ MyISAM
			#~ "
			#~ read -p "Please choose an Praefix:" PRESTASHOP_CRYPT_PRF
			#~ echo "${finished} Your new DB Praefix is $PRESTASHOP_CRYPT_PRF"

			#~ # --------------------------------
			#~ echo "Please choose an DB engine"
			#~ select chooseengine in $PRESTASHOP_DB_ENGINE; do
				#~ if [ "$chooseengine" = "Europe/Berlin" ]; then
					#~ break;
				#~ fi

				#~ if [ "$chooseengine" = "America/New_York" ]; then
					#~ break;
				#~ fi
			#~ done
			#~ echo "${finished} Your Timezone is $chooseengine"

			#~ # --------------------------------
			#~ read -p "Do you want create an Database (It is recommended)? Please type y or n:" PRESTASHOP_CREATE_DB
			#~ if [ "$PRESTASHOP_CREATE_DB" = "y" ]; then
				#~ PRESTASHOP_CREATE_DB="1"
				#~ echo "${finished} You create an new Database."
					#~ # --------------------------------
					#~ read -p "Please type your DB name. Please type y or n:" PRESTASHOP_DB_NAME
			#~ fi

			#~ if [ "$PRESTASHOP_CREATE_DB" = "n" ]; then
				#~ PRESTASHOP_CREATE_DB="0"
				#~ echo "${finished} You dont create an new Database."
			#~ fi

			#~ # --------------------------------
			#~ read -p "Do you want to show the license from Prestashops E-Commerce System? Please type y or n:" PRESTASHOP_SHOW_LICENSE
			#~ if [ "$PRESTASHOP_SHOW_LICENSE" = "y" ]; then
				#~ PRESTASHOP_SHOW_LICENSE="1"
				#~ echo "${finished} You see the license"
			#~ fi

			#~ if [ "$PRESTASHOP_SHOW_LICENSE" = "n" ]; then
				#~ PRESTASHOP_SHOW_LICENSE="0"
				#~ echo "${finished} You dont see the license"
			#~ fi

			#~ # --------------------------------
			#~ read -p "Du you want subscribe your own Newsletter? Please type y or n:" PRESTASHOP_NEWSLETTER
			#~ if [ "$PRESTASHOP_NEWSLETTER" = "y" ]; then
				#~ PRESTASHOP_NEWSLETTER="1"
				#~ echo "${finished} You subscribe your Newsletter"
			#~ fi

			#~ if [ "$PRESTASHOP_NEWSLETTER" = "n" ]; then
				#~ PRESTASHOP_NEWSLETTER="0"
				#~ echo "${finished} You dont subscribe your Newsletter"
			#~ fi

			#~ # --------------------------------
			#~ read -p "Do you wish an E-Mail after Setup? Please type y or n:" PRESTASHOP_SEND_EMAIL
			#~ if [ "$PRESTASHOP_SEND_EMAIL" = "y" ]; then
				#~ PRESTASHOP_SEND_EMAIL="1"
				#~ echo "${finished} You become an E-Mail after installation"
			#~ fi

			#~ if [ "$PRESTASHOP_SEND_EMAIL" = "n" ]; then
				#~ PRESTASHOP_SEND_EMAIL="0"
				#~ echo "${finished} You become no E-Mail after installation"
			#~ fi
			#~ # --------------------------------

	#~ fi

	#~ if [ "$USE_PRESTASHOP" = "n" ]; then
		#~ USE_PRESTASHOP="0"
		#~ echo "${finished} You dont use Prestashop E-Commerce System"
	#~ fi


# Set Value to complete config
ADDONCONFIG_COMPLETED="1"
# Write Vars to Config file:

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
}
##############CONFIGHELPER SHOW CONFIG
confighelper_show_config() {
	echo "Your Credentials"
	echo "#####################################################"
	cat $CONFIGHELPER_PATH/configs/userconfig.cfg

	if [ "$ADDONCONFIG_COMPLETED" = "1" ]; then
	echo "#####################################################"
	cat $CONFIGHELPER_PATH/configs/addonconfig.cfg
	fi
}
##############CONFIGHELPER MERGE FUNCTIONS
confighelper() {
#Run functions
#confighelper_installs
confighelper_generate_passwords
confighelper_userconfig
if [ "$ADDONCONFIG_COMPLETED" = "0" ]; then
	confighelper_addonconfig
fi
confighelper_show_config
}


source ~/configs/userconfig.cfg
source ~/configs/addonconfig.cfg
