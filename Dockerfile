# ubuntu with Mate and noVNC
# VNC port: 5900, noVNC port: 6080, passwd: 888888 ($VNC_PW)
# ubuntu user and passwd: $DESKTOP_USERNAME

FROM ubuntu

MAINTAINER EF <3178323@qq.com>

ENV DESKTOP_USERNAME ericfu
ENV VNC_PW 888888
ENV DEBIAN_FRONTEND noninteractive
ENV SCREEN_DIMENSIONS 1280x768x24
ENV TZ=Asia/Shanghai

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Uses local apt sources
RUN echo "" > /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-backports main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-proposed main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-security main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.163.com/ubuntu/ xenial-updates main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-backports main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-proposed main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-security main multiverse restricted universe" >> /etc/apt/sources.list \
    && echo "deb-src http://mirrors.163.com/ubuntu/ xenial-updates main multiverse restricted universe" >> /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update -y && \
    apt-get install -y supervisor bzip2 curl rsync wget libgl1-mesa-glx qt5-default ttf-wqy-microhei net-tools iputils-ping supervisor && \
    apt-get autoclean && apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update -y && \
    apt-get install -y x11vnc wget git python python-numpy \
    net-tools tar gzip xvfb && \
    mkdir -p /noVNC/utils/websockify \
    && wget -qO- https://github.com/ConSol/noVNC/archive/consol_1.0.0.tar.gz | tar xz --strip 1 -C /noVNC \
    &&  wget -qO- https://github.com/kanaka/websockify/archive/v0.7.0.tar.gz | tar xz --strip 1 -C /noVNC/utils/websockify \
    && chmod +x -v /noVNC/utils/*.sh \
    && cd /noVNC && ln -s vnc.html index.html\
    && useradd -ms /bin/bash ${DESKTOP_USERNAME} && \
    (echo ${DESKTOP_USERNAME} && echo ${DESKTOP_USERNAME} ) | passwd ${DESKTOP_USERNAME} && \
    mkdir /home/${DESKTOP_USERNAME}/.vnc/ && \
    x11vnc -storepasswd ${VNC_PW} /home/${DESKTOP_USERNAME}/.vnc/passwd && \
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

ENTRYPOINT ["/usr/bin/supervisord", "-n"]