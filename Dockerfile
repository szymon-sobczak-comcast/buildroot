FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y build-essential git subversion cvs unzip whois ncurses-dev bc mercurial pmount gcc-multilib g++-multilib libgmp3-dev libmpc-dev liblz4-tool
COPY build.sh /usr/local/bin
#RUN ls /usr/local/bin
#RUN cat /usr/local/bin/build.sh
#ENTRYPOINT ["./build.sh"]
WORKDIR ./../
RUN git clone https://github.com/WebPlatformForEmbedded/buildroot.git
RUN git checkout Divya-test
RUN ls
RUN make raspberrypi3_wpe_ml_defconfig 
RUN make
