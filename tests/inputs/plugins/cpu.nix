{
  pkgs,
  lib,
  ...
}: {
  programs.tmux-nix.plugins.cpu = {
    enable = true;
    cpu = {
      lowIcon = "-";
      mediumThresh = 20;
      highThresh = 80;
    };
    ram = {
      mediumBgColor = "#[bg=yellow]";
    };
    gpu = {
      lowIcon = "G";
    };
    gram = {
      percentageFormat = "%5.1f%%";
    };
    cpuTemp = {
      unit = "F";
    };
    gpuTemp = {
      unit = "F";
    };
  };
}
