{
  description = "my first flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nixpkgs.url = "nixpkgs/nixos-unstable";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # stylix.url = "github:danth/stylix";
  };

  outputs = {self, nixpkgs, home-manager, catppuccin, ... }@inputs:
    let 
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        pkgs = import nixpkgs {inherit system;};
    in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        # system = "x86_64-linux";
        modules = [ 
      	  ./configuration.nix
          inputs.sops-nix.nixosModules.sops
          # inputs.stylix.nixosModules.stylix
          catppuccin.nixosModules.catppuccin
      	  home-manager.nixosModules.home-manager {
      	    home-manager.useGlobalPkgs = true;
      	    home-manager.useUserPackages = true;
      	    home-manager.users.tommy.imports= [ 
              ./home.nix
              catppuccin.homeManagerModules.catppuccin
            ];
            home-manager.extraSpecialArgs = { inherit inputs; };
      	    home-manager.backupFileExtension = "backup";
      	  }
        ];
      };
    };
    homeConfigurations.tommy = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        catppuccin.homeManagerModules.catppuccin
      ];
    };

    qt5 = {
      enable = true;
      style = lib.mkForce "gtk2";
      platformTheme = lib.mkForce "gtk2";
    };

    # nixvim = {
    #   enable = true;
    #   plugins.lightline.enable = true;
    #   vimAlias = true;

    #   colorschemes = {
    #     catppuccin = {
    #       enable = true;
    #       flavour = "mocha";
    #     };
    #   };

    #   plugins = {
    #     nix.enable = true;
    #   };
    # };

  };
   
}
