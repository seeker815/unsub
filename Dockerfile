FROM ubuntu:14.04
MAINTAINER Sean Clemmer <sclemmer@bluejeans.com>
COPY pkg /tmp/
RUN dpkg -i /tmp/*.deb
RUN rm -rf /tmp/*
ENTRYPOINT [ "unsub" ]