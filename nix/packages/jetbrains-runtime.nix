{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  javaVersion = "25.0.2";
  build = "329.117";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "jetbrains-runtime";
  version = "${javaVersion}-b${build}";

  src = fetchurl {
    url = "https://cache-redirector.jetbrains.com/intellij-jbr/jbrsdk_jcef-${javaVersion}-osx-aarch64-b${build}.tar.gz";
    hash = "sha512-s4C27+9hOG0RjMdvG9wY0EpQXLLLpSfKU3+bJpIe/8Mc2dE7lm8ntfeDruZnIfAyznKBbv7OZtNA8LNdkCWy2w==";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -R Contents "$out/"
    ln -s Contents/Home/bin "$out/bin"

    runHook postInstall
  '';

  # Preserve the signatures on JetBrains' prebuilt macOS binaries.
  dontFixup = true;

  passthru.home = "${finalAttrs.finalPackage}/Contents/Home";

  meta = {
    description = "JetBrains Runtime SDK with JCEF based on OpenJDK";
    homepage = "https://github.com/JetBrains/JetBrainsRuntime";
    license = lib.licenses.gpl2Only;
    platforms = [ "aarch64-darwin" ];
    mainProgram = "java";
  };
})
