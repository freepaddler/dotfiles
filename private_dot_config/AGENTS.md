# AGENTS.md

This directory contains my active configs. Work here directly for fast inspection and iteration, but treat `chezmoi` as the source of truth for anything that should persist.

Key rules:

- Anything I edit manually and want to keep should end up tracked by `chezmoi`, unless it is explicitly machine-local, generated, or intentionally excluded from sync.
- Prefer working from this `.config` tree first, then reconcile the final result with `chezmoi` by checking what is tracked, what drifted, and what still needs to be added, updated, or ignored.
- Do not commit or push `chezmoi` changes unless I explicitly ask for it. `Add to chezmoi` means `cz add`; `push` means `cz save`. It is normal to keep local working changes in `.config` and pending tracked changes in the local `chezmoi` source repo until I ask to save them.
- When operating on `chezmoi`, prefer the local `cz` wrapper defined in `shell/rc/chezmoi` and run it outside sandbox restrictions when available. Treat `cz` as a shell wrapper, not a standalone binary: load the relevant shell rc so the function exists before concluding that it is unavailable. Fall back to lower-level `chezmoi` and `git` commands only if that wrapper still isn't available, is broken, or is insufficient for the task.
- Preserve config integrity. Many files depend on each other, load in a specific order, or are deployed together. Do not make isolated edits that break cross-file assumptions.
- Treat `KEYMAP.md` as the working index for keybindings. When changing keybindings anywhere in this config tree, update `KEYMAP.md` in the same change, keep its `key application app_mode desc` format, and check for collisions with existing entries before applying the change.
- `aerc` is not currently used. Do not include `aerc` bindings in `KEYMAP.md` or spend effort tuning them unless I explicitly ask.
- Shell config is a single modular system. The profile layer is intended to stay portable across POSIX `sh`, `bash`, and `zsh`. `zsh` is the current primary shell; `bash` remains a supported fallback.
- There are two deployment targets: my personal machines and remote servers. Personal machines typically receive the full config set. Remote servers may receive either a local `chezmoi` install/bootstrap or a reduced file subset.
- Public and personal installs use different `chezmoi` scopes. Treat that boundary as important, do not infer it loosely, and verify it in `chezmoi` source, data, ignore rules, templates, and encrypted files whenever a change could affect what gets synced where.
- If a task touches public configs, public helpers, or public deployment behavior, explicitly check whether the affected path also needs to be added to `public_files` or related public-scope rules, and remind me if it has not been handled yet.
- When needed, also inspect the `chezmoi` source repository itself, including scripts, data, selected `.local/bin` tools, and repository history. The history matters because recent shell changes, especially the move toward `zsh`, should not break the fallback model.
- Keep synchronization boundaries clean: do not let important manual changes stay outside `chezmoi`, and do not sync extra files unintentionally.
- Encrypted files must remain encrypted. Do not convert encrypted `chezmoi` files into plain tracked files or edit them in rendered form. Use `chezmoi edit` or edit templates/source files through `chezmoi` so encryption and templating are preserved and secrets are not leaked.
- If the `cz` wrapper fails, behaves unexpectedly, or does not cover the needed workflow, report whether the failure was due to wrapper loading, wrapper behavior, or missing underlying `chezmoi`, and propose a concrete fix before or alongside any lower-level workaround.
- If a file should remain outside `chezmoi`, make that an explicit decision rather than an accident.

This file describes the general working model for this config tree. More specific config areas can be handled in separate threads.
