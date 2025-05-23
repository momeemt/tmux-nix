{pkgs, ...}: let
  escape = s: pkgs.lib.strings.escape ["\"" "[" "]"] s;
  check = line: "machine.succeed(\"grep -q '^${escape line}$' /home/alice/.tmux.conf\")";
in {
  inherit escape check;
}
