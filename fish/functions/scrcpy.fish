function scrcpy --description "Run scrcpy with default options"
    set -l default_args \
        --max-size=1920 \
        --video-codec=h265 \
        --video-bit-rate=16M \
        --max-fps=60 \
        --no-audio \
        --stay-awake

    command scrcpy $default_args $argv
end
