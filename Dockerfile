FROM alpine:3.10
LABEL maintainer "publicarray"
LABEL description "High-performance NTP server written in Rust. https://github.com/mlichvar/rsntp"
ENV REVISION 1

ENV BUILD_DEPS rust cargo git

RUN apk add --no-cache $BUILD_DEPS

RUN set -x && \
    cd /tmp && \
    git clone https://github.com/mlichvar/rsntp && \
    cd rsntp && \
    cargo build --release && \
    cp target/release/rsntp /usr/local/bin/rsntp

#------------------------------------------------------------------------------#
FROM alpine:3.9

ENV RUN_DEPS libgcc runit shadow curl

RUN apk add --no-cache $RUN_DEPS

COPY --from=0 /usr/local/bin/rsntp /usr/local/bin/rsntp

RUN set -x && \
    groupadd _rsntp && \
    useradd -g _rsntp -s /dev/null -d /dev/null _rsntp

COPY entrypoint.sh /

EXPOSE 123/udp

RUN rsntp --help

ENTRYPOINT ["/entrypoint.sh"]
