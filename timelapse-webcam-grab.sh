#!/bin/bash

# Looping script to grab a series of webcam images and add timestamps to them.
# I run it in a screen session, but you could also background it.
# Images are pulled from MJPEG Streamer (https://github.com/jacksonliam/mjpg-streamer).
# Timestamps added using convert from ImageMagick.

for (( ; ; ))
do
        today=$(date +%Y/%m/%d)
        now=$(date +%Y-%m-%d-%H-%M-%S)
        overlay=$(date +%d/%m/%Y\ %H\:%M)
        mkdir -p /path/webcam/timelapse-tmp/${today}
        curl http://webcam-address:port/?action=snapshot -o /path/webcam/timelapse-tmp/${today}/snap${now}.jpg
        #add timestamp
        convert -pointsize 20 -fill white -annotate +30+30 "$overlay" /path/webcam/timelapse-tmp/${today}/snap${now}.jpg /path/webcam/timelapse-tmp/${today}/snap${now}.jpg
        sleep 5
done
