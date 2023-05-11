#!/bin/bash
ID=${1}



HOME_DIR='/etc/wireguard/'
SERVER_CONF='wg0'

ALLOWED_IPS="0.0.0.0/0,::/0"

if [[ $(find ${HOME_DIR} -name "*${ID}*") == '' ]]; then 

        echo 'not find'
        exit 1
fi; 

sed "/### Client ${ID}/,/### End/d" "${HOME_DIR}${SERVER_CONF}.conf" -i
rm ${HOME_DIR}*":"${ID}".conf"
wg syncconf "${SERVER_CONF}" <(wg-quick strip "${SERVER_CONF}")