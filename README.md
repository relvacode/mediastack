# mediastack

Sonarr, Radarr and Plex PMS media server docker-compose stacks. 
Features VPN enabled Deluge client and frontend SSL proxy with Let's Encrypt certificates.

The docker-compose environment variable `VIRTUAL_HOST` describes the domain to access Sonnarr, Radarr and Deluge on via the SSL proxy.
