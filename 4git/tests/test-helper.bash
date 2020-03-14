#!/usr/bin/env bash

set -e
set -u

load git-repo

FOURGIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN_DIR="$FOURGIT_DIR/bin"
TESTDATA_DIR="$(mktemp -d)"
trap "test -n '$TESTDATA_DIR' && rm -rf '$TESTDATA_DIR'" EXIT
export FOURGIT_DIR TESTDATA_DIR

# mock the tmux & fzf interface so we don't need them to run the tests
export TMUX_WINDOW_NAME="FOURGIT_BATS_TESTSUITE"
load tmux-mock
load fzf-mock

export USE_TEST_MOCKS=1 # signal that 4gitlib.sh should include the *-mock.bash
                        # files in this directory for the mocked commands to be used



# make sure to clear whose environment variables if they got in here somehow
unset REAL_BASE_BRANCH
unset FOURGIT_WORKSPACE
unset FOURGIT_BASE_BRANCH

# make sure the scripts in the parent folder will be tested
export PATH="$BIN_DIR:$PATH"
