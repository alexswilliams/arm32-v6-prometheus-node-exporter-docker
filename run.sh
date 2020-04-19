#!/bin/bash

echo "Starting Prometheus Node Exporter $NODE_EXP_VERSION"
echo "Relevant Environment Variables (NODE_EXP_*):"
env | grep NODE_EXP
echo ""


# Main flags updated here: https://github.com/prometheus/node_exporter/blob/master/node_exporter.go
# Logger flags updated here: https://github.com/prometheus/common/blob/master/promlog/flag/flag.go
# Generic collector flags updated here: https://github.com/prometheus/node_exporter/blob/master/collector/collector.go

# To find new flags, search the repo for "kingpin" and "registerCollector"


# Booleans are treated specially in kingpin so they need passing in differently.
declare -a booleans=(
    web.disable-exporter-metrics
    collector.disable-defaults
    collector.ntp
    collector.ntp.server-is-local
    collector.systemd
    collector.systemd.private
    collector.systemd.enable-task-metrics
    collector.systemd.enable-restarts-metrics
    collector.systemd.enable-start-time-metrics
    collector.vmstat
    collector.runit
    collector.filesystem
    collector.qdisc
    collector.supervisord
    collector.textfile
    collector.diskstats
    collector.powersupplyclass
    collector.netclass
    collector.netstat
    collector.cpu
    collector.cpu.info
    collector.wifi
    collector.perf
    collector.boottime
    collector.entropy
    collector.interrupts
    collector.loadavg
    collector.time
    collector.uname
    collector.buddyinfo
    collector.conntrack
    collector.diskstats
    collector.ksmd
    collector.meminfo
    collector.rapl
    collector.arp
    collector.exec
    collector.filefd
    collector.stat
    collector.thermal_zone
    collector.zfs
    collector.cpufreq
    collector.netdev
    collector.softnet
    collector.bonding
    collector.udp_queues
    collector.schedstat
    collector.devstat
    collector.meminfo_numa
    collector.meminfo
    collector.pressure
    collector.process
    collector.sockstat
    collector.mdadm
    collector.tcpstat
    collector.edac
    collector.logind
    collector.timex
    collector.xfs
    collector.btrfs
    collector.drbd
    collector.ipvs
    collector.infiniband
    collector.hwmon
    collector.nfsd
    collector.mountstats
)
declare -a flags=(
    web.listen-address
    web.telemetry-path
    web.max-requests
    web.config
    log.format
    log.level
    path.procfs
    path.sysfs
    path.rootfs
    collector.ntp.server
    collector.ntp.protocol-version
    collector.ntp.ip-ttl
    collector.ntp.max-distance
    collector.ntp.local-offset-tolerance
    collector.systemd.unit-whitelist
    collector.systemd.unit-blacklist
    collector.vmstat.fields
    collector.runit.servicedir
    collector.filesystem.ignored-mount-points
    collector.filesystem.ignored-fs-types
    collector.filesystem.mount-timeout
    collector.qdisc.fixtures
    collector.supervisord.url
    collector.textfile.directory
    collector.diskstats.ignored-devices
    collector.powersupply.ignored-supplies
    collector.netclass.ignored-devices
    collector.netstat.fields
    collector.wifi.fixtures
    collector.perf.cpus
    collector.perf.tracepoint
)

declare -a command=(
    "/bin/node_exporter"
)

for flag in "${booleans[@]}"; do
    envVarName="NODE_EXP_$(echo "${flag}" | tr 'a-z-.' 'A-Z__')"
    lowerVarValue="$(echo "${!envVarName}" | tr 'A-Z' 'a-z')"
    if [ ! -z "${lowerVarValue}" ]; then
        if [ "${lowerVarValue}" == "true" ]; then command+=("--${flag}"); else command+=("--no-${flag}"); fi
    fi
done
for flag in "${flags[@]}"; do
    envVarName="NODE_EXP_$(echo "${flag}" | tr 'a-z-.' 'A-Z__')"
    if [ ! -z "${!envVarName}" ]; then
        command+=("--${flag}=${!envVarName}")
    fi
done

unset envVarName lowerVarValue flag booleans flags
set -ex

exec "${command[@]}" $@
