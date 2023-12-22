ARG UPSTREAM_IMAGE
ARG UPSTREAM_DIGEST_AMD64

FROM ${UPSTREAM_IMAGE}@${UPSTREAM_DIGEST_AMD64}
EXPOSE 8080
ENV VPN_ENABLED="false" VPN_LAN_NETWORK="" VPN_CONF="wg0" VPN_ADDITIONAL_PORTS="" WEBUI_PORTS="8080/tcp,8080/udp" PRIVOXY_ENABLED="false" S6_SERVICES_GRACETIME=180000 S6_STAGE2_HOOK="/init-hook"

VOLUME ["${CONFIG_DIR}"]

RUN ln -s "${CONFIG_DIR}" "${APP_DIR}/qBittorrent"

RUN apk add --no-cache privoxy iptables ip6tables iproute2 openresolv wireguard-tools ipcalc && \
    apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing wireguard-go

ARG FULL_VERSION

RUN curl -fsSL "https://github.com/c0re100/qBittorrent-Enhanced-Edition/releases/download/${FULL_VERSION}/qbittorrent-enhanced-nox_x86_64-linux-musl_static.zip" > "/tmp/qbittorrent-nox.zip" && \
    unzip "/tmp/qbittorrent-nox.zip" -d "${APP_DIR}" && \
    chmod 755 "${APP_DIR}/qbittorrent-nox"

ARG VUETORRENT_VERSION
RUN curl -fsSL "https://github.com/wdaan/vuetorrent/releases/download/v${VUETORRENT_VERSION}/vuetorrent.zip" > "/tmp/vuetorrent.zip" && \
    unzip "/tmp/vuetorrent.zip" -d "${APP_DIR}" && \
    rm "/tmp/vuetorrent.zip" && \
    chmod -R u=rwX,go=rX "${APP_DIR}/vuetorrent"

COPY root/ /
RUN chmod +x /init-hook
