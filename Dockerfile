FROM ubuntu:17.04

# Some intial settings
ENV SCREEN_WIDTH 1280
ENV SCREEN_HEIGHT 800
ENV SCREEN_DEPTH 16
ENV DEBIAN_FRONTEND noninteractive

# Minimal desktop environment
RUN apt-get update -q && \
    apt-get install --no-install-recommends -q -y lxde git x11vnc xvfb wget curl python unzip python-numpy tigervnc-common tigervnc-standalone-server \
    && rm -rf /var/lib/apt/*
RUN apt-get update -q && apt-get install -q -y net-tools netcat \
    lxrandr supervisor openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

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
EXPOSE 5901

CMD vncserver :1 -verbose -localhost no -geometry 800x600; tail -f /root/.vnc/*.log
#; socat tcp-listen:7000,reuseaddr,fork tcp:localhost:5901

