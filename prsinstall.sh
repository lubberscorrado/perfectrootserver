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
source script/confighelper.sh
source script/addonconfighelper.sh


source script/checksystem.sh
source script/logininformation.sh
source script/instructions.sh

source script/bash.sh
source script/system.sh
source script/mariadb.sh

if [[ ${USE_PHP7} = '1' ]]; then
		source script/php7.sh
fi

if [[ ${USE_PHP71} = '1' ]]; then
		source script/php71.sh
fi

source script/ssl.sh
source script/ssh.sh
source script/publickey.sh
source script/nginx.sh
source script/fail2ban.sh
source script/phpmyadmin.sh

source script/dovecot.sh
source script/postfix.sh
source script/mailfilter.sh
source script/roundcube.sh
source script/vimbadmin.sh

source script/firewall.sh

#source script/finischer.sh

# Addons
 source addons/ajenti.sh
 source addons/teamspeak3.sh
 source addons/minecraft.sh
 source addons/vsftpdinstall.sh
 source addons/prestashopinstall.sh
 source addons/piwik.sh


# source addons/openvpn.sh
# source addons/disablelogin.sh
# source addons/addnewsite.sh
# source addons/addnewmysqluser.sh

# Start Installation
#----------------------------------------------------
functionsprs
#Alpha!
prerequisites

confighelper_generate_passwords

confighelper_userconfig

if [[ ${ADDONCONFIG_COMPLETED} == "0" ]]; then
confighelper_addonconfig
fi

setipaddrvars

echo "0" | dialog --gauge "Checking your system..." 10 70 0
checksystem
echo "05" | dialog --gauge "Installing prerequisites... Some of the tasks could take a long time, please be patient!" 10 70 0
system
echo "15" | dialog --gauge "Installing MariaDB..." 10 70 0
mariadb
echo "20" | dialog --gauge "Installing Bash..." 10 70 0
bashinstall
echo "25" | dialog --gauge "Installing SSL..." 10 70 0
ssl
echo "30" | dialog --gauge "Installing SSH..." 10 70 0
ssh
echo "35" | dialog --gauge "Installing Nginx..." 10 70 0
nginx
echo "55" | dialog --gauge "Installing PHP..." 10 70 0

if [[ ${USE_PHP7} = '1' ]]; then
		php7
fi

if [[ ${USE_PHP71} = '1' ]]; then
		php71
fi

echo "65" | dialog --gauge "Installing Dovecot..." 10 70 0
dovecot
echo "70" | dialog --gauge "Installing Postfix..." 10 70 0
postfix
echo "72" | dialog --gauge "Installing Mailfilter..." 10 70 0
mailfilter
echo "75" | dialog --gauge "Installing Roundcube..." 10 70 0
roundcube
echo "80" | dialog --gauge "Installing Vimbadmin..." 10 70 0
vimbadmin
echo "85" | dialog --gauge "Installing Firewall..." 10 70 0

# Special harding
#policydweight

firewall
echo "87" | dialog --gauge "Installing Fail2ban..." 10 70 0
fail2ban
echo "90" | dialog --gauge "Installing PHPmyadmin..." 10 70 0
phpmyadmin
echo "98" | dialog --gauge "Creating Publickey..." 10 70 0
publickey
echo "100" | dialog --gauge "Perfect Root Server Installation finished!" 10 70 0


# Addon functions
addonlogininformation
ajenti
teamspeak3
minecraft
#vsftpd

# untestet
#prestashopinstall
#piwikinstall

#openvpn
#disablelogin
#addnewsite
#finischer


# Only at End!
logininformation
instructions
