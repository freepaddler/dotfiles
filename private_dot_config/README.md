# Personal configuration

This directory contains the active configuration files for my personal environment. The source of persistent configuration is maintained with chezmoi; the workflow and sync boundaries are described in [AGENTS.md](AGENTS.md).

## Key bindings

[KEYMAP.md](KEYMAP.md) is the human-readable index of configured key bindings. Use it to look up bindings and check for conflicts before adding new ones.

## chezmoi

For a person's manual CLI workflow, the [`cz` shell wrapper](shell/rc/chezmoi#L70) provides convenient shortcuts around chezmoi. Agents follow the separate workflow in [AGENTS.md](AGENTS.md) and use chezmoi commands directly. To list managed files under this configuration directory:

```sh
chezmoi managed --include=files ~/.config
```

To check whether a specific file is managed and locate its source entry:

```sh
chezmoi source-path ~/.config/AGENTS.md
```

The command prints the source path for a managed file and reports `not managed` otherwise. Pass a narrower directory to `chezmoi managed` to limit the listing to that directory.
