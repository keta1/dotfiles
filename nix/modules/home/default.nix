{
  config,
  pkgs,
  username,
  homedir,
  ...
}:
{
  imports = [
    ./darwin-apps.nix
    ./dotfiles.nix
    ./packages.nix
  ];

  home = {
    inherit username;
    homeDirectory = homedir;
    stateVersion = "25.11";
    preferXdgDirectories = true;
    sessionVariables = {
      ANDROID_AVD_HOME = "${config.xdg.dataHome}/android/avd";
      ANDROID_EMULATOR_HOME = "${config.xdg.configHome}/android/emulator";
      ANDROID_USER_HOME = "${config.xdg.configHome}/android";
      SHELL_SESSIONS_DISABLE = "1";
    };
  };

  # Enable XDG Base Directory support
  xdg.enable = true;

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

  programs.fish = {
    enable = true;
    shellInit = builtins.readFile ../../../fish/config.fish;
  };

  programs.gpg.enable = true;

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    history.path = "${config.xdg.stateHome}/zsh_history";
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry_mac;
  };
}
