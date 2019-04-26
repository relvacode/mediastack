#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

compose () {
        stack="${1}"; shift
        (set -a && cd ${DIR}/${stack} && docker-compose $@)
}
