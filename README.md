# Relva Media Stack

An all-in-one Docker compose media server for internet based hosting

## Features

  - Traefik for SSL termination with LetsEncrypt certificates
  - All applications protected by OAuth2 authentication (such as Google accounts)
  - Log forwarding to Kibana
  - VPN for private Deluge and Jackett communication
  

### Applications

  - [Plex](https://hub.docker.com/r/plexinc/pms-docker/) for your own personal Netflix
  - [Sonarr](#sonarr-and-radarr) for managing your TV shows
  - [Radarr](#sonarr-and-radarr) for managing your movies
  - [Deluge](https://hub.docker.com/r/linuxserver/deluge/) for downloading torrents
  - [Jackett](https://hub.docker.com/r/linuxserver/jackett/) for searching torrents
  
### Extra

  - [Minio](https://www.minio.io/) for accessing your files remotely
  - [Tautulli](https://hub.docker.com/r/linuxserver/tautulli/) for monitoring Plex


## Setup

### SSL Proxy

Configure traefik by adding your [configuration file](https://docs.traefik.io/basics/) to `ssl/traefik/traefik.toml`.
Then start traefik using

```
cd ssl
docker-compose up -d
```

#### Virtual Host

For each application to serve over HTTP/HTTPS the environment variable `VIRTUAL_HOST` is expected which instructs traefik what url host to serve that application on. 
Define the virtual host when starting the application stack with

```
cd sonarr
VIRTUAL_HOST=sonarr.example.org docker-compose up -d
```

### OAuth

Each application comes bundled with an [oauth2_proxy](https://hub.docker.com/r/a5huynh/oauth2_proxy/) authentication layer for providers like Google. This is not only useful to protect your applications against the internet but also to allow friends or family to login using their own credentials and monitor usage from the telemetry stack.

To configure and build your oauth image:

  - Add your [oauth2_proxy.cfg](https://github.com/bitly/oauth2_proxy/blob/master/contrib/oauth2_proxy.cfg.example) to `oauth/oauth2_proxy.cfg`
  - Add your list of e-mails to `oauth/users/emails.txt`
  - Run this command below to build the oauth image shared by all applications
  
    ```
    cd oauth
    docker-compose build --pull
    ```  

### Helper Scripts

Checkout this directory somewhere, then add this to your `~/.bashrc`

```
source <checkout_directory>/compose.sh
```

Now from anywhere on your file system you can call

```
compose <stack> <action>

compose ssl up -d
compose sonarr logs
```

Place an [env](sonarr/env) file in each stack to source environment variables

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
VIRTUAL_HOST=sonarr.example.org docker-compose up -d
```

Start and configure Jackett, then add a new Torznab indexer to Sonarr. 
The hostname you need to enter is `jackett-api` and the port is `80`.
You can add all Jackett sites as one Sonarr indexer using [this method](https://www.reddit.com/r/PleX/comments/737foz/tip_if_you_use_jackett_for_indexers_you_can_set_a/)

Configure and start Deluge, then add a new Deluge download client to Sonarr.
The hostname to enter is `deluge-api` and the port is `80`.

