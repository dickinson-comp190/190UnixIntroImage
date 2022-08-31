FROM debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Not sure how much of this is necessary.
#
# It is from the cypress/base:16.14.2 Dockerfile.
#  https://github.com/cypress-io/cypress-docker-images/blob/master/base/16.14.2/Dockerfile
#
# Including it here allows this to be build from the debian:bullseye image.
# Maybe able to pare it down some.
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libnotify-dev \
  libgconf-2-4 \
  libgbm-dev \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  procps \
  xauth \
  xvfb \
  vim-tiny \
  nano \
  fonts-noto-color-emoji

## Here down is custom stuff for this image.

# Install some base dependencies
RUN apt install -y --no-install-recommends \
        software-properties-common \
        gnupg2 \
        atfs \
        libsecret-1-0 \
        wget \
        man \
        synaptic \
        firefox-esr

# Install the desktop environment.
# Note: Power management does not work inside docker so it is removed.
RUN apt install -y --no-install-recommends \
        xfce4 \
        xfce4-goodies \
        xfce4-terminal -y \
 && apt autoremove -y \
        xfce4-power-manager

# Install the Tiger VNC server, the noVNC server and dbus-x11 depndency.
RUN apt install -y --no-install-recommends \
        tigervnc-standalone-server \
        tigervnc-common \
        dbus-x11 \
        novnc \
        net-tools \
 && cp /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Install sudo to allow user to admin.
RUN apt install -y --no-install-recommends \
        sudo

# Install Firefox
# COPY firefox.bash .
# RUN ./firefox.bash \
#  && rm firefox.bash

# Create the non-root user "comp190" with sudo privileges in the container.
ARG USERNAME=comp190
ARG PASSWD=comp190
ARG USER_UID=1001
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID \
    -m $USERNAME -p "$(openssl passwd -1 $PASSWD)" \
    -s /bin/bash \
    -G sudo

##
## From here down each section assumes that it starts with
## the non-root user and with the working directory being that
## users home directory.  If a user or directory change is made
## in a section it should restore these assumptions.
##
USER $USERNAME
WORKDIR /home/$USERNAME

# Configure the VNC server.
RUN touch .Xauthority \
 && mkdir .vnc \
 && /bin/bash -c "echo -e '$PASSWD\n$PASSWD\nn' | vncpasswd; echo;"
COPY --chown=$USERNAME:$USERNAME ./xstartup .vnc/xstartup
USER root
RUN echo ":1=$USERNAME" >> /etc/tigervnc/vncserver.users \
 && chmod +x .vnc/xstartup
USER $USERNAME

# Add some scripts for the running container.
RUN mkdir .comp190
COPY --chown=$USERNAME:$USERNAME ./startup.bash ./.comp190/startup.bash
COPY --chown=$USERNAME:$USERNAME ./xhost.desktop ./.config/autostart/xhost.desktop
COPY --chown=$USERNAME:$USERNAME ./xhost.bash ./.comp190/xhost.bash
RUN chmod +x .comp190/startup.bash \
 && chmod +x .comp190/xhost.bash

# Stuff to reduce image size.
USER root
RUN apt clean -y \
 && apt autoclean -y \
 && apt autoremove -y \
 && rm -rf /var/lib/apt/lists/*
USER $USERNAME

# Setup the initial container environment.
ENTRYPOINT ./.comp190/startup.bash
