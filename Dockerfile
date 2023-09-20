FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install -y build-essential git subversion cvs unzip whois ncurses-dev bc mercurial pmount gcc-multilib g++-multilib libgmp3-dev libmpc-dev liblz4-tool
#COPY build.sh /usr/local/bin
#ENTRYPOINT ["./build.sh"]
RUN make raspberrypi3_wpe_ml_defconfig 
RUN make
