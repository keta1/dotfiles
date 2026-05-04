# ketal's dotfiles

Personal dotfiles managed by Nix/Home Manager.

The Nix configuration links selected files from this repository into `$HOME`.
Keep secrets and private keys out of this repository.

## Managed files

- `fish/config.fish` -> `~/.config/fish/config.fish`
- `fish/conf.d/*.fish` -> `~/.config/fish/conf.d/*.fish`
- `ghostty/config` -> `~/.config/ghostty/config`
- `git/config` -> `~/.gitconfig`
- `ssh/config` -> `~/.ssh/config`

## Apply changes

From this repository:

```sh
sudo darwin-rebuild switch --flake .#Ketals-MacBook-Pro
```

`/private/etc/nix-darwin` is kept as a symlink to this checkout for the
default `darwin-rebuild switch` workflow.
