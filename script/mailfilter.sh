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

mailfilter() {
if [ ${USE_MAILSERVER} == '1' ]; then
echo "${info} Installing Mailfilter..." | awk '{ print strftime("[%H:%M:%S] |"), $0 }'
apt-get install -y libdbd-mysql-perl 

DEBIAN_FRONTEND=noninteractive apt-get -y install rar unrar arj zip bzip2 gzip cpio file lzop nomarch cabextract ripole rpm pax p7zip zoo ncompress >>"$main_log" 2>>"$err_log"
DEBIAN_FRONTEND=noninteractive apt-get -y install amavisd-new clamav-daemon spamassassin >>"$main_log" 2>>"$err_log"


cat >> /etc/amavis/conf.d/50-user << 'EOF1'
use strict;

# Maximale Anzahl an Prozessen, die Amavis vorh�lt.
# Siehe auch Anmerkung in master.cf im Listener f�r Reinjection
$max_servers = 5;

@lookup_sql_dsn = (
    ['DBI:mysql:database=vimbadmin;host=127.0.0.1;port=3306',
     'vimbadmin',
     'changeme']);

# Hierdurch ermittelt Amavis die lokalen Dom�nen
$sql_select_policy = 'SELECT domain FROM domain WHERE CONCAT("@",domain) IN (%k)';

# Ein Listener f�r die Herkunft "external" sowie "submission"
$inet_socket_port = [10024,10025];

# Mails werden auf Port 10035 zur�ckgef�hrt
$forward_method = 'smtp:[127.0.0.1]:10035';
$notify_method  = 'smtp:[127.0.0.1]:10035';

# Listener :10025 bekommt eine eigene Policy
$interface_policy{'10025'} = 'SUBMISSION';

$policy_bank{'SUBMISSION'} = {
        # Diese Mails kommen von einem vertrauten System
        originating => 1,
        # 7-bit Kodierung erzwingen, damit ein sp�teres Kodieren die DKIM-Signatur nicht zerst�rt
        smtpd_discard_ehlo_keywords => ['8BITMIME'],
        # Viren auch von auth. Sendern ablehnen
        final_virus_destiny => D_REJECT,
        final_bad_header_destiny => D_PASS,
        final_spam_destiny => D_PASS,
        terminate_dsn_on_notify_success => 0,
        warnbadhsender => 1,
};

$myhostname = "mail.domain.tld";

# Wer wird �ber Viren, Spam und "bad header mails" informiert?
# Den Benutzer "postmaster" bitte nachtr�glich in ViMbAdmin erstellen (Alias m�glich)
$virus_admin = "postmaster\@$mydomain";
$spam_admin = "postmaster\@$mydomain";
$banned_quarantine_to = "postmaster\@$mydomain";
$bad_header_quarantine_to = "postmaster\@$mydomain";

# DKIM kann verifiziert werden.
$enable_dkim_verification = 1;

# AR-Header darf gesetzt werden
$allowed_added_header_fields{lc('Authentication-Results')} = 1;

# DKIM-Signatur
# Gilt nur, wenn "originating = 1", ergo f�r die SUBMISSION policy bank
# "default" ist hierbei der Selector
# "domain.tld" als Dom�ne bitte anpassen
# "enable_dkim_signing" nur "1" setzen, wenn Mails wirklich signiert werden sollen.
# "/var/lib/amavis/db/dkim_domain.tld.key" sollte ebenso dem Namen der Dom�ne angepasst werden.
# Die TTL betr�gt im Beispiel 7 Tage
# relaxed/relaxed beschreibt die Header/Body canonicalization, relaxed ist weniger restriktiv

$enable_dkim_signing = 1;
dkim_key('domain.tld', 'default', '/var/lib/amavis/db/dkim_domain.tld.key');
@dkim_signature_options_bysender_maps = (
    { '.' =>
        {
                ttl => 7*24*3600,
                c => 'relaxed/relaxed'
        }
    }
);

# Viren- und Spamfilter ACL; werden automatisch ermittelt
@bypass_virus_checks_maps = (
   \%bypass_virus_checks, \@bypass_virus_checks_acl, \$bypass_virus_checks_re);

@bypass_spam_checks_maps = (
   \%bypass_spam_checks, \@bypass_spam_checks_acl, \$bypass_spam_checks_re);

#------------ Do not modify anything below this line -------------
1;  # ensure a defined return
EOF1
sed -i "s/mail.domain.tld/mail.${MYDOMAIN}/g" /etc/amavis/conf.d/50-user
sed -i "s/changeme/${VIMB_MYSQL_PASS}/g" /etc/amavis/conf.d/50-user
sed -i "s/domain.tld/${MYDOMAIN}/g" /etc/amavis/conf.d/50-user

amavisd-new genrsa /var/lib/amavis/db/dkim_${MYDOMAIN}.key 2048 >>"$main_log" 2>>"$err_log"
amavisd-new showkey ${MYDOMAIN} >>"$main_log" 2>>"$err_log"

adduser clamav amavis >>"$main_log" 2>>"$err_log"
fi
}
source ~/configs/userconfig.cfg