{ lib, pkgs, ... }:

let
  inherit (builtins) attrValues;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  sim-use = pkgs.callPackage ../../packages/sim-use.nix { };
  rpcs3 = pkgs.callPackage ../../packages/rpcs3.nix { };
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
        swiftlint
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
      inherit sim-use;
    }
    // lib.optionalAttrs (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") {
      inherit rpcs3;
    }
  );
}
