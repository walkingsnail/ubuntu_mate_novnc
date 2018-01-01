# ubuntu with Mate and noVNC
# VNC port: 5900, noVNC port: 6080
# user and passwd: $DESKTOP_USERNAME

FROM ubuntu

MAINTAINER EF <3178323@qq.com>

ENV DEBIAN_FRONTEND noninteractive
ENV NOVNC_VERSION 0.6.2
ENV SCREEN_DIMENSIONS 1024x768x24
ENV DESKTOP_USERNAME ericfu

RUN echo "" > /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-backports main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-proposed main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-security main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-updates main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial mainpass multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-backports main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-proposed main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-security main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-updates main multiverse restricted universe" >> /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update && \
    apt-get install -y supervisor && \
    apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && \
    apt-get install -y x11vnc wget git python python-numpy \
    net-tools tar gzip xvfb && \
    wget https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz && \
    tar -zxf v${NOVNC_VERSION}.tar.gz && mv noVNC-${NOVNC_VERSION} noVNC && \
    rm v${NOVNC_VERSION}.tar.gz && \
    apt-get autoclean && apt-get autoremove && \
    useradd -ms /bin/bash ${DESKTOP_USERNAME} && \
    (echo ${DESKTOP_USERNAME} && echo ${DESKTOP_USERNAME} ) | passwd ${DESKTOP_USERNAME} && \
    mkdir /home/${DESKTOP_USERNAME}/.vnc/ && \
    x11vnc -storepasswd ${DESKTOP_USERNAME} /home/${DESKTOP_USERNAME}/.vnc/passwd && \
    chown -R ${DESKTOP_USERNAME}:${DESKTOP_USERNAME} /home/${DESKTOP_USERNAME}/.vnc && \
    chmod 0640 /home/${DESKTOP_USERNAME}/.vnc/passwd && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && \
    apt-get install -y mate-core vim \
    mate-desktop-environment mate-notification-daemon \
    gconf-service libnspr4 libnss3 fonts-liberation \
    libappindicator1 libcurl3 fonts-wqy-microhei firefox && \
    apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5900 6080

COPY supervisor_novnc.conf /etc/supervisor/conf.d/novnc.conf
COPY supervisor_mate.conf /etc/supervisor/conf.d/mate.conf

CMD ["/usr/bin/supervisord", "-n"]