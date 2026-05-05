{ config, lib, pkgs, ... }:

let
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    ;
in
{
  # Enable XDG Base Directory support
  # https://specifications.freedesktop.org/basedir-spec/latest/
  xdg.enable = true;
  home.preferXdgDirectories = true;

  home.sessionVariables = {
    # Android
    # https://developer.android.com/tools/variables
    ANDROID_AVD_HOME = "${dataHome}/android/avd";
    ANDROID_EMULATOR_HOME = "${configHome}/android/emulator";
    ANDROID_USER_HOME = "${configHome}/android";

    # Bundler (Ruby)
    # https://bundler.io/man/bundle-config.1.html
    BUNDLE_USER_CACHE = "${cacheHome}/bundle";
    BUNDLE_USER_CONFIG = "${configHome}/bundle/config";
    BUNDLE_USER_HOME = "${dataHome}/bundle";
    BUNDLE_USER_PLUGIN = "${dataHome}/bundle/plugin";

    # Codex
    # https://github.com/openai/codex/blob/main/docs/config.md
    CODEX_HOME = "${configHome}/codex";

    # Gradle
    # https://docs.gradle.org/current/userguide/directory_layout.html#dir:gradle_user_home
    GRADLE_USER_HOME = "${dataHome}/gradle";

    # Rust
    CARGO_HOME = "${dataHome}/cargo";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    # macOS shell sessions
    # https://apple.stackexchange.com/a/466804
    SHELL_SESSIONS_DISABLE = "1";
  };
}
