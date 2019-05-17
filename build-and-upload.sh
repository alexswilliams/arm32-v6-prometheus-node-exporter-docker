#!/usr/bin/env bash

set -ex

function buildAndPush {
    local version=$1
    local imagename="alexswilliams/arm32v6-prometheus-node-exporter"
    local fromline=$(grep -e '^FROM ' Dockerfile.arm32v6 | tail -n -1 | sed 's/^FROM[ \t]*//' | sed 's#.*/##' | sed 's/:/-/' | sed 's/#.*//' | sed -E 's/[ \t]+.*//')
    local fromlineshort=$(echo ${fromline} | sed 's/:.*//')

    docker build -t ${imagename}:${version} \
        --build-arg VERSION=${version} \
        --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
        --build-arg VCS_REF=$(git rev-parse --short HEAD) \
        --file Dockerfile.arm32v6 . \
    && docker tag ${imagename}:${version} ${imagename}:${version}-${fromline} \
    && docker tag ${imagename}:${version} ${imagename}:${version}-${fromlineshort} \
    && docker push ${imagename}:${version} \
    && docker push ${imagename}:${version}-${fromline} \
    && docker push ${imagename}:${version}-${fromlineshort}
}

buildAndPush "0.17.0"
buildAndPush "0.18.0"

