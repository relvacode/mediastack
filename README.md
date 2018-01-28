# mediastack

[Sonarr](https://hub.docker.com/r/linuxserver/sonarr/), [Radarr](https://hub.docker.com/r/linuxserver/radarr/) and [Plex PMS](https://hub.docker.com/r/plexinc/pms-docker/) media server docker-compose stacks. 

## Features

  - All web applications protected by OAuth2 (such as Google accounts)
  - SSL terminating proxy with LetsEncrypt certificates
  - VPN enabled Deluge client
  
## Files

These stacks assume that all media and torrent data is stored in `/var/lib/ds`.

All applicaition data is stored in `/var/lib/docker/persistence`.
  
## Web

### SSL Proxy

The environment variable `VIRTUAL_HOST` tells the SSL proxy what DNS domain to host each application on

```
VIRTUAL_HOST=sonarr.myserver.com docker-compose up
```

Each application needs its own subdomain to work on, the easiest way to achieve this is to add a wildcard DNS entry for your server and proxy each application to your subdomain of choice. SSL certificates for that domain will be signed automatically.

### Oauth

Each application comes bundled with [oauth2_proxy](https://hub.docker.com/r/a5huynh/oauth2_proxy/) for authentication using providers like Google which allows multiple users to login to your server using just their Google account.

A configuration file is expected on the host in `/var/lib/docker/persistence/oauth/oauth2_proxy.cfg` an example configuration file can be found [here](https://github.com/bitly/oauth2_proxy/blob/master/contrib/oauth2_proxy.cfg.example).


Features VPN enabled Deluge client and a global frontend SSL proxy with Let's Encrypt certificates.

Authentication access to Sonarr and Radarr is protected by 

The docker-compose environment variable `VIRTUAL_HOST` describes the domain to access Sonnarr, Radarr and Deluge on via the SSL proxy.
