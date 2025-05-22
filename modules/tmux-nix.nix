{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../plugins/cpu.nix
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
  };

  config = lib.mkIf config.tmux-nix.enable {
    home.packages = [config.tmux-nix.package];
    home.file.".tmux.conf".text = let
      tmux-nix = config.tmux-nix;
      bind-key = binding: cmd: "bind-key${lib.optionalString binding.repeatable " -r"} ${binding.key} ${cmd}";
      maybe-bind-key = binding: cmd:
        lib.optionalString (binding.key != null) (bind-key binding cmd);
    in ''
      set-option -g prefix ${tmux-nix.prefix}

      # -- pane movement --
      ${maybe-bind-key tmux-nix.keymaps.pane.left "select-pane -L"}
      ${maybe-bind-key tmux-nix.keymaps.pane.right "select-pane -R"}
      ${maybe-bind-key tmux-nix.keymaps.pane.up "select-pane -U"}
      ${maybe-bind-key tmux-nix.keymaps.pane.down "select-pane -D"}

      # -- pane resizing --
      ${maybe-bind-key tmux-nix.keymaps.resize.left "resize-pane -L ${toString tmux-nix.keymaps.resize.left.amount}"}
      ${maybe-bind-key tmux-nix.keymaps.resize.right "resize-pane -R ${toString tmux-nix.keymaps.resize.right.amount}"}
      ${maybe-bind-key tmux-nix.keymaps.resize.up "resize-pane -U ${toString tmux-nix.keymaps.resize.up.amount}"}
      ${maybe-bind-key tmux-nix.keymaps.resize.down "resize-pane -D ${toString tmux-nix.keymaps.resize.down.amount}"}

      ${tmux-nix.extraConfig}
    '';
  };
}
