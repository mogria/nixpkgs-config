#!/usr/bin/env bash

set -e
set -u

d="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$d/4gitlib.sh"

REAL_BASE_BRANCH="$(real_base_branch)"
FOURGIT_WORKSPACE="$(4git_workspace)"


if [ -z "$FOURGIT_WORKSPACE" ]; then
    echo "ERROR: this doesn't seem to be a 4git workspace, please create one first using 4git-create"
    exit 1
fi


4git_branch(){
    echo "4git/$REAL_BASE_BRANCH/$FOURGIT_WORKSPACE"
}

FOURGIT_BASE_BRANCH="$(4git_branch)"

export REAL_BASE_BRANCH FOURGIT_WORKSPACE FOURGIT_BASE_BRANCH
