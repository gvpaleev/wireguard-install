#!/bin/bash
ID=${1}

HOME_DIR='/etc/wireguard/'
SERVER_CONF='wg0'
SERVER_PUB_KEY=$(cat ${HOME_DIR}key.pub)
CLIENT_CONF='client'

CLIENT_PRIV_KEY=$(wg genkey)
CLIENT_PUB_KEY=$(echo "${CLIENT_PRIV_KEY}" | wg pubkey)
CLIENT_PRE_SHARED_KEY=$(wg genpsk)
CLIENT_WG_IPV4="10.66.66."
CLIENT_DNS_1="1.1.1.1"
CLIENT_DNS_2="1.0.0.1"
ENDPOINT=$(ifconfig eth0 | grep -m 1 inet | cut -b 14-26)
ALLOWED_IPS="0.0.0.0/0,::/0"
SERVER_PORT="51820"

for ((i = 1; i < 255; i++))
{

    if [[ $(find ${HOME_DIR} -name "${CLIENT_CONF}${i}*") == '' ]]; then 

        CLIENT_CONF="${CLIENT_CONF}${i}:${ID}"
        break
    
    fi 
    
}


# echo $ENDPOINT

CLIENT_WG_IPV4="${CLIENT_WG_IPV4}${i}"

echo "[Interface]
PrivateKey = ${CLIENT_PRIV_KEY}
Address = ${CLIENT_WG_IPV4}/32
DNS = ${CLIENT_DNS_1},${CLIENT_DNS_2}

[Peer]
PublicKey = ${SERVER_PUB_KEY}
PresharedKey = ${CLIENT_PRE_SHARED_KEY}
Endpoint = ${ENDPOINT}:${SERVER_PORT}
AllowedIPs = ${ALLOWED_IPS}" >"${HOME_DIR}${CLIENT_CONF}.conf"

echo -e "\n### Client ${ID}
[Peer]
PublicKey = ${CLIENT_PUB_KEY}
PresharedKey = ${CLIENT_PRE_SHARED_KEY}
AllowedIPs = ${CLIENT_WG_IPV4}/32
### End" >>"/etc/wireguard/${SERVER_CONF}.conf"

wg syncconf "${SERVER_CONF}" <(wg-quick strip "${SERVER_CONF}")
