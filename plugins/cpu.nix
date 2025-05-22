{ config, lib, pkgs, ... }:
let
  cfg = config.tmux-nix.plugins.cpu;
  escape = lib.strings.escape ["\""];

  mkLoadOpts = { withThresholds ? false }:
    lib.types.submodule {
      options = {
        lowIcon = lib.mkOption { type = lib.types.str; default = "="; };
        mediumIcon = lib.mkOption { type = lib.types.str; default = "≡"; };
        highIcon = lib.mkOption { type = lib.types.str; default = "≣"; };
        lowFgColor = lib.mkOption { type = lib.types.str; default = ""; };
        mediumFgColor = lib.mkOption { type = lib.types.str; default = ""; };
        highFgColor = lib.mkOption { type = lib.types.str; default = ""; };
        lowBgColor = lib.mkOption { type = lib.types.str; default = "#[bg=green]"; };
        mediumBgColor = lib.mkOption { type = lib.types.str; default = "#[bg=yellow]"; };
        highBgColor = lib.mkOption { type = lib.types.str; default = "#[bg=red]"; };
        percentageFormat = lib.mkOption { type = lib.types.str; default = "%3.1f%%"; };
      } // (lib.optionalAttrs withThresholds {
        mediumThresh = lib.mkOption { type = lib.types.int; default = 30; };
        highThresh = lib.mkOption { type = lib.types.int; default = 80; };
      });
    };

  mkTempOpts = {
    options = {
      lowIcon = lib.mkOption { type = lib.types.str; default = "="; };
      mediumIcon = lib.mkOption { type = lib.types.str; default = "≡"; };
      highIcon = lib.mkOption { type = lib.types.str; default = "≣"; };
      lowFgColor = lib.mkOption { type = lib.types.str; default = ""; };
      mediumFgColor = lib.mkOption { type = lib.types.str; default = ""; };
      highFgColor = lib.mkOption { type = lib.types.str; default = ""; };
      lowBgColor = lib.mkOption { type = lib.types.str; default = "#[bg=green]"; };
      mediumBgColor = lib.mkOption { type = lib.types.str; default = "#[bg=yellow]"; };
      highBgColor = lib.mkOption { type = lib.types.str; default = "#[bg=red]"; };
      format = lib.mkOption { type = lib.types.str; default = "%2.0f"; };
      unit = lib.mkOption { type = lib.types.str; default = "C"; };
      mediumThresh = lib.mkOption { type = lib.types.int; default = 80; };
      highThresh = lib.mkOption { type = lib.types.int; default = 90; };
    };
  };

  setLine = name: value:
    "set -g @${name} \"${escape (toString value)}\"";

  loadLines = prefix: cfgGroup:
    lib.mapAttrsToList (n: v: setLine "${prefix}_${n}" v) cfgGroup
    ++ (lib.optionals (cfgGroup ? mediumThresh) [
         setLine "${prefix}_medium_thresh" cfgGroup.mediumThresh
         setLine "${prefix}_high_thresh" cfgGroup.highThresh
       ]);

  tempLines = prefix: cfgGroup:
    lib.mapAttrsToList (n: v:
      if n == "format" then setLine "${prefix}_format" v
      else if n == "unit" then setLine "${prefix}_unit" v
      else setLine "${prefix}_${n}" v
    ) cfgGroup;

  confLines =
    loadLines "cpu" cfg.cpu
    ++ loadLines "ram" cfg.ram
    ++ loadLines "gpu" cfg.gpu
    ++ loadLines "gram" cfg.gram
    ++ tempLines "cpu_temp" cfg.cpuTemp
    ++ tempLines "gpu_temp" cfg.gpuTemp;

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
    cpu = lib.mkOption { type = mkLoadOpts { withThresholds = true; }; default = {}; };
    ram = lib.mkOption { type = mkLoadOpts {}; default = {}; };
    gpu = lib.mkOption { type = mkLoadOpts {}; default = {}; };
    gram = lib.mkOption { type = mkLoadOpts {}; default = {}; };
    cpuTemp = lib.mkOption { type = mkTempOpts; default = {}; };
    gpuTemp = lib.mkOption { type = mkTempOpts; default = {}; };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    tmux-nix.extraConfig = lib.mkAfter ("""
      run-shell ${cfg.package}/share/tmux-plugins/tmux-cpu/cpu.tmux
      ${lib.concatStringsSep "\n" confLines}
    """);
  };
}
