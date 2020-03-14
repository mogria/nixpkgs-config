#!/usr/bin/env bash

tmux-window-name() {
    cat "$TESTDATA_DIR/tmux-window-name"
}

tmux() {
    local cmd="$1"

    case "$1" in
        rename-window)
                echo "$2" > "$TESTDATA_DIR/tmux-window-name"
            ;;
        *) echo "WARNING: unknown tmux command" ;
    esac
}

tmux rename-window "$TMUX_WINDOW_NAME"
