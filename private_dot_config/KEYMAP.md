# Keymap

Human-readable key index for active configs and the shared Window Manager scheme.

Window Manager and Desktop shortcuts use tables; existing application sections
keep the text index format below.

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

## Window Manager

Общая схема управления окнами на основе Niri. База — `niri/dms/binds.kdl`;
это ориентир для переноса на macOS, а не утверждение, что все сочетания уже
реализованы. Цифры 1–9 теперь описывают единый ряд workspace;
соответствующую правку Niri пользователь вносит отдельно. Команды реализации остаются
в конфигах соответствующих оконных менеджеров.

- **Mod в Niri — Super; для macOS выбран Cmd+Alt.** Alt-H/J/K/L на Mac
  остаются для сквозной навигации tmux+nvim.
- **H/L — колонки по горизонтали; J/K — окна внутри колонки.**
- **Shift — перемещение вместо фокуса; Ctrl с H/J/K/L — монитор.**
- `Mod+{1–9}` — переключение между workspace 1–9; без отдельной группы 1–3.
- Стрелки, Home и End — альтернативы, их сохраняем в описании.
- Если сочетание Niri содержит дополнительный Alt, физический вариант для Mac
  выберем отдельно: Alt уже входит в Cmd+Alt. Исключения и неподдерживаемые
  действия будем отмечать при проверке каждого менеджера.

### Навигация: окна и колонки

| Сочетание | Действие |
|---|---|
| `Mod+H` <br><sub>Также: `Mod+Left`</sub> | Фокус на колонку слева |
| `Mod+L` <br><sub>Также: `Mod+Right`</sub> | Фокус на колонку справа |
| `Mod+J` <br><sub>Также: `Mod+Down`</sub> | Фокус на окно ниже |
| `Mod+K` <br><sub>Также: `Mod+Up`</sub> | Фокус на окно выше |
| `Mod+,` <br><sub>Также: `Mod+Home`</sub> | Первая колонка |
| `Mod+.` <br><sub>Также: `Mod+End`</sub> | Последняя колонка |

### Перемещение внутри workspace

| Сочетание | Действие |
|---|---|
| `Mod+Shift+H` <br><sub>Также: `Mod+Shift+Left`</sub> | Переместить колонку влево |
| `Mod+Shift+L` <br><sub>Также: `Mod+Shift+Right`</sub> | Переместить колонку вправо |
| `Mod+Shift+J` <br><sub>Также: `Mod+Shift+Down`</sub> | Переместить окно вниз |
| `Mod+Shift+K` <br><sub>Также: `Mod+Shift+Up`</sub> | Переместить окно вверх |
| `Mod+Shift+,` <br><sub>Также: `Mod+Shift+Home`</sub> | Переместить колонку в начало |
| `Mod+Shift+.` <br><sub>Также: `Mod+Shift+End`</sub> | Переместить колонку в конец |
| `Mod+[` | Присоединить/извлечь окно влево |
| `Mod+]` | Присоединить/извлечь окно вправо |

### Workspace: фокус и перенос

| Сочетание | Действие |
|---|---|
| `Mod+{1–9}` | Переключиться на workspace 1–9 |
| `Mod+P` | Предыдущий workspace по порядку |
| `Mod+N` | Следующий workspace по порядку |
| `Mod+Ctrl+Tab` | Вернуться на ранее активный workspace (back-and-forth) |
| `Mod+Ctrl+{1–9}` | Перенести **окно** в workspace 1–9 |
| `Mod+Shift+{1–9}` | Перенести **колонку** в workspace 1–9 |

Окно переносится отдельно, без предварительного извлечения из колонки. Явный параметр фокуса при переносе не добавляем.

### Мониторы

| Сочетание | Действие |
|---|---|
| `Mod+Ctrl+H` <br><sub>Также: `Mod+Ctrl+Left`</sub> | Фокус на монитор слева |
| `Mod+Ctrl+L` <br><sub>Также: `Mod+Ctrl+Right`</sub> | Фокус на монитор справа |
| `Mod+Ctrl+J` | Фокус на монитор снизу |
| `Mod+Ctrl+K` | Фокус на монитор сверху |
| `Mod+Ctrl+Shift+H` <br><sub>Также: `Mod+Ctrl+Shift+Left`</sub> | Перенести колонку на левый монитор |
| `Mod+Ctrl+Shift+L` <br><sub>Также: `Mod+Ctrl+Shift+Right`</sub> | Перенести колонку на правый монитор |
| `Mod+Ctrl+Shift+J` <br><sub>Также: `Mod+Ctrl+Shift+Down`</sub> | Перенести колонку на нижний монитор |
| `Mod+Ctrl+Shift+K` <br><sub>Также: `Mod+Ctrl+Shift+Up`</sub> | Перенести колонку на верхний монитор |
| `Mod+Ctrl+,` | Перенести текущий workspace целиком на монитор слева |
| `Mod+Ctrl+.` | Перенести текущий workspace целиком на монитор справа |

Перенос workspace выполняется через **Ctrl без Shift**. Ctrl+Shift+H/J/K/L по-прежнему переносит колонку. Вертикальный перенос workspace не назначен.

### Размеры, центрирование и fullscreen

| Сочетание | Действие |
|---|---|
| `Mod+R` | Циклически переключить пресет ширины колонки |
| `Mod+Shift+R` | Циклически переключить пресет высоты окна |
| `Mod+=` | Увеличить ширину колонки на 10% |
| `Mod+-` | Уменьшить ширину колонки на 10% |
| `Mod+Shift+=` | Увеличить высоту окна на 10% |
| `Mod+Shift+-` | Уменьшить высоту окна на 10% |
| `Mod+Ctrl+R` | Сбросить заданную высоту окна |
| `Mod+F` | Максимизировать ширину колонки |
| `Mod+Ctrl+F` | Заполнить доступную ширину колонки |
| `Mod+Shift+F` | Полноэкранный режим текущего окна |
| `Mod+;` | Центрировать колонку |
| `Mod+Shift+;` | Центрировать видимые колонки |

Fullscreen Niri — режим композитора; он не тождественен native fullscreen macOS с отдельным Space. Максимальная и доступная ширина — разные действия.

### Режимы окон: floating и tabbing

| Сочетание | Действие |
|---|---|
| `Mod+W` | Переключить фокус между tiling и floating |
| `Mod+Shift+W` | Переключить текущее окно между tiling и floating |
| `Mod+Ctrl+W` | Переключить колонку между обычным и tabbed-представлением |
| `Mod+Q` | Закрыть текущее окно (без автоповтора) |

В tabbed-колонке J/K переключает окна, Shift-J/K меняет их порядок.

### Overview и переключение контекста

| Сочетание | Действие |
|---|---|
| `Mod+Alt+Tab` | Открыть/закрыть Overview |

История workspace — `Mod+Ctrl+Tab` (см. блок workspace). `Mod+Tab` и `Mod+Shift+Tab` в исходном Niri-конфиге не назначены.

### Мышь

| Сочетание | Действие |
|---|---|
| `Mod+WheelScrollUp` <br><sub>Также: `Mod+WheelScrollLeft`</sub> | Фокус на колонку слева |
| `Mod+WheelScrollDown` <br><sub>Также: `Mod+WheelScrollRight`</sub> | Фокус на колонку справа |
| `Mod+Shift+WheelScrollUp` | Фокус на окно выше |
| `Mod+Shift+WheelScrollDown` | Фокус на окно ниже |
| `Mod+Alt+WheelScrollUp` | Workspace выше |
| `Mod+Alt+WheelScrollDown` | Workspace ниже |

Для смены workspace колёсиком задан cooldown 150 мс. Перетаскивание кнопками мыши в `binds.kdl` не настроено и здесь не объявляется назначенным.

### Справка оконного менеджера

| Сочетание | Действие |
|---|---|
| `Mod+Alt+Shift+/` | Показать справку по горячим клавишам оконного менеджера |

### OmniWM: local implementation

Config: `omniwm/settings.toml`. Mod = **Cmd+Alt**. This workspace change is local only; not added to chezmoi.

Workspace keys and internal IDs: § → 1 (tilda 🏠), 1 → 2 (web 🌐), 2 → 3 (term 💻),
3 → 4 (ai ✨), 4 → 5 (4), 5 → 6 (5), 6 → 7 (gaming 🎮), 7 → 8 (7),
8 → 9 (8), 9 → 10 (files 📁), 0 → 11 (0 🖥️). Workspace 11 is assigned to
secondary; all other workspaces are assigned to main. Workspace UUIDs are
preserved for existing workspaces. § uses physical key code 10 directly in OmniWM.
App defaults: Firefox → 2, Ghostty → 3, Codex/ChatGPT → 4, WoT → 7.

```text
Mod-H/L              omniwm niri    focus column left/right
Mod-J/K              omniwm niri    focus window down/up
Mod-Comma/Period     omniwm niri    focus first/last column
Mod-Shift-H/L        omniwm niri    move whole column left/right
Mod-Shift-J/K        omniwm niri    move window down/up within its column
Mod-[ / Mod-]        omniwm niri    consume/expel focused window left/right via Move actions
Mod-Shift-Comma      omniwm niri    move column to first position
Mod-Shift-Period     omniwm niri    move column to last position
Mod-§                omniwm all     switch to workspace 1 (Tilda), physical ISO key
Mod-Ctrl-§           omniwm all     move window to workspace 1 (Tilda)
Mod-Shift-§          omniwm niri    move whole column to workspace 1 (Tilda)
Mod-1..9             omniwm all     switch to workspace IDs 2..10 (key + 1)
Mod-Ctrl-1..9        omniwm all     move window to workspace IDs 2..10 (key + 1)
Mod-Shift-1..9       omniwm niri    move whole column to workspace IDs 2..10 (key + 1)
Mod-0                omniwm all     switch to workspace 11 (0), secondary monitor
Mod-Ctrl-0           omniwm all     move window to workspace 11 (0)
Mod-Shift-0          omniwm niri    move whole column to workspace 11 (0)
Mod-N/P              omniwm all     next/previous workspace
Mod-Ctrl-Tab         omniwm all     last active workspace
Mod-Ctrl-P/N         omniwm all     focus previous/next monitor
Mod-Ctrl-Shift-H     omniwm all     move focused window to left monitor
Mod-Ctrl-Shift-J     omniwm all     move focused window to lower monitor
Mod-Ctrl-Shift-K     omniwm all     move focused window to upper monitor
Mod-Ctrl-Shift-L     omniwm all     move focused window to right monitor
Mod-Ctrl-Comma       omniwm all     move current workspace to left monitor
Mod-Ctrl-Period      omniwm all     move current workspace to right monitor
Mod-R                omniwm niri    cycle container width presets forward
Mod-Shift-R          omniwm niri    cycle window height presets forward
Mod-Minus/Equal      omniwm niri    decrease/increase container width by configured step
Mod-Shift-Minus      omniwm niri    decrease window height by configured step
Mod-Shift-Equal      omniwm niri    increase window height by configured step
Mod-Ctrl-R           omniwm niri    reset window height
Mod-F                omniwm niri    toggle full container width
Mod-Shift-F          omniwm niri    expand container to available width
Mod-Ctrl-F           omniwm all     toggle OmniWM fullscreen; not native macOS fullscreen
Mod-Semicolon        omniwm niri    center focused column
Mod-Shift-Semicolon  omniwm niri    center visible columns
Mod-W                omniwm all     toggle floating/tiled focus
Mod-Shift-W          omniwm all     toggle focused window floating
Mod-Ctrl-W           omniwm niri    toggle column tabbed mode
Mod-Tab              omniwm all     toggle overview; existing binding preserved
Mod-Shift-/          omniwm all     open Menu Anywhere; replaces Mod-M
```

Differences and intentionally unassigned actions:

- `Mod-[` / `Mod-]` use Move Left/Right for consume/expel; the user confirmed
  this works for the intended workflow. Layout orientation and edge settings still apply.
- Close Focused Window is currently unassigned; no Mod-Q binding is active.
- Monitor focus uses previous/next order on Mod-Ctrl-P/N instead of Niri's
  directional focus. Mod-Ctrl-Shift-H/J/K/L moves one window instead of a whole
  column. The existing Follow Window to Monitor setting remains enabled.
- Native fullscreen remains unassigned. OmniWM fullscreen is used on Mod-Ctrl-F.
- No dedicated hotkey-help action was assigned; the existing Command Palette
  binding (Mod-Ctrl-Space) was preserved.
- Size actions use the configured resize increment (currently 10%). Primary/secondary
  spans mean width/height in horizontal Niri orientation; changing orientation changes that mapping.
- Workspace-to-monitor moves temporarily override routing without changing the
  workspace's saved Home Monitor. Workspace numbers use configured workspace
  identities, not positions on the current monitor.
- Existing Mod-Tab overview and unrelated bindings were preserved. No arrow,
  Home/End, mouse, launcher, or system-shortcut alternatives were added.

## Desktop shortcuts

### Linux / Niri: запуск приложений

| Сочетание | Действие |
|---|---|
| `Mod+Alt+B` | Браузер Firefox |
| `Mod+Alt+T` | Терминал Ghostty |
| `Mod+Shift+M` | Почта Geary |
| `Mod+Shift+T` | Telegram |
| `Mod+Shift+/` | Enpass Assistant |
| `Mod+Alt+=` | Калькулятор (floating scratch) |

### Linux / Niri: системные действия

| Сочетание | Действие |
|---|---|
| `Mod+Alt+Q` | Выйти из Niri |
| `Mod+Alt+P` | Выключить мониторы |
| `Print` <br><sub>Также: `F19`</sub> | Скриншот (область) |
| `Alt+Print` <br><sub>Также: `Mod+F19`</sub> | Скриншот окна |
| `Ctrl+Print` <br><sub>Также: `Mod+Alt+F19`</sub> | Скриншот экрана |
| `XF86Launch8` | Переключить раскладку на английскую |
| `XF86Launch9` | Переключить раскладку на русскую |

### Linux / DMS: оболочка и мультимедиа

| Сочетание | Действие |
|---|---|
| `Alt+Space` | Spotlight Bar |
| `Ctrl+Space` | Application Launcher |
| `Mod+Alt+BackSpace` | Task Manager |
| `Mod+Alt+L` | Lock Screen |
| `Mod+Alt+N` | Notification Center |
| `Mod+Alt+/` | Settings |
| `Mod+Alt+W` | Window Rules |
| `Mod+Shift+N` | Notepad |
| `Mod+Shift+grave` | Clipboard Manager |
| `XF86AudioLowerVolume` / `XF86AudioRaiseVolume` | Громкость −3 / +3 |
| `XF86AudioMute` | Выключить звук |
| `XF86AudioMicMute` | Выключить микрофон |
| `XF86AudioPlay` / `XF86AudioPause` | Плеер: пауза/продолжить |
| `XF86AudioPrev` / `XF86AudioNext` | Плеер: предыдущий/следующий |
| `Ctrl+XF86AudioLowerVolume` / `Ctrl+XF86AudioRaiseVolume` | Управление громкостью плеера −3 / +3 |
| `XF86MonBrightnessDown` / `XF86MonBrightnessUp` | Яркость −5 / +5 |

Для аудио, управления громкостью плеера и яркости в Niri разрешена работа
при заблокированном экране (`allow-when-locked=true`).

### macOS

Сочетания запуска приложений и системных действий будем согласовывать отдельно.
Текущие действующие macOS-привязки сохранены в разделах Karabiner и AeroSpace.

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
<leader>r            run
<leader>s            search
<leader>t            tests
<leader>u            UI toggles
<leader>v            registers / void
<leader>w            windows
<leader>x            diagnostics / quickfix / location lists
```

`c`, `d`, `t`, `u`, `w`, and `x` are reserved for future IDE mappings.
Global clipboard mappings under `<leader>y/Y/p/P` intentionally remain available
in addition to the `<leader>v` group.

```text
<leader>             nvim all           Space
<localleader>        nvim all           \
<leader>-            nvim normal        split window horizontally
<leader>\            nvim normal        split window vertically

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

<leader>ed           nvim normal        toggle dadbod UI
<leader>fd           nvim normal        find dadbod connection
<leader>fq           nvim normal        find SQL query/template copy
<leader>rq           nvim visual        run selected SQL with dadbod
<leader>ra           nvim sql normal    run SQL buffer with dadbod
<leader>rr           nvim sql normal    run SQL query with dadbod

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

]q                   nvim normal        next Trouble or quickfix item and center
[q                   nvim normal        previous Trouble or quickfix item and center
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
<leader>um           nvim normal        toggle mouse
j                    nvim normal/visual visual line down
k                    nvim normal/visual visual line up
J                    nvim normal        join line, keep cursor
J                    nvim visual        move selection down
K                    nvim visual        move selection up

<leader>ee           nvim normal        explorer at current file directory
<leader>eE           nvim normal        explorer at working directory
<leader>es           nvim normal        explorer at current file directory in vertical split
<leader>eS           nvim normal        explorer at current file directory in horizontal split
<leader>sr           nvim normal/visual search and replace current file type
<leader>sR           nvim normal/visual search and replace all files
<leader>ss           nvim normal        substitute word under cursor
<leader>cX           nvim normal        chmod +x current file
<leader>ff           nvim normal        telescope find files
<leader>fn           nvim normal        find notes and scratches
<leader>fg           nvim normal        telescope live grep
<leader>sn           nvim normal        search notes and scratches
<leader>sg           nvim normal        telescope live grep
<leader>fm           nvim normal        telescope keymaps
<leader>fh           nvim normal        telescope help tags
<leader>fb           nvim normal        telescope buffers
<leader>fr           nvim normal        telescope recent files
<leader>fz           nvim normal        telescope chezmoi managed files
C-v                  nvim telescope     open selection in vertical split
C-h                  nvim telescope     open selection in horizontal split
C-b                  nvim telescope     open selection in current buffer
C-t                  nvim telescope     open selection in new tab
Enter                nvim notes picker  open selected in popup
C-a                  nvim notes picker  create note in popup
C-s                  nvim notes picker  create scratch in popup
C-l                  nvim notes picker  open selected in popup
C-x                  nvim notes picker  delete selected
C-l                  nvim normal        toggle last note popup
q                    nvim notes popup   save and close popup
C-l                  nvim notes popup   save and close popup
C-b                  nvim notes popup   promote popup to current buffer
C-v                  nvim notes popup   promote popup to vertical split
C-h                  nvim notes popup   promote popup to horizontal split
C-t                  nvim notes popup   promote popup to new tab
C-a                  nvim notes popup   create note in popup
C-s                  nvim notes popup   create scratch in popup

<leader>ggf          nvim normal        telescope git files
<leader>ggs          nvim normal        telescope git status files
<leader>ggl          nvim normal        telescope git log
<leader>ggF          nvim normal        telescope current file git log
<leader>ggL          nvim normal/visual telescope current line/range git log
<leader>ggb          nvim normal        telescope git branches
<leader>ggS          nvim normal        telescope git stash

<leader>gs           nvim normal        fugitive Git
<leader>gf           nvim normal        fugitive fetch --prune
<leader>gF           nvim normal        fugitive fetch --all --prune --tags
<leader>gp           nvim normal        fugitive pull --ff-only
<leader>gu           nvim normal        fugitive pull --rebase --autostash
<leader>gP           nvim normal        fugitive push
<leader>gB           nvim normal        fugitive blame
<leader>gd           nvim normal        fugitive vertical 3-way diff
<leader>gmt          nvim normal        fugitive mergetool
<leader>gma          nvim normal        fugitive merge abort
<leader>grc          nvim normal        fugitive rebase continue
<leader>gra          nvim normal        fugitive rebase abort
<leader>et           nvim normal        toggle neo-tree filesystem at project root
<leader>ef           nvim normal        toggle neo-tree filesystem left
<leader>eb           nvim normal        neo-tree buffers reveal float
<leader>eg           nvim normal        toggle neo-tree git status left
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

## Vim

Config: `vim/mappings.vim`

Server-oriented Vim mirrors non-plugin nvim mappings where practical.

```text
<leader>             vim all           Space
<localleader>        vim all           \
<leader>-            vim normal        split window horizontally
<leader>\            vim normal        split window vertically

Alt-h                vim normal/visual window left, or tmux pane at edge
Alt-j                vim normal/visual window down, or tmux pane at edge
Alt-k                vim normal/visual window up, or tmux pane at edge
Alt-l                vim normal/visual window right, or tmux pane at edge
Alt-h                vim insert        leave insert, then window left or tmux pane at edge
Alt-j                vim insert        leave insert, then window down or tmux pane at edge
Alt-k                vim insert        leave insert, then window up or tmux pane at edge
Alt-l                vim insert        leave insert, then window right or tmux pane at edge
C-h                  vim normal        window left
C-j                  vim normal        window down
C-k                  vim normal        window up
C-l                  vim normal        window right

C-c                  vim insert        escape
C-s                  vim normal        save file
jj                   vim insert        escape
jk                   vim insert        escape

<leader>y            vim normal/visual yank to clipboard
<leader>Y            vim normal        yank to clipboard until EOF
<leader>p            vim normal        paste after from clipboard
<leader>P            vim normal        paste before from clipboard
<leader>p            vim visual        replace without yanking
<leader>vd           vim normal/visual delete without yanking
<leader>vD           vim normal        delete to EOL without yanking
<leader>vc           vim normal/visual change without yanking
<leader>vC           vim normal        change to EOL without yanking
<leader>vy           vim normal/visual yank to clipboard
<leader>vY           vim normal        yank to clipboard until EOF
<leader>vp           vim normal/visual paste after from clipboard
<leader>vP           vim normal        paste before from clipboard

<leader>bn           vim normal        next buffer
<leader>bp           vim normal        previous buffer
<leader>bl           vim normal        last buffer
<leader>bd           vim normal        delete current buffer
<leader>bD           vim normal        delete all buffers except current
[b                    vim normal        previous buffer
]b                    vim normal        next buffer

<leader><Tab>c       vim normal        new tab
<leader><Tab>d       vim normal        delete current tab
<leader><Tab>D       vim normal        delete all tabs except current
<leader><Tab>e       vim normal        new tab with explorer at current file directory
<leader><Tab>E       vim normal        new tab with explorer at working directory
<leader><Tab>gf      vim normal        open file under cursor in new tab
<leader><Tab>n       vim normal        next tab
<leader><Tab>p       vim normal        previous tab
<leader><Tab><Tab>   vim normal        last tab
<leader><Tab>1..9    vim normal        go to tab 1..9
[t                    vim normal        previous tab
]t                    vim normal        next tab

]q                   vim normal        quickfix next
[q                   vim normal        quickfix previous
]l                   vim normal        location next
[l                   vim normal        location previous

C-d                  vim normal        scroll down and center
C-u                  vim normal        scroll up and center
n                    vim normal        next search and center
N                    vim normal        previous search and center
<leader>uh           vim normal        toggle search highlight
<leader>ul           vim normal        toggle line numbers
<leader>uL           vim normal        toggle relative line numbers
<leader>um           vim normal        toggle mouse
j                    vim normal/visual visual line down
k                    vim normal/visual visual line up
J                    vim normal        join line, keep cursor
J                    vim visual        move selection down
K                    vim visual        move selection up

<leader>ee           vim normal        explorer at current file directory
<leader>eE           vim normal        explorer at working directory
<leader>es           vim normal        explorer at current file directory in vertical split
<leader>eS           vim normal        explorer at current file directory in horizontal split
<leader>ss           vim normal        substitute word under cursor
<leader>cX           vim normal        chmod +x current file
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
