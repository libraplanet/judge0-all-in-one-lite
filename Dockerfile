# judge0-all-in-one-lite
# Lightweight all-in-one image for Judge0 API + IDE + SQLite

# --- Stage 1: Build Judge0 API ---
FROM golang:1.20-alpine AS builder-api
RUN apk add --no-cache git
WORKDIR /go/src/judge0
RUN git clone --depth 1 https://github.com/judge0/judge0.git .
RUN go build -o /judge0-api main.go

# --- Stage 2: Build Judge0 IDE ---
FROM node:18-alpine AS builder-ide
RUN apk add --no-cache git
WORKDIR /build/ide
RUN git clone --depth 1 https://github.com/judge0/ide.git .
RUN npm install && npm run build

# --- Stage 3: Final Container ---
FROM alpine:3.19

# Install runtime dependencies
RUN apk add --no-cache bash nginx sqlite curl

# Create app user (can be overridden by --user)
RUN addgroup -S judge0 && adduser -S judge0 -G judge0

# Create database directory (FHS compliant)
RUN mkdir -p /var/lib/judge0 && chown -R judge0:judge0 /var/lib/judge0
VOLUME ["/var/lib/judge0"]

# Copy built artifacts
COPY --from=builder-api /judge0-api /usr/local/bin/judge0-api
COPY --from=builder-ide /build/ide/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose the unified HTTP port
EXPOSE 80

# Default entrypoint (use host UID:GID via --user)
ENTRYPOINT ["/entrypoint.sh"]
