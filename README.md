# mediastack

[Sonarr](https://hub.docker.com/r/linuxserver/sonarr/), [Radarr](https://hub.docker.com/r/linuxserver/radarr/) and [Plex PMS](https://hub.docker.com/r/plexinc/pms-docker/) media server docker-compose stacks. 
Features VPN enabled Deluge client and a global frontend SSL proxy with Let's Encrypt certificates.

Authentication access to Sonarr and Radarr is protected by [oauth2_proxy](https://hub.docker.com/r/a5huynh/oauth2_proxy/)

The docker-compose environment variable `VIRTUAL_HOST` describes the domain to access Sonnarr, Radarr and Deluge on via the SSL proxy.

## Files

The stacks assume that all persistent data is bound to `/var/lib/docker/persistence`.

  - VPN configuration is expected at `/var/lib/docker/persistence/vpn/vpn.conf`
  - oauth2_proxy configuration is expected at `/var/lib/docker/persistence/oauth/oauth2_proxy.cfg`

The stack also assumes that media data such as movies and TV shows are bound to `/var/lib/ds`
