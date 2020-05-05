# Relva Media Stack

An all-in-one Docker compose media server for internet based hosting

## Features

  - SSL termination with LetsEncrypt certificates
  - OAuth2 authentication (such as Google accounts)
  - VPN for private Deluge and Jackett communication
  

### Applications

  - [Plex](https://hub.docker.com/r/plexinc/pms-docker/) for your own personal Netflix
  - [Sonarr](#sonarr-and-radarr) for managing your TV shows
  - [Radarr](#sonarr-and-radarr) for managing your movies
  - [Deluge](https://hub.docker.com/r/linuxserver/deluge/) for downloading torrents
  - [Jackett](https://hub.docker.com/r/linuxserver/jackett/) for searching torrents
  
#### Extras

  - [Tautulli](https://hub.docker.com/r/linuxserver/tautulli/) for monitoring Plex


## Setup

### Caddy

Caddy is an HTTP proxy, it is used to direct incoming SSL encrypted web traffic to the correct Docker container based on the requested hostname.

Create the `http` network which Caddy will use to communicate to containers with

```
docker network create http
```

Then create a `.env` file in [caddy/](caddy/) containing your LetsEncrypt e-mail address

```
CADDY_EMAIL=me@example.org
```

Then start Caddy using

```
cd caddy
docker-compose up -d
```

#### Virtual Host

Each application needs a `VIRTUAL_HOST` environment variable to tell Caddy what hostname to serve each application on.

The best way to achieve this is by creating `.env` files in the stack directory.

You can also define the virtual host when starting the application stack with

```
cd sonarr
VIRTUAL_HOST=sonarr.example.org docker-compose up -d
```

### OAuth

Each webapp comes with [oauth2_proxy](https://github.com/pusher/oauth2_proxy) to use Google authentication based on a list of valid e-mail addresses. 

Add your list of allowed Google Mail users to `/docker/auth/emails.txt` in the host directory.


## Applications

### [Sonarr](https://hub.docker.com/r/linuxserver/sonarr/) and [Radarr](https://hub.docker.com/r/linuxserver/radarr/)

> Replace the below with `radarr` to setup Radarr as well

| What | Where |
| ---- | ----- |
| Config | `/docker/sonarr` |
| TV Shows | `/ds/tvshows` |
| Movies | `/ds/movies` |
| Torrents | `/ds/torrent` |

```
cd sonarr
echo "VIRTUAL_HOST=sonarr.example.org" > .env
docker-compose up -d
```

Start and configure Jackett, then add a new Torznab indexer to Sonarr/Radarr. 
The URL and API Key to use for Jackett is `http://jackett-api:9117/torznab/all/` more details can be found in [this](https://www.reddit.com/r/PleX/comments/737foz/tip_if_you_use_jackett_for_indexers_you_can_set_a/) reddit post.

Configure and start Deluge, then add a new Deluge download client to Sonarr/Radarr.
The hostname to enter is `deluge-api` and the port is `8112`.

