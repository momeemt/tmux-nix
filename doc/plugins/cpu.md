# tmux-cpu plugin

[tmux-cpu](https://github.com/tmux-plugins/tmux-cpu) shows CPU and GPU statistics in
`status-left` or `status-right`. It provides format strings such as
`#{cpu_percentage}` and color changes based on thresholds as described in its
[README](https://github.com/tmux-plugins/tmux-cpu#usage).

## Options

All options are available under `tmux-nix.plugins.cpu.*` and correspond to the
upstream variables. The default values follow the plugin defaults.

### Base settings
- `enable` (bool): whether to load the plugin.
- `package` (package): package used to source the plugin script.

### CPU load
- `cpu.lowIcon` / `mediumIcon` / `highIcon`
- `cpu.lowFgColor` / `mediumFgColor` / `highFgColor`
- `cpu.lowBgColor` / `mediumBgColor` / `highBgColor`
- `cpu.percentageFormat`
- `cpu.mediumThresh` / `highThresh`

### RAM usage
- `ram.lowIcon` / `mediumIcon` / `highIcon`
- `ram.lowFgColor` / `mediumFgColor` / `highFgColor`
- `ram.lowBgColor` / `mediumBgColor` / `highBgColor`
- `ram.percentageFormat`

### CPU temperature
- `cpuTemp.lowIcon` / `mediumIcon` / `highIcon`
- `cpuTemp.lowFgColor` / `mediumFgColor` / `highFgColor`
- `cpuTemp.lowBgColor` / `mediumBgColor` / `highBgColor`
- `cpuTemp.format`
- `cpuTemp.unit`
- `cpuTemp.mediumThresh` / `highThresh`

### GPU load
- `gpu.lowIcon` / `mediumIcon` / `highIcon`
- `gpu.lowFgColor` / `mediumFgColor` / `highFgColor`
- `gpu.lowBgColor` / `mediumBgColor` / `highBgColor`
- `gpu.percentageFormat`

### GPU RAM usage
- `gram.lowIcon` / `mediumIcon` / `highIcon`
- `gram.lowFgColor` / `mediumFgColor` / `highFgColor`
- `gram.lowBgColor` / `mediumBgColor` / `highBgColor`
- `gram.percentageFormat`

### GPU temperature
- `gpuTemp.lowIcon` / `mediumIcon` / `highIcon`
- `gpuTemp.lowFgColor` / `mediumFgColor` / `highFgColor`
- `gpuTemp.lowBgColor` / `mediumBgColor` / `highBgColor`
- `gpuTemp.format`
- `gpuTemp.unit`
- `gpuTemp.mediumThresh` / `highThresh`

GPU related threshold variables reuse the CPU threshold values.

## Example

```nix
{
  tmux-nix.plugins.cpu = {
    enable = true;
    cpu.lowIcon = "-";
    cpu.mediumThresh = 25;
    cpu.highThresh = 90;
    ram.mediumBgColor = "#[bg=yellow]";
    gpu.lowIcon = "G";
    gram.percentageFormat = "%5.1f%%";
    cpuTemp.unit = "F";
    gpuTemp.unit = "F";
  };
}
```

