{
  config,
  lib,
  pkgs,
  ...
}: {
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
        options = {
          pane = lib.mkOption {
            description = "Pane movement key bindings";
            default = {};
            type = let
              common = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
              };
            in
              lib.types.submodule {
                options = {
                  left = common;
                  right = common;
                  up = common;
                  down = common;
                };
              };
          };
        };
      };
      default = {};
      description = "Keymaps to use for tmux";
      example = {
        pane = {
          left = "h";
          right = "l";
          up = "j";
          down = "k";
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
      bind-key = key: cmd: "bind-key ${key} ${cmd}";
      maybe-bind-key = key: cmd: lib.optionalString (key != null) (bind-key key cmd);
    in ''
      set-option -g prefix ${tmux-nix.prefix}

      # -- pane movement --
      ${maybe-bind-key tmux-nix.keymaps.pane.left "select-pane -L"}
      ${maybe-bind-key tmux-nix.keymaps.pane.right "select-pane -R"}
      ${maybe-bind-key tmux-nix.keymaps.pane.up "select-pane -U"}
      ${maybe-bind-key tmux-nix.keymaps.pane.down "select-pane -D"}

      ${tmux-nix.extraConfig}
    '';
  };
}
