#!/bin/bash

# Telegram Notification Script
# Usage: ./telegram_notify.sh "Your message here" [chat_id] [bot_token]

# Configuration - can be overridden by environment variables
CHAT_ID="${2:-$TELEGRAM_CHAT_ID}"
BOT_TOKEN="${3:-$TELEGRAM_BOT_TOKEN}"

# Check if message is provided
if [ -z "$1" ]; then
    echo "Error: Message is required"
    echo "Usage: $0 \"Your message\" [chat_id] [bot_token]"
    echo "Or set TELEGRAM_CHAT_ID and TELEGRAM_BOT_TOKEN environment variables"
    exit 1
fi

MESSAGE="$1"

# Check if chat_id and bot_token are available
if [ -z "$CHAT_ID" ] || [ -z "$BOT_TOKEN" ]; then
    echo "Error: CHAT_ID and BOT_TOKEN are required"
    echo "Set them as arguments or environment variables:"
    echo "export TELEGRAM_CHAT_ID='your_chat_id'"
    echo "export TELEGRAM_BOT_TOKEN='your_bot_token'"
    exit 1
fi

# URL encode the message
ENCODED_MESSAGE=$(printf '%s' "$MESSAGE" | jq -sRr @uri)

# Send the notification
API_URL="https://api.telegram.org/bot$BOT_TOKEN/sendMessage"
FULL_URL="$API_URL?chat_id=$CHAT_ID&text=$ENCODED_MESSAGE&parse_mode=HTML"

echo "Sending notification to Telegram..."

# Make the API call
RESPONSE=$(curl -s -X GET "$FULL_URL")

# Check if the message was sent successfully
if echo "$RESPONSE" | jq -e '.ok' > /dev/null 2>&1; then
    echo "✅ Notification sent successfully!"
    echo "Message: $MESSAGE"
else
    echo "❌ Failed to send notification"
    echo "Response: $RESPONSE"
    exit 1
fi

