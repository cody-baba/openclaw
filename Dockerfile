# Use the official Moltbot image with the correct tag
FROM ghcr.io/openclaw/openclaw:main

# Switch to root to install global packages
USER root

# Upgrade npm to latest (avoids old bugs)
RUN npm install -g npm@latest

# Install clawhub globally with proper permissions
RUN npm install -g --unsafe-perm clawhub

# Pre-install all verified Clawhub skills
RUN clawhub install calendar || true
RUN clawhub install google-workspace || true
RUN clawhub install finance || true
RUN clawhub install pdf || true
RUN clawhub install gogcli || true
RUN clawhub install Gog || true
RUN clawhub install agent-browser || true
RUN clawhub install google-photos || true
RUN clawhub install google-web-search || true
RUN clawhub install chrome-enterprise || true   # ✅ Chrome browser & ChromeOS management
RUN clawhub install google-maps || true         # ✅ Google Maps & Location APIs
RUN clawhub install outlook || true             # ✅ Microsoft Outlook integration
RUN clawhub install office || true              # ✅ Microsoft Office (Word, Excel, PowerPoint)

# Install useful CLI tools and build dependencies
RUN apt-get update && apt-get install -y \
    curl jq git unzip nano \
    net-tools iputils-ping dnsutils \
    build-essential pkg-config libssl-dev libffi-dev \
    python3 python3-pip python3-requests

# Optional: Node.js developer utilities for TypeScript-based skills
RUN npm install -g typescript ts-node nodemon

# Switch back to non-root user for safety
USER node

# Expose Moltbot port
EXPOSE 3000

# Healthcheck for container monitoring
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
  CMD curl -f http://localhost:3000/health || exit 1

# Default command to start Moltbot
CMD ["npm", "start"]
