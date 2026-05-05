{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkFishConf = source: {
    inherit source;
    force = true;
  };

  homeManagerFishInit = pkgs.runCommandLocal "00-home-manager.fish" { } ''
    ${pkgs.buildPackages.babelfish}/bin/babelfish \
      < ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh \
      > "$out"
  '';

  ghosttyFishInit = pkgs.writeText "05-ghostty-integration.fish" ''
    if status is-interactive; and set -q GHOSTTY_RESOURCES_DIR
        source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
    end
  '';

  atuinFishInit =
    pkgs.runCommand "20-atuin.fish"
      {
        nativeBuildInputs = [
          pkgs.writableTmpDirAsHomeHook
          config.programs.atuin.package
        ];
      }
      ''
        {
          echo "if status is-interactive"
          atuin init fish ${lib.escapeShellArgs config.programs.atuin.flags}
          echo "end"
        } > "$out"
      '';

  zoxideFishConf = pkgs.runCommand "30-zoxide.fish" { nativeBuildInputs = [ pkgs.zoxide ]; } ''
    {
      echo "if status is-interactive"
      zoxide init fish
      echo "end"
    } > "$out"
  '';

  gpgAgentFishInit = pkgs.writeText "40-gpg-agent.fish" (
    ''
      if status is-interactive
          set -gx GPG_TTY (tty)
    ''
    + lib.optionalString config.services.gpg-agent.enableSshSupport ''
      ${config.programs.gpg.package}/bin/gpg-connect-agent --quiet updatestartuptty /bye > /dev/null
    ''
    + ''
      end
    ''
  );
in
{
  xdg.configFile = {
    "fish/conf.d/00-home-manager.fish" = mkFishConf homeManagerFishInit;
    "fish/conf.d/30-zoxide.fish" = mkFishConf zoxideFishConf;
  }
  // lib.optionalAttrs config.programs.ghostty.enableFishIntegration {
    "fish/conf.d/05-ghostty-integration.fish" = mkFishConf ghosttyFishInit;
  }
  // lib.optionalAttrs config.programs.atuin.enableFishIntegration {
    "fish/conf.d/20-atuin.fish" = mkFishConf atuinFishInit;
  }
  // lib.optionalAttrs config.services.gpg-agent.enableFishIntegration {
    "fish/conf.d/40-gpg-agent.fish" = mkFishConf gpgAgentFishInit;
  };
}
