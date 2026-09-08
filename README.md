# ketal's dotfiles

Personal dotfiles managed by Nix/Home Manager.

The Nix configuration links selected files from this repository into `$HOME`.
Keep secrets and private keys out of this repository.

## Managed files

- `fish` -> `~/.config/fish`
- `codex/config.toml` -> `~/.config/codex/config.toml` (local-only, gitignored)
- `ghostty/config` -> `~/.config/ghostty/config`
- `git/config` -> `~/.gitconfig`
- `ssh/config` -> `~/.ssh/config`

## Managed macOS settings

- `nix/modules/darwin/macos.nix` manages Finder, Dock, and Desktop Services defaults.

## Managed Java

`nix/modules/home/java.nix` registers OpenJDK 11, 17, 21 and JetBrains Runtime
SDK 25 with JCEF via jenv. The JBRSDK version and official macOS ARM64 download
checksum are pinned in `nix/packages/jetbrains-runtime.nix`.

After applying the configuration, use `jenv shell jbr-25` for the current shell
or `jenv local jbr-25` for a project.

## Apply changes

From this repository:

```sh
sudo darwin-rebuild switch --flake .#Ketals-MacBook-Pro
```

`/private/etc/nix-darwin` is kept as a symlink to this checkout for the
default `darwin-rebuild switch` workflow.
