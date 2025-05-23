# tmux-cpu plugin

The [tmux-cpu](https://github.com/tmux-plugins/tmux-cpu) plugin enables displaying CPU and GPU information in tmux's `status-right` and `status-left`. It provides configurable percentage and icon display with color changes based on thresholds.

## Format Strings

The plugin provides the following format strings that can be used in your tmux status line configuration:

### CPU

- `#{cpu_icon}` - CPU status icon based on usage percentage
- `#{cpu_percentage}` - CPU percentage (averaged across cores)
- `#{cpu_bg_color}` - Background color based on CPU percentage
- `#{cpu_fg_color}` - Foreground color based on CPU percentage
- `#{cpu_temp_icon}` - CPU temperature status icon
- `#{cpu_temp}` - CPU temperature (averaged across cores)
- `#{cpu_temp_bg_color}` - Background color based on CPU temperature
- `#{cpu_temp_fg_color}` - Foreground color based on CPU temperature

### RAM

- `#{ram_icon}` - RAM status icon based on usage percentage
- `#{ram_percentage}` - RAM percentage
- `#{ram_bg_color}` - Background color based on RAM percentage
- `#{ram_fg_color}` - Foreground color based on RAM percentage

### GPU

- `#{gpu_icon}` - GPU status icon based on usage percentage
- `#{gpu_percentage}` - GPU percentage (averaged across devices)
- `#{gpu_bg_color}` - Background color based on GPU percentage
- `#{gpu_fg_color}` - Foreground color based on GPU percentage
- `#{gram_icon}` - GPU RAM status icon
- `#{gram_percentage}` - GPU RAM percentage (total across devices)
- `#{gram_bg_color}` - Background color based on GPU RAM percentage
- `#{gram_fg_color}` - Foreground color based on GPU RAM percentage
- `#{gpu_temp_icon}` - GPU temperature status icon
- `#{gpu_temp}` - GPU temperature (average across devices)
- `#{gpu_temp_bg_color}` - Background color based on GPU temperature
- `#{gpu_temp_fg_color}` - Foreground color based on GPU temperature

## Options

All options are available under `tmux-nix.plugins.cpu.*` and correspond to the upstream plugin variables.

### Base settings

#### `enable`

- **Type**: `bool`
- **Default**: `false`
- **Description**: Whether to enable the plugin.

#### `package`

- **Type**: `package`
- **Default**: `pkgs.tmuxPlugins.cpu`
- **Description**: Package used to source the plugin script.

### CPU load

All CPU load options affect the `#{cpu_icon}`, `#{cpu_percentage}`, `#{cpu_bg_color}`, and `#{cpu_fg_color}` format strings.

#### `cpu.lowIcon` / `cpu.mediumIcon` / `cpu.highIcon`

- **Type**: `str`
- **Default**: `"="` / `"≡"` / `"≣"`
- **Description**: Icons displayed for low, medium, and high CPU usage.

#### `cpu.lowFgColor` / `cpu.mediumFgColor` / `cpu.highFgColor`

- **Type**: `str`
- **Default**: `""` (empty, uses terminal default)
- **Description**: Foreground colors for low, medium, and high CPU usage. Use tmux color format like `"#[fg=#00ff00]"`.

#### `cpu.lowBgColor` / `cpu.mediumBgColor` / `cpu.highBgColor`

- **Type**: `str`
- **Default**: `"#[bg=green]"` / `"#[bg=yellow]"` / `"#[bg=red]"`
- **Description**: Background colors for low, medium, and high CPU usage.

#### `cpu.percentageFormat`

- **Type**: `str`
- **Default**: `"%3.1f%%"`
- **Description**: Printf format string for displaying CPU percentage.

#### `cpu.mediumThresh` / `cpu.highThresh`

- **Type**: `int`
- **Default**: `30` / `80`
- **Description**: Thresholds (in percentage) for medium and high CPU usage classification.

### RAM usage

RAM options affect the `#{ram_icon}`, `#{ram_percentage}`, `#{ram_bg_color}`, and `#{ram_fg_color}` format strings. The configuration options are identical to CPU load options but without threshold settings (RAM thresholds use CPU threshold values).

#### `ram.lowIcon` / `ram.mediumIcon` / `ram.highIcon`

- **Type**: `str`
- **Default**: `"="` / `"≡"` / `"≣"`

#### `ram.lowFgColor` / `ram.mediumFgColor` / `ram.highFgColor`

- **Type**: `str`
- **Default**: `""` (empty)

#### `ram.lowBgColor` / `ram.mediumBgColor` / `ram.highBgColor`

- **Type**: `str`
- **Default**: `"#[bg=green]"` / `"#[bg=yellow]"` / `"#[bg=red]"`

#### `ram.percentageFormat`

- **Type**: `str`
- **Default**: `"%3.1f%%"`

### CPU temperature

CPU temperature options affect the `#{cpu_temp_icon}`, `#{cpu_temp}`, `#{cpu_temp_bg_color}`, and `#{cpu_temp_fg_color}` format strings.

#### `cpuTemp.lowIcon` / `cpuTemp.mediumIcon` / `cpuTemp.highIcon`

- **Type**: `str`
- **Default**: `"="` / `"≡"` / `"≣"`

#### `cpuTemp.lowFgColor` / `cpuTemp.mediumFgColor` / `cpuTemp.highFgColor`

- **Type**: `str`
- **Default**: `""` (empty)

#### `cpuTemp.lowBgColor` / `cpuTemp.mediumBgColor` / `cpuTemp.highBgColor`

- **Type**: `str`
- **Default**: `"#[bg=green]"` / `"#[bg=yellow]"` / `"#[bg=red]"`

#### `cpuTemp.format`

- **Type**: `str`
- **Default**: `"%2.0f"`
- **Description**: Printf format string for displaying CPU temperature.

#### `cpuTemp.unit`

- **Type**: `str`
- **Default**: `"C"`
- **Description**: Temperature unit. Supports `"C"` (Celsius) and `"F"` (Fahrenheit).

#### `cpuTemp.mediumThresh` / `cpuTemp.highThresh`

- **Type**: `int`
- **Default**: `80` / `90`
- **Description**: Temperature thresholds for medium and high classification.

### GPU load

GPU options affect the `#{gpu_icon}`, `#{gpu_percentage}`, `#{gpu_bg_color}`, and `#{gpu_fg_color}` format strings. Configuration is identical to CPU load options but without threshold settings (GPU thresholds use CPU threshold values).

#### `gpu.lowIcon` / `gpu.mediumIcon` / `gpu.highIcon`

- **Type**: `str`
- **Default**: `"="` / `"≡"` / `"≣"`

#### `gpu.lowFgColor` / `gpu.mediumFgColor` / `gpu.highFgColor`

- **Type**: `str`
- **Default**: `""` (empty)

#### `gpu.lowBgColor` / `gpu.mediumBgColor` / `gpu.highBgColor`

- **Type**: `str`
- **Default**: `"#[bg=green]"` / `"#[bg=yellow]"` / `"#[bg=red]"`

#### `gpu.percentageFormat`

- **Type**: `str`
- **Default**: `"%3.1f%%"`

### GPU RAM usage

GPU RAM options affect the `#{gram_icon}`, `#{gram_percentage}`, `#{gram_bg_color}`, and `#{gram_fg_color}` format strings.

#### `gram.lowIcon` / `gram.mediumIcon` / `gram.highIcon`

- **Type**: `str`
- **Default**: `"="` / `"≡"` / `"≣"`

#### `gram.lowFgColor` / `gram.mediumFgColor` / `gram.highFgColor`

- **Type**: `str`
- **Default**: `""` (empty)

#### `gram.lowBgColor` / `gram.mediumBgColor` / `gram.highBgColor`

- **Type**: `str`
- **Default**: `"#[bg=green]"` / `"#[bg=yellow]"` / `"#[bg=red]"`

#### `gram.percentageFormat`

- **Type**: `str`
- **Default**: `"%3.1f%%"`

### GPU temperature

GPU temperature options affect the `#{gpu_temp_icon}`, `#{gpu_temp}`, `#{gpu_temp_bg_color}`, and `#{gpu_temp_fg_color}` format strings.

#### `gpuTemp.lowIcon` / `gpuTemp.mediumIcon` / `gpuTemp.highIcon`

- **Type**: `str`
- **Default**: `"="` / `"≡"` / `"≣"`

#### `gpuTemp.lowFgColor` / `gpuTemp.mediumFgColor` / `gpuTemp.highFgColor`

- **Type**: `str`
- **Default**: `""` (empty)

#### `gpuTemp.lowBgColor` / `gpuTemp.mediumBgColor` / `gpuTemp.highBgColor`

- **Type**: `str`
- **Default**: `"#[bg=green]"` / `"#[bg=yellow]"` / `"#[bg=red]"`

#### `gpuTemp.format`

- **Type**: `str`
- **Default**: `"%2.0f"`

#### `gpuTemp.unit`

- **Type**: `str`
- **Default**: `"C"`
- **Description**: Temperature unit. Supports `"C"` (Celsius) and `"F"` (Fahrenheit).

#### `gpuTemp.mediumThresh` / `gpuTemp.highThresh`

- **Type**: `int`
- **Default**: `80` / `90`

## Requirements

The plugin has optional requirements depending on your system:

- **CPU percentage**: `iostat` or `sar` (recommended) or `ps aux` (fallback)
- **RAM usage**: `free` command
- **CPU temperature**: `lm-sensors`
- **GPU information**: `nvidia-smi` (Linux) or `cuda-smi` (macOS, limited functionality)

If "No GPU" is displayed, ensure the appropriate GPU monitoring command is installed and available in `$PATH`.

## Examples

### Basic usage

Enable the plugin and display CPU information in the status bar:

```nix
{
  tmux-nix.plugins.cpu.enable = true;
  tmux-nix.statusRight = "#{cpu_bg_color} CPU: #{cpu_icon} #{cpu_percentage} | %a %h-%d %H:%M ";
}
```

### Custom configuration

```nix
{
  tmux-nix.plugins.cpu = {
    enable = true;
    cpu = {
      lowIcon = "-";
      mediumIcon = "~";
      highIcon = "!";
      mediumThresh = 25;
      highThresh = 90;
      percentageFormat = "%5.1f%%";  # Add left padding
    };
    ram = {
      mediumBgColor = "#[bg=yellow]";
      highBgColor = "#[bg=red]";
    };
    gpu = {
      lowIcon = "G";
      mediumIcon = "GPU";
      highIcon = "GPU!";
    };
    gram = {
      percentageFormat = "%5.1f%%";
    };
    cpuTemp = {
      unit = "F";  # Use Fahrenheit
      mediumThresh = 176;  # 80°C in Fahrenheit
      highThresh = 194;    # 90°C in Fahrenheit
    };
    gpuTemp = {
      unit = "F";
    };
  };
}
```

### Status line with multiple metrics

```nix
{
  tmux-nix.plugins.cpu.enable = true;
  tmux-nix.statusRight = "#{cpu_bg_color} CPU: #{cpu_percentage} #{ram_bg_color} RAM: #{ram_percentage} #{gpu_bg_color} GPU: #{gpu_percentage} | %Y-%m-%d %H:%M ";
}
```

For more examples and detailed usage instructions, refer to the [tmux-cpu README](https://github.com/tmux-plugins/tmux-cpu#usage).
