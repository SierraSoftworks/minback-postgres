#! /bin/bash
set -e

DB="$1"

mc config host add pg "$MINIO_SERVER" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" "$MINIO_API_VERSION" > /dev/null

ARCHIVE="${MINIO_BUCKET}/${DB}-$(date $DATE_FORMAT).archive"

echo "Dumping $DB to $ARCHIVE"
echo "> pg_dump ${@:2} -F custom $DB"

pg_dump "${@:2}" -F custom "$DB" | mc pipe "pg/$ARCHIVE" || mc rm "pg/$ARCHIVE"

echo "Backup complete"