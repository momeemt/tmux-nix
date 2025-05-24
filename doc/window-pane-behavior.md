# Window and Pane Behavior Configuration

This document details the options available for configuring tmux window and pane behavior using `tmux-nix`.

## `baseIndex`

Sets the base index for windows. When you create new windows, they will be numbered starting from this index.

- **Type**: `integer`
- **Default**: `0`
- **Example**: `1` (Windows will be numbered 1, 2, 3,...)

## `paneBaseIndex`

Sets the base index for panes. When you create new panes, they will be numbered starting from this index.

- **Type**: `integer`
- **Default**: `0`
- **Example**: `1` (Panes will be numbered 1, 2, 3,...)

## `automaticRename`

Enables or disables automatic renaming of windows. If enabled, tmux will try to rename windows based on the command running in the active pane.

- **Type**: `boolean`
- **Default**: `true`
- **Example**: `false` (Disables automatic window renaming)

## `automaticRenameFormat`

Sets the format string used for automatic window renaming. This is only effective if `automaticRename` is `true`.

- **Type**: `string`
- **Default**: `"#{b:pane_current_path}"` (Basename of the current pane's path)
- **Example**: `"#{window_name}:#{pane_current_command}"`

## `activePaneStyle`

Defines the style for the active pane's border and background. This is an attribute set where keys are tmux style attributes (e.g., `bg`, `fg`, `style`) and values are their corresponding settings.

- **Type**: `attrsOf types.str`
- **Default**: `{}` (Uses tmux defaults)
- **Example**:
  ```nix
  activePaneStyle = {
    bg = "black";
    fg = "terminal";
    style = "bold";
  };
  ```

## `inactivePaneStyle`

Defines the style for inactive panes' borders and backgrounds. Similar to `activePaneStyle`, this is an attribute set.

- **Type**: `attrsOf types.str`
- **Default**: `{}` (Uses tmux defaults)
- **Example**:
  ```nix
  inactivePaneStyle = {
    bg = "default";
    fg = "colour240"; // A dim grey
  };
  ```

## Example Configuration

```nix
{
  tmux-nix = {
    baseIndex = 1;
    paneBaseIndex = 1;
    automaticRename = true;
    automaticRenameFormat = "#{pane_current_path}"; # Show full path
    activePaneStyle = {
      bg = "colour235"; # Dark grey background
      fg = "white";     # White foreground
    };
    inactivePaneStyle = {
      bg = "default";
      fg = "colour245"; # Lighter grey foreground for inactive panes
    };
  };
}
```
