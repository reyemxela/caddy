# Caddy docker image

This is my own custom build of [caddy](https://github.com/caddyserver/caddy) with various installed modules and tweaks.

## Current modules:
- [Cloudflare DNS](https://github.com/caddy-dns/cloudflare) for easy wildcard SSL certs
- [Caddy-l4](https://github.com/mholt/caddy-l4) for proxying TCP/UDP connections

## Tweaks:
Custom launch script that combines a `Caddyfile` (if present) together with any additional `*.json` files (if present), and passes the result to caddy for its config on start. This came about so I could still use a normal Caddyfile alongside modules that only support JSON configuration (like caddy-l4).

A `reload` script is included to re-run the config loading process and pass it to `caddy reload`. Thus a simple `docker exec [containername] reload` is all you need for easy zero-downtime config changes.

This process works by taking the output of `caddy adapt -c /etc/caddy/Caddyfile` and merging it with any `.json` files in the same directory using [jq](https://jqlang.github.io/jq/). Due to the way this is set up, both filetypes are optional so you can use either one with or without the other.

I'm also currently building both amd64 and arm64 versions of the image so I can easily run this on my Oracle Cloud ARM VM.

## Volumes
Same as the official caddy image:
- `-v /path/to/config:/etc/caddy`
- `-v /path/to/data:/data`

Your `Caddyfile` and/or any JSON files go in the config folder and will be loaded on startup.
