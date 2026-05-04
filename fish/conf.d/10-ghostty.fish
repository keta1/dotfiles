if not status is-interactive
    exit
end

# Ghostty shell integration
if set -q GHOSTTY_RESOURCES_DIR
    set -l ghostty_fish_integration "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"

    if test -r "$ghostty_fish_integration"
        source "$ghostty_fish_integration"
    end
end
