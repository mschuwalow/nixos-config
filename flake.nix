{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master"; # release-21.05
      flake = true;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable"; # nixos-21.05
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
  };

  outputs =
    { self, agenix, home-manager, nixpkgs, nixpkgs-unstable, nur, }:
    let
      allSystems = [ "x86_64-linux" ];

      nameValuePair = name: value: { inherit name value; };
      genAttrs = names: f: builtins.listToAttrs (map (n: nameValuePair n (f n)) names);

      config = {
        allowUnfree = true;
        input-fonts.acceptLicense = true;
        oraclejdk.accept_license = true;
        trusted-users = "@wheel";
      };

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
        ./overlays/throttled-fix.nix
      ]);

      baseModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        imports = [
          agenix.nixosModules.age
          nixpkgs.nixosModules.notDetected
          home-manager.nixosModules.home-manager
          ./modules
        ];
        nix = {
          nixPath = [
            "nixpkgs=${self}/compat"
            "nixos-config=${self}/compat/nixos"
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
        nixpkgs = { inherit overlays config; };
      };

      forAllSystems = f: genAttrs allSystems
        (system: f {
          inherit system;
          pkgs = import nixpkgs { inherit system config overlays; };
        });
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
      legacyPackages = forAllSystems ({ pkgs, ... }: builtins.trace "Using <nixpkgs> compat wrapper..." pkgs);
      devShell = forAllSystems
        ({ system, pkgs, ... }:
          with pkgs;
          stdenv.mkDerivation {
            name = "shell";

            buildInputs = [
              agenix
              git
              gnumake
              nixpkgs-fmt
            ];
          });
    };
}
