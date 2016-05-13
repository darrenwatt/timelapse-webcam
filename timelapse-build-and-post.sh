#!/bin/bash

# Script to build and post the timelapse video to youtube.
# Uses Mencoder to build the video - quick and easy.
# Uses youtube-upload to post the video (https://github.com/tokland/youtube-upload)


yesterday=$(date -d '1 day ago' +%Y/%m/%d)
datestamp=$(date -d '1 day ago' +%Y-%m-%d)
twodaysago=$(date -d '2 days ago' +%Y/%m/%d)
twodaysagodatestamp=$(date -d '2 days ago' +%Y-%m-%d)

image_dir='/path/webcam/timelapse-tmp'
video_dir='/path/webcam/timelapse'


# BUILD
mencoder "mf:///$image_dir/$yesterday/*.jpg" -mf fps=60 -o $video_dir/$datestamp.avi -ovc x264 -x264encopts direct=auto:pass=1:bitrate=9600:bframes=1:me=umh:partitions=all:trellis=1:qp_step=4:qcomp=0.7:direct_pred=auto:keyint=300 -vf scale=-1:-10,harddup


# UPLOAD
/usr/local/bin/youtube-upload \
--title="Webcam $datestamp" \
--description="Webcam footage from (place) on $datestamp" \
--category="People & Blogs" \
--tags="webcam, timelapse" \
--privacy private \
--default-language="en" \
--default-audio-language="en" \
--client-secrets=/path/user_client_secrets.json \
--credentials-file=/path/user-youtube-upload-credentials.json \
--playlist "Timelapse Playlist" \
$video_dir/$datestamp.avi


# STOPPIT AND TIDYUP
# make sure we have a video dir set before rm -rf ;)
if [[ $video_dir ]]; then
        # ditch file 2 days ago
        rm -rf $video_dir/$twodaysagodatestamp.avi $image_dir/$twodaysago
fi
