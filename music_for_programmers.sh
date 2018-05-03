#!/bin/bash
# Download all mp3s from musicforprogramming.net

dest=~/music/music_for_programming/

mkdir -p "${dest}"

cd "${dest}"

curl http://www.musicforprogramming.net/rss.php|grep -Eo 'http://datashat.net/[a-zA-Z0-9_-]+\.mp3' | wget -N -c -i -
