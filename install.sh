#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install wireguard -y

HOME_DIR='/etc/wireguard/'
SERVER_CONF='wg0'
SERVER_PRIV_KEY=$(wg genkey)
SERVER_PUB_KEY=$(echo "${SERVER_PRIV_KEY}" | wg pubkey)
echo ${SERVER_PUB_KEY} > "${HOME_DIR}key.pub"
SERVER_WG_IPV4=10.66.66.1 #$(curl ifconfig.me)
SERVER_PORT="51820"
ETHERNET_INT="eth0"

sed /net.ipv4.ip_forward=1/d /etc/sysctl.conf -i
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf



echo "[Interface]
Address = ${SERVER_WG_IPV4}/24
ListenPort = ${SERVER_PORT}
PrivateKey = ${SERVER_PRIV_KEY}
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ${ETHERNET_INT} -j MASQUERADE 
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ${ETHERNET_INT} -j MASQUERADE
" >"${HOME_DIR}${SERVER_CONF}.conf"


systemctl start "wg-quick@${SERVER_CONF}"
systemctl enable "wg-quick@${SERVER_WG_NIC}"

#echo ${SERVER_PRIV_KEY}
#echo ${SERVER_PUB_KEY}


# echo ""> /etc/wireguard/wg.conf
#ip=$(curl ifconfig.me)

#echo ${ip}