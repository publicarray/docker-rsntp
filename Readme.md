```sh
# Build
docker build -t publicarray/rsntp .
# Run
docker run -it --rm --name rsntp -p123:123/udp publicarray/rsntp
# Or your own arguments
docker run -it --rm --name rsntp -p123:123/udp publicarray/rsntp -- -h
docker run -it --rm --name rsntp -p123:123/udp publicarray/rsntp -d ntp
# Always restart / always online service
docker run -d --restart always --name rsntp -p123:123/udp publicarray/chrony
```
