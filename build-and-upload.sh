#!/usr/bin/env bash

set +ex

function buildAndPush {
    local version=$1
    docker build -t alexswilliams/arm32v6-prometheus-node-exporter:${version} --build-arg VERSION=${version} --file Dockerfile.arm32v6 .
    docker push alexswilliams/arm32v6-prometheus-node-exporter:${version}
}

buildAndPush "0.17.0"

