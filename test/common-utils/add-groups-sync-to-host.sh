#!/bin/bash

set -e

source dev-container-features-test-lib

check "docker group exists" getent group docker
check "docker group gid matches host group file" bash -lc "test \"$(getent group docker | cut -d: -f3)\" = \"$(grep -m1 '^docker:' /host/etc/group | cut -d: -f3)\""
check "alternate in docker" bash -lc "id -nG alternate | tr ' ' '\n' | grep -Fx docker"

reportResults
