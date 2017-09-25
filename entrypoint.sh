#! /bin/bash
set -e

DB="$1"
ARGS="${@:2}"

mc config host add pg "$MINIO_SERVER" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" "$MINIO_API_VERSION" > /dev/null

ARCHIVE="${MINIO_BUCKET}/${DB}-$(date $DATE_FORMAT).archive"

echo "Dumping $DB to $ARCHIVE"
echo "> pg_dump ${ARGS} -Fc $DB"

pg_dump $ARGS -Fc "$DB" | mc pipe "pg/$ARCHIVE" || { echo "Backup failed"; mc rm "pg/$ARCHIVE"; exit 1; }

echo "Backup complete"