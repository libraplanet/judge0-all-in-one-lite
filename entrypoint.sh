#!/bin/sh

# Start API in background
/judge0-api --sqlite-db=/var/lib/judge0/judge0.db &

# Start nginx (foreground)
nginx -g 'daemon off;'
