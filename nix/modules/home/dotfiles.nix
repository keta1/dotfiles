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
  home.activation.removeLegacyFishConfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    if [ -L "${configHome}/fish/config.fish" ] \
      && [ "$(readlink "${configHome}/fish/config.fish")" = "${dotfilesDir}/fish/config.fish" ]; then
      $DRY_RUN_CMD rm -f "${configHome}/fish/config.fish"
    fi

    if [ -L "${configHome}/fish/conf.d/20-atuin.fish" ]; then
      $DRY_RUN_CMD rm -f "${configHome}/fish/conf.d/20-atuin.fish"
    fi

    if [ -L "${configHome}/atuin/config.toml" ] \
      && [ "$(readlink "${configHome}/atuin/config.toml")" = "${dotfilesDir}/atuin/config.toml" ]; then
      $DRY_RUN_CMD rm -f "${configHome}/atuin/config.toml"
    fi
  '';

  home.activation.migrateAndroidHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -d "${homeDirectory}/.android" ]; then
      $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}/android" "${config.xdg.dataHome}/android"

      if [ -e "${homeDirectory}/.android/analytics.settings" ] \
        && [ ! -e "${config.xdg.configHome}/android/analytics.settings" ]; then
        $DRY_RUN_CMD mv "${homeDirectory}/.android/analytics.settings" "${config.xdg.configHome}/android/analytics.settings"
      fi

      if [ -d "${homeDirectory}/.android/avd" ] \
        && [ ! -e "${config.xdg.dataHome}/android/avd" ]; then
        $DRY_RUN_CMD mv "${homeDirectory}/.android/avd" "${config.xdg.dataHome}/android/avd"
      fi

      $DRY_RUN_CMD rmdir "${homeDirectory}/.android" 2>/dev/null || true
    fi
  '';

  home.activation.linkDotfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${mkLinkForce}

    # Fish
    $DRY_RUN_CMD mkdir -p "${configHome}/fish/conf.d"
    if [ -L "${configHome}/fish/conf.d/00-hm-session-vars.fish" ]; then
      $DRY_RUN_CMD rm -f "${configHome}/fish/conf.d/00-hm-session-vars.fish"
    fi

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
    if [ -L "${homeDirectory}/.gitignore_global" ] \
      && [ "$(readlink "${homeDirectory}/.gitignore_global")" = "${dotfilesDir}/git/ignore" ]; then
      $DRY_RUN_CMD rm -f "${homeDirectory}/.gitignore_global"
    fi

    # SSH config only. Keys stay unmanaged and untracked.
    $DRY_RUN_CMD mkdir -p "${homeDirectory}/.ssh"
    $DRY_RUN_CMD mkdir -p "${homeDirectory}/.ssh/config.d"
    $DRY_RUN_CMD chmod 700 "${homeDirectory}/.ssh"
    $DRY_RUN_CMD chmod 700 "${homeDirectory}/.ssh/config.d"
    link_force "${dotfilesDir}/ssh/config" "${homeDirectory}/.ssh/config"
  '';
}
