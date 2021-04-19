{
    inputs = {
        agenix.url = "github:ryantm/agenix";
        nixpkgs.url = "nixpkgs/release-20.09";
        nixpkgs-head.url = "nixpkgs/master";
        home-manager = {
            url = "github:nix-community/home-manager/release-20.09";
            flake = true;
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = {self, agenix, nixpkgs, nixpkgs-head, home-manager}: {
        nixosModules = [
            (import ./hardware-configuration.nix)
            agenix.nixosModules.age
            nixpkgs.nixosModules.notDetected
            home-manager.nixosModules.home-manager
        ];
        nixosConfigurations = {
            mschuwalow-desktop = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix
                    ./machines/desktop.nix
                ];
            };
        };
    };
}