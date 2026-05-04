{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.isDarwin {
  # Link GUI apps installed by Home Manager into ~/Applications/Home Manager Apps.
  targets.darwin.copyApps.enable = false;
  targets.darwin.linkApps.enable = true;
}
