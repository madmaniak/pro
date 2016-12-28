FROM debian:latest

RUN mkdir -p /tmp/disque-deb

ADD disque-1.0-rc1-0192ba7e-amd64.deb /tmp/disque-deb/disque-1.0-rc1-0192ba7e-amd64.deb

RUN dpkg -i /tmp/disque-deb/disque-1.0-rc1-0192ba7e-amd64.deb
