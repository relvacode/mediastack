COMPOSE_BASE=/var/lib/docker-compose
compose () {
	stack="${1}"
	shift
        set -a
        source ${COMPOSE_BASE}/globals

	if [[ -a ${COMPOSE_BASE}/${stack}/env ]]
	then
		source ${COMPOSE_BASE}/${stack}/env
	fi		
	set +a

	(set -a && cd ${COMPOSE_BASE}/${stack} && docker-compose $@)
}
