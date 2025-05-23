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
      split = {
        horizontal.key = "%";
        vertical = {
          key = "\"";
          repeatable = true;
        };
      };
    };
    extraConfig = ''
      display-message "Hello, tmux-nix!"
    '';
    statusLeft = {
      text = "LEFT";
      length = 20;
    };
    statusRight = {
      text = "RIGHT";
      length = 30;
    };
    baseIndex = 1;
    paneBaseIndex = 1;
    automaticRename = false;
    automaticRenameFormat = "#{window_name}";
    activePaneStyle = {
      bg = "colour235"; # dark grey
      fg = "colour255"; # white
    };
    inactivePaneStyle = {
      bg = "default";
      fg = "colour245"; # light grey
    };
  };
}
