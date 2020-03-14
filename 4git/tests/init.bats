#!/usr/bin/env bats

load test-helper


teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}


# TEST CASE: No workspace available {{{
@test "check that 4git fails when not in a git repository" {
    run ./4gitinit.sh
    [ "$status" -eq 1 ]
    [ "$output" = "$REPOSITORY" ]
}


@test "check whether temporary test directory has a git repository" {
    setup_git_repo

    run git status
    [ "$status" -eq 0 ]
    [ -d ./.git ]
    [ -f ./README.md ]
    [ -d ./src ]
    [ -f ./src/main.c ]
    [ -f ./README.md ]
    [ "$(cat ./4git-bats-test)" = "$BATS_TEST_NUMBER" ]
}
# }}}
# {{{

# }}}
