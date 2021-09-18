{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "nixpkgs/master";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self, agenix, home-manager, nixpkgs, nixpkgs-unstable, nur, }:
    let
      overlays = [
        (self: super: {
          unstable = import nixpkgs-unstable { inherit (super) system config; };
          home-manager = home-manager.defaultPackage."${super.system}";
        })
        agenix.overlay
      ] ++ (map import [
        ./overlays/bottles
        ./overlays/cups-kyocera-ecosys
        ./overlays/git-heatmap
        ./overlays/iosevka.nix
        ./overlays/nix-direnv-flake-support.nix
        ./overlays/python-packages
        ./overlays/sshuttle-fix.nix
        ./overlays/steam-fix-browser.nix
        ./overlays/vscode-extensions
      ]);
      baseModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        imports = [
          agenix.nixosModules.age
          nixpkgs.nixosModules.notDetected
          home-manager.nixosModules.home-manager
          ./modules/variables.nix
          ./modules/xcursor.nix
          ./modules/vsliveshare.nix
          ./modules/bloop-system.nix
          ./modules/cachix.nix
        ];
        nix = {
          nixPath = [
            "nixpkgs=${nixpkgs}"
          ];
          registry = {
            agenix.flake = agenix;
            current-system.flake = self;
            home-manager.flake = home-manager;
            nixpkgs-unstable.flake = nixpkgs-unstable;
            nixpkgs.flake = nixpkgs;
            nur.flake = nur;
          };
        };
        nixpkgs.overlays = overlays;
      };
    in
    rec {
      inherit overlays;
      nixosModules.base = baseModule;
      nixosConfigurations = {
        mschuwalow-desktop = nixpkgs.lib.nixosSystem {
          modules = [ baseModule ./configuration.nix ./machines/desktop.nix ];
          system = "x86_64-linux";
        };
        mschuwalow-desktop-home = nixpkgs.lib.nixosSystem {
          modules = [ baseModule ./configuration.nix ./machines/desktop-home.nix ];
          system = "x86_64-linux";
        };
        mschuwalow-laptop = nixpkgs.lib.nixosSystem {
          modules = [ baseModule ./configuration.nix ./machines/laptop.nix ];
          system = "x86_64-linux";
        };
        mschuwalow-laptop-asus = nixpkgs.lib.nixosSystem {
          modules = [ baseModule ./configuration.nix ./machines/laptop-asus.nix ];
          system = "x86_64-linux";
        };
      };
    };
}
