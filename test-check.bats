#!/usr/bin/env bats

load git-repo


setup() {
    setup_git_repo
}

teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}


# TEST ENVIRONMENT SANITY CHECK {{{
@test "check whether tests run in temporary directory" {
    # skip "because ..."
    run pwd
    [ "$status" -eq 0 ]
    [ "$output" = "$REPOSITORY" ]
}


@test "check whether temporary test directory has a git repository" {
    run git status
    [ "$status" -eq 0 ]
    [ -d ./.git ]
    [ -f ./README.md ]
    [ -d ./src ]
    [ -f ./src/main.c ]
    [ -f ./README.md ]
}
# }}}
# {{{

# }}}
