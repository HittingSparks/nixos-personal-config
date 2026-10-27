{
  description = "Minhas máquinas NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, plasma-manager, catppuccin, ... }@inputs:
    let
      system = "x86_64-linux";
      usuario = "pelelebas"; # coloque aqui o seu usuário real

      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs usuario hostname; };
        modules = [
          ./hosts/${hostname}
          ./modules/common.nix
          home-manager.nixosModules.home-manager
          {
            networking.hostName = hostname;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs usuario hostname; };
              sharedModules = [
                plasma-manager.homeModules.plasma-manager
                catppuccin.homeModules.catppuccin
              ];
              users.${usuario} = import ./home;
            };
          }
        ];
      };
    in {
      nixosConfigurations = nixpkgs.lib.genAttrs [ "batata" "desktop" ] mkHost;
    };
}
