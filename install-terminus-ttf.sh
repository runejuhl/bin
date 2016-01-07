#!/bin/bash
# Quickie so I don't have to think next time I need to install a good font.

wget http://files.ax86.net/terminus-ttf/files/latest.zip -O /tmp/terminus.zip
cd /tmp
unzip terminus.zip
sudo cp terminus-ttf-*/TerminusTTF* /usr/local/share/fonts/
mkdir -p ~/.fonts/
cp terminus-ttf-*/TerminusTTF* ~/.fonts/

# rebuild font cache
sudo fc-cache -fv
