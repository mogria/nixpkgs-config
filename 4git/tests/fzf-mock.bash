#!#/usr/bin/env bash

fzf_input="$TESTDATA_DIR/fzf-input"
fzf_options="$TESTDATA_DIR/fzf-default-options"
fzf_selections="$TESTDATA_DIR/fzf-selections"


fzf-select() {
    echo "$1" >> "$fzf_selections"
}

get-fzf-selection() {
    local selection="$(head -n1 "$fzf_selections")"
    sed -n -i '2,$p' "$fzf_selections"
    echo "$selection"
}

touch "$fzf_input"
touch "$fzf_options"

fzf() {
    cat > "$fzf_input"
    echo "${DEFAULT_FZF_OPTIONS:-}" > "$fzf_options"
    grep -Fx "$(get-fzf-selection)" "$fzf_input" || return 1
}

fzf-commit() {
    git log --format="%h %s" "${1:-}...${2:-}" | fzf
}

fzf-input() { cat "$fzf_input"; }
fzf-options() { cat "$fzf_options"; }

touch "$fzf_input"
touch "$fzf_options"
touch "$fzf_selections"

