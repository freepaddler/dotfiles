# Setup iOS linux emulator iSH

1. mount iCloud drive
```shell
mkdir /iCloud
mount -t ios . /iCloud
# select iCloud on ios device in popup
```
2. run init script `/iCloud/iSH/init-x.xx.sh`
3. goto iOS settings -> iSH. turn on Recovery mode
4. relaunch iSH, set Launch cmd to `/bin/login -f username`
5. add ios dirs to home i.e.:
```shell
cd && mkdir /Downloads
mount -t ios . /Downloads
# select dir on ios device in popup
```

## reset defaults

delete and reinstall app
