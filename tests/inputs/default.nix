{
  pkgs,
  lib,
  ...
}: {
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
    extraConfig = ''
      display-message "Hello, tmux-nix!"
    '';
  };
}
