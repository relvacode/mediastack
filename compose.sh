#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

compose () {
        stack="${1}"; shift
        set -a
        if [[ -a ${DIR}/${stack}/env ]]
        then
                source ${DIR}/${stack}/env
        fi
        set +a
        (set -a && cd ${DIR}/${stack} && docker-compose $@)
}
