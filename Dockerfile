FROM archlinux/base:latest

MAINTAINER Sylvain Martin (sylvain@nforcer.com)

ARG OVERLAY_VER="v1.22.1.0"
ARG OVERLAY_URL="https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VER}/s6-overlay-amd64.tar.gz"

# s6 overlay
RUN \
 echo "Fetching the basics" \
 && pacman --noconfirm -Syu \
 && pacman --noconfirm -S wget nfs-utils tar grep \
 && rm -rf /usr/share/man/* /var/cache/pacman/pkg/* /var/lib/pacman/sync/* /etc/pacman.d/mirrorlist.pacnew \
 && cd /tmp \
 && echo "Fetching s6 overlay" \
 && curl -L -s ${OVERLAY_URL} -o /tmp/s6-overlay-amd64.tar.gz \
 && echo "2 stage s6 extraction to NOT bork /bin" \
 && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / --exclude="./bin" \
 && tar xzf /tmp/s6-overlay-amd64.tar.gz -C /usr ./bin \
 && echo "Creating abc user" \
 && groupadd -g 3000 abc  \
 && useradd -u 3001 -g 3000 -d /config -m -s /bin/false abc \
 && mkdir -p /app /config /defaults \
 && chown -R abc:abc /app /config /defaults

##
## INIT
##

COPY rootfs/ /

ENTRYPOINT [ "/init" ]
