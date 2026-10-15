#!/bin/sh
ALPINE_VERSION=v3.18
CHEZMOI_REPO_VERSION=v3.19
UID=501
USERNAME=chu
GECOS="Victor Chu"

rm -rf /ish
truncate -s 0 /etc/apk/repositories
{
    echo "https://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/main"
    echo "https://dl-cdn.alpinelinux.org/alpine/${ALPINE_VERSION}/community"
    echo "@${CHEZMOI_REPO_VERSION} https://dl-cdn.alpinelinux.org/alpine/${CHEZMOI_REPO_VERSION}/main"
    echo "@${CHEZMOI_REPO_VERSION} https://dl-cdn.alpinelinux.org/alpine/${CHEZMOI_REPO_VERSION}/community"
} >> /etc/apk/repositories

apk update
apk upgrade
apk fix

apk add --latest \
    ca-certificates \
    bash \
    doas-sudo-shim \
    chezmoi@${CHEZMOI_REPO_VERSION}

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
