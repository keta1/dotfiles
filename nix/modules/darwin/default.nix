{
  imports = [
    ./system.nix
    ./macos.nix
    ./homebrew.nix
    ./service/cliproxyapi.nix
    ./service/cliproxyapi-public.nix
    ./service/cloudflared.nix
    ./service/postgresql.nix
    ./service/redis.nix
  ];
}
