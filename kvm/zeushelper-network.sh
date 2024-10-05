#!/bin/sh 

nmcli con del "Wired connection 1"
nmcli con add connection.id enp1s0 connection.interface-name enp1s0 type ethernet
nmcli con mod enp1s0 ipv4.addresses 192.168.22.50/24
nmcli con mod enp1s0 ipv4.gateway 192.168.22.1
nmcli con mod enp1s0 ipv4.dns "172.31.1.66 172.31.1.2"
nmcli con mod enp1s0 ipv4.method manual
nmcli con mod enp1s0 connection.autoconnect yes
nmcli con down enp1s0
nmcli con up enp1s0

