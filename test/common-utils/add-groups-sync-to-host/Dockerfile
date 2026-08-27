FROM debian:bullseye

# Simulate a host-provided group file with a non-standard GID for docker.
RUN mkdir -p /host/etc \
    && printf 'docker:x:4242:\n' > /host/etc/group
