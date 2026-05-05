{
  config,
  lib,
  pkgs,
  username,
  homedir,
  ...
}:
{
  imports = [
    ./config-files.nix
    ./darwin-apps.nix
    ./dotfiles.nix
    ./packages.nix
  ];

  home = {
    inherit username;
    homeDirectory = homedir;
    stateVersion = "25.11";
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = true;
    enableZshIntegration = false;
    flags = [ "--disable-ai" ];
    settings = builtins.fromTOML (builtins.readFile ../../../atuin/config.toml);
  };

  programs.bash = {
    enable = true;
    enableCompletion = false;
    historyFile = "${config.xdg.stateHome}/bash_history";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../../../fish/config.fish;
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.stateHome}/zsh_history";
  };

  services.gpg-agent = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    pinentry.package = pkgs.pinentry_mac;
  };
}
