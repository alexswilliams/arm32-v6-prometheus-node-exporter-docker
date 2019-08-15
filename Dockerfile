FROM arm32v6/alpine:3.10.1

ARG VERSION
ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Prometheus Node Exporter (arm32v6)" \
      org.label-schema.description="Prometheus Node Exporter - Repackaged for ARM32v6" \
      org.label-schema.url="https://prometheus.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/alexswilliams/arm32-v6-prometheus-node-exporter-docker" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"

RUN mkdir /app \
    && cd /app \
    && wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.linux-armv6.tar.gz \
    && tar xzf node_exporter-${VERSION}.linux-armv6.tar.gz \
    && rm -f node_exporter-${VERSION}.linux-armv6.tar.gz \
    && cp node_exporter-${VERSION}.linux-armv6/node_exporter /bin/ \
    && rm -rf /app

COPY run.sh /run.sh
ENV NODE_EXP_VERSION=${VERSION}

EXPOSE 9100
USER nobody
ENTRYPOINT [ "sh", "/run.sh" ]