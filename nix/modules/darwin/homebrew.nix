{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    global.brewfile = true;

    taps = [
      {
        name = "keta1/tap";
        trusted = true;
      }
    ];

    casks = [
      "keta1/tap/64gram"
      "charles"
      "chatgpt"
      "dockdoor"
      "folo"
      "ghostty"
      "google-chrome"
      "hyperconnect"
      "jetbrains-toolbox"
      "mos"
      "qq"
      "raycast"
      "shottr"
      "stats"
      "steam"
      "tailscale-app"
      "utm"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Bob" = 1630034110;
      "Xcode" = 497799835;
      "WeChat" = 836500024;
    };
  };
}
