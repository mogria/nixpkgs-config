#!/usr/bin/env bats

load test-helper


teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}


# TEST CASE: No workspace available {{{
@test "check that 4git fails when not in a git repository" {
    cd "$(mktemp -d)"
    run source "$FOURGIT_DIR"/4gitinit.sh
    [ "$status" -eq 1 ]
    [ -z "$REAL_BASE_BRANCH" ]
    [ -z "$FOURGIT_WORKSPACE" ]
    [ -z "$FOURGIT_BASE_BRANCH" ]
}


@test "check that 4git when no workspace is in the git repository" {
    setup_git_repo
    export TMUX_WINDOW_NAME=
    run source "$FOURGIT_DIR"/4gitinit.sh
    [ "$status" -eq 2 ]
    [ -z "$REAL_BASE_BRANCH" ]
    [ -z "$FOURGIT_WORKSPACE" ]
    [ -z "$FOURGIT_BASE_BRANCH" ]
}
# }}}
# {{{

# }}}
