#!/usr/bin/env bash

load git-repo
# mock the tmux interface so we don't need tmux to run the tests

TMUX_WINDOW_NAME="FOURGIT-TESTSUITE"

export TMUX_WINDOW_NAME
load tmux-mock

FOURGIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TESTDATA_DIR="$(mktemp -d)"
trap "rm '$TESTDATA_DIR'" EXIT
export FOURGIT_DIR

unset REAL_BASE_BRANCH
unset FOURGIT_WORKSPACE
unset FOURGIT_BASE_BRANCH



export PATH="$FOURGIT_DIR:$PATH"

