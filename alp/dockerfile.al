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
