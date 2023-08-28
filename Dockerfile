FROM ubuntu:22.04

RUN  apt-get install build-essential git subversion cvs unzip whois ncurses-dev bc mercurial pmount gcc-multilib g++-multilib libgmp3-dev libmpc-dev liblz4-tool
COPY buildroot /buildroot
WORKDIR /buildroot
#RUN make raspberrypi3_wpe_ml_defconfig  && make 
