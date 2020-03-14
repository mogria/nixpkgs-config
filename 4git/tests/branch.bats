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

@test "check that 4git-branch --workspace returns the workspace name" {
    run 4git-branch --workspace
    [ "$status" -eq 0 ]
    [ "$output" = "$TMUX_WINDOW_NAME" ]
}
# }}}

# TEST CASE: creating branches in workspace {{{
@test "check that 4git-branch --create without a name shows the usage" {
    run 4git-branch --create
    [ "$status" -eq 1 ]
    echo "$output" | grep '^Usage: 4git-branch'
}

@test "check that 4git-branch --create with a name creates a subbranch in the workspace" {
    run 4git-branch --create subbranchname
    [ "$status" -eq 0 ]
    [ "$(git branch --show-current)" = "4git/$ACTUAL_BASE_BRANCH/${TMUX_WINDOW_NAME}_subbranchname" ]
}
# }}}

# TEST CASE: listing branches in workspace {{{
@test "check that 4git-branch --list returns at least the workspace branch" {
    run 4git-branch --list
    [ "$status" -eq 0 ]
    [ "$output" = "4git/$ACTUAL_BASE_BRANCH/$TMUX_WINDOW_NAME" ]
}

@test "check that 4git-branch --list returns all created subbranches in the worktree" {
    local base_name="4git/$ACTUAL_BASE_BRANCH/$TMUX_WINDOW_NAME"
    4git-branch --create subbranch
    run 4git-branch --list
    [ "$status" -eq 0 ]
    [ "$output" = "$base_name"$'\n'"$base_name"_subbranch ]
}
# }}}

