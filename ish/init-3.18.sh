#!/bin/sh
ALPINE_VERSION=3.18
UID=501
USERNAME=chu
GECOS="Victor Chu"

rm -rf /ish
truncate -s 0 /etc/apk/repositories
{
    echo "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/main"
    echo "https://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}/community"
} >> /etc/apk/repositories
for v in 3.19 3.20 3.21 3.22 3.23 3.24; do
    {
        echo "@v${v} https://dl-cdn.alpinelinux.org/alpine/v${v}/main"
        echo "@v${v} https://dl-cdn.alpinelinux.org/alpine/v${v}/community"
    } >> /etc/apk/repositories
done

apk update
apk upgrade
apk fix

apk add --update-cache --latest \
    ca-certificates musl-locales musl-locales-lang tzdata \
    docs mandoc-apropos less \
    bash bash-completion \
    doas-sudo-shim \
    vim git tmux@v3.23 chezmoi@v3.19 \
    openssh-client-default \
    iproute2 tcpdump drill inetutils-telnet curl \
    tree

# keep simple
echo "permit nopass :wheel" >| /etc/doas.d/doas.conf

# required for chezmoi
echo "export GOMAXPROCS=1" >| /etc/profile.d/gomaxprocs.sh

addgroup -g $UID $USERNAME
adduser -D -u $UID -G $USERNAME -g "$GECOS" -s /bin/bash $USERNAME
adduser $USERNAME root
adduser $USERNAME wheel

echo
echo "done"
echo "goto iOS settings -> iSH. turn on Recovery mode"
echo "relaunch iSH, set Launch cmd to '/bin/login -f $USERNAME'"
echo "turn off Recovery mode"
echo "you're done"
echo
