#!/usr/bin/env bash

load git-repo

FOURGIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

TMUX_WINDOW_NAME="TESTSUITE"

tmux-window-name() {
    echo "$TMUX_WINDOW_NAME"
}

tmux() {
    local cmd="$1"

    case "$1" in
        rename-window)
                TMUX_WINDOW_NAME="$2"
            ;;
        *) echo "WARNING: unknown tmux command" ;;
    esac
}


export PATH="$FOURGIT_DIR:$PATH"

