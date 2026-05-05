{
  config,
  lib,
  dotfilesDir,
  ...
}:
let
  inherit (config.home) homeDirectory;
  inherit (config.xdg) configHome;

  mkLinkForce = ''
    link_force() {
      local src=$1
      local dst=$2
      $DRY_RUN_CMD rm -rf "$dst"
      $DRY_RUN_CMD ln -sf "$src" "$dst"
    }
  '';
in
{
  home.activation.linkFishDotfiles =
    lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ]
      ''
        ${mkLinkForce}

        # Fish
        $DRY_RUN_CMD mkdir -p "${dotfilesDir}/fish/conf.d"
        if [ -e "${configHome}/fish/fish_variables" ] && [ ! -e "${dotfilesDir}/fish/fish_variables" ]; then
          $DRY_RUN_CMD cp -p "${configHome}/fish/fish_variables" "${dotfilesDir}/fish/fish_variables"
        fi
        link_force "${dotfilesDir}/fish" "${configHome}/fish"
      '';

  home.activation.linkDotfiles = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${mkLinkForce}

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
