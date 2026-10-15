#!/bin/sh
set -eu

case "$(uname -r)" in
    *-ish) ;;
    *) exit 0 ;;
esac

if [ "$(id -u)" -ne 0 ]; then
    exec sudo sh "$0" "$@"
fi

ALPINE_VERSION=3.18

{
    echo "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main"
    echo "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community"
    for v in 3.19 3.20 3.21 3.22 3.23 3.24; do
        echo "@v${v} https://dl-cdn.alpinelinux.org/alpine/v${v}/main"
        echo "@v${v} https://dl-cdn.alpinelinux.org/alpine/v${v}/community"
    done
} > /etc/apk/repositories

apk update
apk upgrade
apk fix

set --

# base
set -- "$@" ca-certificates musl-locales musl-locales-lang tzdata doas-sudo-shim

# man
set -- "$@" docs mandoc-apropos less

# ssh
set -- "$@" openssh-client-default

# net utils
set -- "$@" iproute2 tcpdump drill inetutils-telnet

# shell
set -- "$@" bash bash-completion
set -- "$@" vim tmux@v3.23 git chezmoi@v3.19
set -- "$@" less curl tree

apk add --latest "$@"
