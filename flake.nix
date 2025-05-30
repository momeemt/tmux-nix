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
              programs.tmux-nix = {
                enable = true;
                extraConfig = "set -g base-index 1";
              };
            }
          ];
        };

        homeModules.tmux-nix = import ./modules;
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
          nodes.machine = {
            pkgs,
            lib,
            ...
          }: {
            imports = [
              inputs.home-manager.nixosModules.home-manager
            ];
            users.users.alice.isNormalUser = true;
            home-manager.users.alice = {
              imports = [
                (import ./modules)
                (import ./tests/inputs/default.nix)
                (import ./tests/inputs/plugins/cpu.nix)
              ];
              home.stateVersion = "24.11";
            };
          };
          testScript = let
            testLib = import ./tests/lib.nix {inherit pkgs;};
            rootChecks = import ./tests/outputs {inherit pkgs testLib;};
            cpuChecks = import ./tests/outputs/plugins/cpu.nix {inherit pkgs testLib;};
          in ''
            start_all
            machine.wait_for_unit("default.target");
            machine.succeed("su - alice -c 'tmux -V'");
            ${rootChecks}
            ${cpuChecks}
          '';
        };

        treefmt = {
          projectRootFile = "flake.nix";
          programs = {
            alejandra.enable = true;
            mdformat.enable = true;
          };
          settings.global.excludes = [
            "LICENSE-*"
          ];
        };
      };
    };
}
