# tmux-nix

Configure tmux with Nix.

## Installation

### Using Flakes with home-manager

Add tmux-nix to your flake inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux-nix = {
      url = "github:momeemt/tmux-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, tmux-nix, ... }: {
    homeConfigurations.myuser = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        tmux-nix.homeModules.tmux-nix
        {
          programs.tmux-nix = {
            enable = true;
            prefix = "C-a";
            keymaps.pane = {
              left.key = "h";
              right.key = "l";
              up.key = "k";
              down.key = "j";
            };
          };
        }
      ];
    };
  };
}
```

## Options

- `programs.tmux-nix.enable` (bool): enable configuration.
- `programs.tmux-nix.out` (string): output file for tmux configuration. Default: `~/.tmux.conf`.
- `programs.tmux-nix.package` (package): tmux package to install.
- `programs.tmux-nix.prefix` (string): prefix key.
- `programs.tmux-nix.keymaps.pane.*`: pane movement key bindings.
- `programs.tmux-nix.keymaps.resize.*`: pane resizing bindings; each binding has an `amount` attribute.
- `programs.tmux-nix.keymaps.reload`: reload configuration key binding.
- `programs.tmux-nix.extraConfig` (lines): additional configuration appended to `.tmux.conf`.
- `programs.tmux-nix.plugins.cpu.*`: configuration for the `tmux-cpu` plugin. See `doc/plugins/cpu.md` for details.
- `programs.tmux-nix.statusLeft.*`, `programs.tmux-nix.statusRight.*`: configuration for the left and right status bar. See `doc/status-bar.md` for details.
- `programs.tmux-nix.baseIndex` (integer): base index for windows.
- `programs.tmux-nix.paneBaseIndex` (integer): base index for panes.
- `programs.tmux-nix.automaticRename` (bool): enable/disable automatic window renaming.
- `programs.tmux-nix.automaticRenameFormat` (string): format for automatic window names.
- `programs.tmux-nix.activePaneStyle` (attrs): style for active panes.
- `programs.tmux-nix.inactivePaneStyle` (attrs): style for inactive panes.
- `programs.tmux-nix.defaultTerminal` (string): sets the `default-terminal` option in tmux. Default: `screen-256color`.
- `programs.tmux-nix.terminalOverrides` (attrs): terminal capabilities for enabling TrueColor and other features.

Example configuration:

```nix
{
  programs.tmux-nix = {
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
