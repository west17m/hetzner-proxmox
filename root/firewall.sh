#!/bin/bash

# vars
IPT=/sbin/iptables

WAN_IFACE=enp4s0

LAN_IFACE=vmbr0
LAN_ADDY=10.0.0.0/24

echo " * flushing tables"

# Disable forwarding
echo 0 > /proc/sys/net/ipv4/ip_forward

# Flush all rules
$IPT -F
$IPT -t nat -F
$IPT -t mangle -F

# Erase all non-default chains
$IPT -X
$IPT -t nat -X
$IPT -t mangle -X

# Reset Default Policies
$IPT -P INPUT ACCEPT
$IPT -P FORWARD ACCEPT
$IPT -P OUTPUT ACCEPT
$IPT -t nat -P PREROUTING ACCEPT
$IPT -t nat -P POSTROUTING ACCEPT
$IPT -t nat -P OUTPUT ACCEPT
$IPT -t mangle -P PREROUTING ACCEPT
$IPT -t mangle -P OUTPUT ACCEPT


if [ "$1" = "stop" ]
then
        exit 0
fi

echo " * firewall completely flushed!  Now running with no firewall."

export DEBIAN_FRONTEND=noninteractive
apt-get install -yq iptables-persistent

####################################################
#                                                  #
# Process INPUT rules                              #
#                                                  #
####################################################

echo " * INPUT rules"

# Locking services to LAN
$IPT -I INPUT 1 -i $LAN_IFACE -j ACCEPT

$IPT -A INPUT -p UDP --dport bootps -i $WAN_IFACE -j REJECT

# allow new connections only from
# 1. LAN
$IPT -A INPUT -m conntrack --ctstate NEW -i $LAN_IFACE -j ACCEPT

####################################################
#                                                  #
# final clean up and allow masquerading            #
#                                                  #
####################################################

$IPT -A INPUT -p udp --dport 123 -j ACCEPT
$IPT -A OUTPUT -p udp --sport 123 -j ACCEPT
$IPT -A FORWARD -p udp --sport 123 --dport 123 -j ACCEPT

# allow masquerading from the internal network
$IPT -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo " * firewall secured"
echo " * the following ports are being opened"

# allow these ports access to the firewall
echo "   * opening sshd"
$IPT -A INPUT -p tcp --dport 22 -i $WAN_IFACE -j ACCEPT

echo "   * opening proxmox management"
$IPT -A INPUT -p tcp --dport 8006 -i $WAN_IFACE -j ACCEPT

#
# allow ping
#
echo "allowing ping responses"
$IPT -A INPUT -p icmp -m icmp --icmp-type 8 -j ACCEPT

#  And now deny everything else and log it
# $IPT -A INPUT -j ULOG
$IPT -A INPUT -i $WAN_IFACE -j DROP
#$IPT -P INPUT DROP

####################################################
#                                                  #
# allow these ports access to the LAN from outside #
#   or by clients on the wifi subnet               #
#                                                  #
####################################################

#echo " * port forwarding"
#
#echo "   * opening port 8123 to homeassistant (192.168.1.99)"
#$IPT -A PREROUTING -t nat -p tcp -i $WAN_IFACE --dport 8123 \
#                       -j DNAT --to 192.168.1.99:8123
#$IPT -A PREROUTING -t nat -p udp -i $WAN_IFACE --dport 8123 \
#                       -j DNAT --to 192.168.1.99:8123
# this is specifically for letsencrypt
#$IPT -A PREROUTING -t nat -p tcp -i $WAN_IFACE --dport 80 \
#                       -j DNAT --to 192.168.1.99:80

####################################################
#                                                  #
# Set up masquerading                              #
#                                                  #
####################################################

echo " * enabling maquerading"
$IPT -A FORWARD -i $LAN_IFACE -s $LAN_ADDY -j ACCEPT
$IPT -A FORWARD -i $WAN_IFACE -d $LAN_ADDY -j ACCEPT

# $IPT -P FORWARD DROP
$IPT -t nat -A POSTROUTING -o $WAN_IFACE -j MASQUERADE


# DROP all packets originating from outside that
# are disguised as internal packets
for f in /proc/sys/net/ipv4/conf/*/rp_filter; do
    echo 1 > $f
done


echo " * bringing up firewall"
echo 1 > /proc/sys/net/ipv4/ip_forward

echo " * saving settings"
mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4
