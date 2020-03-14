#!#/usr/bin/env bash

tmux-window-name() {
    echo "$TMUX_WINDOW_NAME"
}

tmux() {
    local cmd="$1"

    case "$1" in
        rename-window)
                TMUX_WINDOW_NAME="$2"
                export TMUX_WINDOW_NAME
            ;;
        *) echo "WARNING: unknown tmux command" ;;
    esac
}

export TMUX_WINDOW_NAME

export FOURGIT_MOCK_TMUX=1 # signal 4gitlib.sh to load this file
