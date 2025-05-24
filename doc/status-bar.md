# Status Bar Configuration

This document details the options available for configuring the tmux status bar using `tmux-nix`.

## `statusLeft`

Configures the left side of the tmux status bar.

- **Type**: Submodule
- **Default**: `{ text = ""; length = 10; }`

### `statusLeft.text`

Sets the content displayed on the left side of the status bar. You can use tmux format strings here. If left as an empty string, tmux will use its default value.

- **Type**: `string`
- **Default**: `""`
- **Example**: `"#[bg=blue] #S #[default]"` (Displays session name with a blue background)

### `statusLeft.length`

Sets the maximum length for the left status bar.

- **Type**: `integer`
- **Default**: `10`
- **Example**: `20`

## `statusRight`

Configures the right side of the tmux status bar.

- **Type**: Submodule
- **Default**: `{ text = ""; length = 40; }`

### `statusRight.text`

Sets the content displayed on the right side of the status bar. You can use tmux format strings here. If left as an empty string, tmux will use its default value.

- **Type**: `string`
- **Default**: `""`
- **Example**: `"%H:%M %d-%b-%y"` (Displays time and date)

### `statusRight.length`

Sets the maximum length for the right status bar.

- **Type**: `integer`
- **Default**: `40`
- **Example**: `50`

## Example Configuration

```nix
{
  tmux-nix = {
    statusLeft = {
      text = "#[fg=cyan]#S"; // Session name in cyan
      length = 15;
    };
    statusRight = {
      text = "#[fg=yellow]%R %d/%m"; // Time (HH:MM) and date (DD/MM) in yellow
      length = 25;
    };
  };
}
```

This configuration will display the session name on the left and the time and date on the right, with specified colors and lengths.
