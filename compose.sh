#!/usr/bin/env bash

# Docker Compose Entry Script
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Wraps docker-compose to first change directory to 
# argument $1 relative to this script.
# You can either source this in your bash profile
# or execute it directly.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

compose () {
        stack="${1}"; shift
        (set -a && cd ${DIR}/${stack} && exec docker-compose $@)
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    compose $@
fi
