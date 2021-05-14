FROM ghcr.io/linuxserver/baseimage-rdesktop-web:bionic

# https://github.com/ehough/docker-nfs-server/pull/3#issuecomment-387880692
#ARG DEBIAN_FRONTEND=noninteractive
LABEL maintainer="rysmario"


ENV \
  CUSTOM_PORT="80" \
  GUIAUTOSTART="true" \
  HOME="/config"

# install the team-xbmc ppa

ARG KODI_EXTRA_PACKAGES=


RUN \
  echo "**** install runtime packages ****" && \
  apt-get update && \
  apt-get install dialog apt-utils -y &&\
  apt-get install -y --no-install-recommends \
    dbus \
    fcitx-rime \
    fonts-wqy-microhei \
    samba-vfs-modules \
    mysql-client traceroute \
    jq \
    libnss3 \
    libqpdf21 \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-xinerama0 \
    python3 \
    python3-xdg \
    ttf-wqy-zenhei \
    wget \
    xz-utils  &&\
  echo "**** install kodi ****" && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:team-xbmc/ppa                                  && \
    packages="                                               \
                                                             \
    ca-certificates                                          \
    kodi                                 \
    kodi-eventclients-kodi-send                              \
    kodi-inputstream-adaptive                                \
    kodi-inputstream-rtmp                                    \
    kodi-peripheral-joystick                                 \
    kodi-pvr-hts                                             \
    kodi-pvr-iptvsimple                                      \
    locales                                                  \
    pulseaudio                                               \
    tzdata                                                   \
    va-driver-all                                            \
    ${KODI_EXTRA_PACKAGES}"                               && \
                                                             \
    apt-get update                                        && \
    apt-get install -y --no-install-recommends $packages  && \
  echo "**** cleanup ****" && \
  apt-get clean && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

ARG KODI_EXTRA_PACKAGES=

# besides kodi, we will install a few extra packages:
#  - ca-certificates              allows Kodi to properly establish HTTPS connections
#  - kodi-eventclients-kodi-send  allows us to shut down Kodi gracefully upon container termination
#  - kodi-game-libretro           allows Kodi to utilize Libretro cores as game add-ons
#  - kodi-inputstream-*           input stream add-ons
#  - kodi-peripheral-*            enables the use of gamepads, joysticks, game controllers, etc.
#  - locales                      additional spoken language support (via x11docker --lang option)
#  - pulseaudio                   in case the user prefers PulseAudio instead of ALSA
#  - tzdata                       necessary for timezone selection
#  - va-driver-all                the full suite of drivers for the Video Acceleration API (VA API)
#  - kodi-game-libretro-*         Libretro cores (DEPRECATED: WILL BE REMOVED IN VERSION 4 OF THIS IMAGE)
#  - kodi-pvr-*                   PVR add-ons (DEPRECATED: WILL BE REMOVED IN VERSION 4 OF THIS IMAGE)
#  - kodi-screensaver-*           additional screensavers (DEPRECATED: WILL BE REMOVED IN VERSION 4 OF THIS IMAGE)
# setup entry point
#COPY entrypoint.sh /usr/local/bin
#ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
COPY root/ /
