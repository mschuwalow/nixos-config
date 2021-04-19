{
  inputs = {
    agenix.url = "github:ryantm/agenix";
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-head.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, agenix, nixpkgs, nixpkgs-head, home-manager }@inputs: {
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
                unstable =
                  import nixpkgs-head { config = { allowUnfree = true; }; };
              });
            in { nixpkgs.overlays = [ overlay-unstable ]; })
          ./configuration.nix
          ./machines/mschuwalow-desktop.nix
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
