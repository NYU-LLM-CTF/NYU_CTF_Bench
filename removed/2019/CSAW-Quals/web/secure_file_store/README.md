# Secure File Store


## Overview
* php responsible for session and file mgmt
* browser/frontend responsible for encryption


### Distribute:
* `dist/client.py`


### Admin Notes
* baked-in creds for admin are `admin:4QGynywauXLZWp2jakgM48NKztNe0hY`
* Needs to have `--cap-add=SYS_ADMIN` for chrome
* should update port in distributed client with actual port from deployment


## Exploit chain
* unsanitized target in symlink creation -> arb file r/w
* write over php session file giving file listing perms
* use symlink bug to list all php session files
* find admin session file, overwrite name field to xss and leak client-side encryption keys
* decrypt flag
