# macOS Homebrew
set -gx HOMEBREW_PREFIX "/opt/homebrew"
set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"

fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin"

if not set -q MANPATH
    set MANPATH ''
end
set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH

if not set -q INFOPATH
    set INFOPATH ''
end
set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH
