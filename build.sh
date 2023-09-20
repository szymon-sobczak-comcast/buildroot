#!/bin/bash

apt-get update
apt-get install -y build-essential git subversion cvs unzip whois ncurses-dev bc mercurial pmount gcc-multilib g++-multilib libgmp3-dev libmpc-dev liblz4-tool

make raspberrypi3_wpe_defconfig  && make
~                                            
