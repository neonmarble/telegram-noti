# syntax=docker/dockerfile:1
FROM alpine:3.21

# Install dependencies
RUN apk add --no-cache bash curl jq

# Create non-root user with specific UID/GID
RUN addgroup -g 1001 -S appuser && \
    adduser -S appuser -u 1001 -G appuser

# Set working directory
WORKDIR /app

# Copy script with proper ownership
COPY --chown=appuser:appuser telegram_notify.sh .

# Make script executable
RUN chmod +x telegram_notify.sh

# Switch to non-root user
USER appuser

# Use ENTRYPOINT + CMD pattern for flexibility
ENTRYPOINT ["/app/telegram_notify.sh"]
CMD [""]
