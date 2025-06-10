#
# build container
#
FROM --platform=linux/amd64 golang:1.19-alpine as builder
WORKDIR /

COPY clickhouse_exporter_linux_amd64 /clickhouse_exporter_linux_amd64

EXPOSE     9116
ENTRYPOINT ["/clickhouse_exporter_linux_amd64"]
