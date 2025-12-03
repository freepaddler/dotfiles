ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice depth"1"
zinit light Aloxaf/fzf-tab
source "$_ENV_ZSH_DIR/plugins/fzf-tab.zsh"

zinit ice depth"1" pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure
source "$_ENV_ZSH_DIR/plugins/pure.zsh"

zinit ice depth"1"
zinit light zsh-users/zsh-syntax-highlighting
