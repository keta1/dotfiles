{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cliproxyapi";
  version = "7.2.155";

  src = fetchurl {
    url = "https://github.com/router-for-me/CLIProxyAPI/releases/download/v${version}/CLIProxyAPI_${version}_darwin_aarch64.tar.gz";
    hash = "sha256-+QxQPOQaeYyFtvYd/l/ouBLBuIljTwyA0E7jdkJP4wU=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    install -Dm755 cli-proxy-api "$out/bin/cli-proxy-api"
    install -Dm644 config.example.yaml "$out/share/cliproxyapi/config.example.yaml"

    runHook postInstall
  '';

  # Preserve the signature on the upstream macOS binary.
  dontFixup = true;

  meta = {
    description = "Proxy server with OpenAI, Gemini, Claude, and Codex compatible APIs";
    homepage = "https://github.com/router-for-me/CLIProxyAPI";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "cli-proxy-api";
  };
}
