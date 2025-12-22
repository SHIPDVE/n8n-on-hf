# 使用 n8n 官方映像檔
FROM n8nio/n8n:latest

# 切換到 root 權限來安裝 Cloudflare
USER root

# 安裝 cloudflared
RUN apk add --no-cache curl libc6-compat && \
    curl -L --output cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x cloudflared && \
    mv cloudflared /usr/local/bin/

# 切換回安全性較高的 node 使用者
USER node

# 建立啟動腳本：同時啟動 Tunnel 和 n8n
RUN echo '#!/bin/sh' > /home/node/start.sh && \
    echo 'cloudflared tunnel run --token $TUNNEL_TOKEN &' >> /home/node/start.sh && \
    echo 'n8n start' >> /home/node/start.sh && \
    chmod +x /home/node/start.sh

# 執行腳本
CMD ["/home/node/start.sh"]
