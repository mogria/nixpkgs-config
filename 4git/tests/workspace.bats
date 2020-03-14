#!/usr/bin/env bats

load test-helper

setup() {
    setup_git_repo 1> /dev/null
}

teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}

# TESTCASE: creating a workspace {{{
@test "check that 4git-workspace uses the tmux window name as the workspace and base branch name" {
    run 4git-workspace
    assert_success
    [ -n "$(tmux-window-name)"  ]
    assert_current_workspace_equals "$(tmux-window-name)"
}

@test "check that 4git-workspace fails when no workspace name is given nor tmux window name available" {
    TMUX_WINDOW_NAME=
    export TMUX_WINDOW_MAME=
    run 4git-workspace
    assert_fail 2
    [ "$(git branch --show-current)" = "$ACTUAL_BASE_BRANCH" ]
}

@test "check that 4git-workspace works when tmux window name available but one is given as an argument" {
    TMUX_WINDOW_NAME=
    export TMUX_WINDOW_MAME=
    run 4git-workspace CLIARGNAME

    assert_success
    [ "$(git branch --show-current)" = "4git/$ACTUAL_BASE_BRANCH/CLIARGNAME" ]
}

@test "check that 4git-workspace sets tmux window title" {
    expected=SETTMUXWINDOWNAME
    run 4git-workspace "$expected"

    assert_success
    [ "$(tmux-window-name)" = "$expected" ]
}

@test "check that 4git-workspace switches to already existing 4git-branches" {
    run 4git-workspace "workspace1"
    assert_success
    run 4git-workspace "workspace2"
    assert_success

    set -x
    git switch "4git/$ACTUAL_BASE_BRANCH/workspace1"
    assert_current_branch_equals "workspace1"
    git switch master
    set +x

    run 4git-workspace "workspace1"
    assert_success
    assert_current_workspace_equals "workspace1"
}

@test "check that 4git-workspace stays on the correct branch when switching" {
    4git-workspace "workspace1"
    assert_current_workspace_equals "workspace1"

    # NOTE: there is a bug here where "/workspace2" gets appended to the branch name.
    4git-workspace "workspace2"
    assert_current_workspace_equals "workspace2"

    git switch "4git/$ACTUAL_BASE_BRANCH/workspace1"
    assert_current_workspace_equals "workspace1"

    run 4git-workspace "workspace1"
    assert_success
    assert_current_workspace_equals "workspace1"

    run 4git-workspace "workspace2"
    assert_success
    assert_current_workspace_equals "workspace2"
}

# }}}
