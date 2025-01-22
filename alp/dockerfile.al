FROM debian:12.8-slim AS steamstage

RUN apt update &&\
 apt install -y \
 curl \
 tar \
 lib32gcc-s1 \

WORKDIR /home/user

RUN mkdir steamcmd &&\
 curl -s http://media.steampowered.com/client/steamcmd_linux.tar.gz |\
 tar -zxf - -C steamcmd &&\
 steamcmd/steamcmd.sh +force_install_dir empyrion +login anonymous +app_update 530870 +quit &> steamlog

FROM alpine:3.21

RUN apk update && apk add -y \
 SSHINST\
 winbind \
 wine \
 xvfb \
 netcat-openbsd

RUN adduser -D user &&\
 echo 'user:user' | chpasswd &&\
 passwd -l root

WORKDIR
COPY --from=steamstage --chown=user:user empyrion .
SSHCOPY
RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
COPY --chown=user:user ["entrypoint.sh","exitpoint.sh","tel.sh",CONFCOPY"./"]

RUN echo "empyrion built from debian:12.8-slim on $(date +%Y%m%d)" >> /info.txt
USER user:user
EXPOSE SSHPORT\
 30000-30003/tcp \
 30000-30004/udp
