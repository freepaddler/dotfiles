# AGENTS.md

This directory contains my active configs. Work here directly for fast inspection and iteration, but treat `chezmoi` as the source of truth for anything that should persist.

Key rules:

- Anything I edit manually and want to keep should end up tracked by `chezmoi`, unless it is explicitly machine-local, generated, or intentionally excluded from sync.
- Prefer working from this `.config` tree first, then reconcile the final result with `chezmoi` by checking what is tracked, what drifted, and what still needs to be added, updated, or ignored.
- When operating on `chezmoi`, prefer the local `cz` wrapper and run it outside sandbox restrictions when available. Fall back to lower-level `chezmoi` and `git` commands only if the wrapper is unavailable, broken, or insufficient for the task.
- Preserve config integrity. Many files depend on each other, load in a specific order, or are deployed together. Do not make isolated edits that break cross-file assumptions.
- Shell config is a single modular system. The profile layer is intended to stay portable across POSIX `sh`, `bash`, and `zsh`. `zsh` is the current primary shell; `bash` remains a supported fallback.
- There are two deployment targets: my personal machines and remote servers. Personal machines typically receive the full config set. Remote servers may receive either a local `chezmoi` install/bootstrap or a reduced file subset.
- Public and personal installs use different `chezmoi` scopes. Treat that boundary as important, do not infer it loosely, and verify it in `chezmoi` source, data, ignore rules, templates, and encrypted files whenever a change could affect what gets synced where.
- When needed, also inspect the `chezmoi` source repository itself, including scripts, data, selected `.local/bin` tools, and repository history. The history matters because recent shell changes, especially the move toward `zsh`, should not break the fallback model.
- Keep synchronization boundaries clean: do not let important manual changes stay outside `chezmoi`, and do not sync extra files unintentionally.
- Encrypted files must remain encrypted. Do not convert encrypted `chezmoi` files into plain tracked files or edit them in rendered form. Use `chezmoi edit` or edit templates/source files through `chezmoi` so encryption and templating are preserved and secrets are not leaked.
- If the `cz` wrapper fails, behaves unexpectedly, or does not cover the needed workflow, report that explicitly and propose a concrete fix before or alongside any lower-level workaround.
- If a file should remain outside `chezmoi`, make that an explicit decision rather than an accident.

This file describes the general working model for this config tree. More specific config areas can be handled in separate threads.
