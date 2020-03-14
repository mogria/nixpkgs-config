#!/usr/bin/env bash

set -e
set -u

d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$d/4gitlib.sh"

error_no_workspace() {
    echo "ERROR: This doesn't seem to be a 4git workspace, please create one first using 4git-workspace" 1>&2
    exit 2
}

REAL_BASE_BRANCH="$(real_base_branch)"
FOURGIT_WORKSPACE="$(4git_workspace)"

if [ -z "$REAL_BASE_BRANCH" ]; then
    echo "ERROR: this doesn't seem to be a git repository"
    exit 1
fi


if [ -z "$FOURGIT_WORKSPACE" ]; then
    error_no_workspace
fi


4git_branch(){
    echo "4git/$REAL_BASE_BRANCH/$FOURGIT_WORKSPACE"
}

FOURGIT_BASE_BRANCH="$(4git_branch)"

if ! git rev-parse "$FOURGIT_BASE_BRANCH" 1> /dev/null; then
    error_no_workspace
fi

export REAL_BASE_BRANCH FOURGIT_WORKSPACE FOURGIT_BASE_BRANCH
