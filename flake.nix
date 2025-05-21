{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = with inputs; [
        treefmt-nix.flakeModule
        home-manager.flakeModules.home-manager
      ];

      systems = import inputs.systems;

      flake = {
        homeConfigurations.local = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = inputs.nixpkgs.legacyPackages.${inputs.systems.local};
          modules = [
            inputs.self.flake.homeModules.tmux-nix
            {
              tmux-nix = {
                enable = true;
                extraConfig = "set -g base-index 1";
              };
            }
          ];
        };

        homeModules.tmux-nix = import ./modules/tmux-nix.nix;
      };

      perSystem = {
        pkgs,
        self',
        ...
      }: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nil
            alejandra
          ];
        };

        checks.tmux-nix-test = pkgs.nixosTest {
          name = "tmux-nix-test";
          nodes.machine = {pkgs, ...}: {
            imports = [
              inputs.home-manager.nixosModules.home-manager
            ];
            users.users.alice.isNormalUser = true;
            home-manager.users.alice = {
              imports = [
                (import ./modules/tmux-nix.nix)
              ];
              tmux-nix = {
                enable = true;
                prefix = "C-a";
                extraConfig = "set -g status off";
              };
              home.stateVersion = "24.11";
            };
          };
          testScript = ''
            start_all
            machine.wait_for_unit("default.target");
            machine.succeed("grep 'status off' /home/alice/.tmux.conf");
            machine.succeed("su - alice -c 'tmux -V'");
          '';
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
          };
          settings.global.excludes = [
            "LICENSE-*"
          ];
        };
      };
    };
}
