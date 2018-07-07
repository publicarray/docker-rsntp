#!/bin/sh
set -e

getServiceIP () {
    nslookup "$1" 2>/dev/null | grep -oE '(([0-9]{1,3})\.){3}(1?[0-9]{1,3})'
}

waitOrFail () {
    maxTries=24
    i=0
    while [ $i -lt $maxTries ]; do
        outStr="$($@)"
        if [ $? -eq 0 ];then
            echo "$outStr"
            return
        fi
        i=$((i+1))
        echo "==> waiting for a dependent service $i/$maxTries" >&2
        sleep 5
    done
    echo "Too many failed attempts" >&2
    exit 1
}

NTP_SERVICE_HOST=${NTP_SERVICE_HOST-"127.0.0.1"}
NTP_SERVICE_PORT=${NTP_SERVICE_PORT-"123"}
while getopts "h?d" opt; do
    case "$opt" in
        h|\?) echo "-d  DNS lookup for service discovery"; exit 0;;
        d) shift; NTP_SERVICE_HOST="$(waitOrFail getServiceIP "${1-"ntp-server"}")";;
    esac
done
shift $((OPTIND-1))
export NTP_SERVER="$NTP_SERVICE_HOST:$NTP_SERVICE_PORT"

if [ $# -eq 0 ]; then
    echo "rsntp - ntp server-address: $NTP_SERVER"
    exec /usr/local/bin/rsntp -s "${NTP_SERVER}"
fi

[ "$1" = '--' ] && shift

exec /usr/local/bin/rsntp "$@"
