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

# ---------------------------------------------------------------------------------------- #
########################### Roundcube Version
# ---------------------------------------------------------------------------------------- #
# Version from 28 April 2017
ROUNDCUBE_VERSION="1.2.5"

# ---------------------------------------------------------------------------------------- #
########################### SYSTEM UPDATE 
# ---------------------------------------------------------------------------------------- #
SYSTEM_UPDATE="1"

# ---------------------------------------------------------------------------------------- #
########################### Cert without mail UPDATE 
# ---------------------------------------------------------------------------------------- #
CERT_ONLY_UPDATE="0"

# ---------------------------------------------------------------------------------------- #
########################### Cert With Mail UPDATE 
# ---------------------------------------------------------------------------------------- #
CERT_UPDATE_MAIL="1"

# Enter your domain without a subdomain (www)
# --------------------------------
MYDOMAIN="perfectrootserver.de"

# Leave blank if you have only one Domain!
MYDOMAIN_TWO=""

MYEMAIL="yourE-Mail@address.de"

# ---------------------------------------------------------------------------------------- #
########################### UPDATE ROUNDCUBE
# ---------------------------------------------------------------------------------------- #
ROUNDCUBE_UPDATE="1"

# ---------------------------------------------------------------------------------------- #
########################### READY?
# ---------------------------------------------------------------------------------------- #
CONFIG_COMPLETED="1"



#################################
##  DO NOT MODIFY, JUST DON'T! ##
#################################

# Some nice colors
cyan() { echo "$(tput setaf 6)$*$(tput setaf 9)"; }
textb() { echo $(tput bold)${1}$(tput sgr0); }
greenb() { echo $(tput bold)$(tput setaf 2)${1}$(tput sgr0); }
redb() { echo $(tput bold)$(tput setaf 1)${1}$(tput sgr0); }
yellowb() { echo $(tput bold)$(tput setaf 3)${1}$(tput sgr0); }
pinkb() { echo $(tput bold)$(tput setaf 5)${1}$(tput sgr0); }

# Some nice variables
info="$(textb [INFO] -)"
warn="$(yellowb [WARN] -)"
error="$(redb [ERROR] -)"
fyi="$(pinkb [INFO] -)"
ok="$(greenb [OKAY] -)"

echo
echo "$(yellowb +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+)"
echo " $(textb Perfect) $(textb Rootserver) $(textb Update) $(textb by)" "$(cyan REtender / BoBBeer)"
echo "$(yellowb +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+)"
echo

# ---------------------------------------------------------------------------------------- #
########################### READY TO GO?
# ---------------------------------------------------------------------------------------- #
if [ $CONFIG_COMPLETED != '1' ]; then
	echo "${error} Please check the updateconfig and set a valid value for the variable \"$(textb CONFIG_COMPLETED)\" to continue." | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
	exit 1
fi

# ---------------------------------------------------------------------------------------- #
########################### ARE YOU Admin?
# ---------------------------------------------------------------------------------------- #
if [[ $EUID -ne 0 ]]; then
   echo "${error} This script must be run as root User" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
   exit 1
fi

# ---------------------------------------------------------------------------------------- #
########################### Check if CERT_ONLY_UPDATE and CERT_UPDATE_MAIL are both activated
# ---------------------------------------------------------------------------------------- #
if [ $CERT_UPDATE_MAIL == '1' ] && [ $CERT_ONLY_UPDATE == '1' ]; then
	echo "${error} CERT_UPDATE and CERT_UPDATE_MAIL are both activated, please check the config!" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
	exit 1
fi

# ---------------------------------------------------------------------------------------- #
########################### SYSTEM UPDATE 
# ---------------------------------------------------------------------------------------- #
if [ $SYSTEM_UPDATE = '1' ]; then
	echo "${info} Update System" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
	apt-get update -y  >/dev/null 2>&1
	apt-get upgrade -y >/dev/null 2>&1
	echo "${ok} Finished: System Update" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
fi

# ---------------------------------------------------------------------------------------- #
########################### Cert with mail UPDATE 
# ---------------------------------------------------------------------------------------- #
if [ $CERT_UPDATE_MAIL == '1' ] && [ $CERT_ONLY_UPDATE == '0' ]; then
	echo "${info} Update your SSL Certificate with Mailserver" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
	systemctl -q stop nginx.service >/dev/null 2>&1
	cd ~/sources/letsencrypt >/dev/null 2>&1
	
	#mail 1
	./letsencrypt-auto --agree-tos --renew-by-default --standalone --email ${MYEMAIL} --rsa-key-size 4096 -d ${MYDOMAIN} -d www.${MYDOMAIN} -d mail.${MYDOMAIN} -d autodiscover.${MYDOMAIN} -d autoconfig.${MYDOMAIN} -d dav.${MYDOMAIN} certonly >/dev/null 2>&1
	
	#mail 2
	if [ ! -z $MYDOMAIN_TWO ]; then
		./letsencrypt-auto --agree-tos --renew-by-default --standalone --email ${MYEMAIL} --rsa-key-size 4096 -d ${MYDOMAIN_TWO} -d www.${MYDOMAIN_TWO} -d mail.${MYDOMAIN_TWO} -d autodiscover.${MYDOMAIN_TWO} -d autoconfig.${MYDOMAIN_TWO} -d dav.${MYDOMAIN_TWO} certonly >/dev/null 2>&1
	fi	
	systemctl -q start nginx.service >/dev/null 2>&1
	echo "${ok} Finished: Update Certificate without mail Server" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'	
fi

# ---------------------------------------------------------------------------------------- #
########################### Cert Without Mail UPDATE 
# ---------------------------------------------------------------------------------------- #
if [ $CERT_ONLY_UPDATE == '1' ] && [ $CERT_UPDATE_MAIL == '0' ]; then
	echo "${info} Update your SSL Certificate" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
	systemctl -q stop nginx.service >/dev/null 2>&1
	cd ~/sources/letsencrypt >/dev/null 2>&1
	
	#Mail 1
	./letsencrypt-auto --agree-tos --renew-by-default --standalone --email ${MYEMAIL} --rsa-key-size 4096 -d ${MYDOMAIN} -d www.${MYDOMAIN} certonly >/dev/null 2>&1
	#Mail 2
	if [ ! -z $MYDOMAIN_TWO ]; then
	./letsencrypt-auto --agree-tos --renew-by-default --standalone --email ${MYEMAIL} --rsa-key-size 4096 -d ${MYDOMAIN_TWO} -d www.${MYDOMAIN_TWO} certonly >/dev/null 2>&1
	fi
	systemctl -q start nginx.service >/dev/null 2>&1
	echo "${ok} Finished: Update Certificate with mail Server" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
fi

# ---------------------------------------------------------------------------------------- #
########################### UPDATE ROUNDCUBE
# ---------------------------------------------------------------------------------------- #
if [ $ROUNDCUBE_UPDATE = '1' ]; then
	echo "${info} Update Roundcube" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
	cd ~/sources >/dev/null 2>&1
	wget https://github.com/roundcube/roundcubemail/releases/download/${ROUNDCUBE_VERSION}/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz >/dev/null 2>&1
	tar xfvz roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz >/dev/null 2>&1
	cd roundcubemail-${ROUNDCUBE_VERSION} >/dev/null 2>&1
	yes | bin/installto.sh /var/www/mail/rc >/dev/null 2>&1
	rm -r /root/roundcubemail-${ROUNDCUBE_VERSION}/  >/dev/null 2>&1
	rm -f /root/roundcubemail-${ROUNDCUBE_VERSION}-complete.tar.gz/ >/dev/null 2>&1
	echo "${ok} Finished: Roundcube Update" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
fi

echo "${ok} All is done, bye dude!" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
