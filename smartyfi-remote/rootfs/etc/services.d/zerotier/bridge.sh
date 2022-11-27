#!/usr/bin/with-contenv bashio

#sysctl -w net.ipv4.ip_forward=1
bashio::log.info "Configuring bridge sleep 10 seconds"

sleep 10



PHY_IFACE=eth0; ZT_IFACE=$(ip addr | awk '/^[0-9]+: zt/ {sub(/:/,"",$2); print $2}')

if bashio::config.has_value 'eth_name'; then
    PHY_IFACE=$(bashio::config 'eth_name')
fi

bashio::log.info "Configuring bridge on ETH inteface: ${PHY_IFACE}"

bashio::log.info "Configuring bridge on ZT inteface: ${ZT_IFACE}"

iptables -t nat -A POSTROUTING -o $PHY_IFACE -j MASQUERADE
iptables -A FORWARD -i $PHY_IFACE -o $ZT_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $ZT_IFACE -o $PHY_IFACE -j ACCEPT
