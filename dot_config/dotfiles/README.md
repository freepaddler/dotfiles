# dotfiles

`_ENV_CONFIG_DIR` points to ~/.config/dotfiles and contains everything necessary to load POSIX-compatible shell, bash and zsh.

+ `helper` is a set of POSIX-compatible functions and env vars desigend to exist on loading, and unset on configuration is done. Practical usage is:
```sh
# load helper
. "${_ENV_CONFIG_DIR:-$HOME/.config/dotfiles}/helper" || echo "ERROR: unable to load helper, environment setup may fail!"

# ...
# anything that may use helper
# ...

# unload helper
_env_run_after
_env_cleanup
```

## login sessions (profile)
Login session environment

Softlinks from `$HOME`:

+ `~/.profile -> profile`
+ `~/.bash_profile -> bash_profile`
+ `~/.zprofile -> zprofile`

Files:

+ `common_profile` loads always and should be sourced from any `*profile`
+ `${_ENV_OS}_profile` loads _from_ `common_profile` and should contain OS-specific options

## interactive sessions (rc)
Interative session environment

Files:

+ `aliases` all aliases defined in one place (also per-os and per-shell)
+ `functions` POSIX-compatible functions only
+ `${_ENV_OS}_rc` per-os interactive configuration (vars, functions, completions, etc). For now only one file contains everything, subject for change later. Should be sources AFTER `*rc`.

## utils
Is a set of specific configuration options for cli utils. Each file represents one util and its configuration for any type of supported shells (POSIX, bash, zsh).

Should be sourced for interactive sessions AFTER `profile` and `rc` are applied.

Files are designed in a way to be sourced only if required binary exists.
