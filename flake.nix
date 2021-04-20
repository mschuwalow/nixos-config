{
  inputs = {
    agenix.url = "github:ryantm/agenix";
    nixpkgs.url = "nixpkgs/master";
    nixpkgs-unstable.url = "nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, agenix, nixpkgs, nixpkgs-unstable, nur, home-manager }@inputs: 
    let
      overlays = {
        "x86_64-linux" = [
          (self: super: {
            unstable = import nixpkgs-unstable {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          })
          (import ./overlays/python-packages.nix)
          (import ./overlays/vscode-extensions)
          (import ./overlays/joplin.nix)
          (import ./overlays/ibus-rime)
          (import ./overlays/cups-kyocera-ecosys)
          (import ./overlays/sshuttle-fix.nix)
        ];
      };
      nixosModules = [
        agenix.nixosModules.age
        nixpkgs.nixosModules.notDetected
        home-manager.nixosModules.home-manager
        ./modules/variables.nix
        ./modules/xcursor.nix
        ./modules/vsliveshare.nix
        ./modules/bloop-system.nix
      ];
    in
    {
      inherit overlays nixosModules;
      nixosConfigurations = {
        mschuwalow-desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = nixosModules ++ [
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              nix = {
                nixPath = [ "nixpkgs=${nixpkgs}" ];
                registry = {
                  nixpkgs.flake = nixpkgs;
                  sys.flake = self;
                  home-manager.flake = home-manager;
                };
              };
              nixpkgs.overlays = overlays."x86_64-linux";
            }
            ./configuration.nix
            ./machines/mschuwalow-desktop.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
