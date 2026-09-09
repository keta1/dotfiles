{
  lib,
  username,
  homedir,
  ...
}:

let
  redisDataDir = "${homedir}/.local/share/redis";
in
{
  services.redis = {
    enable = true;
    bind = "127.0.0.1";
    dataDir = redisDataDir;
    appendOnly = true;
  };

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    install -d -o ${username} -g staff -m 0755 \
      "${homedir}/.local" \
      "${homedir}/.local/share" \
      "${redisDataDir}"
  '';
}
