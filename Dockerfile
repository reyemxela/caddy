FROM --platform=$BUILDPLATFORM caddy:2-builder AS builder

ARG TARGETOS TARGETARCH
RUN GOOS=$TARGETOS GOARCH=$TARGETARCH xcaddy build \
    --with github.com/caddy-dns/cloudflare \
		--with github.com/mholt/caddy-l4

FROM caddy:2

RUN apk add --no-cache \
    jq \
    bind-tools

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

COPY --chmod=755 scripts/parsecfg /usr/bin/
COPY --chmod=755 scripts/reload /usr/bin/
COPY --chmod=755 scripts/start /usr/bin/

CMD start