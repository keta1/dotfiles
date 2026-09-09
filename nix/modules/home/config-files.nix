{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.xdg)
    cacheHome
    configHome
    dataHome
    stateHome
    ;
  androidSdkRoot = "${dataHome}/android/sdk";
  androidNdkVersion = "28.2.13676358";
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
    ANDROID_HOME = androidSdkRoot;
    ANDROID_NDK_HOME = "${androidSdkRoot}/ndk/${androidNdkVersion}";
    ANDROID_SDK_ROOT = androidSdkRoot;
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

    # Kotlin/Native
    KONAN_DATA_DIR = "${dataHome}/konan";

    # Node.js / npm / pnpm
    COREPACK_HOME = "${dataHome}/corepack";
    NODE_REPL_HISTORY = "${stateHome}/node/repl_history";
    NPM_CONFIG_CACHE = "${cacheHome}/npm";
    NPM_CONFIG_PREFIX = "${dataHome}/npm";
    NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
    PNPM_HOME = "${dataHome}/pnpm";

    # Java
    JENV_ROOT = "${dataHome}/jenv";
    JAVA_HOME = "${dataHome}/jenv/versions/21";
    JDK_HOME = "${dataHome}/jenv/versions/21";

    # Rust
    CARGO_HOME = "${dataHome}/cargo";
    RUSTUP_HOME = "${dataHome}/rustup";

    # Swift Package Manager
    SWIFTPM_CACHE_PATH = "${cacheHome}/swiftpm";
  }
  // lib.optionalAttrs pkgs.stdenv.isDarwin {
    # macOS shell sessions
    # https://apple.stackexchange.com/a/466804
    SHELL_SESSIONS_DISABLE = "1";
  };

  home.sessionPath = [
    "${dataHome}/cargo/bin"
    "${androidSdkRoot}/cmdline-tools/latest/bin"
    "${androidSdkRoot}/platform-tools"
    "${dataHome}/npm/bin"
    "${dataHome}/pnpm"
  ];

  home.activation.createNodeStateDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p "${stateHome}/node"
  '';

  xdg.configFile."npm/npmrc".text = ''
    cache=${cacheHome}/npm
    prefix=${dataHome}/npm
    init-module=${configHome}/npm/npm-init.js
  '';

  xdg.configFile."pnpm/rc".text = ''
    cache-dir=${cacheHome}/pnpm
    store-dir=${dataHome}/pnpm/store
    state-dir=${stateHome}/pnpm
    global-dir=${dataHome}/pnpm/global
    global-bin-dir=${dataHome}/pnpm
  '';
}
