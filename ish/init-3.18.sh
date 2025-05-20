#!/bin/sh

rm -rf /ish
truncate -s 0 /etc/apk/repositories
echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/main" >> /etc/apk/repositories
echo "https://dl-cdn.alpinelinux.org/alpine/v3.18/community" >> /etc/apk/repositories

apk update
apk upgrade
apk fix

apk add --update-cache --latest \
musl-locales musl-locales-lang tzdata docs mandoc-apropos less \
bash bash-completion vim git age tmux openssh-client-default curl \
doas-sudo-shim

echo "permit nopass :wheel" >| /etc/doas.d/doas.conf

addgroup -g 501 chu
adduser -D -u 501 -G chu -g "Victor Chu" -s /bin/bash chu
adduser chu root
adduser chu wheel

homedir=$(getent passwd chu | cut -d: -f6)
mkdir -p "$homedir"/.config "$homedir"/.local/bin
cp -f /iCloud/Documents/Secrets/chezmoi.age "$homedir"/.config/
cat <<'EOF' >| "$homedir"/.local/bin/ish-update.sh
#!/bin/sh
WORKDIR="$HOME/dotfiles"
rm -rf "$WORKDIR"
git clone --depth 1 https://github.com/freepaddler/dotfiles "$WORKDIR"
"$WORKDIR"/ish/ish-update.sh && rm -rf "$WORKDIR"
EOF
chown -R chu:chu "$homedir" && chmod +x "$homedir"/.local/bin/ish-update.sh

doas -u chu "$homedir"/.local/bin/ish-update.sh

echo
echo "done"
echo "goto iOS settings -> iSH. turn on Recovery mode"
echo "relaunch iSH, set Launch cmd to '/bin/login -f chu'"
echo
