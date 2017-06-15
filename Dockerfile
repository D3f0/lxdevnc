FROM ubuntu:17.04

# Some intial settings
ENV SCREEN_WIDTH 1280
ENV SCREEN_HEIGHT 800
ENV SCREEN_DEPTH 16
ENV DEBIAN_FRONTEND noninteractive

#
ENV TINI_VERSION v0.14.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Minimal desktop environment
RUN apt-get update -q && \
    apt-get install --no-install-recommends -q -y lxde git x11vnc xvfb wget curl python \
    unzip python-numpy tigervnc-common tigervnc-standalone-server \
    net-tools netcat \
    lxrandr supervisor openssh-server supervisor \
    && rm -rf /var/lib/apt/*

RUN apt-get update && apt-get -y install rsyslog && rm -rf /var/lib/apt/*

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd


COPY etc/ssh/sshd_config etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


ADD ./vnc /root/.vnc
RUN chmod +x /root/.vnc/xstartup
ENV USER root
ENV PASS root

ENV TZ=America/Argentina/Buenos_Aires
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY etc/supervisor/conf.d/* /etc/supervisor/conf.d/
COPY usr/local/bin/vncwrapper /usr/local/bin
RUN chmod +x /usr/local/bin/vncwrapper

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 22 5901

VOLUME /root/shared

ENTRYPOINT ["/tini", "--"]
CMD sh /run.sh


