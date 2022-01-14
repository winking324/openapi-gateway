#!/bin/bash

OPENAPI_NET=openapi-gateway.net

# 1 init
docker volume create vol-openapi-gateway-db
docker volume create vol-openapi-dashboard-db
docker network create ${OPENAPI_NET}

# 2 init konga
## 2.1 create konga database
docker run -d --name openapi-dashboard-db \
    --net $OPENAPI_NET \
    -e "POSTGRES_USER=konga" \
    -e "POSTGRES_PASSWORD=konga" \
    -v vol-openapi-dashboard-db:/var/lib/postgresql/data \
    postgres:11-alpine
## 2.2 setup konga to init database
docker run --rm \
    --net $OPENAPI_NET \
    -e "DB_ADAPTER=postgres" \
    -e "DB_HOST=openapi-dashboard-db" \
    -e "DB_PORT=5432" \
    -e "DB_USER=konga" \
    -e "DB_PASSWORD=konga" \
    -e "NODE_ENV=development" \
    -e "KONGA_HOOK_TIMEOUT=120000" \
    pantsel/konga:latest
## 2.3 stop database
docker rm -f openapi-dashboard-db

# 3 init kong
## 3.1 create kong database
docker run -d --name openapi-gateway-db \
    --net $OPENAPI_NET \
    -e "POSTGRES_DB=kong" \
    -e "POSTGRES_USER=kong" \
    -e "POSTGRES_PASSWORD=kong" \
    -v vol-openapi-gateway-db:/var/lib/postgresql/data \
    postgres:11-alpine
## 3.2 setup kong to init database
docker run --rm \
  --net $OPENAPI_NET \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=openapi-gateway-db" \
  -e "KONG_PG_PASSWORD=kong" \
  kong:alpine kong migrations bootstrap
## 3.3 stop database
docker rm -f openapi-gateway-db