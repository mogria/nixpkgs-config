set -u
set -e

export GIT_PAGER=cat
export ACTUAL_BASE_BRANCH=fourgit-test

setup_git_repo_template() {
    TEMPLATE_REPOSITORY="$(mktemp -d)"
    [ "${#TEMPLATE_REPOSITORY}" -gt 3 ] || exit 1
    [ -d "$TEMPLATE_REPOSITORY" ] || exit 1
    cd "$TEMPLATE_REPOSITORY" || exit 1
    trap "rm -rf '$TEMPLATE_REPOSITORY'" EXIT
    export TEMPLATE_REPOSITORY
    git init "$TEMPLATE_REPOSITORY"
    echo "$BATS_TEST_NUMBER" > "$TEMPLATE_REPOSITORY/4git-bats-test"
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
}

setup_git_repo() {
    if [ -z "${TEMPLATE_REPOSITORY:-}" ]; then
        setup_git_repo_template
    fi
    REPOSITORY="$(mktemp -d)"
    cd "$REPOSITORY" || exit 1
    export REPOSITORY

    cp -R "$TEMPLATE_REPOSITORY/*" "$REPOSITORY"
    cp -R "$TEMPLATE_REPOSITORY/.*" "$REPOSITORY"
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
