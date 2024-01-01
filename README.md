# Managed Media Stack

## Extended Documentation
[todo-docs-plus](./todo-docs-plus.py) is included in this repository. It created the documentation
in the [Docs](./Docs/) diretory.

- [manage TODOs](./Docs/TODO_manage.md)
- [manage Functions](./Docs/FUNCTION_manage.md)

## Quickstart

### Clone the repository

        git clone https://github.com/spencerbutler/managed-media-stack.git
        cd managed-media-stack

### Create `global.conf`

        cp global-example.conf global.conf

### Customize `global.conf`

Change `DOMAIN_NAME` to your domain. This domain should be configured as a [wildcard DNS domain](https://en.wikipedia.org/wiki/Wildcard_DNS_record).

```bash
DOMAIN_NAME=wildcard.example.com  # Wildcard domain name (*.domain.name.tld)
```

### Update `PUID` and `PGID` (optional)

You can use `id -u` and `id -g` to get the values for your user. This allows the image
to run as your user and group ID.

```bash
PUID=1000
PGID=1000
```

### Choose the ITEMS (docker apps) that you want to run

This is the default list. You can modify (or add new) as you see fit.

```bash
# STACK_ITEMS["ITEM"]="PORT=PROVIDER=TAG=ENABLED"
STACK_ITEMS["traefik"]="443=''=:latest=true"                # Official docker container, no provider name.
STACK_ITEMS["bazarr"]="6767=linuxserver/=:latest=true"
STACK_ITEMS["lidarr"]="8686=linuxserver/=:latest=true"
STACK_ITEMS["nzbget"]="6789=linuxserver/=:latest=false"     # Deprecated
STACK_ITEMS["plex"]="32400=linuxserver/=:latest=true"
STACK_ITEMS["radarr"]="7878=linuxserver/=:latest=true"
STACK_ITEMS["sabnzbd"]="8080=linuxserver/=:latest=true"
STACK_ITEMS["sonarr"]="8989=linuxserver/=:latest=true"
STACK_ITEMS["tautulli"]="8181=linuxserver/=:latest=true"
STACK_ITEMS["readarr"]="8787=hotio/=:latest=true"
```

### Update traefik login credentials
The default credentials are admin/admin. Follow the [official documentation](https://doc.traefik.io/traefik/middlewares/http/basicauth/#configuration-examples) to change this value.

```bash
TRAEFIK_CREDENTIALS='admin:$apr1$xjhezoPA$DYDhR/MHUHrsSUwWDnT9M/'
```

### Update your DNS Challenge  settings

By default, we use the `gcloud` provider. See the [traefik docs]( https://doc.traefik.io/traefik/https/acme/#providers) for more information.

```bash
ACME_EMAIL=certs@example.com
ACME_PROVIDER=gcloud
ACME_STORAGE=/letsencrypt/acme.json
ACME_RESOLVERS=1.1.1.1:53,8.8.8.8:53
ACME_DELAY=5
```

### Create your auth JSON file
This directory does not exist by default, you'll need to create it - if this is where you'll store your Google Cloud auth file. [More Information](https://go-acme.github.io/lego/dns/gcloud/) on 
setting up your Google Cloud Service Account.

        mkdir ${HOME}/.config/plex-stack/gcloud-auth.json

```bash
GCLOUD_AUTH=${HOME}/.config/plex-stack/gcloud-auth.json
```

### Create Docker configuration files and directories

        ./manage all update

### Bring all containers up

        ./manage all up

### Check Status

        ./manage all status

    