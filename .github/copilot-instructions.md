# Telegram Notify - Copilot Instructions

## Project Overview

This is a simple Bash script utility for sending Telegram notifications via the Telegram Bot API. The entire application consists of a single shell script (`telegram_notify.sh`) that wraps the Telegram Bot API to enable command-line notifications.

## Architecture

**Single Script Design**: The entire functionality is contained in `telegram_notify.sh`. There are no modules, packages, or complex dependencies - just bash, curl, and jq.

**Configuration Pattern**: The script uses a flexible configuration approach:
1. Arguments take precedence: `./telegram_notify.sh "message" "chat_id" "bot_token"`
2. Falls back to environment variables: `TELEGRAM_CHAT_ID` and `TELEGRAM_BOT_TOKEN`
3. This dual approach enables both interactive use and automation (cron, CI/CD)

**Security Model**:
- Bot token is sent via POST body (never in URL query parameters)
- JSON payloads constructed using `jq` to prevent injection attacks
- Error messages avoid exposing sensitive data
- Script output logs only non-sensitive information

## Key Conventions

**Message Format**: Messages support Telegram HTML formatting (`<b>`, `<i>`, etc.). The script always sends with `parse_mode: "HTML"` enabled.

**Exit Codes**: 
- Exit 1 for validation errors (missing parameters)
- Exit 1 for API failures
- Exit 0 on successful send

**Dependencies**: Requires `bash`, `curl`, and `jq`. No version constraints specified - assumes modern versions available via package managers.

## Testing

No automated tests exist. Manual testing approach:
1. Test with environment variables: `TELEGRAM_CHAT_ID=<id> TELEGRAM_BOT_TOKEN=<token> ./telegram_notify.sh "Test message"`
2. Test with arguments: `./telegram_notify.sh "Test message" "<chat_id>" "<bot_token>"`
3. Test HTML formatting: `./telegram_notify.sh "<b>Bold</b> and <i>italic</i>"`
4. Test error cases: missing arguments, invalid credentials

## Common Use Cases

The script is designed for:
- Server monitoring alerts (disk space, service status)
- CI/CD pipeline notifications
- Cron job completion/failure alerts
- Deployment notifications

Typical integration: Call from shell scripts, wrap in conditionals based on command exit codes, or use in cron jobs with command substitution for dynamic content.
