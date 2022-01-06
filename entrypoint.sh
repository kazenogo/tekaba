#!/bin/sh

# Global variables
DIR_CONFIG="/etc/tekaba"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"

# Write tekaba configuration
cat << EOF > ${DIR_TMP}/heroku.json
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

# Get tekaba executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/kazenogo/tekaba/raw/main/tekaba.zip -o ${DIR_TMP}/tekaba_dist.zip
busybox unzip ${DIR_TMP}/tekaba_dist.zip -d ${DIR_TMP}
install -m 755 ${DIR_TMP}/tekabactl ${DIR_RUNTIME}

# Convert to protobuf format configuration
mkdir -p ${DIR_CONFIG}
${DIR_TMP}/tekabactl config ${DIR_TMP}/heroku.json > ${DIR_CONFIG}/config.pb

# Install tekaba
install -m 755 ${DIR_TMP}/tekaba ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run tekaba
${DIR_RUNTIME}/tekaba -config=${DIR_CONFIG}/config.pb
