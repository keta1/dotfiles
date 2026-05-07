{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gnused,
  ...
}:

stdenvNoCC.mkDerivation rec {
  pname = "jenv";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jenv";
    repo = "jenv";
    rev = version;
    hash = "sha256-BHkHc1dJuLYszkVe4z9CoFXURxTNdzaxd8tCKxuQues=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out" "$out/share/fish/vendor_completions.d"
    cp -R bin libexec completions available-plugins fish "$out/"
    cp completions/jenv.fish "$out/share/fish/vendor_completions.d/jenv.fish"
    chmod -R u+w "$out"

    wrapProgram "$out/bin/jenv" \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          coreutils
          gnused
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Manage your Java environment";
    homepage = "https://github.com/jenv/jenv";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "jenv";
  };
}
