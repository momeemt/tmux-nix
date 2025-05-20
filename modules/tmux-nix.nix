{
  config,
  lib,
  pkgs,
  ...
}: {
  options.tmux-nix = {
    enable = lib.mkEnableOption "Enable tmux-nix";
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra tmux configuration";
    };
  };

  config = lib.mkIf config.tmux-nix.enable {
    home.packages = [pkgs.tmux];
    home.file.".tmux.conf".text = ''
      set -g mouse on
      ${config.tmux-nix.extraConfig}
    '';
  };
}
