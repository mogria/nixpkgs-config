#!/usr/bin/env bash

load git-repo
# mock the tmux interface so we don't need tmux to run the tests
load tmux-mock

FOURGIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export FOURGIT_DIR

unset REAL_BASE_BRANCH
unset FOURGIT_WORKSPACE
unset FOURGIT_BASE_BRANCH



export PATH="$FOURGIT_DIR:$PATH"

