# AGENTS.md

This directory contains my active rendered configs. The `chezmoi` source repository is the canonical source for changes intended to persist; use this rendered tree for local edits and real-system checks before saving changes to the source.

Key rules:

- Configuration work is usually stepwise, not a fully automated end-to-end flow: edit the active local files in this rendered `.config` tree without changing `chezmoi` sources, verify the behavior, then stop for the user's own review. Continue only after the user explicitly says to save/add the change to `chezmoi`, unless the user explicitly requests the full cycle up front. Work directly in the source repository only for `chezmoi`-specific functionality.
- New files created in the rendered tree are not automatically tracked. At the save/add-to-chezmoi step, ensure each intended managed file has a corresponding source entry; otherwise explicitly keep it machine-local or exclude it.
- “Save” or “add to chezmoi” means transfer the reviewed local change into the `chezmoi` source, then check for missing source entries, file mode, encryption and template needs, and verify that the resulting source applies correctly to the local system. It does not mean commit or push. Commit and push are separate actions and require an explicit request.
- Do not commit or push `chezmoi` changes unless I explicitly ask for it. Work directly with `chezmoi` commands; the `cz` wrapper is a convenience for the user and is used only when a specific operation depends on it or the user explicitly asks.
- Preserve config integrity. Many files depend on each other, load in a specific order, or are deployed together. Do not make isolated edits that break cross-file assumptions.
- Treat `KEYMAP.md` as the working index for keybindings. When changing keybindings anywhere in this config tree, update `KEYMAP.md` in the same change, keep its `key application app_mode desc` format, and check for collisions with existing entries before applying the change.
- `aerc` is not currently used. Do not include `aerc` bindings in `KEYMAP.md` or spend effort tuning them unless I explicitly ask.
- Shell config is a single modular system. The profile layer is intended to stay portable across POSIX `sh`, `bash`, and `zsh`. `zsh` is the current primary shell; `bash` remains a supported fallback.
- There are two deployment targets: my personal machines and remote servers. Personal machines typically receive the full config set. Remote servers may receive either a local `chezmoi` install/bootstrap or a reduced file subset.
- Minimal and full installs use different `chezmoi` scopes; age-key availability independently controls secrets. Treat that boundary as important, do not infer it loosely, and verify it in `chezmoi` source, data, ignore rules, templates, and encrypted files whenever a change could affect what gets synced where.
- If a task touches public configs, public helpers, or public deployment behavior, explicitly check whether the affected path also needs to be added to `minimal_files` or related minimal-scope rules, and remind me if it has not been handled yet.
- When needed, also inspect the `chezmoi` source repository itself, including scripts, data, selected `.local/bin` tools, and repository history. The history matters because recent shell changes, especially the move toward `zsh`, should not break the fallback model.
- Keep synchronization boundaries clean: do not let important manual changes stay outside `chezmoi`, and do not sync extra files unintentionally.
- When transferring a validated local change into `chezmoi`, account for source files that do not yet exist, preserve the intended file mode, and preserve existing encryption and templating. If a plain file may need encryption, or a file may need to become a template or stop being a template, ask the user before making that format change. Encrypted source files must remain encrypted unless the user explicitly agrees otherwise.
- If a file should remain outside `chezmoi`, make that an explicit decision rather than an accident.

## Linux Configuration Scope

Until the user explicitly changes this rule after stabilizing Linux, do not add host-specific settings or Linux GUI application settings without a cross-platform configuration to `chezmoi`. This includes Niri, DMS, Nemo, and Vulcan settings. Continue managing shared Linux terminal configuration in `chezmoi`, including key bindings, utility configs, Linux-specific `profile`/`rc` files, and `pkg-sync`. If a configuration seems useful to sync but the user has not asked to add it, ask first.

When transferring a locally validated configuration into `chezmoi`, check whether it could break the cross-platform compatibility implemented by this project and tell the user about any such risk.

This file describes the general working model for this config tree. More specific config areas can be handled in separate threads.

## Optional vchu.net Notebook

The primary Codex project is this `.config` directory. A local copy of the vchu.net project notebook may be added to the current project as supplementary context. When that folder is available, read its `AGENTS.md` and `README.md` before notebook-related work and follow them. For personal environment work, use its `Environment/` section primarily; consult `Infrastructure/` only when the task concerns infrastructure. Work directly with the locally available files. Dropbox Connector instructions do not apply to a locally connected notebook folder. If the folder is not available, continue using this config project's instructions without it. Do not assume a particular path, operating system, or sync provider.
