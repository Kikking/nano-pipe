#!/bin/bash

#A way to auto pull from the nano-pipe repo and maintain position in current working directory

x=$PWD;
cd;
cd nano-pipe;
git pull;
cd $x;

#save as autopull=`sudo bash ~/nano-pipe/autopull.sh`
# call : echo $autopull
