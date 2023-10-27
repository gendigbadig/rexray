FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y xfsprogs e2fsprogs ca-certificates nvme-cli
RUN rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
RUN mkdir -p /etc/rexray /run/docker/plugins /var/lib/rexray/volumes
ADD rexray /usr/bin/rexray
ADD rexray.yml /etc/rexray/rexray.yml

ADD ebsnvme-id /usr/sbin/ebsnvme-id
ADD rexray.sh /rexray.sh
RUN chmod +x /rexray.sh /usr/sbin/ebsnvme-id

CMD [ "rexray", "start", "--nopid" ]
ENTRYPOINT [ "/rexray.sh" ]
