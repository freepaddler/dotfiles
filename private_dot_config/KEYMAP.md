# Keymap

Human-readable key index for active configs.

Format:

```text
key application app_mode desc
```

Notes:

```text
all       all modes for that application
default   application default, not explicitly configured here
main      AeroSpace main mode
term      AeroSpace terminal mode
normal    vi/nvim normal mode
insert    vi/nvim insert mode
visual    vi/nvim visual mode
prefix    tmux prefix binding
root      tmux root binding, no prefix
cmd       command-line mode
```

Use it with grep/sort:

```sh
rg '^Alt' KEYMAP.md
rg ' nvim ' KEYMAP.md
sort KEYMAP.md
```

Terminal workspace `2` switches AeroSpace to `term` mode. Other workspaces use
`main` mode.

## Karabiner

Config: `karabiner/karabiner.json`

```text
Caps                 karabiner hold  right_control
Caps                 karabiner alone Esc
Left-Shift+Right-Shift karabiner all toggle Caps Lock
Left-Option          karabiner hold  use ABC while held on Russian layout, restore Russian on release
§                    karabiner all   switch to ABC and type section
```

## AeroSpace

Config: `aerospace/aerospace.toml`

```text
Alt-0..9             aerospace all  workspace 0..9
Alt-`                aerospace all  workspace ~
Alt-[                aerospace all  previous window, dfs order
Alt-]                aerospace all  next window, dfs order
Alt-Tab              aerospace all  focus back and forth
Alt-Ctrl-Tab         aerospace all  workspace back and forth
Alt-q                aerospace all  hide current/floating window
Alt-a                aerospace all  reveal all windows
Alt-h                aerospace main focus left
Alt-j                aerospace main focus down
Alt-k                aerospace main focus up
Alt-l                aerospace main focus right

Alt-Shift-=          aerospace all  open Calculator
Alt-Shift-b          aerospace all  open BBEdit
Alt-Shift-c          aerospace all  open Codex
Alt-Shift-g          aerospace all  open ChatGPT
Alt-Shift-m          aerospace all  open Mail
Alt-Shift-t          aerospace all  open Telegram
Alt-Shift-u          aerospace all  open Chromium
Alt-Shift-w          aerospace all  open WhatsApp
Alt-Shift-y          aerospace all  open Yandex Telemost

Alt-Shift-,          aerospace all  accordion layout
Alt-Shift-.          aerospace all  tiles layout
Alt-Shift-/          aerospace all  toggle floating/tiling
Alt-Shift-\          aerospace all  flatten workspace tree
Alt-Shift-z          aerospace all  fullscreen

Alt-Shift-h          aerospace all  move window left
Alt-Shift-j          aerospace all  move window down
Alt-Shift-k          aerospace all  move window up
Alt-Shift-l          aerospace all  move window right

Alt-Shift-0..9       aerospace all  move window to workspace 0..9
Alt-Shift-`          aerospace all  move window to workspace ~

Alt-Ctrl--           aerospace all  resize smaller
Alt-Ctrl-=           aerospace all  resize larger
Alt-Ctrl-h           aerospace main join with left
Alt-Ctrl-j           aerospace main join with down
Alt-Ctrl-k           aerospace main join with up
Alt-Ctrl-l           aerospace main join with right

Alt-Ctrl-Shift-h     aerospace all  move workspace to monitor left
Alt-Ctrl-Shift-j     aerospace all  move workspace to monitor down
Alt-Ctrl-Shift-k     aerospace all  move workspace to monitor up
Alt-Ctrl-Shift-l     aerospace all  move workspace to monitor right
```

In AeroSpace `term` mode, `Alt-h/j/k/l` are left to tmux.

## tmux

Config: `tmux/tmux.conf`

```text
C-q                  tmux root   tmux prefix
§                    tmux root   secondary prefix
Alt-h                tmux root   pane left, or send to nvim/vim
Alt-j                tmux root   pane down, or send to nvim/vim
Alt-k                tmux root   pane up, or send to nvim/vim
Alt-l                tmux root   pane right, or send to nvim/vim

h                    tmux prefix pane left
j                    tmux prefix pane down
k                    tmux prefix pane up
l                    tmux prefix pane right
H                    tmux prefix resize pane left
J                    tmux prefix resize pane down
K                    tmux prefix resize pane up
L                    tmux prefix resize pane right
;                    tmux prefix last pane

\                    tmux prefix split horizontal
|                    tmux prefix join horizontal
-                    tmux prefix split vertical
_                    tmux prefix join vertical

'                    tmux prefix last window
Tab                  tmux prefix last client
q                    tmux prefix kill window, confirm
Q                    tmux prefix kill session, confirm
W                    tmux prefix rename window
R                    tmux prefix reload tmux config
C-d                  tmux prefix detach
f                    tmux prefix tmux-sessionizer popup
e                    tmux prefix tmux-sessionizer new window, preset 0
r                    tmux prefix tmux-sessionizer new window, preset 1
t                    tmux prefix tmux-sessionizer new window, preset 2
y                    tmux prefix tmux-sessionizer new window, preset 3
S                    tmux prefix toggle synchronize-panes
T                    tmux prefix clock mode

C-v                  tmux prefix iPad split horizontal
C-S-v                tmux prefix iPad join horizontal
C-h                  tmux prefix iPad split vertical
C-S-h                tmux prefix iPad join vertical

Enter                tmux copy   copy selection and cancel
M-Enter              tmux copy   copy selection, cancel, paste buffer
y                    tmux copy   copy selection
Esc                  tmux copy   clear selection, or exit copy mode
```

`Alt-h/j/k/l` are tmux root bindings. In nvim/vim panes, tmux sends them through
to the editor; nvim then navigates editor windows and falls through to tmux at
the edge.

## nvim

Config: `nvim/lua/keymap.lua`

Leader group plan:

```text
<leader><Tab>        tabs
<leader>b            buffers
<leader>c            code / LSP
<leader>d            debugger
<leader>e            explorer
<leader>f            find
<leader>g            git
<leader>q            quit / sessions
<leader>s            search
<leader>t            tests
<leader>u            UI toggles
<leader>v            registers / void
<leader>w            windows
<leader>x            diagnostics / quickfix / location lists
```

`c`, `d`, `q`, `t`, `u`, `w`, and `x` are reserved for future IDE mappings.
Global clipboard mappings under `<leader>y/Y/p/P` intentionally remain available
in addition to the `<leader>v` group.

```text
<leader>             nvim all           Space
<localleader>        nvim all           \
<leader>-            nvim normal        split window horizontally
<leader>\            nvim normal        split window vertically

C-h                  nvim normal        window left, or tmux pane at edge
C-j                  nvim normal        window down, or tmux pane at edge
C-k                  nvim normal        window up, or tmux pane at edge
C-l                  nvim normal        window right, or tmux pane at edge
Alt-h                nvim normal/visual window left, or tmux pane at edge
Alt-j                nvim normal/visual window down, or tmux pane at edge
Alt-k                nvim normal/visual window up, or tmux pane at edge
Alt-l                nvim normal/visual window right, or tmux pane at edge
Alt-h                nvim insert/replace leave insert, then window left or tmux pane at edge
Alt-j                nvim insert/replace leave insert, then window down or tmux pane at edge
Alt-k                nvim insert/replace leave insert, then window up or tmux pane at edge
Alt-l                nvim insert/replace leave insert, then window right or tmux pane at edge

C-c                  nvim insert        escape
C-s                  nvim normal        save file
jj                   nvim insert        escape
jk                   nvim insert        escape

<leader>y            nvim normal/visual yank to clipboard
<leader>Y            nvim normal        yank to clipboard until EOF
<leader>p            nvim normal        paste after from clipboard
<leader>P            nvim normal        paste before from clipboard
<leader>p            nvim visual        replace without yanking
<leader>vd           nvim normal/visual delete without yanking
<leader>vD           nvim normal        delete to EOL without yanking
<leader>vc           nvim normal/visual change without yanking
<leader>vC           nvim normal        change to EOL without yanking
<leader>vy           nvim normal/visual yank to clipboard
<leader>vY           nvim normal        yank to clipboard until EOF
<leader>vp           nvim normal/visual paste after from clipboard
<leader>vP           nvim normal        paste before from clipboard
<leader>vr           nvim normal        telescope registers

<leader>bn           nvim normal        next buffer
<leader>bp           nvim normal        previous buffer
<leader>bl           nvim normal        last buffer
<leader>bd           nvim normal        delete current buffer
<leader>bD           nvim normal        delete all buffers except current
[b                    nvim normal        previous buffer
]b                    nvim normal        next buffer

<leader><Tab>c       nvim normal        new tab
<leader><Tab>d       nvim normal        delete current tab
<leader><Tab>D       nvim normal        delete all tabs except current
<leader><Tab>e       nvim normal        new tab with explorer at current file directory
<leader><Tab>E       nvim normal        new tab with explorer at working directory
<leader><Tab>gf      nvim normal        open file under cursor in new tab
<leader><Tab>n       nvim normal        next tab
<leader><Tab>p       nvim normal        previous tab
<leader><Tab><Tab>   nvim normal        last tab
<leader><Tab>1..9    nvim normal        go to tab 1..9
[t                    nvim normal        previous tab
]t                    nvim normal        next tab

]q                   nvim normal        next Trouble or quickfix item
[q                   nvim normal        previous Trouble or quickfix item
]l                   nvim normal        location next
[l                   nvim normal        location previous
]d                   nvim normal        diagnostic next
[d                   nvim normal        diagnostic previous

<leader>xx           nvim normal        toggle workspace diagnostics in Trouble
<leader>xX           nvim normal        toggle buffer diagnostics in Trouble
<leader>xL           nvim normal        toggle location list in Trouble
<leader>xQ           nvim normal        toggle quickfix list in Trouble
<leader>cs           nvim normal        toggle symbols in Trouble
<leader>cS           nvim normal        toggle LSP references and definitions in Trouble

C-d                  nvim normal        scroll down and center
C-u                  nvim normal        scroll up and center
n                    nvim normal        next search and center
N                    nvim normal        previous search and center
<leader>uh           nvim normal        toggle search highlight
<leader>ud           nvim normal        toggle diagnostics
<leader>ul           nvim normal        toggle line numbers
<leader>uL           nvim normal        toggle relative line numbers
j                    nvim normal/visual visual line down
k                    nvim normal/visual visual line up
J                    nvim normal        join line, keep cursor
J                    nvim visual        move selection down
K                    nvim visual        move selection up

<leader>ee           nvim normal        explorer at current file directory
<leader>eE           nvim normal        explorer at working directory
<leader>sr           nvim normal/visual search and replace current file type
<leader>sR           nvim normal/visual search and replace all files
<leader>ss           nvim normal        substitute word under cursor
<leader>cX           nvim normal        chmod +x current file
<leader>ff           nvim normal        telescope find files
<leader>fp           nvim normal        telescope find git files
<leader>fg           nvim normal        telescope live grep
<leader>sg           nvim normal        telescope live grep
<leader>fm           nvim normal        telescope keymaps
<leader>fh           nvim normal        telescope help tags
<leader>fb           nvim normal        telescope buffers
<leader>fr           nvim normal        telescope recent files
<leader>fz           nvim normal        telescope chezmoi managed files
C-\                  nvim telescope     open selection in vertical split
C--                  nvim telescope     open selection in horizontal split

<leader>et           nvim normal        toggle neo-tree filesystem reveal left
<leader>ef           nvim normal        reveal current file in neo-tree left
<leader>eb           nvim normal        neo-tree buffers reveal float
<leader>gs           nvim normal        fugitive Git
<leader>su           nvim normal        undotree toggle
<leader>cf           nvim normal        format with conform
<leader>cl           nvim normal        lint current buffer
<leader>cp           nvim markdown      toggle Markdown preview
K                    nvim lsp           hover
gd                   nvim lsp           go to definition
gD                   nvim lsp           go to declaration

C-s                  nvim blink         complete snippets only
C-k                  nvim blink         scroll docs up
C-j                  nvim blink         scroll docs down
C-u                  nvim blink         scroll docs up, large step
C-d                  nvim blink         scroll docs down, large step
C-Space              nvim blink         complete or toggle docs
C-@                  nvim blink         complete or toggle docs
C-e                  nvim blink         hide completion
C-y                  nvim blink         confirm completion
CR                   nvim blink         confirm completion
Tab                  nvim blink         next completion item or snippet jump
S-Tab                nvim blink         previous completion item or snippet jump
Tab                  nvim markdown      next table cell
S-Tab                nvim markdown      previous table cell
Ctrl-Alt-H           nvim markdown      move table column left
Ctrl-Alt-L           nvim markdown      move table column right
Ctrl-Alt-J           nvim markdown      move table row down
Ctrl-Alt-K           nvim markdown      move table row up
Ctrl-Alt-I           nvim markdown      insert table column left
Ctrl-Alt-A           nvim markdown      insert table column right
Ctrl-Alt-U           nvim markdown      insert table row above
Ctrl-Alt-D           nvim markdown      insert table row below
Ctrl-Alt-N           nvim markdown      insert table
Ctrl-Alt-X           nvim markdown      delete table column
```

## IdeaVim

Config: `ideavim/ideavimrc`

```text
C-h                  ideavim normal        window left
C-j                  ideavim normal        window down
C-k                  ideavim normal        window up
C-l                  ideavim normal        window right
C-d                  ideavim normal        scroll down and center
C-u                  ideavim normal        scroll up and center
jj                   ideavim insert        escape
jk                   ideavim insert        escape
```

## yazi

Config: `yazi/keymap.toml`

```text
!                    yazi mgr    open shell here
gd                   yazi mgr    cd to ~/Documents
gl                   yazi mgr    cd to ~/Downloads
ge                   yazi mgr    cd to ~/dev
gw                   yazi mgr    cd to ~/work
gi                   yazi mgr    show git file changes
l                    yazi mgr    smart enter/open
Enter                yazi mgr    smart enter/open
cm                   yazi mgr    chmod selected files
M                    yazi mgr    mount plugin
p                    yazi mgr    smart paste
```

## fzf

Config: `shell/rc/fzf`, `shell/zsh/fzf-tab.zsh`

```text
C-/                  fzf all     move/hide preview window
Shift-Up             fzf default scroll preview up
Shift-Down           fzf default scroll preview down
C-y                  fzf ctrl-r  copy selected command to clipboard and abort
Shift-Tab            fzf-tab zle toggle fzf-tab/compsys
<                    fzf-tab all switch completion group left
>                    fzf-tab all switch completion group right
```

## zsh

Config: `shell/zsh/zshrc`

```text
bindkey-e            zsh all    emacs keymap by default
C-n                  zsh emacs  history search forward
C-p                  zsh emacs  history search backward
C-x-C-e              zsh emacs  edit command line in editor
C-g                  zsh emacs  fzf completion trigger
M-.                  zsh viins  insert last word

Home                 zsh all    beginning of line
End                  zsh all    end of line
Delete               zsh all    delete char
PageUp               zsh all    history search backward
PageDown             zsh all    history search forward
C-Left               zsh all    backward word
C-Right              zsh all    forward word
Shift-Left           zsh all    backward word
Shift-Right          zsh all    forward word
```
