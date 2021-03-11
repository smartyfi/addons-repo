#!/usr/bin/with-contenv bashio

#sysctl -w net.ipv4.ip_forward=1
bashio::log.info "Configuring bridge sleep 10 seconds"

sleep 10

PHY_IFACE=eth0; ZT_IFACE=$(ip addr | awk '/^[0-9]+: zt/ {sub(/:/,"",$2); print $2}')

bashio::log.info "Configuring bridge on inteface: ${ZT_IFACE}"

iptables -t nat -A POSTROUTING -o $PHY_IFACE -j MASQUERADE
iptables -A FORWARD -i $PHY_IFACE -o $ZT_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $ZT_IFACE -o $PHY_IFACE -j ACCEPT