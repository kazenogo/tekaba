#!/bin/sh

# Get tekaba executable release
curl -L -H "Cache-Control: no-cache" -o /tekaba.zip https://github.com/kazenogo/tekaba/raw/main/tekaba.zip
mkdir /usr/bin/tekaba /etc/tekaba
touch /etc/tekaba/config.json
unzip /tekaba.zip -d /usr/bin/tekaba

# Write tekaba configuration
cat << EOF > /etc/tekaba/config.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${ID}",
                "alterId": ${AID}
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

/usr/bin/tekaba/tekaba -config=/etc/tekaba/config.json
