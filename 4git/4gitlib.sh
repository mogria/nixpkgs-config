#!/usr/bin/env bash

set -u

current_branch() {
    git branch --show-current
}


create_branch() {
    local branch="$1"
    local base="$2"
    git checkout -b "$branch" "$base"
}

is_4git_branch() {
    echo "$1" | grep '^4git/[^/]\+/.\+$' > /dev/null
}

extract_base_branch() {
    echo "$1" | sed 's|^4git/\([^/]\+\)/.*$|\1|g'
}

real_base_branch() {
    branch="$(current_branch)"
    if is_4git_branch "$branch"; then
        extract_base_branch "$branch"
    else
        echo "$branch"
    fi
}


4git_workspace() {
    tmux-window-name
}

set_4git_workspace() {
    tmux rename-window "$1"
}

get_workspace_branches() {
    git branch --list "$FOURGIT_BASE_BRANCH*" | sed 's/^[\* ] //g'
}

fzf_set_options() {
    local options=()
    for opt in "$@"; do
        options+=" $opt"
    done
    export FZF_DEFAULT_OPTIONS="${FZF_DEFAULT_OPTIONS:-}$options"
}


