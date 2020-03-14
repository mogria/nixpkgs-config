export GIT_PAGER=cat
export ACTUAL_BASE_BRANCH=fourgit-test

setup_git_repo() {
    REPOSITORY=`mktemp -d`
    export REPOSITORY
    git init "$REPOSITORY"
    echo "$BATS_TEST_NUMBER" > "$REPOSITORY/4git-bats-test"
    cd "$REPOSITORY" || exit 1
    git config user.name "Chuck Tester"
    git config user.email  "chuck@example.com"

    git add "4git-bats-test"
    git commit -m 'Initial Commit'
    cat <<README > "README.md"
This is just a repository where some tests for 4git are being run.
Feel free to delete this folder after the test run has finished.
(It should get deleted automatically tough)
README

    mkdir "src"
    cat <<MAIN_C > "src/main.c"
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

dummy_commit() {
    local f="$RANDOM$RANDOM"
    touch "$f"
    git add "$f"
    git commit -m 'dummy commit'
    return
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
