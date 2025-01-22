FROM debian:12.8-slim AS steamstage

RUN apt update &&\
 apt install -y \
 SSHINST\
 curl \
 tar \
 lib32gcc-s1 \
 wine64 \
 xvfb \
 winbind \
 netcat-openbsd

RUN useradd -ms /bin/bash user &&\
 echo 'user:user' | chpasswd &&\
 passwd -l root
WORKDIR /home/user

RUN su -c ' \
 mkdir steamcmd &&\
 curl -s http://media.steampowered.com/client/steamcmd_linux.tar.gz |\
 tar -zxf - -C steamcmd &&\
 steamcmd/steamcmd.sh +quit \
 ' user

FROM alpine:3.21

SSHCOPY
RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
COPY --chown=user:user ["entrypoint.sh","exitpoint.sh","tel.sh",CONFCOPY"./"]

RUN echo "empyrion built from debian:12.8-slim on $(date +%Y%m%d)" >> /info.txt
USER user:user
EXPOSE SSHPORT\
 30000-30003/tcp \
 30000-30004/udp
