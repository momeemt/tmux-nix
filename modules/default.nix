{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./plugins/cpu.nix
  ];
  options.tmux-nix = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whenever to configure {command}`tmux` system-wide.";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.tmux;
      description = "tmux binary to install (override to use a patched build etc.)";
    };
    prefix = lib.mkOption {
      type = lib.types.str;
      default = "C-b";
      example = "C-a";
      description = "Prefix key to use for tmux.";
    };
    keymaps = lib.mkOption {
      type = lib.types.submodule {
        options = let
          baseBindingType = lib.types.submodule {
            options = {
              key = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              repeatable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to pass -r to bind-key.";
              };
            };
          };
          bindingType = baseBindingType;
          resizeBindingType = lib.types.submodule {
            options = {
              key = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
              repeatable = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to pass -r to bind-key.";
              };
              amount = lib.mkOption {
                type = lib.types.int;
                default = 5;
                description = "Number of cells to adjust when resizing.";
              };
            };
          };
          bindingGroup = lib.types.submodule {
            options = {
              left = lib.mkOption {
                type = bindingType;
                default = {};
              };
              right = lib.mkOption {
                type = bindingType;
                default = {};
              };
              up = lib.mkOption {
                type = bindingType;
                default = {};
              };
              down = lib.mkOption {
                type = bindingType;
                default = {};
              };
            };
          };
          resizeGroup = lib.types.submodule {
            options = {
              left = lib.mkOption {
                type = resizeBindingType;
                default = {};
              };
              right = lib.mkOption {
                type = resizeBindingType;
                default = {};
              };
              up = lib.mkOption {
                type = resizeBindingType;
                default = {};
              };
              down = lib.mkOption {
                type = resizeBindingType;
                default = {};
              };
            };
          };
        in {
          pane = lib.mkOption {
            description = "Pane movement key bindings";
            default = {};
            type = bindingGroup;
          };
          resize = lib.mkOption {
            description = "Pane resizing key bindings";
            default = {};
            type = resizeGroup;
          };
        };
      };
      default = {};
      description = "Keymaps to use for tmux";
      example = {
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
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        display-message "Hello, tmux-nix!"
      '';
      description = "Extra tmux configuration";
    };
    statusLeft = lib.mkOption {
      type = lib.types.submodule {
        options = {
          text = lib.mkOption {
            type = lib.types.str;
            default = "";
            example = "#S";
            description = "Content of the left status bar. If empty, tmux default is used.";
          };
          length = lib.mkOption {
            type = lib.types.int;
            default = 10; # Default tmux value
            example = 20;
            description = "Length of the left status bar.";
          };
        };
      };
      default = {};
      description = "Configuration for the left part of the status bar.";
    };
    statusRight = lib.mkOption {
      type = lib.types.submodule {
        options = {
          text = lib.mkOption {
            type = lib.types.str;
            default = "";
            example = "%H:%M";
            description = "Content of the right status bar. If empty, tmux default is used.";
          };
          length = lib.mkOption {
            type = lib.types.int;
            default = 40; # Default tmux value
            example = 30;
            description = "Length of the right status bar.";
          };
        };
      };
      default = {};
      description = "Configuration for the right part of the status bar.";
    };
  };

  config = lib.mkIf config.tmux-nix.enable {
    home.packages = [config.tmux-nix.package];
    home.file.".tmux.conf".text = let
      tmux-nix = config.tmux-nix;
      keymaps = tmux-nix.keymaps;
      # Helper function to generate bind-key commands
      mkBind = key: repeatable: cmd: "bind-key${lib.optionalString repeatable " -r"} ${key} ${cmd}";

      # Pane navigation keybindings
      paneNavigationBinds = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: binding: let
            direction =
              {
                left = "L";
                right = "R";
                up = "U";
                down = "D";
              }
              .${name};
          in
            mkBind binding.key binding.repeatable "select-pane -${direction}"
        )
        keymaps.pane
      );

      # Pane resizing keybindings
      paneResizingBinds = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (
          name: binding: let
            direction =
              {
                left = "L";
                right = "R";
                up = "U";
                down = "D";
              }
              .${name};
          in
            mkBind binding.key binding.repeatable "resize-pane -${direction} ${toString binding.amount}"
        )
        keymaps.resize
      );
    in ''
      ### Do not edit this file directly.
      ### It is generated by tmux-nix.

      # Prefix
      set-option -g prefix ${tmux-nix.prefix}

      # Pane navigation
      ${paneNavigationBinds}

      # Pane resizing
      ${paneResizingBinds}

      # Status bar
      ${lib.optionalString (tmux-nix.statusLeft.text != "") ''
        set-option -g status-left "${tmux-nix.statusLeft.text}"
        set-option -g status-left-length ${toString tmux-nix.statusLeft.length}
      ''}
      ${lib.optionalString (tmux-nix.statusRight.text != "") ''
        set-option -g status-right "${tmux-nix.statusRight.text}"
        set-option -g status-right-length ${toString tmux-nix.statusRight.length}
      ''}

      # Extra configuration (from module options)
      ${tmux-nix.extraConfig}

    '';
  };
}
