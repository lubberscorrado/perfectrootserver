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

addonlogininformation() {

touch ~/addoninformation.txt
echo "///////////////////////////////////////////////////////////////////////////" >> ~/addoninformation.txt
echo "// Passwords, Usernames, Databases" >> ~/addoninformation.txt
echo "///////////////////////////////////////////////////////////////////////////" >> ~/addoninformation.txt
echo "" >> ~/addoninformation.txt
echo "_______________________________________________________________________________________" >> ~/addoninformation.txt
}

logininformation() {
touch ~/credentials.txt
echo "///////////////////////////////////////////////////////////////////////////" >> ~/credentials.txt
echo "// Passwords, Usernames, Databases" >> ~/credentials.txt
echo "///////////////////////////////////////////////////////////////////////////" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "_______________________________________________________________________________________" >> ~/credentials.txt
echo "### MYSQL & WEB" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "--------------------------------------------" >> ~/credentials.txt
echo "MySQL root" >> ~/credentials.txt
echo "--------------------------------------------" >> ~/credentials.txt
echo "hostname = ${MYSQL_HOSTNAME}" >> ~/credentials.txt
echo "username = root" >> ~/credentials.txt
echo "password = ${MYSQL_ROOT_PASS}" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "" >> ~/credentials.txt
if [ ${USE_MAILSERVER} == '1' ]; then
		if [ ${USE_WEBMAIL} == '1' ]; then
			echo "--------------------------------------------" >> ~/credentials.txt
			echo "roundcube database" >> ~/credentials.txt
			echo "--------------------------------------------" >> ~/credentials.txt
			echo "database = roundcube" >> ~/credentials.txt
			echo "username = roundcube" >> ~/credentials.txt
			echo "password = ${ROUNDCUBE_MYSQL_PASS}" >> ~/credentials.txt
			echo "" >> ~/credentials.txt
			echo "" >> ~/credentials.txt
		fi
fi
if [ ${USE_PMA} == '1' ]; then
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "phpMyAdmin database" >> ~/credentials.txt
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "database = ${MYSQL_PMADB_NAME}" >> ~/credentials.txt
	echo "username = ${MYSQL_PMADB_USER}" >> ~/credentials.txt
	echo "password = ${MYSQL_PMADB_PASS}" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "phpMyAdmin web" >> ~/credentials.txt
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "username = ${PMA_HTTPAUTH_USER}" >> ~/credentials.txt
	echo "password = ${PMA_HTTPAUTH_PASS}" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
	echo "blowfish = ${PMA_BFSECURE_PASS}" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
fi
echo "_______________________________________________________________________________________" >> ~/credentials.txt
echo "## SSH" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "port       = ${SSH_PORT}" >> ~/credentials.txt
echo "password   = ${SSH_PASS}" >> ~/credentials.txt
echo "privatekey = check /root/ssh_privatekey.txt" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "_______________________________________________________________________________________" >> ~/credentials.txt
echo "## URLs" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "--------------------------------------------" >> ~/credentials.txt
echo "your domain" >> ~/credentials.txt
echo "--------------------------------------------" >> ~/credentials.txt
echo "https://${MYDOMAIN}" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "" >> ~/credentials.txt
if [ ${USE_MAILSERVER} == '1' ]; then
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "Vimbadmin " >> ~/credentials.txt
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "https://${MYDOMAIN}/vma" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
	if [ ${USE_WEBMAIL} == '1' ]; then
		echo "--------------------------------------------" >> ~/credentials.txt
		echo "roundcube (webmail)" >> ~/credentials.txt
		echo "--------------------------------------------" >> ~/credentials.txt
		echo "https://${MYDOMAIN}/webmail" >> ~/credentials.txt
		echo "" >> ~/credentials.txt
		echo "" >> ~/credentials.txt
	fi
fi
if [ ${USE_PMA} == '1' ]; then
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "phpMyAdmin" >> ~/credentials.txt
	echo "--------------------------------------------" >> ~/credentials.txt
	echo "https://${MYDOMAIN}/pma" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
	echo "" >> ~/credentials.txt
fi
echo "_______________________________________________________________________________________" >> ~/credentials.txt
echo "## SYSTEM INFORMATION" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "--------------------------------------------" >> ~/credentials.txt
echo "open ports" >> ~/credentials.txt
echo "--------------------------------------------" >> ~/credentials.txt
if [ ${USE_MAILSERVER} == '1' ]; then
		echo "TCP = 25 (SMTP), 80 (HTTP), 110 (POP3), 143(IMAP), 443 (HTTPS), 465 (SMPTS)" >> ~/credentials.txt 
		echo "TCP = 587 (Submission), 993 (IMAPS), 995 (POP3S), ${SSH_PORT} (SSH)" >> ~/credentials.txt
		echo "UDP = All ports are closed" >> ~/credentials.txt
		echo "" >> ~/credentials.txt
		echo "" >> ~/credentials.txt
else
		echo "TCP = 80 (HTTP), 443 (HTTPS), ${SSH_PORT} (SSH)" >> ~/credentials.txt
		echo "UDP = All ports are closed" >> ~/credentials.txt
		echo "" >> ~/credentials.txt
		echo "" >> ~/credentials.txt
fi

echo "You can add additional ports, just edit \"/etc/arno-iptables-firewall/firewall.conf\" (lines 1241 & 1242)" >> ~/credentials.txt
echo "and restart your firewall -> \"systemctl force-reload arno-iptables-firewall\"" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "" >> ~/credentials.txt
echo "_______________________________________________________________________________________" >> ~/credentials.txt
echo "${ok} Done! The credentials are located in the file $(textb ~/root/credentials.txt)!" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
echo "${ok} Done! The add on credentials are located in the file $(textb ~/root/addoninformation.txt)!" | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
}
source ~/configs/userconfig.cfg
