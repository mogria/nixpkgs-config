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


# Assertion Function Helpers
# ==========================
# These should be helpful in writing tests:
assert_success() {
    if [ "$status" -eq 0 ]; then
        return 0
    fi

    return 40
}


assert_fail() {
    local expected_exit_code="$1"

    if [ "$expected_exit_code" -eq 0 ]; then
        echo "TEST ERROR: The expected exit code cannot be 0 when the program is expected to fail. Exit code 0 means the programm was successful!"
        return 99
    fi

    if [ "$status" -eq "$1" ]; then
        return 0
    fi

    return 41
}

assert_current_branch_equals() {
    local expected_branch="$1"
    current_branch="$(git branch --show-current)"

    if [ "$current_branch" = "$expected_branch" ]; then
        return 0
    fi

    return 42
}

assert_current_workspace_equals() {
    local expected_workspace="$1"

    assert_current_branch_equals "4git/$ACTUAL_BASE_BRANCH/$expected_workspace"
}
