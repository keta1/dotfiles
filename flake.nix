{
  description = "ketal's home-manager configuration";

  inputs = {
    # Package sets
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      username = "ketal";
      darwinSystem = "aarch64-darwin";
      darwinHostname = "Ketals-MacBook-Pro";
      darwinHomedir = "/Users/${username}";
      dotfilesDir = "${darwinHomedir}/workspace/nix/dotfiles";
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      flake = {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#Ketals-MacBook-Pro
        darwinConfigurations.${darwinHostname} = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          specialArgs = {
            inherit
              self
              username
              darwinSystem
              dotfilesDir
              ;
            homedir = darwinHomedir;
          };

          modules = [
            ./nix/modules/darwin
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {
                  inherit username dotfilesDir;
                  homedir = darwinHomedir;
                };
                users.${username} = import ./nix/modules/home;
              };
            }
          ];
        };
      };
    };
}
