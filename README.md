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
  
#### Extra

  - [Minio](https://www.minio.io/) for accessing your files remotely using S3 protocol
  - [DenyHosts](http://denyhosts.sourceforge.net/) for protecting your server against repeated break-in attempts over SSH


## Setup

### Traefik v1.7 SSL Proxy

Traefik acts as a proxy to all of your applications. It can generate SSL certificates and knows how to proxy to your applications by inspecting Docker.

Configure Traefik by adding this example configuration file `/docker/traefik/traefik.toml`:

```
debug = false

logLevel = "INFO"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
  [entryPoints.https.tls]
  minVersion = "VersionTLS12"
  cipherSuites = [
        "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
        "TLS_RSA_WITH_AES_256_GCM_SHA384"
       ]

[retry]

[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "<your_domain>"
watch = true
exposedByDefault = false

[acme]
email = "<your_email>"
storage = "/acme.json"
entryPoint = "https"
[acme.dnsChallenge]
provider = "digitalocean"
[[acme.domains]]
  main = "*.<your_domain>"
```

Create the `http` network which traefik will use to proxy http services

```
docker network create http
```

Then start traefik using

```
cd traefik
docker-compose up -d
```

This example is using `dns` chanellenge which means I need to provide `DO_AUTH_TOKEN` when starting the Trafeik container

This example uses strong TLS cipher suites which may not be supported by legacy web browsers.

#### Virtual Host

Each compose stack needs to have the environment variable `VIRTUAL_HOST` defined when starting the stack. It tells Traefik what hostname to serve the application on.

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

## Stacks

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
