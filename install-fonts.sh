#!/bin/bash
# Quickie so I don't have to think next time I need to install a good font.
set -e

uid=$(id -u)

# Terminus
wget http://files.ax86.net/terminus-ttf/files/latest.zip -O /tmp/terminus.zip
cd /tmp
unzip -o terminus.zip
[[ $uid == 0 ]] && sudo cp terminus-ttf-*/TerminusTTF* /usr/local/share/fonts/
mkdir -p ~/.fonts/
cp terminus-ttf-*/TerminusTTF* ~/.fonts/

# Iosevka
IFS=' ' read io_url io_name <<< $(curl https://api.github.com/repos/be5invis/iosevka/releases/latest | jq -r '.assets[0].browser_download_url, .assets[0].name' | tr '\n' ' ')
io_tmp=$(mktemp -d)
wget "${io_url}" -O "${io_tmp}/${io_name}"
cd $io_tmp
7z x $io_name
cp ./*.ttf ~/.fonts
[[ $uid == 0 ]] && sudo cp ./*.ttf /usr/local/share/fonts

# Ubuntu
ubuntu_url='http://font.ubuntu.com/'
ubuntu_path=$(curl "${ubuntu_url}" | grep -Eo '../download/ubuntu-[a-z0-9.-]+')
ubuntu_tmp=$(mktemp -d)
ubuntu_name=$(basename "${ubuntu_path}")
wget "${ubuntu_url}/${ubuntu_path}" -O "${ubuntu_tmp}/${ubuntu_name}"
cd "$ubuntu_tmp"
7z e "$ubuntu_name"
cp ./*.ttf ~/.fonts
[[ $uid == 0 ]] && sudo cp ./*.ttf /usr/local/share/fonts


# rebuild font cache
fc-cache -fv
