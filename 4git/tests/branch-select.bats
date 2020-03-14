#!/usr/bin/env bats

load test-helper

setup() {
    setup_git_repo 1> /dev/null
    4git-workspace 2> /dev/null

    for i in `seq 1 5`; do
        4git-branch --create "br$i"
    done
}

teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}

# TEST CASE: branch selection via fzf {{{
@test "check that 4git-branch-select uses the list from 4git-branch --list" {
    fzf-select "$(4git-branch --base)"
    4git-branch-select
    run 4git-branch --list

    [ "$status" -eq 0 ]
    [ "$(echo "$output" | wc -l)" -eq 6 ]
    [ "$output" = "$(fzf-input)" ]
}

# }}}

