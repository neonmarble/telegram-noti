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

## 🔐 Security Notes

- ✅ Bot token is sent via POST body (not in URLs)
- ✅ No sensitive data logged to stdout
- ✅ Safe JSON construction prevents injection
- ⚠️ Store bot token securely (use environment variables or secrets manager)
- ⚠️ Never commit tokens to version control

## 🛠️ Troubleshooting

**"jq: command not found"**
- Install jq: `sudo apt-get install jq` or `brew install jq`

**"Failed to send notification"**
- Verify your bot token and chat ID are correct
- Ensure your bot has permission to send messages
- Check your internet connection

**"Error: Message is required"**
- You must provide a message as the first argument

## 📄 License

MIT License - Feel free to use and modify as needed.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!
