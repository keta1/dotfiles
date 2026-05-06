{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    global.brewfile = true;

    taps = [
      "keta1/homebrew-tap"
    ];

    casks = [
      "mos"
      "ghostty"
      "google-chrome"
      "codex-app"
      "hyperconnect"
      "steam"
      "superset"
      "jetbrains-toolbox"
      "qq"
      "raycast"
      "shottr"
      "keta1/homebrew-tap/64gram"
      "keta1/homebrew-tap/cc-switch"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Bob" = 1630034110;
      "Xcode" = 497799835;
      "WeChat" = 836500024;
    };
  };
}
