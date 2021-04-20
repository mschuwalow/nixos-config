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
            home-manager = home-manager.defaultPackage."x86_64-linux";
          })
          (import ./overlays/python-packages.nix)
          (import ./overlays/vscode-extensions)
          (import ./overlays/joplin.nix)
          (import ./overlays/ibus-rime)
          (import ./overlays/cups-kyocera-ecosys)
          (import ./overlays/sshuttle-fix.nix)
          (import ./overlays/git-heatmap)
          agenix.overlay
        ];
      };
      allModules = [
        ({ ... }: {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nix = {
            registry = {
              nixpkgs.flake = nixpkgs;
              home-manager.flake = home-manager;
              sys.flake = self;
            };
          };
        })
        agenix.nixosModules.age
        nixpkgs.nixosModules.notDetected
        home-manager.nixosModules.home-manager
        ./modules/variables.nix
        ./modules/xcursor.nix
        ./modules/vsliveshare.nix
        ./modules/bloop-system.nix
      ];
    in rec {
      inherit overlays;
      nixosModules.all = { ... }: { imports = allModules; };
      nixosConfigurations = {
        mschuwalow-desktop = let system = "x86_64-linux";
        in nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            {
              imports = allModules;
              nixpkgs.overlays = overlays."${system}";
            }
            ./configuration.nix
            ./machines/mschuwalow-desktop.nix
          ];
        };
      };
    };
}
