# Docker container for [rsntp](https://github.com/mlichvar/rsntp)

```sh
# Build
docker build -t publicarray/rsntp .
# Run
docker run -it --rm --name rsntp -p123:123/udp publicarray/rsntp
# Or use your own arguments
docker run -it --rm --name rsntp -p123:123/udp publicarray/rsntp -- -h
docker run -it --rm --name rsntp -p123:123/udp publicarray/rsntp -d ntp
# Always restart and run as a daemon
docker run -d --restart always --name rsntp -p123:123/udp publicarray/rsntp
```

## Prevent conntrack from filling up

```sh
# get current status:
$ contrack -C
$ sysctl net.netfilter.nf_conntrack_max

# disable conntrack on NTP port 123
$ iptables -t raw -A PREROUTING -p udp -m udp --dport 123 -j NOTRACK
$ iptables -t raw -A OUTPUT -p udp -m udp --sport 123 -j NOTRACK
