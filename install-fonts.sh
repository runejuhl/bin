#!/bin/bash
# Quickie so I don't have to think next time I need to install a good font.

uid=$(id -u)

# Terminus
wget http://files.ax86.net/terminus-ttf/files/latest.zip -O /tmp/terminus.zip
cd /tmp
unzip terminus.zip
[[ $uid == 0 ]] && sudo cp terminus-ttf-*/TerminusTTF* /usr/local/share/fonts/
mkdir -p ~/.fonts/
cp terminus-ttf-*/TerminusTTF* ~/.fonts/

# Iosevka
IFS=' ' read io_url io_name <<< $(curl https://api.github.com/repos/be5invis/iosevka/releases/latest | jq -r '.assets[0].browser_download_url, .assets[0].name')
io_tmp=$(mktemp -d)
wget "${io_url}" -O "${io_tmp}/${io_name}"
cd $io_tmp
7z x $io_name
cp ./*.ttf ~/.fonts
[[ $uid == 0 ]] && sudo cp ./*.ttf /usr/local/share/fonts

# rebuild font cache
fc-cache -fv
