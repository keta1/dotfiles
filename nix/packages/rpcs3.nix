{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:

stdenvNoCC.mkDerivation {
  pname = "rpcs3";
  version = "0.0.43-20410";

  src = fetchurl {
    url = "https://github.com/RPCS3/rpcs3-binaries-mac-arm64/releases/download/build-c365ea76a552961ff078ea1a46da9d4b07729674/rpcs3-v0.0.43-20410-c365ea76_macos_aarch64.7z";
    hash = "sha256-7jz8z5RCPc6CfNzx9DnbGQ5y2cG3iR9+mXNI6BUs6aA=";
  };

  nativeBuildInputs = [ _7zz ];

  unpackPhase = ''
    runHook preUnpack
    7zz x "$src"
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R RPCS3.app "$out/Applications/"

    runHook postInstall
  '';

  # Preserve the signatures on the official prebuilt macOS application.
  dontFixup = true;

  meta = {
    description = "PlayStation 3 emulator and debugger";
    homepage = "https://rpcs3.net";
    license = lib.licenses.gpl2Only;
    platforms = [ "aarch64-darwin" ];
  };
}
