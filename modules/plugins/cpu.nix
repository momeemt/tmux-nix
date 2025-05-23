{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.tmux-nix.plugins.cpu;
  tmux-nix-lib = import ../lib.nix {inherit lib;}; # Updated import path

  # CPU plugin specific option types
  mkDisplayOpts = {withThresholds ? false}:
    lib.types.submodule {
      options =
        {
          lowIcon = lib.mkOption {
            type = lib.types.str;
            default = "=";
            description = "Icon displayed when the metric is at low level.";
          };
          mediumIcon = lib.mkOption {
            type = lib.types.str;
            default = "≡";
            description = "Icon displayed when the metric is at medium level.";
          };
          highIcon = lib.mkOption {
            type = lib.types.str;
            default = "≣";
            description = "Icon displayed when the metric is at high level.";
          };
          lowFgColor = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Foreground color when the metric is at low level. Use tmux color format like '#[fg=#00ff00]'.";
          };
          mediumFgColor = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Foreground color when the metric is at medium level.";
          };
          highFgColor = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "Foreground color when the metric is at high level.";
          };
          lowBgColor = lib.mkOption {
            type = lib.types.str;
            default = "#[bg=green]";
            description = "Background color when the metric is at low level.";
          };
          mediumBgColor = lib.mkOption {
            type = lib.types.str;
            default = "#[bg=yellow]";
            description = "Background color when the metric is at medium level.";
          };
          highBgColor = lib.mkOption {
            type = lib.types.str;
            default = "#[bg=red]";
            description = "Background color when the metric is at high level.";
          };
          percentageFormat = lib.mkOption {
            type = lib.types.str;
            default = "%3.1f%%";
            description = "Printf format string for displaying the percentage value.";
          };
        }
        // (lib.optionalAttrs withThresholds {
          mediumThresh = lib.mkOption {
            type = lib.types.int;
            default = 30;
            description = "Threshold percentage for medium level classification.";
          };
          highThresh = lib.mkOption {
            type = lib.types.int;
            default = 80;
            description = "Threshold percentage for high level classification.";
          };
        });
    };

  mkTempOpts = lib.types.submodule {
    options = {
      lowIcon = lib.mkOption {
        type = lib.types.str;
        default = "=";
        description = "Icon displayed when the temperature is at low level.";
      };
      mediumIcon = lib.mkOption {
        type = lib.types.str;
        default = "≡";
        description = "Icon displayed when the temperature is at medium level.";
      };
      highIcon = lib.mkOption {
        type = lib.types.str;
        default = "≣";
        description = "Icon displayed when the temperature is at high level.";
      };
      lowFgColor = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Foreground color when the temperature is at low level.";
      };
      mediumFgColor = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Foreground color when the temperature is at medium level.";
      };
      highFgColor = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Foreground color when the temperature is at high level.";
      };
      lowBgColor = lib.mkOption {
        type = lib.types.str;
        default = "#[bg=green]";
        description = "Background color when the temperature is at low level.";
      };
      mediumBgColor = lib.mkOption {
        type = lib.types.str;
        default = "#[bg=yellow]";
        description = "Background color when the temperature is at medium level.";
      };
      highBgColor = lib.mkOption {
        type = lib.types.str;
        default = "#[bg=red]";
        description = "Background color when the temperature is at high level.";
      };
      format = lib.mkOption {
        type = lib.types.str;
        default = "%2.0f";
        description = "Printf format string for displaying the temperature value.";
      };
      unit = lib.mkOption {
        type = lib.types.str;
        default = "C";
        description = "Temperature unit. Supports 'C' (Celsius) and 'F' (Fahrenheit).";
      };
      mediumThresh = lib.mkOption {
        type = lib.types.int;
        default = 80;
        description = "Temperature threshold for medium level classification.";
      };
      highThresh = lib.mkOption {
        type = lib.types.int;
        default = 90;
        description = "Temperature threshold for high level classification.";
      };
    };
  };

  # Configuration line generation for different metric types
  confLines = lib.flatten [
    # CPU, RAM, GPU load metrics
    (tmux-nix-lib.generateConfigLines {
      prefix = "cpu";
      config = cfg.cpu;
    })
    (tmux-nix-lib.generateConfigLines {
      prefix = "ram";
      config = cfg.ram;
    })
    (tmux-nix-lib.generateConfigLines {
      prefix = "gpu";
      config = cfg.gpu;
    })
    (tmux-nix-lib.generateConfigLines {
      prefix = "gram";
      config = cfg.gram;
    })
    # Temperature metrics with special field mappings
    (tmux-nix-lib.generateConfigLines {
      prefix = "cpu_temp";
      config = cfg.cpuTemp;
      fieldMappings = {
        format = "cpu_temp_format";
        unit = "cpu_temp_unit";
      };
    })
    (tmux-nix-lib.generateConfigLines {
      prefix = "gpu_temp";
      config = cfg.gpuTemp;
      fieldMappings = {
        format = "gpu_temp_format";
        unit = "gpu_temp_unit";
      };
    })
  ];
in {
  options.tmux-nix.plugins.cpu = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable tmux-cpu plugin.";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.tmuxPlugins.cpu;
      description = "tmux-cpu package.";
    };
    cpu = lib.mkOption {
      type = mkDisplayOpts {withThresholds = true;};
      default = {};
      description = "CPU load display configuration.";
    };
    ram = lib.mkOption {
      type = mkDisplayOpts {};
      default = {};
      description = "RAM usage display configuration.";
    };
    gpu = lib.mkOption {
      type = mkDisplayOpts {};
      default = {};
      description = "GPU load display configuration.";
    };
    gram = lib.mkOption {
      type = mkDisplayOpts {};
      default = {};
      description = "GPU RAM usage display configuration.";
    };
    cpuTemp = lib.mkOption {
      type = mkTempOpts;
      default = {};
      description = "CPU temperature display configuration.";
    };
    gpuTemp = lib.mkOption {
      type = mkTempOpts;
      default = {};
      description = "GPU temperature display configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.package];
    tmux-nix.extraConfig = lib.mkAfter ''
      run-shell ${cfg.package}/share/tmux-plugins/tmux-cpu/cpu.tmux
      ${lib.concatStringsSep "\n" confLines}
    '';
  };
}
