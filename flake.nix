{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
          (import ./overlays/git-heatmap)
        ];
      };
      allModules = [
        agenix.nixosModules.age
        nixpkgs.nixosModules.notDetected
        home-manager.nixosModules.home-manager
        ./modules/variables.nix
        ./modules/xcursor.nix
        ./modules/vsliveshare.nix
        ./modules/bloop-system.nix
      ];
    in {
      inherit overlays;
      nixosModules.all = { ... }: { imports = allModules; };
      nixosConfigurations = {
        mschuwalow-desktop = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              imports = allModules;
              nix = {
                registry = {
                  nixpkgs.flake = nixpkgs;
                  home-manager.flake = home-manager;
                  sys.flake = self;
                };
              };
              nixpkgs.overlays = overlays."${system}";
            }
            ./configuration.nix
            ./machines/mschuwalow-desktop.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
