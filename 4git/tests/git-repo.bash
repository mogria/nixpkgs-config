export GIT_PAGER=cat
export ACTUAL_BASE_BRANCH=fourgit-test

setup_git_repo() {
    REPOSITORY=`mktemp -d`
    cd "$REPOSITORY" || return 1


    echo "$BATS_TEST_NUMBER" > "$REPOSITORY/4git-bats-test"
    git init "$REPOSITORY"

    git add "$REPOSITORY/4git-bats-test"
    git commit -m 'Initial Commit'

    cat <<README > "$REPOSITORY/README.md"
This is just a repository where some tests for 4git are being run.
Feel free to delete this folder after the test run has finished.
(It should get deleted automatically tough)
README

    mkdir "$REPOSITORY/src"
    cat <<MAIN_C > "$REPOSITORY/src/main.c"
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char ** argv) {
    printf("Hello, World");
    return EXIT_SUCCESS;
}
MAIN_C

    git add .
    git commit -m 'Add hello world program'
    git checkout -b "$ACTUAL_BASE_BRANCH" 2>/dev/null

    export REPOSITORY
}

delete_git_repo() {
    local repo="${REPOSITORY:-}"
    unset REPOSITORY

    if [ -n "${KEEP_GIT_REPO:-}" ]; then
        echo "NOTE: Did not delete test git repository at $repo"
        return 0
    fi


    if [ -n "$repo" ] && [ -f "$repo/4git-bats-test" ]  && [ "x$BATS_TEST_NUMBER" = "x$(cat "$repo/4git-bats-test")" ]; then
        rm -rf "$repo"
    fi
}
