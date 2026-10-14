# iSH setup

## Initial setup

1. Mount iCloud Drive at `/iCloud` (see below).
2. Run the init script as root:
   ```sh
   sh /iCloud/iSH/init-3.18.sh
   ```
3. Open iOS Settings → iSH and enable Recovery Mode.
4. Relaunch iSH and set Launch cmd to `/bin/login -f <username>`.
5. Disable Recovery Mode.

## Saved filesystems

Import through iSH Settings → Filesystems → Import, then select
**Boot From This Filesystem** and reopen iSH.

- `default-3.14.tar.gz` (in this directory): stock Alpine 3.14 with iCloud
  Drive already mounted at `/iCloud`. A starting point for experiments;
  run `/iCloud/iSH/init-3.18.sh` to set it up.
- Alpine 3.18 image (in iCloud Drive, `iSH` folder): ready to use;
  no initial setup required.

As of **2026-10-13**, Alpine **3.18** is the latest personally verified working
release. In my Alpine 3.19 tests, `/bin/login -f <username>` did not work for
logging in as a regular user.

## Mount iOS folders

Run as root. Select the corresponding folder in the iOS picker after each
`mount` command.

### iCloud Drive

```sh
mkdir -p /iCloud
mount -t ios . /iCloud
```

### Downloads

```sh
mkdir -p /Downloads
mount -t ios . /Downloads
```

## Reset to defaults

Delete and reinstall the app.
