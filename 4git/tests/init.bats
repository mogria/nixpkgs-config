#!/usr/bin/env bats

load test-helper


teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}


# TEST CASE: No workspace available {{{
@test "check that 4git initialization fails when not in a git repository" {
    cd "$(mktemp -d)"
    run source "$FOURGIT_DIR"/bin/4gitinit.sh
    [ "$status" -eq 1 ]
    [ -z "${REAL_BASE_BRANCH:-}" ]
    [ -z "${FOURGIT_WORKSPACE:-}" ]
    [ -z "${FOURGIT_BASE_BRANCH:-}" ]
}


@test "check that 4git when no workspace is in the git repository" {
    setup_git_repo > /dev/null
    export TMUX_WINDOW_NAME=
    run source "$FOURGIT_DIR"/bin/4gitinit.sh
    [ "$status" -eq 2 ]
    [ -z "${REAL_BASE_BRANCH:-}" ]
    [ -z "${FOURGIT_WORKSPACE:-}" ]
    [ -z "${FOURGIT_BASE_BRANCH:-}" ]
}
# }}}
# TEST CASE: workspace available {{{
@test "check that 4gitinit.sh loads fine when everythings is there" {
    setup_git_repo > /dev/null
    4git-workspace
    run source "$FOURGIT_DIR"/bin/4gitinit.sh
    [ "$status" -eq 0 ]
}
# }}}
