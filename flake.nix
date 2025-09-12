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

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    illogical-impulse = {
      url = "github:soetl/end-4-dots-hyprland-nixos/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    illogicalImpulse = {
      url = "git+file:///home/soetl/Projects/end-4-dots-hyprland?ref=dev";
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

      commonModules = [
        { nixpkgs.config.allowUnfree = lib.mkDefault true; }
      ];

      args = {
        inherit inputs outputs vars;
      };
    in
    {
      nixosModules = import ./modules/nixos.nix;
      homeManagerModules = import ./modules/homeManager.nix;

      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          specialArgs = args;
          modules = [ ./hosts/desktop.nix ] ++ commonModules;
        };
      };

      homeConfigurations = {
        "${vars.user.name}@${vars.hostname}" = lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = args;
          modules = [ ./homes/desktop.nix ] ++ commonModules;
        };
      };
    };
}
