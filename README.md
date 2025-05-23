# tmux-nix

Configure tmux with Nix.

## Options

- `tmux-nix.enable` (bool): enable configuration.
- `tmux-nix.package` (package): tmux package to install.
- `tmux-nix.prefix` (string): prefix key.
- `tmux-nix.keymaps.pane.*`: pane movement key bindings.
- `tmux-nix.keymaps.resize.*`: pane resizing bindings; each binding has an `amount` attribute.
- `tmux-nix.extraConfig` (lines): additional configuration appended to `.tmux.conf`.
- `tmux-nix.plugins.cpu.*`: configuration for the `tmux-cpu` plugin. See `doc/plugins/cpu.md` for details.
- `tmux-nix.statusLeft.*`, `tmux-nix.statusRight.*`: configuration for the left and right status bar. See `doc/status-bar.md` for details.
- `tmux-nix.baseIndex` (integer): base index for windows.
- `tmux-nix.paneBaseIndex` (integer): base index for panes.
- `tmux-nix.automaticRename` (bool): enable/disable automatic window renaming.
- `tmux-nix.automaticRenameFormat` (string): format for automatic window names.
- `tmux-nix.activePaneStyle` (attrs): style for active panes.
- `tmux-nix.inactivePaneStyle` (attrs): style for inactive panes.

Example configuration:

```nix
{
  tmux-nix = {
    enable = true;
    plugins.cpu.enable = true;
    keymaps.resize.left.amount = 10;
    keymaps.resize.right.amount = 10;
    keymaps.resize.up = {
      key = "J";
      repeatable = true;
      amount = 10;
    };
    keymaps.resize.down = {
      key = "K";
      repeatable = true;
      amount = 10;
    };
  };
}
```
