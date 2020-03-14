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
    [ "$status" -eq 0 ]
    [ "$(git branch --show-current)" = "4git/$ACTUAL_BASE_BRANCH/$TMUX_WINDOW_NAME" ]
}


@test "check that 4git-workspace fails when no workspace name is given nor tmux window name available" {
    TMUX_WINDOW_NAME=
    export TMUX_WINDOW_MAME=
    run 4git-workspace
    [ "$status" -eq 2 ]
    [ "$(git branch --show-current)" = "$ACTUAL_BASE_BRANCH" ]
}

@test "check that 4git-workspace works when tmux window name available but one is given as an argument" {
    TMUX_WINDOW_NAME=
    export TMUX_WINDOW_MAME=
    run 4git-workspace CLIARGNAME
    echo $output
    [ "$status" -eq 0 ]
    [ "$(git branch --show-current)" = "4git/$ACTUAL_BASE_BRANCH/CLIARGNAME" ]
}
# }}}
