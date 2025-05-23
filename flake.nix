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
                keymaps = {
                  pane = {
                    left.key = "h";
                    right.key = "l";
                    up = {
                      key = "j";
                      repeatable = true;
                    };
                    down = {
                      key = "k";
                      repeatable = true;
                    };
                  };
                  resize = {
                    left = {
                      key = "H";
                      amount = 10;
                    };
                    right = {
                      key = "L";
                      amount = 10;
                    };
                    up = {
                      key = "J";
                      repeatable = true;
                      amount = 10;
                    };
                    down = {
                      key = "K";
                      repeatable = true;
                      amount = 10;
                    };
                  };
                };
                plugins.cpu = {
                  enable = true;
                  cpu.lowIcon = "-";
                  cpu.mediumThresh = 20;
                  cpu.highThresh = 80;
                  ram.mediumBgColor = "#[bg=yellow]";
                  gpu.lowIcon = "G";
                  gram.percentageFormat = "%5.1f%%";
                  cpuTemp.unit = "F";
                  gpuTemp.unit = "F";
                };
                extraConfig = ''
                  display-message "Hello, tmux-nix!"
                '';
              };
              home.stateVersion = "24.11";
            };
          };
          testScript = let
            escape = s: pkgs.lib.strings.escape ["\"" "[" "]"] s;
            check = line: "machine.succeed(\"grep -q '^${escape line}$' /home/alice/.tmux.conf\")";
          in ''
            start_all
            machine.wait_for_unit("default.target");
            machine.succeed("su - alice -c 'tmux -V'");
            ${check "set-option -g prefix C-a"}
            ${check "bind-key h select-pane -L"}
            ${check "bind-key l select-pane -R"}
            ${check "bind-key -r j select-pane -U"}
            ${check "bind-key -r k select-pane -D"}
            ${check "bind-key H resize-pane -L 10"}
            ${check "bind-key L resize-pane -R 10"}
            ${check "bind-key -r J resize-pane -U 10"}
            ${check "bind-key -r K resize-pane -D 10"}
            ${check "display-message \"Hello, tmux-nix!\""}
            ${check "run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/tmux-cpu/cpu.tmux"}
            ${check "set -g @cpu_low_icon \"-\""}
            ${check "set -g @cpu_medium_thresh \"20\""}
            ${check "set -g @cpu_high_thresh \"80\""}
            ${check "set -g @ram_medium_bg_color \"#[bg=yellow]\""}
            ${check "set -g @gpu_low_icon \"G\""}
            ${check "set -g @gram_percentage_format \"%5.1f%%\""}
            ${check "set -g @cpu_temp_unit \"F\""}
            ${check "set -g @gpu_temp_unit \"F\""}
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
