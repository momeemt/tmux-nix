{lib}: let
  # Convert camelCase to snake_case for tmux variable names
  camelToSnake = s: let
    chars = lib.stringToCharacters s;
    charIsUpper = c: builtins.match "[A-Z]" c != null;
    toPiece = idx: ch:
      if charIsUpper ch
      then (lib.optionalString (idx != 0) "_") + lib.strings.toLower ch
      else ch;
  in
    builtins.concatStringsSep "" (lib.imap0 toPiece chars);

  # Escape strings for tmux configuration
  escape = lib.strings.escape ["\""];

  # Generate a tmux variable setting line
  setLine = name: value: "set -g @${name} \"${escape (toString value)}\"";

  # Generate configuration lines for a plugin option group
  # This is a generic function that can be used by any plugin
  generateConfigLines = {
    prefix,
    config,
    fieldMappings ? {},
  }:
    lib.mapAttrsToList (
      name: value: let
        tmuxVarName =
          if fieldMappings ? ${name}
          then fieldMappings.${name}
          else "${prefix}_${camelToSnake name}";
      in
        setLine tmuxVarName value
    )
    config;
in {
  inherit
    camelToSnake
    escape
    setLine
    generateConfigLines
    ;
}
