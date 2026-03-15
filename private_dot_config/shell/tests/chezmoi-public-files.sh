#!/usr/bin/env bash
set -euo pipefail

TMPDIR_TEST="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_TEST"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_file_exists() {
  local path="$1"
  local label="$2"
  [ -f "$path" ] || fail "$label"
}

assert_file_missing() {
  local path="$1"
  local label="$2"
  [ ! -e "$path" ] || fail "$label"
}

CHEZMOI_BIN="${CHEZMOI_BIN:-$(command -v chezmoi || true)}"
if [ -z "$CHEZMOI_BIN" ] && [ -x /opt/homebrew/bin/chezmoi ]; then
  CHEZMOI_BIN=/opt/homebrew/bin/chezmoi
fi
[ -n "$CHEZMOI_BIN" ] || fail "chezmoi not found"

FIXTURE_SRC="$TMPDIR_TEST/source"
FIXTURE_HOME="$TMPDIR_TEST/source-home"
PUBLIC_HOME="$TMPDIR_TEST/public-home"
SSH_COPY_HOME="$TMPDIR_TEST/ssh-copy-home"
OVERRIDE_JSON="$TMPDIR_TEST/public-data.json"
SSH_STUB_DIR="$TMPDIR_TEST/bin"
SSH_CP_ENV_SCRIPT="$TMPDIR_TEST/ssh-cp-env"
TEST_CONFIG="$TMPDIR_TEST/chezmoi.toml"

mkdir -p \
  "$FIXTURE_SRC/.chezmoidata" \
  "$FIXTURE_SRC/private_dot_config/tmux/themes" \
  "$FIXTURE_SRC/private_dot_config/vim" \
  "$FIXTURE_SRC/private_dot_config/ghostty" \
  "$FIXTURE_SRC/private_dot_local/bin" \
  "$FIXTURE_SRC/private_dot_ssh" \
  "$FIXTURE_HOME/.config/tmux/themes" \
  "$FIXTURE_HOME/.config/vim" \
  "$FIXTURE_HOME/.config/ghostty" \
  "$FIXTURE_HOME/.local/bin" \
  "$FIXTURE_HOME/.ssh" \
  "$PUBLIC_HOME" \
  "$SSH_COPY_HOME" \
  "$SSH_STUB_DIR"

cat > "$FIXTURE_SRC/.chezmoidata/public-config.yml" <<'EOF'
public_files:
  - ".profile"
  - ".ssh/"
  - ".ssh/authorized_keys"
  - ".config/"
  - ".config/tmux/*"
  - ".config/vim/**"
  - ".local/bin/"
  - ".local/bin/tm"
EOF

cat > "$FIXTURE_SRC/.chezmoiignore" <<'EOF'
{{- if not .private }}
**
{{- range $pf := .public_files }}
  {{- $path := $pf -}}
  {{- if regexMatch "/\\*\\*$" $pf }}
    {{- $path = regexReplaceAll "/\\*\\*$" $pf "/" -}}
  {{- else if regexMatch "/\\*$" $pf }}
    {{- $path = regexReplaceAll "/\\*$" $pf "/" -}}
  {{- end }}
  {{- $parts := splitList "/" $path -}}
  {{- $prefix := "" -}}
  {{- range $i, $part := $parts }}
    {{- if eq $part "" }}{{- continue -}}{{- end }}
    {{- $prefix = print $prefix $part "/" -}}
    {{- if lt $i (sub (len $parts) 1) }}
!{{$prefix}}
    {{- end }}
  {{- end }}
!{{$pf}}
{{- end }}
{{- end }}
EOF

cat > "$FIXTURE_SRC/private_dot_local/bin/executable_ssh-cp-env.tmpl" <<'EOF'
#!/bin/sh

set -eu

if [ $# -ne 1 ]; then
    printf >&2 "usage: %s <ssh-connection>\n" "${0##*/}"
    exit 2
fi

remote=$1

LIST='
{{- range $pf := .public_files }}
{{$pf}}
{{- end }}
'

set --

for line in $LIST; do
    case $line in
        */)
            continue
            ;;
        *'/**')
            base=${line%/**}
            [ -d "$HOME/$base" ] && set -- "$@" "$base"
            ;;
        *'/*')
            dir=${line%/*}
            for x in "$HOME/$dir"/*; do
                [ -f "$x" ] || continue
                rel=${x#"$HOME"/}
                set -- "$@" "$rel"
            done
            ;;
        *)
            [ -e "$HOME/$line" ] && set -- "$@" "$line"
            ;;
    esac
done

(
    cd "$HOME" || exit 1
    tar --no-xattrs -cf - "$@" | gzip -c | ssh -- "$remote" 'gzip -dc | tar xpof - -C "$HOME"'
)
EOF

printf 'profile\n' > "$FIXTURE_SRC/dot_profile"
printf 'profile\n' > "$FIXTURE_HOME/.profile"

printf 'tmux\n' > "$FIXTURE_SRC/private_dot_config/tmux/tmux.conf"
printf 'theme\n' > "$FIXTURE_SRC/private_dot_config/tmux/themes/nord2.conf"
printf 'vim\n' > "$FIXTURE_SRC/private_dot_config/vim/vimrc"
printf 'ghostty\n' > "$FIXTURE_SRC/private_dot_config/ghostty/config"
printf 'tm\n' > "$FIXTURE_SRC/private_dot_local/bin/executable_tm"
printf 'other\n' > "$FIXTURE_SRC/private_dot_local/bin/executable_other-tool"
printf 'auth\n' > "$FIXTURE_SRC/private_dot_ssh/private_authorized_keys"
printf 'sshcfg\n' > "$FIXTURE_SRC/private_dot_ssh/private_config"

printf 'tmux\n' > "$FIXTURE_HOME/.config/tmux/tmux.conf"
printf 'theme\n' > "$FIXTURE_HOME/.config/tmux/themes/nord2.conf"
printf 'vim\n' > "$FIXTURE_HOME/.config/vim/vimrc"
printf 'ghostty\n' > "$FIXTURE_HOME/.config/ghostty/config"
printf 'tm\n' > "$FIXTURE_HOME/.local/bin/tm"
printf 'other\n' > "$FIXTURE_HOME/.local/bin/other-tool"
printf 'auth\n' > "$FIXTURE_HOME/.ssh/authorized_keys"
printf 'sshcfg\n' > "$FIXTURE_HOME/.ssh/config"

cat > "$OVERRIDE_JSON" <<'EOF'
{"private":false}
EOF

: > "$TEST_CONFIG"

"$CHEZMOI_BIN" --config "$TEST_CONFIG" --config-format toml apply \
  --source "$FIXTURE_SRC" \
  --destination "$PUBLIC_HOME" \
  --override-data-file "$OVERRIDE_JSON"

"$CHEZMOI_BIN" --config "$TEST_CONFIG" --config-format toml execute-template \
  --source "$FIXTURE_SRC" \
  --override-data-file "$OVERRIDE_JSON" \
  --file "$FIXTURE_SRC/private_dot_local/bin/executable_ssh-cp-env.tmpl" \
  > "$SSH_CP_ENV_SCRIPT"
chmod +x "$SSH_CP_ENV_SCRIPT"

cat > "$SSH_STUB_DIR/ssh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
gzip -dc | tar xpof - -C "$FAKE_SSH_DEST"
EOF
chmod +x "$SSH_STUB_DIR/ssh"

HOME="$FIXTURE_HOME" PATH="$SSH_STUB_DIR:$PATH" FAKE_SSH_DEST="$SSH_COPY_HOME" \
  "$SSH_CP_ENV_SCRIPT" test-target >/dev/null

assert_file_exists "$PUBLIC_HOME/.profile" "public chezmoi apply should include .profile"
assert_file_exists "$SSH_COPY_HOME/.profile" "ssh-cp-env should include .profile"
assert_file_exists "$PUBLIC_HOME/.config/vim/vimrc" "public chezmoi apply should include explicit vim subtree"
assert_file_exists "$SSH_COPY_HOME/.config/vim/vimrc" "ssh-cp-env should include explicit vim subtree"
assert_file_exists "$PUBLIC_HOME/.ssh/authorized_keys" "public chezmoi apply should include authorized_keys"
assert_file_exists "$SSH_COPY_HOME/.ssh/authorized_keys" "ssh-cp-env should include authorized_keys"

assert_file_exists "$PUBLIC_HOME/.config/tmux/tmux.conf" "public chezmoi apply should include explicit tmux files"
assert_file_exists "$SSH_COPY_HOME/.config/tmux/tmux.conf" "ssh-cp-env should include explicit tmux files"
assert_file_exists "$PUBLIC_HOME/.local/bin/tm" "public chezmoi apply should include explicit tm"
assert_file_exists "$SSH_COPY_HOME/.local/bin/tm" "ssh-cp-env should include explicit tm"
assert_file_missing "$PUBLIC_HOME/.config/ghostty/config" "public chezmoi apply should not include unrelated ghostty config"
assert_file_missing "$SSH_COPY_HOME/.config/ghostty/config" "ssh-cp-env should not include unrelated ghostty config"
assert_file_missing "$PUBLIC_HOME/.local/bin/other-tool" "public chezmoi apply should not include unrelated local bin tools"
assert_file_missing "$SSH_COPY_HOME/.local/bin/other-tool" "ssh-cp-env should not include unrelated local bin tools"
assert_file_missing "$PUBLIC_HOME/.ssh/config" "public chezmoi apply should not include ssh config"
assert_file_missing "$SSH_COPY_HOME/.ssh/config" "ssh-cp-env should not include ssh config"

printf 'ok\n'
