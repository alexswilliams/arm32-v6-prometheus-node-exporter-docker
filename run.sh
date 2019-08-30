#!/bin/sh

echo "Starting Prometheus Node Exporter $NODE_EXP_VERSION"
echo "Relevant Environment Variables (NODE_EXP_*):"
env | grep NODE_EXP

/bin/node_exporter \
    --collector.filesystem.ignored-mount-points=${NODE_EXP_COLLECTOR_FILESYSTEM_IGNORED_MOUNT_POINTS:-^/(dev|proc|sys|var/lib/docker/.+)($|/)} \
    --path.procfs=${NODE_EXP_PATH_PROCFS:-/proc} \
    --path.sysfs=${NODE_EXP_PATH_SYSFS:-/sys} \
    --path.rootfs=${NODE_EXP_PATH_ROOTFS:-/} \
    --web.listen-address=${NODE_EXP_WEB_LISTEN_ADDRESS:-:9100} \
    $@

