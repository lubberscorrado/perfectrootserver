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

source ~/script/security.sh
source ~/script/functions.sh
confighelper_installs() {
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
}




confighelper_userconfig() {
echo "${info} Start confighelper...." | awk '{ print strftime("[%H:%M:%S] |"), $0 }'

# Small function...
CHECK_E_MAIL="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"

	echo "${info} Confighelper for userconfig" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'

	read -p "Are you an expert? Please type y or n:" IAMEXPERT
		if [ "$IAMEXPERT" = "y" ]; then
			IAMEXPERT="1"
			echo "${finished} You are an Expert!"
		fi

		if [ "$IAMEXPERT" = "n" ]; then
			IAMEXPERT="0"
			echo "${finished} You are normal user"
		fi

	# ----------------------------------------------------------------
	if [ "$IAMEXPERT" = "1" ]; then
		read -p "Do you want choose and SSH Port? If you say \"No\" we generate a secure Port! Please type y or n:" CHOOSE_SSH_PORT
		if [[ "$CHOOSE_SSH_PORT" = "y" ]]; then
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
		elif [[ "$CHOOSE_SSH_PORT"="n" ]]; then
			#Generate SSH Port
			randomNumber="$(($RANDOM % 1023))"
			#return a string
			SSH_PORT=$([[ ! -n "${BLOCKED_PORTS["$randomNumber"]}" ]] && printf "%s\n" "$randomNumber")
			#sed -i "s/SSH_PORT=\"generateport\"/SSH_PORT=\"$SSH_PORT\"/g" ~/configs/userconfig.cfg
			echo "${finished} Your SSH Port is: $SSH_PORT"

		else
			echo "Y or N .....and again bro...."
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
	timezones="
	Europe/Berlin
	America/New_York
	"
	select choosetimezone in $timezones; do
		if [ "$choosetimezone" = "Europe/Berlin" ]; then
		TIMEZONE="$choosetimezone"
			break;
		fi

		if [ "$choosetimezone" = "America/New_York" ]; then
		TIMEZONE="$choosetimezone"
			break;
		fi
	done
	echo "${finished} Your Timezone is $choosetimezone"
	# ----------------------------------------------------------------

	read -p "Enter your Domain without http://:" MYDOMAIN
	echo "${finished} Your Domain is $MYDOMAIN"

	# ----------------------------------------------------------------
	read -p "Do you want to Use SSL? Please type y or n:" USE_VALID_SSL
		if [ "$USE_VALID_SSL" = "y" ]; then
			USE_VALID_SSL="1"
			echo "${finished} You use SSL"

				# --------------------------------
					while true
					do
						read -p "Enter your valid E-Mail address: " SSLMAIL
						if [[ "$SSLMAIL" =~ $CHECK_E_MAIL ]];then
							echo "${finished} Your E-Mail address is $SSLMAIL"
							break
						else
							echo "${error} Should we again practice how an e-mail address looks?"
						fi
					done
		fi

		if [ "$USE_VALID_SSL" = "n" ]; then
			USE_VALID_SSL="0"
			echo "${finished} You dont use SSL"
		fi
	# ----------------------------------------------------------------
	read -p "Do you want to Use Mailserver? Please type y or n:" USE_MAILSERVER
		if [ "$USE_MAILSERVER" = "y" ]; then
			USE_MAILSERVER="1"
			echo "${finished} You use Mailserver"
					# -------------------------------
					read -p "Do you want to Use webmail? Please type y or n:" USE_WEBMAIL
					if [ "$USE_WEBMAIL" = "y" ]; then
						USE_WEBMAIL="1"
						echo "${finished} You use Webmail"
					fi

					if [ "$USE_WEBMAIL" = "n" ]; then
						USE_WEBMAIL="0"
						echo "${finished} You dont use Webmail"
					fi
					# -------------------------------
		fi

		if [ "$USE_MAILSERVER" = "n" ]; then
			USE_MAILSERVER="0"
			USE_WEBMAIL="0"
			echo "${finished} You dont use Mailserver"
		fi

	# ----------------------------------------------------------------
	read -p "Do you want to Use PHP5 oder PHP7? Please type 5 or 7 " USE_PHPVERSION
		if [ "$USE_PHPVERSION" = "5" ]; then
			USE_PHP5="1"
			USE_PHP7="0"
			echo "${finished} You use PHP-Version 5"
		fi

		if [ "$USE_PHPVERSION" = "7" ]; then
			USE_PHP7="1"
			USE_PHP5="0"
			echo "${finished} You use PHP-Version 7"
		fi
	# ----------------------------------------------------------------
	read -p "Do you want to Use PHPMyAdmin? Please type y or n:" USE_PMA
		if [ "$USE_PMA" = "y" ]; then
			USE_PMA="1"
			echo "${finished} You use PHPMyAdmin"
					# -------------------------------
					read -p "Do you want to restrict PHPMyAdmin? Please type y or n:" PMA_RESTRICT
					if [ "$PMA_RESTRICT" = "y" ]; then
						PMA_RESTRICT="1"
						echo "${finished} You use restricted pma Login"
					fi

					if [ "$PMA_RESTRICT" = "n" ]; then
						PMA_RESTRICT="0"
						echo "${finished} You dont use restricted pma Login"
					fi
					# -------------------------------
		fi

		if [ "$USE_PMA" = "n" ]; then
			USE_PMA="0"
			echo "${finished} You dont use PHPMyAdmin"
		fi
	# ----------------------------------------------------------------
	read -p "Do you want allow http-connections? Please type y or n:" ALLOWHTTPCONNECTIONS
		if [ "$ALLOWHTTPCONNECTIONS" = "y" ]; then
			ALLOWHTTPCONNECTIONS="1"
			echo "${finished} You allow http-connections"
		fi

		if [ "$ALLOWHTTPCONNECTIONS" = "n" ]; then
			ALLOWHTTPCONNECTIONS="0"
			echo "${finished} You dont allow http-connections"
		fi

	# ----------------------------------------------------------------
	read -p "Please choose an user for HTTP-Auth login:" PMA_HTTPAUTH_USER
	# ----------------------------------------------------------------
	read -p "Please choose an user for MYSQL PHPMyAdmin Login:" MYSQL_PMADB_USER
	# ----------------------------------------------------------------
	read -p "Please choose an user for MYSQL PHPMyAdmin Name:" MYSQL_PMADB_NAME


	# ----------------------------------------------------------------
	if [ "$IAMEXPERT" = "1" ]; then
	# ----------------------------------------------------------------
		read -p "Do you want use Cloudflare? Please type y or n:" CLOUDFLARE
			if [ "$CLOUDFLARE" = "y" ]; then
				CLOUDFLARE="1"
				echo "${finished} You use Cloudflare"
			fi

			if [ "$CLOUDFLARE" = "n" ]; then
				CLOUDFLARE="0"
				echo "${finished} You dont use Cloudflare"
			fi
	# ----------------------------------------------------------------
		if [ "$ALLOWHTTPCONNECTIONS" = "0" ]; then
			read -p "Do you want use HIGH SECURITY? Please type y or n:" HIGH_SECURITY
				if [ "$HIGH_SECURITY" = "y" ]; then
					HIGH_SECURITY="1"
					echo "${finished} You use HIGH SECURITY"
				fi

				if [ "$HIGH_SECURITY" = "n" ]; then
					HIGH_SECURITY="0"
					echo "${finished} You dont use HIGH SECURITY"
				fi

		else
		HIGH_SECURITY="0"
		fi
	# ----------------------------------------------------------------
		read -p "Do you want use Debug Mode? Please type y or n:" DEBUG_IS_SET
			if [ "$DEBUG_IS_SET" = "y" ]; then
				DEBUG_IS_SET="1"
				echo "${finished} You use Debug Mode"
			fi

			if [ "$DEBUG_IS_SET" = "n" ]; then
				DEBUG_IS_SET="0"
				echo "${finished} You dont use Debug Mode"
			fi
	fi

	if [ "$IAMEXPERT" = "0" ]; then
		# If no expert, we set default values
		CLOUDFLARE="0"
		HIGH_SECURITY="0"
		DEBUG_IS_SET="0"
	fi
	# ----------------------------------------------------------------
	NEED_ADDONCONFIG="1"
	read -p "Do You need Addonconfig? Please type y or n:" NEED_ADDONCONFIG
		if [ "$NEED_ADDONCONFIG" = "y" ]; then
			ADDONCONFIG_COMPLETED="0"

		fi

		if [ "$NEED_ADDONCONFIG" = "n" ]; then
			ADDONCONFIG_COMPLETED="1"
			echo "${finished} All is done!"
		fi


# Write Vars to Config file:

rm -rf ~/configs/userconfig.cfg
cat >> ~/configs/userconfig.cfg <<END
#-----------------------------------------------------------#
############### Config File from Confighelper ###############
#-----------------------------------------------------------#
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


confighelper_addonconfig() {
echo "Start Confighelper for Addonconfig"


	# ----------------------------------------------------------------
	read -p "Do you want to Add a new Site? Please type y or n:" ADD_NEW_SITE
	if [ "$ADD_NEW_SITE" = "y" ]; then
			ADD_NEW_SITE="1"
			echo "${finished} You want to add a new Site."
				# --------------------------------
				read -p "Please Type your Domain without http://www.:" MYOTHERDOMAIN
				echo "${finished} Your second Domain is: $MYOTHERDOMAIN"
	fi

	if [ "$ADD_NEW_SITE" = "n" ]; then
			MYOTHERDOMAIN="0"
			echo "${finished} You dont add a new site"
	fi

	# ----------------------------------------------------------------
	read -p "Do you want to disable root Login? Please type y or n:" DISABLE_ROOT_LOGIN
	if [ "$DISABLE_ROOT_LOGIN" = "y" ]; then
			DISABLE_ROOT_LOGIN="1"
			echo "${finished} You want to disable root login."
				# --------------------------------
				read -p "Please Type your new SSH User:" SSHUSER
				echo "${finished} Your new SSH USer is: $SSHUSER"
	fi

	if [ "$DISABLE_ROOT_LOGIN" = "n" ]; then
			DISABLE_ROOT_LOGIN="0"
			echo "${finished} You dont disable root Login. Your User to login is: root"
	fi

	# ----------------------------------------------------------------
	read -p "Do you want use TeamSpeak? Please type y or n:" USE_TEAMSPEAK
	if [ "$USE_TEAMSPEAK" = "y" ]; then
			USE_TEAMSPEAK="1"
			echo "${finished} You install Teamspeack."
	fi

	if [ "$USE_TEAMSPEAK" = "n" ]; then
			USE_TEAMSPEAK="0"
			echo "${finished} You dont use Teamspeak"
	fi

	# ----------------------------------------------------------------
	read -p "Do you want use Minecraft? Please type y or n:" USE_MINECRAFT
	if [ "$USE_MINECRAFT" = "y" ]; then
			USE_MINECRAFT="1"
			echo "${finished} You install Minecraft."
	fi

	if [ "$USE_MINECRAFT" = "n" ]; then
			USE_MINECRAFT="0"
			echo "${finished} You dont use Minecraft"
	fi

	# ----------------------------------------------------------------

	if [ "$USE_VALID_SSL" = "1" ]; then
		read -p "Do you want use Ajenti? Please type y or n:" USE_AJENTI
			if [ "$USE_AJENTI" = "y" ]; then
			USE_AJENTI="1"
			echo "${finished} You install Ajenti."
		fi

		if [ "$USE_AJENTI" = "n" ]; then
				USE_AJENTI="0"
				echo "${finished} You dont use Ajenti"
		fi

	fi

	# ----------------------------------------------------------------
	read -p "Do you want use Piwik? Please type y or n:" USE_PIWIK
	if [ "$USE_PIWIK" = "y" ]; then
			USE_PIWIK="1"
			echo "${finished} You install Piwik."
	fi

	if [ "$USE_PIWIK" = "n" ]; then
			USE_PIWIK="0"
			echo "${finished} You dont use Piwik"
	fi

	# ----------------------------------------------------------------
	read -p "Do you want use VSFTPd? Please type y or n:" USE_VSFTPD
	if [ "$USE_VSFTPD" = "y" ]; then
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
	fi

	if [ "$USE_VSFTPD" = "n" ]; then
			USE_VSFTPD="0"
			echo "${finished} You dont use VSFTPd"
	fi
	# ----------------------------------------------------------------
	read -p "Do you want use OPENVPN? Please type y or n:" USE_OPENVPN
	if [ "$USE_OPENVPN" = "y" ]; then
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
					echo "${error} Should we again practice how an e-mail address looks?"
				fi
			done

			read -p "Please type your COUNTRY. Example: DE for Germany:" KEY_COUNTRY
			read -p "Please type your PROVINCE. Example: Hessen:" KEY_PROVINCE
			read -p "Please type your CITY. Example: Frankfurt:" KEY_CITY

	fi

	if [ "$USE_OPENVPN" = "n" ]; then
		USE_OPENVPN="0"
		echo "${finished} You dont use OPENVPN"
	fi
	# ----------------------------------------------------------------
	# NOT READY!
	# DO NOT USE PRESTASHOP!
	# ---------------------------------------------------------------#
		#read -p "Do you want use Prestashop E-Commerce System? Please type y or n:" USE_PRESTASHOP
		USE_PRESTASHOP="n"
	if [ "$USE_PRESTASHOP" = "y" ]; then
		USE_PRESTASHOP="1"
		echo "${finished} You use Prestashop E-Commerce System"
			# --------------------------------
			PRESTASHOP_VERSION="1.6.1.12"
			PRESTASHOPDOMAIN="domain.tld"
			PRESTASHOP_OWNER_FIRSTNAME="Perfect"
			PRESTASHOP_OWNER_LASTNAME="Rootserver"
			PRESTASHOP_OWNER_EMAIL="prestashop@perfectrootserver.de"
			PRESTASHOPS_NAME="perfectrootserver script"
			PRESTASHOP_INSTALL_FOLDER_NAME="CHANGEME"
			PRESTASHOP_LANGUAGE="de"
			PRESTASHOP_COUNTRY="de"

			PRESTASHOP_DB_SERVER="localhost"


			PRESTASHOP_TIMEZONE="berlin"
			PRESTASHOP_DB_CLEAR="1"
			PRESTASHOP_CRYPT_PRF="${PRESTASHOP_CRYPT_PRF}"
			PRESTASHOP_DB_NAME="${PRESTASHOP_DB_NAME}"
			PRESTASHOP_CREATE_DB="1"
			PRESTASHOP_SHOW_LICENSE="0"
			PRESTASHOP_NEWSLETTER="1"
			PRESTASHOP_SEND_EMAIL="1"



			# --------------------------------
			read -p "Do you want clear DB? Please type y or n:" PRESTASHOP_DB_CLEAR
			if [ "$PRESTASHOP_DB_CLEAR" = "y" ]; then
				PRESTASHOP_DB_CLEAR="1"
				echo "${finished} Deleting the database"
			fi

			if [ "$PRESTASHOP_DB_CLEAR" = "n" ]; then
				PRESTASHOP_DB_CLEAR="0"
				echo "${finished} Deleting no database"
			fi

			# --------------------------------
			# Todo
			# Check var after installation!
			select choosetimezone in $timezones; do
				if [ "$choosetimezone" = "Europe/Berlin" ]; then
				PRESTASHOP_TIMEZONE="$choosetimezone"
					break;
				fi

				if [ "$choosetimezone" = "America/New_York" ]; then
				PRESTASHOP_TIMEZONE="$choosetimezone"
					break;
				fi
			done
			echo "${finished} Your Timezone is $choosetimezone"


			# --------------------------------
			# Todo
			# Add function to check prf
			PRESTASHOP_DB_ENGINE="
			InnoDB
			MyISAM
			"
			read -p "Please choose an Praefix:" PRESTASHOP_CRYPT_PRF
			echo "${finished} Your new DB Praefix is $PRESTASHOP_CRYPT_PRF"

			# --------------------------------
			echo "Please choose an DB engine"
			select chooseengine in $PRESTASHOP_DB_ENGINE; do
				if [ "$chooseengine" = "Europe/Berlin" ]; then
					break;
				fi

				if [ "$chooseengine" = "America/New_York" ]; then
					break;
				fi
			done
			echo "${finished} Your Timezone is $chooseengine"

			# --------------------------------
			read -p "Do you want create an Database (It is recommended)? Please type y or n:" PRESTASHOP_CREATE_DB
			if [ "$PRESTASHOP_CREATE_DB" = "y" ]; then
				PRESTASHOP_CREATE_DB="1"
				echo "${finished} You create an new Database."
					# --------------------------------
					read -p "Please type your DB name. Please type y or n:" PRESTASHOP_DB_NAME
			fi

			if [ "$PRESTASHOP_CREATE_DB" = "n" ]; then
				PRESTASHOP_CREATE_DB="0"
				echo "${finished} You dont create an new Database."
			fi

			# --------------------------------
			read -p "Do you want to show the license from Prestashops E-Commerce System? Please type y or n:" PRESTASHOP_SHOW_LICENSE
			if [ "$PRESTASHOP_SHOW_LICENSE" = "y" ]; then
				PRESTASHOP_SHOW_LICENSE="1"
				echo "${finished} You see the license"
			fi

			if [ "$PRESTASHOP_SHOW_LICENSE" = "n" ]; then
				PRESTASHOP_SHOW_LICENSE="0"
				echo "${finished} You dont see the license"
			fi

			# --------------------------------
			read -p "Du you want subscribe your own Newsletter? Please type y or n:" PRESTASHOP_NEWSLETTER
			if [ "$PRESTASHOP_NEWSLETTER" = "y" ]; then
				PRESTASHOP_NEWSLETTER="1"
				echo "${finished} You subscribe your Newsletter"
			fi

			if [ "$PRESTASHOP_NEWSLETTER" = "n" ]; then
				PRESTASHOP_NEWSLETTER="0"
				echo "${finished} You dont subscribe your Newsletter"
			fi

			# --------------------------------
			read -p "Do you wish an E-Mail after Setup? Please type y or n:" PRESTASHOP_SEND_EMAIL
			if [ "$PRESTASHOP_SEND_EMAIL" = "y" ]; then
				PRESTASHOP_SEND_EMAIL="1"
				echo "${finished} You become an E-Mail after installation"
			fi

			if [ "$PRESTASHOP_SEND_EMAIL" = "n" ]; then
				PRESTASHOP_SEND_EMAIL="0"
				echo "${finished} You become no E-Mail after installation"
			fi
			# --------------------------------

	fi

	if [ "$USE_PRESTASHOP" = "n" ]; then
		USE_PRESTASHOP="0"
		echo "${finished} You dont use Prestashop E-Commerce System"
	fi

# Write Vars to Config file:

rm -rf ~/configs/addonconfig.cfg
cat >> ~/configs/addonconfig.cfg <<END
#-----------------------------------------------------------#
############### Config File from Confighelper ###############
#-----------------------------------------------------------#
ADDONCONFIG_COMPLETED="${CONFIG_COMPLETED}"
ADD_NEW_SITE="${ADD_NEW_SITE}"
MYOTHERDOMAIN="${MYOTHERDOMAIN}"
DISABLE_ROOT_LOGIN="${DISABLE_ROOT_LOGIN}"
SSHUSER="${SSHUSER}"
USE_TEAMSPEAK="${USE_TEAMSPEAK}"
USE_MINECRAFT="${USE_MINECRAFT}"
USE_AJENTI="${USE_AJENTI}"
AJENTI_PASS="generatepw"
USE_PIWIK="${USE_PIWIK}"
USE_VSFTPD="${USE_VSFTPD}"
FTP_USERNAME="${FTP_USERNAME}"
USE_OPENVPN="${USE_OPENVPN}"
KEY_COUNTRY="${KEY_COUNTRY}"
KEY_PROVINCE="${KEY_PROVINCE}"
KEY_CITY="${KEY_CITY}"
KEY_EMAIL="${KEY_EMAIL}"
SERVER_IP="${SERVER_IP}"
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

confighelper() {
#Run functions
confighelper_installs
confighelper_generate_passwords
confighelper_userconfig
if [ "$ADDONCONFIG_COMPLETED" = "0" ]; then
	confighelper_addonconfig
fi
}

source ~/configs/userconfig.cfg
source ~/configs/addonconfig.cfg
