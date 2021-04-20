{
  inputs = {
    agenix.url = "github:ryantm/agenix";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, agenix, nixpkgs, nixpkgs-unstable, nur, home-manager }@inputs: {
      nixosConfigurations = {
        mschuwalow-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            agenix.nixosModules.age
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            ({ ... }:
              let
                overlay-unstable = (self: super: {
                  unstable = import nixpkgs-unstable {
                    system = "x86_64-linux";
                    config.allowUnfree = true;
                  };
                });
              in {
                nix = {
                  nixPath = [ "nixpkgs=${nixpkgs}" ];
                  registry.nixpkgs.flake = nixpkgs;
                };
                nixpkgs.overlays = [ overlay-unstable nur.overlay ];
              })
            ./configuration.nix
            ./machines/mschuwalow-desktop.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
