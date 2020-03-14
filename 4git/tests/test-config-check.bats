#!/usr/bin/env bats

load git-repo


setup() {
    setup_git_repo 1> /dev/null
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
}

# }}


# TEST contents of git repository {{{
@test "check whether current master branch is checked out into worktree" {
    [ -d ./.git ]
    [ -f ./README.md ]
    [ -d ./src ]
    [ -f ./src/main.c ]
    [ -f ./README.md ]
}

@test "check whether the temporary git repository has two commits" {
    run git log --format=%s -n2
    echo "$output"
    [ "$status" -eq 0 ]
    [ "$output" = $'Add hello world program\nInitial Commit' ]
}

@test "check whether the temporary git repository is on the right branch" {
    run git branch --show-current
    [ "$status" -eq 0 ]
    [ "$output" = "$ACTUAL_BASE_BRANCH" ]
}
# }}}
