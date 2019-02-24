# debian 8 is the most recent debian version that aprsc supports
FROM debian:jessie-slim

# add the deb source
# add the signing key
# apt update
# install the aprsc debian package
RUN echo "deb http://aprsc-dist.he.fi/aprsc/apt jessie main" > /etc/apt/sources.list.d/aprsc.list && \
    gpg --keyserver keys.gnupg.net --recv 657A2B8D && \
    gpg --export C51AA22389B5B74C3896EF3CA72A581E657A2B8D | apt-key add - && \
    apt-get update && \
    apt-get install -y aprsc

# change the aprsc user's uid to 1000 so that volume permissions translate
# between the first non-root user on the host
RUN usermod -u 1000 aprsc

# start the service and follow the logs so that container doesn't exit
CMD service aprsc start && tail -F /opt/aprsc/logs/aprsc.log
