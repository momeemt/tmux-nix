{
  pkgs,
  testLib,
  ...
}:
with testLib; ''
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
  ${check "set-option -g status-left \"LEFT\""}
  ${check "set-option -g status-left-length 20"}
  ${check "set-option -g status-right \"RIGHT\""}
  ${check "set-option -g status-right-length 30"}
  ${check "set-option -g base-index 1"}
  ${check "set-option -g pane-base-index 1"}
  ${check "set-option -g automatic-rename off"}
  ${check "set-option -g automatic-rename-format \"#{window_name}\""}
  ${check "set-option -g window-active-style \"bg=colour235,fg=colour255\""}
  ${check "set-option -g window-style \"bg=default,fg=colour245\""}
  ${check "bind-key % split-window -h"}
  ${check "bind-key -r \" split-window -v"}
''
