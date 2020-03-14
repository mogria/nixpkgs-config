#!#/usr/bin/env bash

fzf_input="$TESTDATA_DIR/fzf-input"
fzf_options="$TESTDATA_DIR/fzf-default-options"

fzf() {
    cat > "$fzf_input"
    echo "$DEFAULT_FZF_OPTIONS" > "$fzf_options"
    grep -Fx "$FZF_SELECTION" "$fzf_input"
}


