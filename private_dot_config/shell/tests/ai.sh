#!/usr/bin/env bash
set -euo pipefail

RC_AI="/Users/chu/.config/shell/rc/ai"
TMPDIR_TEST="$(mktemp -d)"
export TMPDIR_TEST
trap 'rm -rf "$TMPDIR_TEST"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local label="$3"
  case "$haystack" in
    *"$needle"*) ;;
    *) fail "$label" ;;
  esac
}

run_in_shell() {
  local shell_bin="$1"
  local script="$2"
  local script_path="$TMPDIR_TEST/run.sh"
  printf '%s\n' "$script" > "$script_path"
  "$shell_bin" "$script_path"
}

HELP_SCRIPT=$(cat <<'EOF'
source "/Users/chu/.config/shell/rc/ai"
ai -h
EOF
)

help_bash="$(run_in_shell bash "$HELP_SCRIPT")"
help_zsh="$(run_in_shell zsh "$HELP_SCRIPT")"
assert_contains "$help_bash" "Runtime modes:" "bash help should describe runtime modes"
assert_contains "$help_bash" "Model: qwen-cli" "bash help should mention cli model"
assert_contains "$help_bash" "Model: qwen-fast" "bash help should mention fast model"
assert_contains "$help_bash" "Model: qwen-max" "bash help should mention max model"
assert_contains "$help_bash" "Limit: each stdin or file input <= 256 KB" "bash help should mention KB limit"
assert_contains "$help_bash" "If no subcommand is given, ai sends the input and query without a predefined command prompt." "bash help should mention raw data prompt behavior"
assert_contains "$help_bash" "Prompt: Transform the provided input according to the user's request." "bash help should render command prompt"
assert_contains "$help_bash" "ai [FILE ...] -- QUERY" "bash help should mention file shorthand"
assert_contains "$help_zsh" "Runtime modes:" "zsh help should describe runtime modes"

CLI_SCRIPT=$(cat <<'EOF'
source "/Users/chu/.config/shell/rc/ai"
_ollama_run() {
  printf 'MODEL=%s\nPROMPT=%s\n' "$1" "$2"
}
ai 'find files older than 5 days'
EOF
)

cli_bash="$(run_in_shell bash "$CLI_SCRIPT")"
cli_zsh="$(run_in_shell zsh "$CLI_SCRIPT")"
assert_contains "$cli_bash" "MODEL=qwen-cli" "bash plain ai should use cli model"
assert_contains "$cli_bash" "find files older than 5 days" "bash plain ai should pass query"
assert_contains "$cli_zsh" "MODEL=qwen-cli" "zsh plain ai should use cli model"

HTTP_SCRIPT=$(cat <<'EOF'
source "/Users/chu/.config/shell/rc/ai"
TMPDIR="$TMPDIR_TEST"
curl() {
  local args_file="$TMPDIR_TEST/curl.args"
  local payload_file="$TMPDIR_TEST/curl.payload"
  local data_ref=
  : > "$args_file"
  : > "$payload_file"
  while [ "$#" -gt 0 ]; do
    printf '%s\n' "$1" >> "$args_file"
    if [ "$1" = "--data-binary" ]; then
      data_ref="$2"
      printf '%s\n' "$data_ref" >> "$args_file"
      if [ "${data_ref#@}" != "$data_ref" ]; then
        cat "${data_ref#@}" > "$payload_file"
      else
        printf '%s' "$data_ref" > "$payload_file"
      fi
      shift 2
      continue
    fi
    shift
  done
  printf '{"response":"http-ok"}\n'
}
result="$(_ollama_run 'qwen-fast' 'hello local http')"
printf 'RESULT=%s\n' "$result"
printf 'ARGS=%s\n' "$(tr '\n' '|' < "$TMPDIR_TEST/curl.args")"
printf 'PAYLOAD=%s\n' "$(cat "$TMPDIR_TEST/curl.payload")"
EOF
)

http_bash="$(run_in_shell bash "$HTTP_SCRIPT")"
http_zsh="$(run_in_shell zsh "$HTTP_SCRIPT")"
assert_contains "$http_bash" "RESULT=http-ok" "bash http transport should return parsed response"
assert_contains "$http_bash" "http://127.0.0.1:11434/api/generate" "bash http transport should call local Ollama endpoint"
assert_contains "$http_bash" "@$TMPDIR_TEST/ai-ollama-payload." "bash http transport should send payload by file reference"
assert_contains "$http_bash" "\"model\": \"qwen-fast\"" "bash http transport should send model"
assert_contains "$http_bash" "\"prompt\": \"hello local http\"" "bash http transport should send prompt"
assert_contains "$http_bash" "\"stream\": false" "bash http transport should disable streaming"
assert_contains "$http_bash" "\"keep_alive\": \"30m\"" "bash http transport should send keepalive"
assert_contains "$http_zsh" "RESULT=http-ok" "zsh http transport should return parsed response"
assert_contains "$http_zsh" "http://127.0.0.1:11434/api/generate" "zsh http transport should call local Ollama endpoint"

STDIN_SCRIPT=$(cat <<'EOF'
source "/Users/chu/.config/shell/rc/ai"
_ollama_run() {
  printf 'MODEL=%s\nPROMPT=%s\n' "$1" "$2"
}
printf 'panic: boom\n' | ai 'why did it fail'
EOF
)

stdin_bash="$(run_in_shell bash "$STDIN_SCRIPT")"
stdin_zsh="$(run_in_shell zsh "$STDIN_SCRIPT")"
assert_contains "$stdin_bash" "MODEL=qwen-fast" "bash stdin should use fast model"
assert_contains "$stdin_bash" "panic: boom" "bash stdin should include stdin"
assert_contains "$stdin_bash" "why did it fail" "bash stdin should include raw query"
assert_contains "$stdin_zsh" "MODEL=qwen-fast" "zsh stdin should use fast model"

FILE_ONE="$TMPDIR_TEST/panic.log"
FILE_TWO="$TMPDIR_TEST/app.log"
printf 'panic: nil pointer\n' > "$FILE_ONE"
printf 'retrying request\n' > "$FILE_TWO"

FILE_SHORTHAND_SCRIPT=$(cat <<EOF
source "$RC_AI"
_ollama_run() {
  printf 'MODEL=%s\nPROMPT=%s\n' "\$1" "\$2"
}
ai "$FILE_ONE" "$FILE_TWO" -- 'find the root cause'
EOF
)

file_shorthand_bash="$(run_in_shell bash "$FILE_SHORTHAND_SCRIPT")"
file_shorthand_zsh="$(run_in_shell zsh "$FILE_SHORTHAND_SCRIPT")"
assert_contains "$file_shorthand_bash" "MODEL=qwen-fast" "bash file shorthand should use fast model"
assert_contains "$file_shorthand_bash" "==> $FILE_ONE <==" "bash file shorthand should include first file"
assert_contains "$file_shorthand_bash" "==> $FILE_TWO <==" "bash file shorthand should include second file"
assert_contains "$file_shorthand_bash" "find the root cause" "bash file shorthand should include query"
assert_contains "$file_shorthand_zsh" "==> $FILE_ONE <==" "zsh file shorthand should include first file"

COMMAND_SCRIPT=$(cat <<EOF
source "$RC_AI"
_ollama_run() {
  printf 'MODEL=%s\nPROMPT=%s\n' "\$1" "\$2"
}
ai summarize "$FILE_ONE" -- 'summarize briefly'
printf '\n---\n'
ai incident "$FILE_ONE" -- 'what failed first'
printf '\n---\n'
ai inspect "$FILE_ONE" -- 'explain the panic'
printf '\n---\n'
ai extract "$FILE_ONE" -- 'extract the panic line'
printf '\n---\n'
ai transform "$FILE_ONE" -- 'rewrite this as a short summary'
printf '\n---\n'
ai diff "$FILE_ONE" -- 'review risky changes'
EOF
)

commands_bash="$(run_in_shell bash "$COMMAND_SCRIPT")"
commands_zsh="$(run_in_shell zsh "$COMMAND_SCRIPT")"
assert_contains "$commands_bash" "Summarize the provided input briefly" "bash summarize should use registry prompt"
assert_contains "$commands_bash" "Analyze the provided input as an incident" "bash incident should use registry prompt"
assert_contains "$commands_bash" "Inspect the provided input and explain how it works" "bash inspect should use registry prompt"
assert_contains "$commands_bash" "Extract exactly what the user's request asks for" "bash extract should use registry prompt"
assert_contains "$commands_bash" "Transform the provided input according to the user's request" "bash transform should use registry prompt"
assert_contains "$commands_bash" "Review the provided diff or patch" "bash diff should use registry prompt"
assert_contains "$commands_zsh" "Transform the provided input according to the user's request" "zsh transform should use registry prompt"

RUN_DATA_SCRIPT=$(cat <<EOF
source "$RC_AI"
printf 'y\n' | ai run "$FILE_ONE" -- 'summarize'
EOF
)

run_data_bash="$(run_in_shell bash "$RUN_DATA_SCRIPT" 2>&1 || true)"
run_data_zsh="$(run_in_shell zsh "$RUN_DATA_SCRIPT" 2>&1 || true)"
assert_contains "$run_data_bash" "run/! is only supported in cli mode" "bash should reject run in data mode"
assert_contains "$run_data_zsh" "run/! is only supported in cli mode" "zsh should reject run in data mode"

LIMIT_FILE="$TMPDIR_TEST/too-large.log"
python3 - <<EOF
from pathlib import Path
limit = 256 * 1024
Path("$LIMIT_FILE").write_text("x" * (limit + 1))
EOF

LIMIT_FILE_SCRIPT=$(cat <<EOF
source "$RC_AI"
AI_MODEL=qwen-fast
AI_MODEL_MAX=qwen-max
ai analyze "$LIMIT_FILE" -- 'summarize'
EOF
)

limit_file_bash="$(run_in_shell bash "$LIMIT_FILE_SCRIPT" 2>&1 || true)"
limit_file_zsh="$(run_in_shell zsh "$LIMIT_FILE_SCRIPT" 2>&1 || true)"
assert_contains "$limit_file_bash" "ai input too large for qwen-fast" "bash oversized file should mention fast model"
assert_contains "$limit_file_bash" "qwen-max" "bash oversized file should mention max model"
assert_contains "$limit_file_zsh" "qwen-max" "zsh oversized file should mention max model"

printf 'ok\n'
