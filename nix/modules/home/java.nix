{
  config,
  lib,
  pkgs,
  ...
}:

let
  jenv = pkgs.callPackage ../../packages/jenv.nix { };

  jdks = {
    "11" = pkgs.jdk11;
    "17" = pkgs.jdk17;
    "21" = pkgs.jdk21;
    "jbr-25" = pkgs.callPackage ../../packages/jetbrains-runtime.nix { };
  };
in
{
  home.packages = [ jenv ];

  xdg.dataFile =
    lib.mapAttrs' (version: jdk: {
      name = "jenv/versions/${version}";
      value = {
        source = jdk.home;
        force = true;
      };
    }) jdks
    // {
      "jenv/plugins/export" = {
        source = "${jenv}/available-plugins/export";
        force = true;
      };
      "jenv/version" = {
        text = "17\n";
        force = true;
      };
    };

  xdg.configFile."fish/conf.d/35-jenv.fish" = {
    force = true;
    text = ''
      if status is-interactive
          function __jenv_lazy_init
              functions -e __jenv_lazy_init jenv java javac jar jarsigner javadoc jshell keytool mvn gradle

              if command -q jenv
                  jenv init - | source
                  functions -q __jenv_export_hook; and __jenv_export_hook
              end
          end

          for command_name in jenv java javac jar jarsigner javadoc jshell keytool mvn gradle
              function $command_name --inherit-variable command_name
                  __jenv_lazy_init
                  command $command_name $argv
              end
          end
      end
    '';
  };
}
