FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y file wget cpio rsync build-essential git subversion cvs unzip whois ncurses-dev bc mercurial pmount gcc-multilib g++-multilib libgmp3-dev libmpc-dev liblz4-tool
COPY build.sh /usr/local/bin
#RUN ls /usr/local/bin
#RUN cat /usr/local/bin/build.sh
#ENTRYPOINT ["./build.sh"]
RUN git clone https://github.com/WebPlatformForEmbedded/buildroot.git
RUN cd buildroot
WORKDIR ./buildroot
RUN ls
RUN make raspberrypi3_wpe_ml_defconfig 
RUN make
