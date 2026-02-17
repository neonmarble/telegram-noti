# 📱 Telegram Notify

A simple and secure Bash script for sending notifications to Telegram via the Telegram Bot API.

## 🎯 Purpose

Send notifications, alerts, or messages to Telegram directly from your command line or shell scripts. Perfect for:
- Server monitoring and alerts
- CI/CD pipeline notifications
- Cron job status updates
- Automated deployment notifications
- Script completion alerts

## ✨ Features

- 🔒 **Secure**: Uses POST requests with JSON payloads (no credentials in URLs)
- 🚀 **Simple**: Single script with minimal dependencies
- 🎨 **HTML Support**: Supports Telegram HTML formatting
- ⚙️ **Flexible**: Configure via arguments or environment variables
- 📝 **Clean Output**: Non-sensitive logging only

## 📋 Prerequisites

### Native Script
- `bash` shell
- `curl` - for API requests
- `jq` - for JSON processing

Install dependencies:
```bash
# Ubuntu/Debian
sudo apt-get install curl jq

# macOS
brew install curl jq

# RHEL/CentOS
sudo yum install curl jq
```

### Docker (Alternative)
- Docker Engine 20.10+
- Docker Compose (optional, for easier usage)

All dependencies are bundled in the Docker image - no local installation needed!

## 🔧 Setup

### 1. Create a Telegram Bot

- Open Telegram and search for [@BotFather](https://t.me/botfather)
- Send `/newbot` and follow the instructions
- Save the **bot token** you receive

### 2. Get Your Chat ID

- Send a message to your bot
- Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
- Find your `chat_id` in the response

### 3. Configure the Script

**Option A: Environment Variables** (Recommended)
```bash
export TELEGRAM_CHAT_ID="your_chat_id"
export TELEGRAM_BOT_TOKEN="your_bot_token"
```

**Option B: Command Arguments**
```bash
./telegram_notify.sh "Your message" "chat_id" "bot_token"
```

## 🚀 Usage

### Basic Usage
```bash
./telegram_notify.sh "Hello from the command line!"
```

### With HTML Formatting
```bash
./telegram_notify.sh "<b>Bold text</b> and <i>italic text</i>"
```

### From Scripts
```bash
#!/bin/bash
if [ $? -eq 0 ]; then
    ./telegram_notify.sh "✅ Backup completed successfully"
else
    ./telegram_notify.sh "❌ Backup failed!"
fi
```

### Cron Job Example
```bash
# Send notification when disk usage exceeds 80%
0 */6 * * * df -h | awk '$5 > 80 {print}' | xargs -I {} ./telegram_notify.sh "⚠️ High disk usage: {}"
```

## 📝 Examples

### Deployment Notification
```bash
./telegram_notify.sh "🚀 <b>Deployment Started</b>
Environment: Production
Commit: $(git rev-parse --short HEAD)"
```

### System Alert
```bash
./telegram_notify.sh "🔴 <b>ALERT</b>: Server load is high
Load: $(uptime | awk -F'load average:' '{print $2}')"
```

### Monitoring Script
```bash
#!/bin/bash
STATUS=$(systemctl is-active nginx)
if [ "$STATUS" != "active" ]; then
    ./telegram_notify.sh "⚠️ Nginx is down! Status: $STATUS"
fi
```

## 🐳 Docker Usage

### Why Docker?
- 📦 All dependencies bundled (no need to install curl/jq)
- 🔒 Isolated environment
- 🚀 Perfect for CI/CD pipelines
- 🎯 Consistent behavior across systems

### Quick Start

#### 1. Setup Credentials
```bash
# Copy the example environment file
cp .env.example .env

# Edit .env with your actual credentials
nano .env  # or use your preferred editor
```

**⚠️ Important:** Add `.env` to your `.gitignore` to prevent committing secrets!

#### 2. Pull the Pre-built Image
```bash
# Pull from GitHub Container Registry (automatically built via CI/CD)
docker pull ghcr.io/neonmarble/telegram_notify:latest
```

Or build locally:
```bash
docker build -t telegram-notify .
```

#### 3. Send a Notification

**Using pre-built image from GHCR:**
```bash
docker run --env-file .env ghcr.io/neonmarble/telegram_notify:latest "Hello from Docker! 🐳"
```

**Using locally built image:**
```bash
docker run --env-file .env telegram-notify "Hello from Docker! 🐳"
```

**Using explicit environment variables:**
```bash
docker run \
  -e TELEGRAM_CHAT_ID="your_chat_id" \
  -e TELEGRAM_BOT_TOKEN="your_bot_token" \
  ghcr.io/neonmarble/telegram_notify:latest "Hello from Docker!"
```

**With HTML formatting:**
```bash
docker run --env-file .env ghcr.io/neonmarble/telegram_notify:latest "<b>Bold</b> and <i>italic</i> text"
```

### Docker Compose Usage

Docker Compose simplifies running the container:

```bash
# Send a notification (reads .env automatically)
docker-compose run telegram-notify "Deployment complete! ✅"

# With HTML formatting
docker-compose run telegram-notify "<b>Alert:</b> High CPU usage detected"

# In CI/CD pipelines
docker-compose run telegram-notify "Build #${BUILD_NUMBER} succeeded"
```

### CI/CD Integration Examples

**GitHub Actions:**
```yaml
- name: Send Telegram notification
  run: |
    docker run \
      -e TELEGRAM_CHAT_ID="${{ secrets.TELEGRAM_CHAT_ID }}" \
      -e TELEGRAM_BOT_TOKEN="${{ secrets.TELEGRAM_BOT_TOKEN }}" \
      ghcr.io/neonmarble/telegram_notify:latest "GitHub Actions: Build completed ✅"
```

**GitLab CI:**
```yaml
notify:
  image: ghcr.io/neonmarble/telegram_notify:latest
  script:
    - echo "Sending notification..."
  variables:
    TELEGRAM_CHAT_ID: $TELEGRAM_CHAT_ID
    TELEGRAM_BOT_TOKEN: $TELEGRAM_BOT_TOKEN
  entrypoint: ["/app/telegram_notify.sh", "GitLab CI: Pipeline passed"]
```

### Automated Builds

Docker images are automatically built and published to GitHub Container Registry via GitHub Actions on every push to `main`:

- 🏷️ **Tags available:**
  - `latest` - Latest stable version from main branch
  - `main` - Latest commit on main branch
  - `v1.0.0` - Semantic version tags
  - `sha-abc123` - Specific commit SHA

- 🏗️ **Multi-platform support:**
  - `linux/amd64` (x86_64)
  - `linux/arm64` (ARM v8, Apple Silicon, Raspberry Pi 4+)

- 🔄 **Workflow:**
  - Push to main → Build & publish to GHCR
  - Create tag (v*) → Build & publish with version tag
  - Pull request → Build only (test, no publish)

View all available images: [GitHub Container Registry](https://github.com/neonmarble/telegram_notify/pkgs/container/telegram_notify)

### Docker Image Details

- **Base Image:** Alpine Linux 3.21 (minimal footprint)
- **Size:** ~15-20MB
- **User:** Non-root user (UID 1001) for security
- **Dependencies:** bash, curl, jq

## 🔐 Security Notes

### General
- ✅ Bot token is sent via POST body (not in URLs)
- ✅ No sensitive data logged to stdout
- ✅ Safe JSON construction prevents injection
- ⚠️ Store bot token securely (use environment variables or secrets manager)
- ⚠️ Never commit tokens to version control

### Docker-Specific
- ✅ Runs as non-root user (UID 1001)
- ✅ Use `.env` file for secrets (add to `.gitignore`)
- ✅ For production, consider Docker secrets or external secrets managers
- ⚠️ Don't hardcode credentials in docker-compose.yml

## 🛠️ Troubleshooting

### Native Script

**"jq: command not found"**
- Install jq: `sudo apt-get install jq` or `brew install jq`

**"Failed to send notification"**
- Verify your bot token and chat ID are correct
- Ensure your bot has permission to send messages
- Check your internet connection

**"Error: Message is required"**
- You must provide a message as the first argument

### Docker

**"TELEGRAM_CHAT_ID is required" error**
- Ensure your `.env` file exists and contains the required variables
- Check that you copied `.env.example` to `.env` and filled in real values

**Build fails or image not found**
- Run `docker build -t telegram-notify .` in the project directory
- Ensure you're in the correct directory (where Dockerfile is located)

**Permission denied errors**
- The container runs as non-root user - this is expected and secure
- Script is automatically made executable during build

## 📄 License

MIT License - Feel free to use and modify as needed.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
