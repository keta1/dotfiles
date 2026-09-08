{ config, ... }:

let
  goPath = "${config.xdg.dataHome}/go";
in
{
  programs.go.enable = true;

  home.sessionVariables.GOPATH = goPath;
  home.sessionPath = [ "${goPath}/bin" ];
}
