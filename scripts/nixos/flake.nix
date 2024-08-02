{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: let
    system = import ./system.nix;
  in
  {
    nixosConfigurations.packer = nixpkgs.lib.nixosSystem {
      system = system;
      modules = [
        ./configuration.nix
        inputs.disko.nixosModules.disko
      ];
    };
  };
}