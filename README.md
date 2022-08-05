
# subtitle-monitor

**Directory/file monitor and subtitle downloader.**

Powered by [watchdog](https://github.com/gorakhargosh/watchdog) and [subliminal](https://github.com/Diaoul/subliminal).



**_Pull from hub.docker.com:_**
```
$ docker pull queeup/subtitle-monitor
```

**_Pull from ghcr.io:_**
```
$ docker pull ghcr.io/queeup/subtitle-monitor
```

**_Volumes:_**
 - `-v cache:/cache`

**_Example usage:_** Checking /storage/downloads directory recursively for new created `*.mkv`, `*.mp4`, `*.avi` files and then download subtitles for it.
```bash
docker run --rm -i --name subtitle-monitor \
    -v "$HOME/.cache/subliminal:/cache" \
    -v "/storage/downloads:/storage/downloads" \
    queeup/subtitle-monitor watchmedo shell-command \
        --ignore-directories \
        --recursive \
        --pattern="*.mkv;*.mp4;*.avi" \
        --ignore-pattern=".incomplete/*;*__*/*" \
        --command='test "${watch_event_type}" == "created" && (printf "Checking subtitles for ${watch_src_path} video file\n"; subliminal --opensubtitles user password download -l tr -l en -l es -a 1w -p opensubtitles "${watch_src_path}")' \
        /storage/downloads
```

