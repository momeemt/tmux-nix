# /home/momeemt/ghq/github.com/momeemt/tmux-nix/tests/outputs/root.nix
# Expected .tmux.conf content checks for root options
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
''
