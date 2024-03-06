#!/bin/bash

ffmpeg -i noir.png -pix_fmt rgb24 -f rawvideo noir.webm
