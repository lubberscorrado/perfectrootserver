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


confighelper_userconfig() {
cho "${info} Start confighelper for Userconfig" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'

# Small function...
CHECK_E_MAIL="^[a-z0-9!#\$%&'*+/=?^_\`{|}~-]+(\.[a-z0-9!#$%&'*+/=?^_\`{|}~-]+)*@([a-z0-9]([a-z0-9-]*[a-z0-9])?\.)+[a-z0-9]([a-z0-9-]*[a-z0-9])?\$"
	#Userconfig
	CONFIG_COMPLETED="0"
	TIMEZONE="Europe/Berlin"
	MYDOMAIN="domain.tld"
	USE_VALID_SSL="1"
	SSLMAIL="user@yourEmail.tld"
	USE_MAILSERVER="1"
	USE_WEBMAIL="1"
	USE_PHP5="0"
	USE_PHP7="1"
	USE_PMA="1"
	PMA_RESTRICT="0"
	SSH_PORT="generateport"
	SSH_PASS="generatepw"
	ALLOWHTTPCONNECTIONS="0"
	CLOUDFLARE="0"
	HIGH_SECURITY="0"
	DEBUG_IS_SET="0"
	POSTFIX_ADMIN_PASS="generatepw"
	VIMB_MYSQL_PASS="generatepw"
	ROUNDCUBE_MYSQL_PASS="generatepw"
	PMA_HTTPAUTH_USER="httpauth"
	PMA_HTTPAUTH_PASS="generatepw"
	PMA_BFSECURE_PASS="generatepw"
	MYSQL_ROOT_PASS="generatepw"
	MYSQL_PMADB_NAME="phpmyadmin"
	MYSQL_PMADB_USER="phpmyadmin"
	MYSQL_PMADB_PASS="generatepw"
	MYSQL_HOSTNAME="localhost"
	IAMEXPERT="0"

	read -p "Are you an expert? Please type y or n:" IAMEXPERT
		if [ "$IAMEXPERT" = "y" ]; then
			IAMEXPERT="1"
			echo "[Finishd] You are an Expert!"
		fi

		if [ "$IAMEXPERT" = "n" ]; then
			IAMEXPERT="0"
			echo "[Finishd] You are normal user"
		fi


	# --------------------------------
	timezones="
	Europe/Berlin
	America/New_York
	"
	select choosetimezone in $timezones; do
		if [ "$choosetimezone" = "Europe/Berlin" ]; then
			break;
		fi

		if [ "$choosetimezone" = "America/New_York" ]; then
			break;
		fi
	done
	echo "[Finishd] Your Timezone is $choosetimezone"
	# --------------------------------

	read -p "Enter your Domain without http://:" MYDOMAIN
	echo "[Finishd] Your Domain is $MYDOMAIN"

	# --------------------------------
	read -p "Do you want to Use SSL? Please type y or n:" USE_VALID_SSL
		if [ "$USE_VALID_SSL" = "y" ]; then
			USE_VALID_SSL="1"
			echo "[Finishd] You use SSL"

				# --------------------------------
					while true
					do
						read -p "Enter your valid E-Mail address: " SSLMAIL
						if [[ "$SSLMAIL" =~ $CHECK_E_MAIL ]];then
							echo "[Finishd] Your E-Mail address is $SSLMAIL"
							break
						else
							echo "[ERROR] Should we again practice how an e-mail address looks?"
						fi
					done
		fi

		if [ "$USE_VALID_SSL" = "n" ]; then
			USE_VALID_SSL="0"
			echo "[Finishd] You dont use SSL"
		fi
	# --------------------------------
	read -p "Do you want to Use Mailserver? Please type y or n:" USE_MAILSERVER
		if [ "$USE_MAILSERVER" = "y" ]; then
			USE_MAILSERVER="1"
			echo "[Finishd] You use Mailserver"
					# -------------------------------
					read -p "Do you want to Use webmail? Please type y or n:" USE_WEBMAIL
					if [ "$USE_WEBMAIL" = "y" ]; then
						USE_WEBMAIL="1"
						echo "[Finishd] You use Webmail"
					fi

					if [ "$USE_WEBMAIL" = "n" ]; then
						USE_WEBMAIL="0"
						echo "[Finishd] You dont use Webmail"
					fi
					# -------------------------------
		fi

		if [ "$USE_MAILSERVER" = "n" ]; then
			USE_MAILSERVER="0"
			echo "[Finishd] You dont use Mailserver"
		fi

	# --------------------------------
	read -p "Do you want to Use PHP5 oder PHP7? Please type 5 or 7 " USE_PHPVERSION
		if [ "$USE_PHPVERSION" = "5" ]; then
			USE_PHP5="1"
			USE_PHP7="0"
			echo "[Finishd] You use PHP-Version 5"
		fi

		if [ "$USE_PHPVERSION" = "7" ]; then
			USE_PHP7="1"
			USE_PHP5="0"
			echo "[Finishd] You use PHP-Version 7"
		fi
	# --------------------------------
	read -p "Do you want to Use PHPMyAdmin? Please type y or n:" USE_PMA
		if [ "$USE_PMA" = "y" ]; then
			USE_PMA="1"
			echo "[Finishd] You use PHPMyAdmin"
					# -------------------------------
					read -p "Do you want to restrict PHPMyAdmin? Please type y or n:" PMA_RESTRICT
					if [ "$PMA_RESTRICT" = "y" ]; then
						PMA_RESTRICT="1"
						echo "[Finishd] You use restricted pma Login"
					fi

					if [ "$PMA_RESTRICT" = "n" ]; then
						PMA_RESTRICT="0"
						echo "[Finishd] You dont use restricted pma Login"
					fi
					# -------------------------------
		fi

		if [ "$USE_PMA" = "n" ]; then
			USE_PMA="0"
			echo "[Finishd] You dont use PHPMyAdmin"
		fi
	# --------------------------------
	read -p "Do you want allow http-connections? Please type y or n:" ALLOWHTTPCONNECTIONS
		if [ "$ALLOWHTTPCONNECTIONS" = "y" ]; then
			ALLOWHTTPCONNECTIONS="1"
			echo "[Finishd] You allow http-connections"
		fi

		if [ "$ALLOWHTTPCONNECTIONS" = "n" ]; then
			ALLOWHTTPCONNECTIONS="0"
			echo "[Finishd] You dont allow http-connections"
		fi

	# --------------------------------
	read -p "Please choose an user for HTTP-Auth login:" PMA_HTTPAUTH_USER
	# --------------------------------
	read -p "Please choose an user for MYSQL PHPMyAdmin Login:" MYSQL_PMADB_USER
	# --------------------------------
	read -p "Please choose an user for MYSQL PHPMyAdmin Name:" MYSQL_PMADB_NAME


	# --------------------------------
	if [ "$IAMEXPERT" = "1" ]; then
		# --------------------------------
		read -p "Do you want use Cloudflare? Please type y or n:" CLOUDFLARE
			if [ "$CLOUDFLARE" = "y" ]; then
				CLOUDFLARE="1"
				echo "[Finishd] You use Cloudflare"
			fi

			if [ "$CLOUDFLARE" = "n" ]; then
				CLOUDFLARE="0"
				echo "[Finishd] You dont use Cloudflare"
			fi
		# --------------------------------
		read -p "Do you want use HIGH SECURITY? Please type y or n:" HIGH_SECURITY
			if [ "$HIGH_SECURITY" = "y" ]; then
				HIGH_SECURITY="1"
				echo "[Finishd] You use HIGH SECURITY"
			fi

			if [ "$HIGH_SECURITY" = "n" ]; then
				HIGH_SECURITY="0"
				echo "[Finishd] You dont use HIGH SECURITY"
			fi
		# --------------------------------
		read -p "Do you want use Debug Mode? Please type y or n:" DEBUG_IS_SET
			if [ "$DEBUG_IS_SET" = "y" ]; then
				DEBUG_IS_SET="1"
				echo "[Finishd] You use Debug Mode"
			fi

			if [ "$DEBUG_IS_SET" = "n" ]; then
				DEBUG_IS_SET="0"
				echo "[Finishd] You dont use Debug Mode"
			fi
	fi
	# --------------------------------
	NEED_ADDONCONFIG="1"
	read -p "Do You need Addonconfig? Please type y or n:" NEED_ADDONCONFIG
		if [ "$NEED_ADDONCONFIG" = "y" ]; then
			NEED_ADDONCONFIG="1"

		fi

		if [ "$NEED_ADDONCONFIG" = "n" ]; then
			NEED_ADDONCONFIG="0"
			echo "[Finishd] All is done!"
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
	POSTFIX_ADMIN_PASS="generatepw"
	VIMB_MYSQL_PASS="generatepw"
	ROUNDCUBE_MYSQL_PASS="generatepw"
	PMA_HTTPAUTH_PASS="generatepw"
	PMA_BFSECURE_PASS="generatepw"
	MYSQL_ROOT_PASS="generatepw"
	MYSQL_PMADB_PASS="generatepw"
	MYSQL_HOSTNAME="localhost"
#-----------------------------------------------------------#
############### Config File from Confighelper ###############
#-----------------------------------------------------------#
END



} # END confighelper_userconfig


confighelper_addonconfig() {
echo "Start Confighelper for Addonconfig"
echo "soon as possible"


}


confighelper() {
#Run functions
confighelper_userconfig
confighelper_addonconfig

}
