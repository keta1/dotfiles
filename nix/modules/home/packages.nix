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
        curl
        fd
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
