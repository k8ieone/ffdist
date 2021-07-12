#!/bin/bash

wd=$(dirname -- $(readlink -fn -- "$0"))
tmpd="$wd/tmp"
ind="$wd/in"
outd="$wd/out"

prepare () {
  mkdir $tmpd
  mkdir $outd
}

main () {
  files=($(ls "$ind"))
  dir=()
  for file in "${files[@]}"
  do
    if [ ! -f "$tmpd/$file.t" ];
    then
      touch "$tmpd/$file.t"
      echo Touched "$tmpd/$file.t"
      echo Converting "$ind/$file" to "$outd/${file%.*}.mp4"
      ffmpeg -i "$ind/$file" -filter:v fps=30 -c:v libx264 -preset:v medium "$outd/${file%.*}.mp4"
    else
      echo Ignored "$ind/$file"
    fi
  done
}

prepare
while :
do
  del=$(shuf -i 1-10 -n 1)
  echo "Sleeping for $del seconds..."
  sleep "$del"
  main
done
