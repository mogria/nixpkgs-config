#!/usr/bin/env bats

load test-helper

# required for rebase --interactive not to block the tests
export EDITOR=cat
export VISUAL=cat

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
@test "check that 4git-rebase shows usage when -h or --help is passed" {
    run 4git-rebase --help
    [ "$status" -eq 1 ]
    echo "$output"  | grep -F 'Usage: 4git-rebase '
}
# }}}

# TEST CASE: branch selection via fzf {{{
@test "check that 4git-rebase --current rebases the current branch on the workspace" {
    git switch "$(4git-branch --base)_br1-1-1"
    run 4git-rebase --current
    assert_success
}


@test "check that 4git-rebase --current rebases when currently directly on the workspace branch" {
    git switch "$(4git-branch --base)"
    run 4git-rebase --current
    assert_success
}


@test "check that 4git-rebase --select rebases the selected branch on the workspace no matter what branch you're corrently on" {
    git switch "$(4git-branch --base)_br1"
    fzf-select "$(4git-branch --base)_br1-2"
    run 4git-rebase --select
    assert_success
}

# }}}

