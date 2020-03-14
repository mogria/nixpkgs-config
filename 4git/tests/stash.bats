#!/usr/bin/env bats

load test-helper

setup() {
    setup_git_repo 1> /dev/null
    4git-workspace 2> /dev/null

    touch filetodelete
    git add filetodelete
    git commit -m 'add file to delete'

    echo 'and some more stuff' >> README.md
    echo '// this is a hello world program' >> src/main.c
    echo 'some other file' > otherfile
    echo 'some hidden file' > .hidden
    rm filetodelete
}

teardown() {
    # export KEEP_GIT_REPO
    delete_git_repo
}

# TEST CASE: creating a stash commit with a branch {{{
@test "check that 4git-stash creates a new commit" {
    commit_before=$(git rev-parse HEAD)
    run 4git-stash
    [ "$status" -eq 0 ]
    [ "$(git rev-parse HEAD~1)" = "$commit_before" ]
    [ "$(git log --format=%s -n1)" = '[WIP] 4git stash' ]
}

@test "check that 4git-stash creates a new stash branch" {
    run 4git-stash
    [ "$status" -eq 0 ]
    git branch --show-current | grep '_STASH_[0-9]\{8\}_[0-9]\{6\}'
}

@test "check that 4git-stash adds everything to the commit" {
    run 4git-stash
    [ "$status " -eq 0 ]
    run git show $(git rev-parse HEAD)
    for f in README.md .hidden otherfile src/main.c filetodelete; do
        echo "$output" | grep -Fx "diff --git a/$f b/$f"
    done
}
# }}}
