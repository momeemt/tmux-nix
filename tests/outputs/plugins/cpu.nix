{
  pkgs,
  testLib,
  ...
}:
with testLib; ''
  ${check "run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/tmux-cpu/cpu.tmux"}
  ${check "set -g @cpu_low_icon \"-\""}
  ${check "set -g @cpu_medium_thresh \"20\""}
  ${check "set -g @cpu_high_thresh \"80\""}
  ${check "set -g @ram_medium_bg_color \"#[bg=yellow]\""}
  ${check "set -g @gpu_low_icon \"G\""}
  ${check "set -g @gram_percentage_format \"%5.1f%%\""}
  ${check "set -g @cpu_temp_unit \"F\""}
  ${check "set -g @gpu_temp_unit \"F\""}
''
