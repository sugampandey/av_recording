#!/bin/bash

#avconv -i 'http://50.197.140.116:88/videostream.asf?user=admin&pwd=TheGreat123&resolution=16' -t 3600 -acodec libmp3lame ou.avi > /dev/null 2>&1 &

avconv -i "$1" -t $2 -acodec libmp3lame $3 > /dev/null 2>&1 &
echo $$
