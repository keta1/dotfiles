{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };

    global.brewfile = true;

    taps = [
      "detachhead/tap"
      "keta1/tap"
    ];

    casks = [
      "detachhead/tap/rebased"
      "keta1/tap/64gram"
      "charles"
      "chatgpt"
      "claude"
      "dockdoor"
      "folo"
      "ghostty"
      "google-chrome"
      "hyperconnect"
      "jetbrains-toolbox"
      "mos"
      "orbstack"
      "qq"
      "raycast"
      "shottr"
      "stats"
      "steam"
      "tailscale-app"
      "tencent-meeting"
      "utm"
    ];

    masApps = {
      "Bitwarden" = 1352778147;
      "Bob" = 1630034110;
      "TestFlight" = 899247664;
      "Xcode" = 497799835;
      "WeChat" = 836500024;
    };
  };
}
