#!/usr/bin/env bash

load git-repo
# mock the tmux interface so we don't need tmux to run the tests

TMUX_WINDOW_NAME="FOURGIT-TESTSUITE"

FOURGIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TESTDATA_DIR="$(mktemp -d)"
trap "test -n '$TESTDATA_DIR' && rm -rf '$TESTDATA_DIR'" EXIT

export TMUX_WINDOW_NAME
load tmux-mock
load fzf-mock

export FOURGIT_DIR
export TESTDATA_DIR
export USE_TEST_MOCKS=1 # signal 4gitlib.sh to the *-mock.bash test files
                        # to mock e.g. tmux and fzf and other commands

# make sure to clear whose environment variables if they got in here somehow
unset REAL_BASE_BRANCH
unset FOURGIT_WORKSPACE
unset FOURGIT_BASE_BRANCH

export PATH="$FOURGIT_DIR:$PATH"
