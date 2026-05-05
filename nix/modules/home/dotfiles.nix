{
  config,
  lib,
  pkgs,
  dotfilesDir,
  ...
}:
let
  inherit (config.home) homeDirectory;
  inherit (config.xdg) configHome;

  zoxideFishInit = pkgs.runCommand "zoxide-init.fish" { nativeBuildInputs = [ pkgs.zoxide ]; } ''
    zoxide init fish > "$out"
  '';

  zoxideFishConf = pkgs.writeText "30-zoxide.fish" ''
    if not status is-interactive
        return
    end

    source ${zoxideFishInit}
  '';

  mkLinkForce = ''
    link_force() {
      local src=$1
      local dst=$2
      $DRY_RUN_CMD rm -f "$dst"
      $DRY_RUN_CMD ln -sf "$src" "$dst"
    }
  '';
in
{
  home.activation.linkDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${mkLinkForce}

    # Fish
    $DRY_RUN_CMD mkdir -p "${configHome}/fish/conf.d"

    if [ -d "${dotfilesDir}/fish/conf.d" ]; then
      for source in "${dotfilesDir}"/fish/conf.d/*.fish; do
        [ -e "$source" ] || continue
        [ "$(basename "$source")" != "20-atuin.fish" ] || continue
        link_force "$source" "${configHome}/fish/conf.d/$(basename "$source")"
      done
    fi

    for dir in themes functions completions; do
      $DRY_RUN_CMD mkdir -p "${configHome}/fish/$dir"

      if [ -d "${dotfilesDir}/fish/$dir" ]; then
        for source in "${dotfilesDir}"/fish/"$dir"/*.fish; do
          [ -e "$source" ] || continue
          link_force "$source" "${configHome}/fish/$dir/$(basename "$source")"
        done
      fi
    done

    # Zoxide
    link_force "${zoxideFishConf}" "${configHome}/fish/conf.d/30-zoxide.fish"

    # Ghostty
    $DRY_RUN_CMD mkdir -p "${configHome}/ghostty"
    link_force "${dotfilesDir}/ghostty/config" "${configHome}/ghostty/config"

    # Git
    link_force "${dotfilesDir}/git/config" "${homeDirectory}/.gitconfig"

    # Codex CLI. Config is local-only; auth, sessions, logs, and caches stay unmanaged.
    if [ -e "${dotfilesDir}/codex/config.toml" ]; then
      $DRY_RUN_CMD mkdir -p "${configHome}/codex"
      link_force "${dotfilesDir}/codex/config.toml" "${configHome}/codex/config.toml"
    fi

    # SSH config only. Keys stay unmanaged and untracked.
    $DRY_RUN_CMD mkdir -p "${homeDirectory}/.ssh"
    $DRY_RUN_CMD mkdir -p "${homeDirectory}/.ssh/config.d"
    $DRY_RUN_CMD chmod 700 "${homeDirectory}/.ssh"
    $DRY_RUN_CMD chmod 700 "${homeDirectory}/.ssh/config.d"
    link_force "${dotfilesDir}/ssh/config" "${homeDirectory}/.ssh/config"
    if [ -e "${dotfilesDir}/ssh/config.local" ]; then
      link_force "${dotfilesDir}/ssh/config.local" "${homeDirectory}/.ssh/config.local"
    fi
  '';
}
