# TetherATurtle
This is a modified version of the wp5.sh script for tethering your Wifi Pineapple to your laptop, so instead of tethering your pineapple you will instead tether your Lan Turtle.

## Turtle Configuration
You will need to configure a default gateway of 172.16.84.42 on your Lan Turtle. To do this ssh into your turtle and run the following command:

'''bash
route add default gw 172.16.84.42
'''

Next you will need to configure a DNS server. Nano /etc/resolv.conf and add the following line:
'''
nameserver 8.8.8.8
'''

## The Script
After you configure your turtle go ahead and run the script. Its the same proccess you may be familiar with with the Wifi Pineapple. Specify the Lan Turtle facing interface and your internet facing interface as well as your default gateway. Everything else can be left at the defaults but you can change them if you feel like it.

## Why?
Because who wants to develop modules while sitting next to your router unable to leave because you have a cable coming out of your machine.

