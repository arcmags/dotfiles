#!/bin/bash

cmd_ffmpeg() {
    ffmpeg -y -hide_banner "$@"
}

len_vid() {
    ffprobe -hide_banner -show_format "$1" 2>/dev/null | grep -Po '^duration=\K\d+'
}

## ffmpeg ::
# Apply delogo filter, fade in/out audio and video, and add a brief caption:
#   $ ffmpeg_caption-delogo-fade <INPUT> <DELOGO PARMS> [START] [END] [CAPTION] [OUTPUT]
#   $ ffmpeg_caption-delogo-fade file.mp4 o=x=1449:y=954:w=434:h=52 5 90 Title new.mp4
ffmpeg_caption-delogo-fade() {
    [ -z "$2" ] && return 1
    vid_in="$1"
    vid_out="${1%.*}_out.mp4"
    caption="${5:-$vid_out}"
    ss="${3:-10}"
    to="${4:-40}"
    to=$((to-ss))
    af="afade=in:st=0:d=1,"
    af+="afade=out:st=$((to-4)):d=4"
    vf="delogo=$2,"
    vf+="fade=in:st=0:d=4,"
    vf+="fade=out:st=$((to-4)):d=4[clear];"
    vf+='movie=tmp.mov[logo];'
    vf+="[clear][logo]overlay=W-w-16:H-h-16:eof_action=pass[out]"
    font='NimbusSans-Bold'
    font_color='white'
    font_outline='black'
    convert -pointsize 64 -background '#00000000' -fill DeepPink -font ComicBook-Bold \
      -strokewidth 3 -stroke navy -size 1000x caption:"$caption" -trim tmp.png
    #ffmpeg -loop 1 -i tmp.png -vframes 400 -vf 'fade=out:300:99:alpha=1' -c:v png \
    ffmpeg -loop 1 -i tmp.png -vframes 336 -vf 'fade=out:224:112:alpha=1' -c:v png \
      -pix_fmt rgba -y tmp.mov
    #printf "ffmpeg -i $vid_in -ss $ss -to $to -crf 22 -vf $vf -af $af -y $vid_out\n"
    ffmpeg -ss $ss -i "$vid_in" -to $to -crf 22 -vf "$vf" -af "$af" -y "$vid_out"
    rm -f tmp.mov tmp.png
}

# Remove all metadata/tags from  all formats:
#   $  ffmpeg_metadata-clear <FILES>
ffmpeg_metadata-clear() {
    for arg in "$@"; do
        file_ext="${arg##*.}"
        tmp_file="$(mktemp -t "XXXX.$file_ext")"
        ffmpeg -hide_banner -loglevel 8 -i "$arg" -map_metadata -1 -c:a copy -c:v copy \
          -fflags +bitexact -flags:a +bitexact -flags:v +bitexact -y "$tmp_file" &&
        rm "$arg" &&
        mv "$tmp_file" "$arg"
    done
}

# Add padding to all track number tags:
#   $ ffmpeg_tracknumber-pad <FILES>
ffmpeg_track-pad() {
    for arg in "$@"; do
        track="$(ffprobe -loglevel 8 -hide_banner -show_format "$arg" | grep -Po '^TAG:track=\K.*')"
        [ -z "$track" ] && continue
        track="${track%/*}"
        [ "${#track}" -gt 1 ] && continue
        track="0$track"
        file_ext="${arg##*.}"
        tmp_file="$(mktemp -t "XXXX.$file_ext")"
        ffmpeg -hide_banner -i "$arg" -c:a copy -c:v copy \
          -metadata "track=$track" \
          -fflags +bitexact -flags:a +bitexact -flags:v +bitexact -y "$tmp_file" &&
        rm "$arg" &&
        mv "$tmp_file" "$arg"
    done
}

ffmpeg_Thylacine_ARTE2022() {
    local input='Thylacine_ARTE2022.mp4'
    ffmpeg -hide_banner -i "$input" -c:a copy -crf 25 -preset veryslow \
      -vf delogo=x=62:y=55:w=90:h=180 Thylacine_ARTE2022_delogo_crf25.mp4
}

# vim:ft=bash
