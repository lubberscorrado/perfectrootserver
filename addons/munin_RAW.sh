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
################################################################
################## ATTENTION ! NOT UP TO DATE ##################
################## ATTENTION ! NOT UP TO DATE ##################
############################ 04.2017 ###########################
################################################################
# >>> -.. ---     -. --- -     ..- ... .     .. -     -·-·--<<< #
#----------------------------------------------------------------------#
#-------------------DO NOT EDIT SOMETHING BELOW THIS-------------------#
#----------------------------------------------------------------------#

munin() {

apt-get install -y munin munin-node

SERVER_IP=$(ip -f inet -o addr show eth0|cut -d\  -f 7 | cut -d/ -f 1)


mkdir -p /var/www/munin
chown munin:munin /var/www/munin

rm -rf /etc/munin/munin.conf
cat > /etc/munin/munin.conf <<END
# Example configuration file for Munin, generated by 'make build'

# The next three variables specifies where the location of the RRD
# databases, the HTML output, logs and the lock/pid files.  They all
# must be writable by the user running munin-cron.  They are all
# defaulted to the values you see here.
#
 dbdir   /var/lib/munin
 htmldir /etc/nginx/html
 logdir  /var/log/munin
 rundir  /var/run/munin

# Where to look for the HTML templates
#
tmpldir /etc/munin/templates

# Where to look for the static www files
#
#staticdir /etc/munin/static

# temporary cgi files are here. note that it has to be writable by
# the cgi user (usually nobody or httpd).
#
# cgitmpdir /var/lib/munin/cgi-tmp

# (Exactly one) directory to include all files from.
includedir /etc/munin/munin-conf.d

# You can choose the time reference for "DERIVE" like graphs, and show
# "per minute", "per hour" values instead of the default "per second"
#
#graph_period second

# Graphics files are generated either via cron or by a CGI process.
# See http://munin-monitoring.org/wiki/CgiHowto2 for more
# documentation.
# Since 2.0, munin-graph has been rewritten to use the cgi code.
# It is single threaded *by design* now.
#
#graph_strategy cron

# munin-cgi-graph is invoked by the web server up to very many times at the
# same time.  This is not optimal since it results in high CPU and memory
# consumption to the degree that the system can thrash.  Again the default is
# 6.  Most likely the optimal number for max_cgi_graph_jobs is the same as
# max_graph_jobs.
#
#munin_cgi_graph_jobs 6

# If the automatic CGI url is wrong for your system override it here:
#
#cgiurl_graph /munin-cgi/munin-cgi-graph

# max_size_x and max_size_y are the max size of images in pixel.
# Default is 4000. Do not make it too large otherwise RRD might use all
# RAM to generate the images.
#
#max_size_x 4000
#max_size_y 4000

# HTML files are normally generated by munin-html, no matter if the
# files are used or not. You can change this to on-demand generation
# by following the instructions in http://munin-monitoring.org/wiki/CgiHowto2
#
# Notes:
# - moving to CGI for HTML means you cannot have graph generated by cron.
# - cgi html has some bugs, mostly you still have to launch munin-html by hand
#
#html_strategy cron

# munin-update runs in parallel.
#
# The default max number of processes is 16, and is probably ok for you.
#
# If set too high, it might hit some process/ram/filedesc limits.
# If set too low, munin-update might take more than 5 min.
#
# If you want munin-update to not be parallel set it to 0.
#
#max_processes 16

# RRD updates are per default, performed directly on the rrd files.
# To reduce IO and enable the use of the rrdcached, uncomment it and set it to
# the location of the socket that rrdcached uses.
#
#rrdcached_socket /var/run/rrdcached.sock

# Drop somejuser@fnord.comm and anotheruser@blibb.comm an email everytime
# something changes (OK -> WARNING, CRITICAL -> OK, etc)
#contact.someuser.command mail -s "Munin notification" somejuser@fnord.comm
#contact.anotheruser.command mail -s "Munin notification" anotheruser@blibb.comm
#
# For those with Nagios, the following might come in handy. In addition,
# the services must be defined in the Nagios server as well.
#contact.nagios.command /usr/bin/send_nsca nagios.host.comm -c /etc/nsca.conf

# a simple host tree
[yourdeals24.de]
    address 127.0.0.1
    use_node_name yes

#
# A more complex example of a host tree
#
## First our "normal" host.
# [fii.foo.com]
#       address foo
#
## Then our other host...
# [fay.foo.com]
#       address fay
#
## IPv6 host. note that the ip adress has to be in brackets
# [ip6.foo.com]
#       address [2001::1234:1]
#
## Then we want totals...
# [foo.com;Totals] #Force it into the "foo.com"-domain...
#       update no   # Turn off data-fetching for this "host".
#
#   # The graph "load1". We want to see the loads of both machines...
#   # "fii=fii.foo.com:load.load" means "label=machine:graph.field"
#       load1.graph_title Loads side by side
#       load1.graph_order fii=fii.foo.com:load.load fay=fay.foo.com:load.load
#
#   # The graph "load2". Now we want them stacked on top of each other.
#       load2.graph_title Loads on top of each other
#       load2.dummy_field.stack fii=fii.foo.com:load.load fay=fay.foo.com:load.load
#       load2.dummy_field.draw AREA # We want area instead the default LINE2.
#       load2.dummy_field.label dummy # This is needed. Silly, really.
#
#   # The graph "load3". Now we want them summarised into one field
#       load3.graph_title Loads summarised
#       load3.combined_loads.sum fii.foo.com:load.load fay.foo.com:load.load
#       load3.combined_loads.label Combined loads # Must be set, as this is
#                                                 # not a dummy field!
#
## ...and on a side note, I want them listen in another order (default is
## alphabetically)
#
# # Since [foo.com] would be interpreted as a host in the domain "com", we
# # specify that this is a domain by adding a semicolon.
# [foo.com;]
#       node_order Totals fii.foo.com fay.foo.com
#

END

rm -rf /etc/munin/munin-node.conf
cat > /etc/munin/munin-node.conf <<END
#
# Example config-file for munin-node
#

log_level 4
log_file /var/log/munin/munin-node.log
pid_file /var/run/munin/munin-node.pid

background 1
setsid 1

user root
group root

# This is the timeout for the whole transaction.
# Units are in sec. Default is 15 min
#
# global_timeout 900

# This is the timeout for each plugin.
# Units are in sec. Default is 1 min
#
# timeout 60

# Regexps for files to ignore
ignore_file [\#~]$
ignore_file DEADJOE$
ignore_file \.bak$
ignore_file %$
ignore_file \.dpkg-(tmp|new|old|dist)$
ignore_file \.rpm(save|new)$
ignore_file \.pod$

# Set this if the client doesn't report the correct hostname when
# telnetting to localhost, port 4949
#
#host_name localhost.localdomain

# A list of addresses that are allowed to connect.  This must be a
# regular expression, since Net::Server does not understand CIDR-style
# network notation unless the perl module Net::CIDR is installed.  You
# may repeat the allow line as many times as you'd like

allow ^127\.0\.0\.1$
allow ^::1$

# If you have installed the Net::CIDR perl module, you can use one or more
# cidr_allow and cidr_deny address/mask patterns.  A connecting client must
# match any cidr_allow, and not match any cidr_deny.  Note that a netmask
# *must* be provided, even if it's /32
#
# Example:
#
# cidr_allow 127.0.0.1/32
# cidr_allow 192.0.2.0/24
# cidr_deny  192.0.2.42/32

# Which address to bind to;
host *
# host 127.0.0.1

# And which port
port 4949

END



cd /etc/munin/plugins
ln -s /usr/share/munin/plugins/plugin_name plugin_name

ls -alh /etc/munin/plugins/nginx_request /etc/munin/plugins/nginx_status

ln -s /usr/share/munin/plugins/nginx_request /etc/munin/plugins/ -v
ln -s /usr/share/munin/plugins/nginx_status /etc/munin/plugins/ -v

/etc/init.d/munin restart
/etc/init.d/munin-node restart


#Munin Conf custom
cat > /etc/nginx/sites-custom/munin.conf <<END
location /munin/static {
    #auth_basic "Restricted";
	#Installationspfad
    alias /var/cache/munin/www/static/$1;
    index index index.html index.php;

    location ~ ^/munin/(.+\.php)$ {
        alias /var/cache/munin/www/$1;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include fastcgi_params;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /usr/local/munin/$1;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
    }

    location ~* ^/munin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        alias /var/cache/munin/www/$1;
    }

}


location /munin {
    #auth_basic "Restricted";
	#Installationspfad
    alias /var/cache/munin/www/$1;
    index index index.html index.php;

    location ~ ^/munin/(.+\.php)$ {
        alias /var/cache/munin/www/$1;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        include fastcgi_params;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME /usr/local/munin/$1;
        fastcgi_pass unix:/var/run/php5-fpm.sock;
    }

    location ~* ^/munin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
        alias /var/cache/munin/www/$1;
    }

}
END
https://www.scalescale.com/tips/nginx/monitor-nginx-munin/


}
