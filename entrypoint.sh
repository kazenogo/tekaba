#!/bin/sh

# Get tekaba executable release
curl -L -H "Cache-Control: no-cache" -o /tekaba.zip https://github.com/kazenogo/tekaba/raw/main/tekaba.zip
mkdir /usr/bin/tekaba /etc/tekaba
touch /etc/tekaba/config.json
unzip /tekaba.zip -d /usr/bin/tekaba
chmod +x /usr/bin/tekaba/tekaba

# Write tekaba configuration
cat << EOF > /etc/tekaba/config.json
{
    "inbounds": [{
        "port": "443",
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "60491148-dc85-451b-9b67-badd656cb5fb",
                "alterId": "128"
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "/"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

/usr/bin/tekaba/tekaba -config=/etc/tekaba/config.json
