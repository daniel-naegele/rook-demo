{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Taken from https://github.com/davidtwco/veritas/blob/master/flake.nix
  outputs =
    {
      self,
      nixpkgs,
      disko,
      nixos-generators,
      ...
    }@inputs:
    with inputs.nixpkgs.lib;
    let

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f:
        genAttrs supportedSystems (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
            };
          }
        );

      mkNixOsConfiguration =
        hostname:
        { system, config }:
        nameValuePair hostname (nixosSystem {
          inherit system;
          modules = [
            disko.nixosModules.disko
            (
              { inputs, hostname, ... }:
              {
                # Set the hostname to the name of the configuration being applied (since the
                # configuration being applied is determined by the hostname).
                networking.hostName = hostname;

                # For compatibility with nix-shell, nix-build, etc.
                # See also the setting of NIX_PATH in the home-manager host config
                environment.etc.nixpkgs.source = inputs.nixpkgs;
                nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];

                nix = {
                  # Don't rely on the configuration to enable a flake-compatible version of Nix.
                  # package = pkgs.nixFlakes;
                  extraOptions = "experimental-features = nix-command flakes";
                  # Re-expose self, nixpkgs and unstable as flakes.
                  registry = {
                    self.flake = inputs.self;
                    unstable = {
                      from = {
                        id = "unstable";
                        type = "indirect";
                      };
                      flake = inputs.unstable;
                    };
                    nixpkgs = {
                      from = {
                        id = "nixpkgs";
                        type = "indirect";
                      };
                      flake = inputs.nixpkgs;
                    };
                  };
                  settings = {
                    auto-optimise-store = true;
                  };
                };
              }
            )
            (import config)
          ];
          specialArgs = {
            inherit hostname inputs;
          };
        });

      mkDevShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = import ./shell.nix pkgs;
        }
      );

      # Attribute set of hostnames to evaluated NixOS configurations. Consumed by `nixos-rebuild`
      # on those hosts.
      nixosHostConfigurations = mapAttrs' mkNixOsConfiguration {
        demo = {
          system = "x86_64-linux";
          config = ./nixos/hetzner/demo.nix;
        };
      };
    in
    {
      formatter = nixpkgs.nixfmt-rfc-style;
      nixosConfigurations = nixosHostConfigurations;
      devShells = mkDevShells;
      packages.x86_64-linux.installationMedia = mkImage "install-iso" [ ./nixos/installer-image.nix ];
    };
}
