#!/usr/bin/env bats

load test-helper


setup() {
    setup_git_repo 1> /dev/null
    4git-workspace 2> /dev/null
}

teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}

# TEST CASE: prints usage when not enough parameters {{{
@test "check that 4git-branch prints usage when no parameter given" {
    run 4git-branch
    [ "$status" -eq 1 ]
    echo "$output" | grep '^Usage: 4git-branch \['
}
# }}}

# TEST CASE: check whether the real base is correct {{{
@test "check that 4git-branch --base returns the workspace base branch" {
    run 4git-branch --base
    expected="4git/$ACTUAL_BASE_BRANCH/$TMUX_WINDOW_NAME"
    [ "$status" -eq 0 ]
    [ "$output" = "$expected" ]
}

@test "check that 4git-branch --real-base returns the real base branch" {
    run 4git-branch --real-base
    [ "$output" = "$ACTUAL_BASE_BRANCH" ]
    [ "$status" -eq 0 ]
}

@test "check that 4git-branch returns the correct workspace name" {
    run 4git-branch --workspace
    [ "$status" -eq 0 ]
    [ "$output" = "$TMUX_WINDOW_NAME" ]
}
# }}}
