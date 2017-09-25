#! /bin/bash
set -e

DB="$1"
ARGS="${@:2}"

mc config host add pg "$MINIO_SERVER" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY" "$MINIO_API_VERSION" > /dev/null

ARCHIVE="${MINIO_BUCKET}/${DB}-$(date $DATE_FORMAT).archive"

if [[ ! -z "$PGUSER" ]]; then
    ARGS+="-U $PGUSER"
fi

if [[ ! -z "$PGPASSWORD" ]]; then
    echo "*:*:*:*:${PGPASSWORD}" > /tmp/pgpass
    export PGPASSFILE=/tmp/pgpass
fi

echo "Dumping $DB to $ARCHIVE"
echo "> pg_dump ${ARGS} -F custom $DB"

pg_dump "${ARGS}" -F custom "$DB" | mc pipe "pg/$ARCHIVE" || mc rm "pg/$ARCHIVE"

echo "Backup complete"