{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./plugins/cpu.nix
  ];
  options.programs.tmux-nix = {
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
    out = lib.mkOption {
      type = lib.types.str;
      default = "~/.tmux.conf";
      example = "~/.config/tmux/tmux.conf";
      description = "Output file for tmux configuration.";
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
          split = lib.mkOption {
            description = "Window splitting key bindings";
            default = {};
            type = lib.types.submodule {
              options = {
                horizontal = lib.mkOption {
                  description = "Split window horizontally";
                  default = {key = "|";};
                  type = bindingType;
                };
                vertical = lib.mkOption {
                  description = "Split window vertically";
                  default = {key = "-";};
                  type = bindingType;
                };
              };
            };
          };
          reload = lib.mkOption {
            description = "Reload tmux configuration. Sources the generated tmux.conf file.";
            default = {
              key = "r";
              repeatable = false;
            };
            type = bindingType;
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
    baseIndex = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Base index for windows.";
    };
    paneBaseIndex = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "Base index for panes.";
    };
    automaticRename = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically rename windows.";
    };
    automaticRenameFormat = lib.mkOption {
      type = lib.types.str;
      default = "#{b:pane_current_path}";
      description = "Format for automatically renamed windows.";
    };
    activePaneStyle = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        "bg" = "black";
        "fg" = "white";
      };
      description = "Style for active panes. Keys are style attributes (e.g., bg, fg) and values are colors or attributes.";
    };
    inactivePaneStyle = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        "bg" = "default";
        "fg" = "default";
      };
      description = "Style for inactive panes. Keys are style attributes (e.g., bg, fg) and values are colors or attributes.";
    };

    defaultTerminal = lib.mkOption {
      type = lib.types.str;
      default = "screen-256color";
      example = "tmux-256color";
      description = ''
        Sets the `default-terminal` option in tmux.
        This is important for correct color rendering and feature support.
        For TrueColor, `tmux-256color` or `screen-256color` are common starting points,
        often paired with `terminalOverrides`.
      '';
    };
    terminalOverrides = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      example = {
        alacritty = "RGB";
        "xterm-256color" = "RGB";
        kitty = "Tc";
      };
      description = ''
        Allows specifying terminal capabilities, primarily for enabling TrueColor.
        Each attribute in the set corresponds to a terminal name (or pattern)
        and its value to the capabilities string (e.g., "RGB" or "Tc").
        Generates a single `set-option -ga terminal-overrides ",TERM1:CAP1,TERM2:CAP2,..."` line.
      '';
    };
  };

  config = lib.mkIf config.programs.tmux-nix.enable (let
    tmux-nix = config.programs.tmux-nix;
    # Remove leading ~/ from the output path for home.file
    homeRelativePath = lib.removePrefix "~/" tmux-nix.out;
    # Full resolved path for use in tmux commands
    resolvedOutPath = lib.strings.replaceStrings ["~"] [config.home.homeDirectory] tmux-nix.out;
  in {
    home.packages = [tmux-nix.package];
    home.file.${homeRelativePath}.text = let
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

      # Window splitting
      ${lib.optionalString (keymaps.split.horizontal.key != null) (mkBind keymaps.split.horizontal.key keymaps.split.horizontal.repeatable "split-window -h")}
      ${lib.optionalString (keymaps.split.vertical.key != null) (mkBind keymaps.split.vertical.key keymaps.split.vertical.repeatable "split-window -v")}

      # Reload configuration
      ${lib.optionalString (keymaps.reload.key != null) (mkBind keymaps.reload.key keymaps.reload.repeatable "source-file \"${resolvedOutPath}\"")}

      # Window and Pane Behavior
      set-option -g base-index ${toString tmux-nix.baseIndex}
      set-option -g pane-base-index ${toString tmux-nix.paneBaseIndex}
      set-option -g automatic-rename ${
        if tmux-nix.automaticRename
        then "on"
        else "off"
      }
      set-option -g automatic-rename-format "${tmux-nix.automaticRenameFormat}"

      # Pane Styles
      ${lib.optionalString (tmux-nix.activePaneStyle != {}) ''
        set-option -g window-active-style "${lib.concatStringsSep "," (lib.mapAttrsToList (name: value: "${name}=${value}") tmux-nix.activePaneStyle)}"
      ''}
      ${lib.optionalString (tmux-nix.inactivePaneStyle != {}) ''
        set-option -g window-style "${lib.concatStringsSep "," (lib.mapAttrsToList (name: value: "${name}=${value}") tmux-nix.inactivePaneStyle)}"
      ''}

      # Status bar
      ${lib.optionalString (tmux-nix.statusLeft.text != "") ''
        set-option -g status-left "${tmux-nix.statusLeft.text}"
        set-option -g status-left-length ${toString tmux-nix.statusLeft.length}
      ''}
      ${lib.optionalString (tmux-nix.statusRight.text != "") ''
        set-option -g status-right "${tmux-nix.statusRight.text}"
        set-option -g status-right-length ${toString tmux-nix.statusRight.length}
      ''}

      # Terminal settings (including TrueColor)
      set-option -g default-terminal "${tmux-nix.defaultTerminal}"
      ${lib.optionalString (lib.attrNames tmux-nix.terminalOverrides != []) ''
        set-option -ga terminal-overrides ",${lib.concatStringsSep "," (lib.mapAttrsToList (name: value: "${name}:${value}") tmux-nix.terminalOverrides)}"
      ''}

      # Extra configuration (from module options)
      ${tmux-nix.extraConfig}

    '';
  });
}
