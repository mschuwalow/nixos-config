{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-21.05";
    nixpkgs-unstable.url = "nixpkgs/master";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, agenix, nixpkgs, nixpkgs-unstable, nur, home-manager }@inputs:
    let
      overlays = [
        (self: super: {
          unstable = import nixpkgs-unstable { inherit (super) system config; };
          home-manager = home-manager.defaultPackage."${super.system}";
        })
        (import ./overlays/python-packages)
        (import ./overlays/vscode-extensions)
        (import ./overlays/joplin.nix)
        (import ./overlays/ibus-rime)
        (import ./overlays/cups-kyocera-ecosys)
        (import ./overlays/sshuttle-fix.nix)
        (import ./overlays/git-heatmap)
        (import ./overlays/gtktitlebar)
        (import ./overlays/nix-direnv-flake-support.nix)
        agenix.overlay
      ];
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
          registry = {
            nixpkgs.flake = nixpkgs;
            nixpkgs-unstable.flake = nixpkgs-unstable;
            home-manager.flake = home-manager;
            sys.flake = self;
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
