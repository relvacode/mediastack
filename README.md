# Relva Media Stack

An all-in-one Docker compose media server for internet based hosting

## Features

  - SSL termination with LetsEncrypt certificates
  - OAuth2 authentication (such as Google accounts)
  - VPN for private Deluge and Jackett communication
  

### Applications

  - [Plex](https://hub.docker.com/r/plexinc/pms-docker/) for your own personal Netflix
  - [Tautulli](https://hub.docker.com/r/linuxserver/tautulli/) for monitoring Plex usage
  - [Sonarr](#sonarr-and-radarr) for managing your TV shows
  - [Radarr](#sonarr-and-radarr) for managing your movies
  - [Deluge](https://hub.docker.com/r/linuxserver/deluge/) for downloading torrents
  - [Jackett](https://hub.docker.com/r/linuxserver/jackett/) for searching torrents
  
#### Extras

  - [Tautulli](https://hub.docker.com/r/linuxserver/tautulli/) for monitoring Plex
  - [DenyHosts](http://denyhosts.sourceforge.net/) for protecting your server against repeated break-in attempts over SSH


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

Each application is protected Google authentication using [oauth2_proxy](https://github.com/pusher/oauth2_proxy).

Add your list of allowed Google Mail users to `/docker/auth/emails.txt` in the host directory. 

Follow [these instructions](https://pusher.github.io/oauth2_proxy/auth-configuration#google-auth-provider) on how to setup the Google authentication provider.

## Applications

#### [Plex](https://hub.docker.com/r/plexinc/pms-docker/) with [Tautulli](https://hub.docker.com/r/tautulli/tautulli/)

| What | Where |
| ---- | ----- |
| Plex Config | `/docker/plex` |
| TV Shows | `/ds/tvshows` |
| Movies | `/ds/movies` |

```
cd plex
echo "PLEX_VIRTUAL_HOST=plex.example.org" >> .env
echo "VIRTUAL_HOST=tautulli.example.org" >> .env
docker-compose up -d
```

Once Plex has started, to gain access from devices follow these steps (replace `PLEX_VIRTUAL_HOST` with the hostname you setup in your env file).

Note you do not need to enable Remote Access with this method.

  - Open `https://PLEX_VIRTUAL_HOST:3200` in your browser
  - Setup the server as usual
  - Go to `Settings` -> `Network`
  - Set `Secure connections` to `DISABLED`. This doesn't actually disable secure connections to your server as Caddy will be arbitrating TLS
  - Set `Custom server access URLs` to `https://PLEX_VIRTUAL_HOST:3200`

I also uncheck `Enable Relay` as I don't want my connections going via Plex's servers.

#### [Deluge](https://hub.docker.com/r/linuxserver/deluge/) with [VPN](https://hub.docker.com/r/dperson/openvpn-client/)

| What | Where |
| ---- | ----- |
| Deluge Config | `/docker/deluge` |
| VPN Config | `/docker/vpn` |
| Torrents | `/ds/torrent` |

```
cd deluge
echo "DELUGE_VIRTUAL_HOST=deluge.example.org" >> .env
echo "JACKETT_VIRTUAL_HOST=jackett.example.org" >> .env
docker-compose up -d
```

All downloads and tracker searches will use a secure VPN connection. Find the OpenVPN configuration from your VPN provider and place it in `/docker/vpn/vpn.conf`.

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
