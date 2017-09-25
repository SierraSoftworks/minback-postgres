# minback-mongo
**Minio Backup container for PostgreSQL**

This container provides a trivially simple means to run `pg_dump` and fire the results off
to a [Minio][] instance. It is intended to be run in conjunction with a [Kubernetes CronJob][]
to maintain a frequent backup of your critical data with minimal fuss.

## Features
* Dumps a single PostgreSQL database to an S3 bucket
* Lightweight and short lived
* Simple and readable implementation

## Example
```sh
docker run --rm --env-file backup.env minback/postgres my_db -h pgserver1
```

#### `backup.env`
```
MINIO_SERVER=https://play.minio.io/
MINIO_ACCESS_KEY=minio
MINIO_SECRET_KEY=miniosecret
MINIO_BUCKET=backups
```

## Usage
```
DB_NAME [OPTIONS...]

Arguments
  DB_NAME  - The name of the database you wish to backup
  OPTIONS  - Any additional options you wish to pass to mongodump
```

## Configuration
This container is configured using environment variables, enabling it to easily be started
manually or automatically and integrate well with Kubernetes' configuration framework.

#### `MINIO_SERVER=https://play.minio.io/`
The Minio server you wish to send backups to.

#### `MINIO_ACCESS_KEY=minio`
The Access Key used to connect to your Minio server.

#### `MINIO_SECRET_KEY=miniosecret`
The Secret Key used to connect to your Minio server.

#### `MINIO_BUCKET=backups`
The Minio bucket you wish to store your backup in.

### `DATE_FORMAT=+%Y-%m-%d`
The date format you would like to use when naming your backup files. Files are named `$DB-$DATE.archive`.

[Kubernetes CronJob]: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/
[Minio]: https://minio.io/
