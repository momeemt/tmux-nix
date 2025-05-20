{
  config,
  lib,
  pkgs,
  ...
}: {
  options.tmux-nix = {
    enable = lib.mkEnableOption "Enable tmux-nix";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.tmux;
      description = "tmux binary to install (override to use a patched build etc.)";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra tmux configuration";
    };
  };

  config = lib.mkIf config.tmux-nix.enable {
    home.packages = [config.tmux-nix.package];
    home.file.".tmux.conf".text = ''
      set -g mouse on
      ${config.tmux-nix.extraConfig}
    '';
  };
}
