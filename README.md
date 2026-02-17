# 📱 Telegram Notify

> **Learning Project:** A simple Bash script for sending Telegram notifications. Built to explore Docker containerization, CI/CD pipelines, and security best practices. Agentically context-engineered with GitHub Copilot.

## Quick Start

Send notifications to Telegram from command line or scripts. Supports server monitoring, CI/CD alerts, and automation.

## Setup

### 1. Get Telegram Credentials

1. Create bot: Search [@BotFather](https://t.me/botfather) on Telegram, send `/newbot`
2. Get chat ID: Message your bot, then visit `https://api.telegram.org/bot<TOKEN>/getUpdates`

### 2. Choose Your Method

**Native Script:**
```bash
# Install dependencies
sudo apt-get install curl jq bash

# Set credentials
export TELEGRAM_CHAT_ID="your_chat_id"
export TELEGRAM_BOT_TOKEN="your_bot_token"

# Send notification
./telegram_notify.sh "Hello from terminal!"
```

**Docker (Recommended):**
```bash
# Pull image
docker pull ghcr.io/neonmarble/telegram_notify:latest

# Send notification
docker run \
  -e TELEGRAM_CHAT_ID="your_chat_id" \
  -e TELEGRAM_BOT_TOKEN="your_bot_token" \
  ghcr.io/neonmarble/telegram_notify:latest "Hello from Docker! 🐳"
```

**Docker Compose:**
```bash
# Setup
cp .env.example .env
nano .env  # Add your credentials

# Run
docker-compose run telegram-notify "Deployment complete!"
```

## CI/CD Usage

**GitHub Actions:**
```yaml
- name: Notify Telegram
  run: |
    docker run \
      -e TELEGRAM_CHAT_ID="${{ secrets.TELEGRAM_CHAT_ID }}" \
      -e TELEGRAM_BOT_TOKEN="${{ secrets.TELEGRAM_BOT_TOKEN }}" \
      ghcr.io/neonmarble/telegram_notify:latest "Build completed ✅"
```

**GitLab CI:**
```yaml
notify:
  image: ghcr.io/neonmarble/telegram_notify:latest
  variables:
    TELEGRAM_CHAT_ID: $TELEGRAM_CHAT_ID
    TELEGRAM_BOT_TOKEN: $TELEGRAM_BOT_TOKEN
  entrypoint: ["/app/telegram_notify.sh", "Pipeline passed"]
```

## Docker Images

Images auto-built via GitHub Actions on push to `main`:

- **Registry:** `ghcr.io/neonmarble/telegram_notify`
- **Tags:** `latest`, `main`, version tags (e.g., `v1.0.0`), commit SHAs
- **Platforms:** `linux/amd64`, `linux/arm64` (Apple Silicon, Raspberry Pi)
- **Size:** ~15-20MB (Alpine Linux base)

## Security

- ✅ POST requests (credentials in body, not URLs)
- ✅ Non-root container user (UID 1001)
- ✅ No sensitive data logged
- ⚠️ Never commit `.env` to version control
- ⚠️ Use secrets managers in production

## License

MIT License
