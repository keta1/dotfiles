{
  lib,
  pkgs,
  username,
  homedir,
  ...
}:

let
  stateDir = "${homedir}/.local/state/cliproxyapi-public";
in
{
  system.activationScripts.extraActivation.text = lib.mkAfter ''
    sudo -u ${username} -- ${pkgs.coreutils}/bin/install -d -m 0700 "${stateDir}"
  '';

  launchd.user.agents.cliproxyapi-public = {
    command = "${pkgs.nginx}/bin/nginx -e stderr -p ${stateDir}/ -c ${./cliproxyapi-public.conf}";

    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      WorkingDirectory = stateDir;
      StandardOutPath = "${stateDir}/launchd.log";
      StandardErrorPath = "${stateDir}/launchd.log";
      Umask = 63; # 0077
    };
  };
}
