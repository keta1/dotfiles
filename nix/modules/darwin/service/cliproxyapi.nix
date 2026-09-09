{
  lib,
  pkgs,
  username,
  homedir,
  ...
}:

let
  package = pkgs.callPackage ../../../packages/cliproxyapi.nix { };
  configDir = "${homedir}/.config/cliproxyapi";
  configFile = "${configDir}/config.yaml";
  authDir = "${homedir}/.local/share/cliproxyapi/auth";
  stateDir = "${homedir}/.local/state/cliproxyapi";
in
{
  environment.systemPackages = [ package ];

  system.activationScripts.extraActivation.text = lib.mkAfter ''
    sudo -u ${username} -- ${pkgs.coreutils}/bin/install -d -m 0700 \
      "${configDir}" "${authDir}" "${stateDir}"
  '';

  launchd.user.agents.cliproxyapi = {
    path = [
      pkgs.coreutils
      pkgs.openssl
    ];
    environment.HOME = homedir;

    script = ''
      set -eu
      umask 077

      # Create writable, local-only configuration once; never overwrite credentials.
      if [ ! -e "${configFile}" ]; then
        apiKey=$(openssl rand -hex 32)
        managementKey=$(openssl rand -hex 32)
        printf '%s\n' "$managementKey" > "${configDir}/management-key"
        cat > "${configFile}" <<EOF
      host: "127.0.0.1"
      port: 8317
      auth-dir: "${authDir}"
      # Send upstream requests through Clash Verge; Tailscale serves inbound traffic.
      proxy-url: "http://127.0.0.1:7897"
      api-keys:
        - "$apiKey"
      remote-management:
        allow-remote: false
        secret-key: "$managementKey"
      logging-to-file: true
      logs-max-total-size-mb: 100
      error-logs-max-files: 10
      ws-auth: true
      EOF
      fi

      exec ${lib.getExe package} -config "${configFile}"
    '';

    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      WorkingDirectory = stateDir;
      StandardOutPath = "${stateDir}/launchd.log";
      StandardErrorPath = "${stateDir}/launchd.log";
      Umask = 63; # 0077 in decimal, as required by launchd.
    };
  };

  launchd.user.agents.cliproxyapi-tailscale = {
    environment.HOME = homedir;
    # Run in the foreground so launchd owns the forwarding process and its lifetime.
    command = "/Applications/Tailscale.app/Contents/MacOS/Tailscale serve --yes --http=8317 http://127.0.0.1:8317";

    serviceConfig = {
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${stateDir}/tailscale.log";
      StandardErrorPath = "${stateDir}/tailscale.log";
      Umask = 63;
    };
  };
}
