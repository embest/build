FROM debian:stretch
MAINTAINER Wayne Guo "wayne.guo@embest.net"
RUN apt-get update \
    && apt-get install -y openjdk-8-jdk git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip ant wget bc gawk vim python openssh-server \
    && apt-get autoclean && apt-get clean && apt-get -y autoremove

ADD android.tar.gz /opt

RUN export PATH=/opt/android/platform-tools:/opt/android/tools:/opt/android/build-tools/27.0.1:$PATH \
    && echo "\nexport PATH=/opt/android/platform-tools:/opt/android/tools:/opt/android/build-tools/27.0.1:\$PATH" >> /root/.bashrc \
    && rm -rf /var/cahce/apt && rm -rf /var/lib/apt/lists

RUN mkdir -p /opt/android/ /root/.android/ /var/run/sshd /root/.ssh 

RUN echo 'root:root' | chpasswd \
    && sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config


COPY debug.keystore /root/.android/debug.keystore

EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]
