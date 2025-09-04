{
  description = "Soetl's nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      lib = nixpkgs.lib // home-manager.lib;
      vars = import ./vars.nix;
      system = "x86_64-linux";

      args = {
        inherit inputs outputs vars;
      };
    in
    {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          specialArgs = args;
          modules = [ ./hosts/desktop ];
        };
      };

      homeConfigurations = {
        "${vars.user.name}@${vars.hostname}" = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = args;
          modules = [ ./homes/desktop ];
        };
      };
    };
}
