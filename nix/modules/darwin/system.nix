{
  self,
  pkgs,
  username,
  homedir,
  darwinSystem,
  ...
}:
{
  nix.settings.extra-experimental-features = [
    "nix-command"
    "flakes"
  ];
  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = darwinSystem;
  };

  programs.fish = {
    enable = true;
    useBabelfish = true;
  };

  environment.shells = [ pkgs.fish ];

  launchd.user.envVariables = {
    GRADLE_USER_HOME = "${homedir}/.local/share/gradle";
    KONAN_DATA_DIR = "${homedir}/.local/share/konan";
  };

  # sudo: allow Touch ID authentication for sudo prompts.
  security.pam.services.sudo_local.touchIdAuth = true;

  system = {
    primaryUser = username;
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
  };

  users.users.${username}.home = homedir;
}
