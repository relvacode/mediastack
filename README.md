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
  
#### Extra

  - [Minio](https://www.minio.io/) for accessing your files remotely using S3 protocol
  - [Tautulli](https://hub.docker.com/r/linuxserver/tautulli/) for monitoring Plex


## Setup

### Traefik SSL Proxy

Configure traefik by adding your [configuration file](https://docs.traefik.io/basics/) to `/docker/traefik/traefik.toml`.

My configuration looks like this

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

My configuration is using `dns` chanellenge which means I need to provide `DO_AUTH_TOKEN` when starting the Trafeik container. 
See [acme configuration](https://docs.traefik.io/configuration/acme/) to find out more.

I am using strong TLS cipher suites which may not be supported by legacy web browsers.

#### Virtual Host

For each application to serve over HTTP/HTTPS the environment variable `VIRTUAL_HOST` is expected which instructs traefik what url host to serve that application on.

The best way to achieve this is by creating `.env` files in the stack directory.

You can also define the virtual host when starting the application stack with

```
cd sonarr
VIRTUAL_HOST=sonarr.example.org docker-compose up -d
```

### OAuth

Each webapp comes with [oauth2_proxy](https://github.com/pusher/oauth2_proxy) to use Google authentication based on a list of valid e-mail addresses. 

Add your list of allowed Google Mail users to `/docker/auth/emails.txt` in the host directory.


## Stacks

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

