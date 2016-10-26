# Docker container for NCBO 4-store
#
# VERSION 0.1

# Pull base image.
FROM ubuntu:14.04

MAINTAINER Vincent Emonet, vincent.emonet@gmail.com

# Install packages.
RUN apt-get update && \
    apt-get install -y git supervisor make automake gperf libtool flex bison \
            libssl-dev libraptor2-0 librasqal3 libraptor2-dev \
            librasqal3-dev ncurses-base libncurses5 \
            libncurses5-dev libreadline6-dev uuid-dev libglib2.0-dev && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Install 4store
RUN \
  cd /tmp && \
  git clone https://github.com/ncbo/4store.git && \
  cd 4store && \
  ./autogen.sh && \
  ./configure && \
  make && \
  make install && \
  4s-backend-setup default && \
  4s-backend default

# Define working directory.
WORKDIR /data


# Define default command.
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# docker run -d -p 9000:9000 vemonet/bioportal-4store
