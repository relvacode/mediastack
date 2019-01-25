#!/bin/bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${DIR}/compose.sh"

update () {
        echo "updating ${1}..."
        for service in ${@:2}
	do
		compose "${1}" pull --quiet "${2}"
        done
        compose "${1}" up -d
}

compose oauth build --pull 

update ssl traefik &
update plex media-server tautulli &
update deluge vpn deluge &
update sonarr sonarr &
update radarr radarr &
wait
