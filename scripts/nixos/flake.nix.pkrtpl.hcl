{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko }: {
    nixosConfigurations.packer = nixpkgs.lib.nixosSystem {
      system = "${system}";
      modules = [ ./configuration.nix disko.nixosModules.disko ];
    };
  };
}
