FROM arm32v6/alpine:3.11.5
# Updated here: https://hub.docker.com/r/arm32v6/alpine/tags
# Inspired from: https://github.com/prometheus/node_exporter/blob/master/Dockerfile

ARG VERSION
ARG VCS_REF
ARG BUILD_DATE
ENV NODE_EXP_VERSION=${VERSION}

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Prometheus Node Exporter (arm32v6)" \
      org.label-schema.description="Prometheus Node Exporter - Repackaged for ARM32v6" \
      org.label-schema.url="https://prometheus.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/alexswilliams/arm32-v6-prometheus-node-exporter-docker" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

RUN apk add bash coreutils \
    && mkdir /app \
    && cd /app \
    && wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-armv6.tar.gz \
    && tar xzf node_exporter-${VERSION}.linux-armv6.tar.gz \
    && rm -f node_exporter-${VERSION}.linux-armv6.tar.gz \
    && cp node_exporter-${VERSION}.linux-armv6/node_exporter /bin/ \
    && rm -rf /app

USER nobody
EXPOSE 9100
COPY run.sh /run.sh
ENTRYPOINT [ "/run.sh" ]
