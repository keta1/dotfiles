{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "sim-use";
  version = "0.14.0";

  src = fetchurl {
    url = "https://github.com/lycorp-jp/sim-use/releases/download/v${version}/sim-use-v${version}.tar.gz";
    hash = "sha256-Z+LuKackYnLehkbkZmSpPZzrys4TQJTP09B9+4K9o+Y=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/libexec"
    cp -R sim-use SimUse_SimUse.bundle SimUse_AndroidBackend.bundle "$out/libexec/"
    chmod +x "$out/libexec/sim-use"
    cat > "$out/bin/sim-use" <<EOF
    #!/bin/sh
    exec "$out/libexec/sim-use" "\$@"
    EOF
    chmod +x "$out/bin/sim-use"

    runHook postInstall
  '';

  postFixup = ''
    /usr/bin/codesign --force --sign - --timestamp=none "$out/libexec/sim-use"
  '';

  meta = {
    description = "Give AI agents eyes and hands on iOS Simulator and Android devices";
    homepage = "https://github.com/lycorp-jp/sim-use";
    license = lib.licenses.asl20;
    platforms = lib.platforms.darwin;
    mainProgram = "sim-use";
  };
}
