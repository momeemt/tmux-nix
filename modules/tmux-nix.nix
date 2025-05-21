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
    home.file.".tmux.conf".text = ''
      set -g mouse on
      set-option -g prefix ${config.tmux-nix.prefix}
      ${config.tmux-nix.extraConfig}
    '';
  };
}
