#!/bin/bash
set -e

DB_PATH="/var/lib/judge0/judge0.db"

if [ ! -w "$(dirname "$DB_PATH")" ]; then
  echo "Error: $DB_PATH is not writable. Check volume and UID/GID settings."
  exit 1
fi

if [ ! -f "$DB_PATH" ]; then
  echo "Creating SQLite DB at $DB_PATH..."
  sqlite3 "$DB_PATH" "VACUUM;"
fi

# Start API and Nginx
/judge0-api --db sqlite://$DB_PATH --port 3000 &
nginx -g 'daemon off;'
