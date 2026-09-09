{
  lib,
  pkgs,
  username,
  homedir,
  ...
}:

let
  postgresqlPackage = pkgs.postgresql;
  postgresqlDataRoot = "${homedir}/.local/share/postgresql";
in
{
  services.postgresql = {
    enable = true;
    package = postgresqlPackage;
    dataDir = "${postgresqlDataRoot}/${postgresqlPackage.psqlSchema}";
    enableTCPIP = false;

    authentication = lib.mkForce ''
      # Generated file; do not edit!
      local all all trust
      host  all all 127.0.0.1/32 trust
      host  all all ::1/128      trust
    '';
  };

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    install -d -o ${username} -g staff -m 0755 \
      "${homedir}/.local" \
      "${homedir}/.local/share" \
      "${postgresqlDataRoot}"
  '';
}
