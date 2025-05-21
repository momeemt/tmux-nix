# tmux-nix

Configure tmux with Nix.

## Options

- `tmux-nix.enable` (bool): enable configuration.
- `tmux-nix.package` (package): tmux package to install.
- `tmux-nix.prefix` (string): prefix key.
- `tmux-nix.keymaps.pane.*`: pane movement key bindings.
- `tmux-nix.keymaps.resize.*`: pane resizing bindings; each binding has an `amount` attribute.
- `tmux-nix.extraConfig` (lines): additional configuration appended to `.tmux.conf`.

Example configuration:

```nix
{
  tmux-nix = {
    enable = true;
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

