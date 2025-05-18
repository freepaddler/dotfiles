# Setup iOS linux emulator iSH

1. mount iCloud drive (select folder from popup)
   
   ```shell
   mkdir /iCloud
   mount -t ios . /iCloud
   ```
2. run init script `/iCloud/iSH/init-x.xx.sh`
3. goto iOS settings -> iSH. turn on Recovery mode
4. relaunch iSH, set Launch cmd to `/bin/login -f username`

## reset defaults

delete and reinstall app
