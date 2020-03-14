#!/usr/bin/env bats

load test-helper

commit_to_pick=
expected_fzf_input=
setup() {
    setup_git_repo 1> /dev/null
    4git-workspace 2> /dev/null

    4git-branch --create stuff

    echo 'some stuff' >> README.md
    git add README.md
    git commit -m 'update readme'

    echo 'documentation' > DOCS.md
    git add DOCS.md
    git commit -m 'add documentation'
    commit_to_pick="$(git rev-parse HEAD | cut -b1-7)"

    echo '// just a comment' >> src/main.c
    git add src/main.c
    git commit -m 'add comment'
    expected_fzf_input=$(git log -n3 --format='%h %s')

    git switch $(4git-branch --base)
}

teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}

# TEST CASE: creating a stash commit with a branch {{{
@test "check that 4git-pick picks a commit from an other branch to the base branch" {
    commit_before=$(git rev-parse HEAD)
    fzf-select "$(4git-branch --base)_stuff"
    fzf-select "$commit_to_pick add documentation"
    echo "$commit_to_pick add documentation"
    run 4git-pick

    [ "$status" -eq 0 ]
    [ "$(git branch --show-current)" = "$(4git-branch --base)" ]
    [ "$(git rev-parse HEAD~1)" = "$commit_before" ]
    [ "$(fzf-input)" = "$expected_fzf_input" ]
}



@test "check that 4git-pick errors when no branch got picked" {
    run 4git-pick
    [ "$status" -eq 1 ]
    [ "$(echo "$output" | tail -n1)" = "ERROR: no branch picked" ]
}

@test "check that 4git-pick errors when no commit got picked" {
    fzf-select "$(4git-branch --base)_stuff"
    run 4git-pick
    echo "$output"
    [ "$status" -eq 2 ]
    [ "$(echo "$output" | tail -n1)" = "ERROR: no commit picked" ]
}

# }}}
