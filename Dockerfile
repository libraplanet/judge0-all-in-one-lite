# --- Stage 1: Use prebuilt Judge0 API from official image ---
FROM judge0/api:latest AS builder-api

# --- Stage 2: Get IDE static files ---
FROM alpine:3.19 AS builder-ide
RUN apk add --no-cache git
WORKDIR /build/ide
RUN git clone --depth 1 https://github.com/judge0/ide.git .

# --- Stage 3: Final container ---
FROM alpine:3.19
RUN apk add --no-cache bash nginx sqlite curl

# Create runtime user
RUN addgroup -S judge0 && adduser -S judge0 -G judge0

# Persistent DB path
RUN mkdir -p /var/lib/judge0 && chown -R judge0:judge0 /var/lib/judge0
VOLUME ["/var/lib/judge0"]

# Copy compiled Judge0 API and IDE
COPY --from=builder-api /usr/src/app/judge0-api /usr/local/bin/judge0-api
COPY --from=builder-ide /build/ide /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
