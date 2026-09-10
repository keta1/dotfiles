{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cloudflared";
  version = "2026.9.0";

  src = fetchurl {
    url = "https://github.com/cloudflare/cloudflared/releases/download/${version}/cloudflared-darwin-arm64.tgz";
    hash = "sha256-wOzLN1hCDR9ORsvyuOzeAdmAKhVCMqgX8lEzNAAJ/Mc=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -Dm755 cloudflared "$out/bin/cloudflared"
    runHook postInstall
  '';

  # Preserve the signature on the upstream macOS binary.
  dontFixup = true;

  meta = {
    description = "Cloudflare Tunnel client";
    homepage = "https://github.com/cloudflare/cloudflared";
    license = lib.licenses.asl20;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "cloudflared";
  };
}
