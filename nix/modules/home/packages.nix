{ lib, pkgs, ... }:

let
  inherit (builtins) attrValues;
  inherit (pkgs.stdenv) isDarwin;
in
{
  home.packages = attrValues (
    {
      inherit (pkgs)
        # Some basics
        aria2
        curl
        fd
        fastfetch
        ffmpeg
        htop
        ripgrep
        tealdeer
        vim
        wget
        xz
        zoxide

        # Dev stuff
        android-tools
        codex
        gh
        git
        jq
        nixd
        nodejs
        pnpm
        rustup
        scrcpy
        shellcheck
        uv

        # Useful Nix related tools
        cachix
        nix-output-monitor
        nix-tree
        nixfmt
        statix
        ;
    }
    // lib.optionalAttrs isDarwin {
      inherit (pkgs)
        m-cli
        mas
        ;
    }
  );
}
