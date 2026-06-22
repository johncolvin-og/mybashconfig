# rsync
## Examples
* Sync files from main host to a remote host through an intermediary/proxy host

```bash
# rsync opts
#   -r copy recursively
#   -p preserve permissions
#   -l preserve symlinks
#   -t preserve file times (modify, create, etc.)
#   -v verbose
#   -z use compression
#   --rsh remote shell command

rsync -rpltvz --progress \
  --dry-run \
  --rsh 'ssh -T proxy_user@proxy_host ssh' \
  <src_path> \
  user@host:<dest_path>
```
