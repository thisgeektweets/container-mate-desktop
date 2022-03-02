FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
    apt-get install -y supervisor && \
    apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

CMD ["/usr/bin/supervisord", "-n"]

RUN apt-get update -y && \
    apt-get install -y xrdp && \
    apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -ms /bin/bash desktop && \
    sed -i '/TerminalServerUsers/d' /etc/xrdp/sesman.ini && \
    sed -i '/TerminalServerAdmins/d' /etc/xrdp/sesman.ini && \
    xrdp-keygen xrdp auto && \
    echo "desktop:desktop" | chpasswd

ADD xrdp.conf /etc/supervisor/conf.d/xrdp.conf

EXPOSE 3389

RUN apt-get update -y && \
    apt-get install -y ubuntu-mate-desktop \
    htop \
    gconf-service libnspr4 libnss3 fonts-liberation \
    libappindicator1 libcurl4 fonts-wqy-microhei firefox && \
    apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* && \
echo "mate-session" > /home/desktop/.xsession

RUN adduser desktop sudo

RUN apt remove blueman -y
