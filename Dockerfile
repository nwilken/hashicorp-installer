FROM amazonlinux:2
LABEL maintainer="Nate Wilken <wilken@asu.edu>"

# adapted from https://github.com/sethvargo/hashicorp-installer

RUN set -x && \
    yum update -y && \
    yum install -y unzip && \
    yum clean all && \
    rm -rf /var/cache/yum /var/log/yum.log

# Install the hashicorp gpg key - the key exists on keyservers, but they aren't
# reliably available. After a lot of testing, it's easier to just manage the key
# ourselves.
COPY hashicorp.asc /tmp/hashicorp.asc
COPY hashicorp.trust /tmp/hashicorp.trust
RUN \
  gpg --import /tmp/hashicorp.asc && \
  gpg --import-ownertrust /tmp/hashicorp.trust && \
  rm /tmp/hashicorp.asc && \
  rm /tmp/hashicorp.trust

# Install the helper tool
COPY install-hashicorp-tool.sh /install-hashicorp-tool
RUN chmod +x /install-hashicorp-tool

# Where the software will be
RUN mkdir -p /software

# Setup the entrypoint
ENTRYPOINT ["/install-hashicorp-tool"]
