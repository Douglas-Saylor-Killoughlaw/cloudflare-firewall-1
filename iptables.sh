#!/usr/bin/bash

iptables -F;
ip6tables -F;

iptables -I INPUT -p tcp -s localhost -j ACCEPT;
ip6tables -I INPUT -p tcp -s localhost -j ACCEPT;

iptables -I INPUT -p tcp -s `curl ip.sb -4 -s` -j ACCEPT;
ip6tables -I INPUT -p tcp -s `curl ip.sb -6 -s` -j ACCEPT;

for i in `curl https://www.cloudflare.com/ips-v4 -s`;
do
    # http, https, railgun
    iptables -I INPUT -p tcp -m multiport -s $i --dports 80,443,2408 -j ACCEPT;
done

for i in `curl https://www.cloudflare.com/ips-v6 -s`;
do
    # http, https, railgun
    ip6tables -I INPUT -p tcp -m multiport -s $i --dports 80,443,2408 -j ACCEPT;
done
# allow ssh, bt, pma
iptables -I INPUT -p tcp -m multiport --dports 22,888,8888 -j ACCEPT;
ip6tables -I INPUT -p tcp -m multiport --dports 22,888,8888 -j ACCEPT;

# drop other http, https, railgun, mysql
iptables -A INPUT -p tcp -m multiport --dports 80,443,2408,3306 -j DROP;
ip6tables -A INPUT -p tcp -m multiport --dports 80,443,2408,3306 -j DROP;