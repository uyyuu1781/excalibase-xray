#!/bin/sh
set -eu
PORT="${PORT:-8080}"
: "${UUID:?UUID env is required}"
: "${WSPATH:?WSPATH env is required}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOJ
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "${UUID}", "flow": "" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": { "path": "${WSPATH}" }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "blocked" }
  ]
}
EOJ
echo "xray listening on 0.0.0.0:${PORT} ws path=${WSPATH}"
exec /usr/local/bin/xray run -c /etc/xray/config.json
