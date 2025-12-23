# 使用 n8n 官方映像檔作為基底
FROM n8nio/n8n:latest

# 切換到 root 用戶以安裝 Cloudflared
USER root

# 安裝必要的工具 (curl)
RUN apk add --no-cache curl

# 下載並安裝 Cloudflared
RUN curl -L --output cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm cloudflared.deb

# 切換回 node 用戶 (安全考量)
USER node

# 建立一個啟動腳本
RUN echo '#!/bin/sh' > /home/node/start.sh && \
    echo 'cloudflared tunnel run --token $TUNNEL_TOKEN &' >> /home/node/start.sh && \
    echo 'n8n start' >> /home/node/start.sh && \
    chmod +x /home/node/start.sh

# 設定入口點
CMD ["/home/node/start.sh"]
