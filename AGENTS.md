# Coding Guidelines

## Commit Author

- All commits must be authored as `Codex <codex@openai.com>`.
- Each commit message must include the line `Co-authored-by: Mutsuha Asada <me@momee.mt>`.

## Tests

- When modifying the tmux integration test in `flake.nix`, define a reusable `check` helper using a `let` expression.
- Use this helper to verify expected lines in `.tmux.conf` with `grep -q '^${line}$'`.
- Ensure keymaps, prefix, and `extraConfig` lines are covered.

## Implementation Heuristics

- Configure each key binding with `key` and `repeatable` attributes under the binding name (e.g. `keymaps.pane.left.key`).
- Keep integration tests minimal: verify non-repeatable bindings via `left` and `right`, and repeatable bindings via `up` and `down`.
- Append any new decisions or rules identified during implementation to this file.
