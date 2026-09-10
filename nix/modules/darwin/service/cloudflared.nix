{
  lib,
  pkgs,
  username,
  homedir,
  ...
}:

let
  package = pkgs.callPackage ../../../packages/cloudflared.nix { };
  configDir = "${homedir}/.config/cloudflared";
  stateDir = "${homedir}/.local/state/cloudflared";
  tokenFile = "${configDir}/cliproxyapi-token";
in
{
  environment.systemPackages = [ package ];

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    sudo -u ${username} -- ${pkgs.coreutils}/bin/install -d -m 0700 \
      "${configDir}" "${stateDir}"
  '';

  # Create a dashboard-managed tunnel whose public hostname targets
  # http://127.0.0.1:8318. Save its token in tokenFile with mode 0600.
  # PathState starts the agent only after that machine-local credential exists.
  launchd.user.agents.cloudflared-cliproxyapi = {
    command = "${package}/bin/cloudflared tunnel --no-autoupdate --metrics 127.0.0.1:20241 run --token-file ${tokenFile}";

    serviceConfig = {
      KeepAlive.PathState.${tokenFile} = true;
      ThrottleInterval = 30;
      WorkingDirectory = stateDir;
      StandardOutPath = "${stateDir}/launchd.log";
      StandardErrorPath = "${stateDir}/launchd.log";
      Umask = 63; # 0077
    };
  };
}
