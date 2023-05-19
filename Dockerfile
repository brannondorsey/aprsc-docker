# debian 11 is the most recent debian version that aprsc supports
FROM debian:bullseye-slim

# Install requirements
RUN apt-get update && apt-get install -y gnupg

# add signing key and deb source, install aprsc
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys C51AA22389B5B74C3896EF3CA72A581E657A2B8D && \
    gpg --export C51AA22389B5B74C3896EF3CA72A581E657A2B8D > /etc/apt/trusted.gpg.d/aprsc.gpg && \
    chown root:root /etc/apt/trusted.gpg.d/aprsc.gpg && chmod 644 /etc/apt/trusted.gpg.d/aprsc.gpg && \
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/aprsc.gpg] http://aprsc-dist.he.fi/aprsc/apt $(cat /etc/os-release | grep VERSION_CODENAME | awk '{gsub("VERSION_CODENAME=", "");print}') main" > /etc/apt/sources.list.d/aprsc.list && \
    apt-get update && \
    apt-get install -y aprsc

# change the aprsc user's uid to 1000 so that volume permissions translate
# between the first non-root user on the host
RUN usermod -u 1000 aprsc

# start the service and follow the logs so that container doesn't exit
CMD service aprsc start && tail -F /opt/aprsc/logs/aprsc.log
