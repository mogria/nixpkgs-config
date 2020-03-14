#!/usr/bin/env bats

load test-helper

setup() {
    setup_git_repo 1> /dev/null
    git checkout -b should_not_be_shown
    git switch master
    git checkout -b hidden
    4git-workspace 2> /dev/null

    git switch $(4git-branch --base)
    4git-branch --create "br1" && dummy_commit
    4git-branch --create "br1-1" && dummy_commit
    4git-branch --create "br1-1-1" && dummy_commit
    git switch $(4git-branch --base)_br1
    4git-branch --create "br1-2"

    git switch $(4git-branch --base)
    4git-branch --create "br2" && dummy_commit
    4git-branch --create "br2-1" && dummy_commit
    git switch $(4git-branch --base)_br2
    4git-branch --create "br2-2-1" && dummy_commit
    4git-branch --create "br2-2" && dummy_commit

    git switch $(4git-branch --base)_br1
    4git-branch --create "br3-nocommit"
}

teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}

# TEST CASE: Shows usage {{{
@test "check that 4git-branch-select shows usage when -h or --help is passed" {
    run 4git-branch-select --help
    [ "$status" -eq 1 ]
    echo "$output"  | grep '^Usage: 4git\-branch\-select '
}
# }}}

# TEST CASE: branch selection via fzf {{{
@test "check that 4git-branch-select uses the list from 4git-branch --list" {
    fzf-select "$(4git-branch --base)"
    4git-branch-select
    run 4git-branch --list

    [ "$status" -eq 0 ]
    [ "$(echo "$output" | wc -l)" -eq 10 ]
    [ "$output" = "$(fzf-input)" ]
}

@test "check that 4git-branch-select --subbranch only shows subbranches of the current branch in the workspace" {
    git switch $(4git-branch --base)_br2
    fzf-select "$(4git-branch --base)_br2-2-1"
    run 4git-branch-select --subbranch

    echo "fzf"
    fzf-input
    [ "$status" -eq 0 ]
    [ "$(fzf-input | wc -l)" -eq 4 ]
}


@test "check that 4git-branch-select --subbranch <branch> only shows subbranches of the current branch in the workspace" {
    fzf-select "$(4git-branch --base)_br3-nocommit"
    run 4git-branch-select --subbranch $(4git-branch --base)_br1

    echo "fzf"
    fzf-input
    [ "$status" -eq 0 ]
    [ "$(fzf-input | wc -l)" -eq 5 ]
}
# }}}

