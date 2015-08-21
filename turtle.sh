#!/bin/bash
#define variables

#
# This is just a modifed version of wp5.sh for the pineapple with the turtle network address and bannder
# You will need to manully cofigure the default gw on your turtle to 172.16.84.42
# To do that run this command on your turtle: route add default gw 172.16.84.42
# You will also need to set your DNS settings, add the following line to /etc/resolv.conf on your turtle
# nameserver: 8.8.8.8
#
# I hope this makes development for turtle modules less of a pain... who wants to be tethered to a cable anymore?
# - Newbi3
#
# Credit goes to whoever wrote the wp5.sh script for the wifi pineapple.
#

echo "$(tput setaf 2)"
echo "               LAN TURTLE"
echo "               by Hak5"
echo "        .-./*)            (*\.-."
echo "      _/___\/              \/___\_"
echo "        U U                  U U"
echo "$(tput sgr0)"

echo -n "Turtle Netmask [255.255.255.0]: "
read turtlenetmask
if [[ $turtlenetmask == '' ]]; then 
turtlenetmask=255.255.255.0 #Default netmask for /24 network
fi

echo -n "Turtle Network [172.16.84.0/24]: "
read turtlenet
if [[ $turtlenet == '' ]]; then 
turtlenet=172.16.84.0/24 # Turtle network. Default is 172.16.84.0/24
fi

echo -n "Interface between PC and Turtle [eth1]: "
read turtlelan
if [[ $turtlelan == '' ]]; then 
turtlelan=eth1 # Interface of ethernet cable directly connected to Turtle
fi

echo -n "Interface between PC and Internet [wlan0]: "
read turtlewan
if [[ $turtlewan == '' ]]; then 
turtlewan=wlan0 #i.e. wlan0 for wifi, ppp0 for 3g modem/dialup, eth0 for lan
fi

tempturtlegw=`netstat -nr | awk 'BEGIN {while ($3!="0.0.0.0") getline; print $2}'` #Usually correct by default
echo -n "Internet Gateway [$tempturtlegw]: "
read turtlegw
if [[ $turtlegw == '' ]]; then 
turtlegw=`netstat -nr | awk 'BEGIN {while ($3!="0.0.0.0") getline; print $2}'` #Usually correct by default
fi

echo -n "IP Address of Host PC [172.16.84.42]: "
read turtlehostip
if [[ $turtlehostip == '' ]]; then 
turtlehostip=172.16.84.42 #IP Address of host computer
fi

echo -n "IP Address of Turtle [172.16.84.1]: "
read turtleip
if [[ $turtleip == '' ]]; then 
turtleip=172.16.84.1 #Thanks Douglas Adams
fi

echo ""
echo "$(tput setaf 6)     _ .   $(tput sgr0)        $(tput setaf 7)___$(tput sgr0)          $(tput setaf 2)  .-./*) $(tput sgr0)   Internet: $turtlegw  - $turtlewan"
echo "$(tput setaf 6)   (  _ )_ $(tput sgr0) $(tput setaf 5)<-->$(tput sgr0)  $(tput setaf 7)[___]$(tput sgr0)  $(tput setaf 5)<-->$(tput sgr0)  $(tput setaf 2) _/___\/  $(tput sgr0)   Computer: $turtlehostip"
echo "$(tput setaf 6) (_  _(_ ,)$(tput sgr0)       $(tput setaf 7)\___\\$(tput sgr0)        $(tput setaf 2)   U U $(tput sgr0)      Turtle: $turtlenet - $turtlelan"

#Bring up Ethernet Interface directly connected to Turtle
ifconfig $turtlelan $turtlehostip netmask $turtlenetmask up

# Enable IP Forwarding
echo '1' > /proc/sys/net/ipv4/ip_forward
#echo -n "IP Forwarding enabled. /proc/sys/net/ipv4/ip_forward set to "
#cat /proc/sys/net/ipv4/ip_forward

#clear chains and rules
iptables -X
iptables -F
#echo iptables chains and rules cleared

#setup IP forwarding
iptables -A FORWARD -i $turtlewan -o $turtlelan -s $turtlenet -m state --state NEW -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A POSTROUTING -t nat -j MASQUERADE
#echo IP Forwarding Enabled

#remove default route
route del default
#echo Default route removed

#add default gateway
route add default gw $turtlegw $turtlewan
#echo Turtle Default Gateway Configured

##send the command to add 8.8.8.8 to lanturtles /etc/resolv.conf
#ping -c1 $turtleip
#if [ $? -eq 0 ]; then
#echo "ICS configuration successful."
#echo "Issuing on Turtle: 'echo 8.8.8.8 >> /etc/resolv.conf'"
#echo "Enter password if prompted"
#ssh root@$turtleip 'echo 8.8.8.8 >> /etc/resolv.conf'
#fi

#instruction
echo " "
echo "Now on the Turtle execute:"
echo " \"echo 8.8.8.8 >> /etc/resolv.conf\""
echo " \"bash route add default gw 172.16.84.42\""
echo ""
echo "Happy Shelling :)"
echo ""
