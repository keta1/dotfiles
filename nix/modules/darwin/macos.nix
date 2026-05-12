{ username, ... }:

let
  byHostPreferences = "~${username}/Library/Preferences/ByHost";
in
{
  # macOS defaults managed by nix-darwin
  system.defaults = {
    finder = {
      # Finder: allow quitting with Command-Q; quitting Finder also hides desktop icons.
      QuitMenuItem = true;

      # Finder: show hidden files by default.
      AppleShowAllFiles = true;

      # Finder: show all filename extensions.
      AppleShowAllExtensions = true;

      # Finder: show the status bar at the bottom of each window.
      ShowStatusBar = true;

      # Finder: show the path bar for the current folder.
      ShowPathbar = true;

      # Finder: show the full POSIX path in the window title.
      _FXShowPosixPathInTitle = true;

      # Finder: keep folders above files when sorting by name.
      _FXSortFoldersFirst = true;

      # Finder: search the current folder by default instead of "This Mac".
      FXDefaultSearchScope = "SCcf";

      # Finder: do not warn when changing a file extension.
      FXEnableExtensionChangeWarning = false;
    };

    dock = {
      # Dock: set icon size to 48 pixels.
      tilesize = 48;

      # Dock: automatically hide and show the Dock.
      autohide = true;

      # Mission Control: group windows by application.
      expose-group-apps = true;

      # Dock: hide suggested and recent apps.
      show-recents = false;
    };

    NSGlobalDomain = {
      # Global: show all filename extensions in apps that honor the global preference.
      AppleShowAllExtensions = true;

      # Menu Bar: reduce horizontal spacing between status icons.
      NSStatusItemSpacing = 6;

      # Menu Bar: reduce clickable padding around status icons.
      NSStatusItemSelectionPadding = 4;

      # Keyboard: use F1, F2, etc. keys as standard function keys.
      "com.apple.keyboard.fnState" = true;
    };

    CustomUserPreferences = {
      "${byHostPreferences}/com.apple.Spotlight" = {
        # Menu Bar: hide the Spotlight icon.
        MenuItemHidden = 1;
      };

      "com.apple.controlcenter" = {
        # Menu Bar: hide the Keyboard Brightness icon.
        "NSStatusItem Visible KeyboardBrightness" = false;
      };

      "com.apple.desktopservices" = {
        # Desktop Services: avoid creating .DS_Store files on network volumes.
        DSDontWriteNetworkStores = true;

        # Desktop Services: avoid creating .DS_Store files on USB volumes.
        DSDontWriteUSBStores = true;
      };
    };
  };
}
