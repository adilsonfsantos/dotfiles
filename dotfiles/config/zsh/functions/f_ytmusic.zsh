#!/usr/bin/env zsh

ytmusic () {
	zlog INFO "Buscando '$*'"
    mpv --no-audio-display --ytdl-format=bestaudio "ytdl://ytsearch:$*"
}
