# Fetch the mc command line client
FROM alpine:3.7
RUN apk update && apk add ca-certificates wget && update-ca-certificates
RUN wget -O /tmp/mc https://dl.minio.io/client/mc/release/linux-amd64/mc
RUN chmod +x /tmp/mc

# Then build our backup image
FROM postgres:10.3-alpine
LABEL maintainer="Benjamin Pannell <admin@sierrasoftworks.com>"

COPY --from=0 /tmp/mc /usr/bin/mc

ENV MINIO_SERVER=""
ENV MINIO_BUCKET="backups"
ENV MINIO_ACCESS_KEY=""
ENV MINIO_SECRET_KEY=""
ENV MINIO_API_VERSION="S3v4"

ENV DATE_FORMAT="+%Y-%m-%d"

ADD entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]