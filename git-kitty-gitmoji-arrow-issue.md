# kitty: gitmoji ⬆️ renders wrong in `git log`

## Issue

The gitmoji up-arrow (`⬆️` = `U+2B06` + `U+FE0F` variation selector) rendered as a narrow, black, non-emoji glyph in `git log` output inside kitty — while other gitmoji icons (🐛 🔧 ✨ etc.) rendered correctly.

## Root cause

Two separate problems stacked on top of each other:

1. **`symbol_map` override.** An explicit `symbol_map U+2B06 Noto Color Emoji` line in `kitty.conf` was forcing font selection for the bare codepoint, but bypassing kitty's normal variation-selector-aware glyph resolution — so it grabbed the plain/text-style glyph instead of the color one. `⬆️` belongs to Unicode's smaller set of "text-presentation-default" symbols (along with `♻️`, `⚠️`, etc.), which only render as color emoji when explicitly paired with `U+FE0F` — unlike most gitmoji icons, which are emoji-presentation-default and need no selector at all. **Fix:** remove the explicit `symbol_map` entry; kitty's automatic emoji detection already handles the VS16 sequence correctly on its own.

2. **Pager width miscalculation.** Even after fixing (1), `git log`'s default pager (`less`) computes its own column widths and doesn't account for VS16 promoting `⬆️` to a double-width glyph — so it got squashed/truncated back to a narrow, monochrome rendering. Piping without a pager (`git log | cat`, `git --no-pager log`) rendered correctly, confirming the pager as the cause.

## Resolution

- Removed the `symbol_map U+2B06 Noto Color Emoji` line from `kitty.conf`.
- Switched git's pager to bat's built-in pager (`minus`, a separate width-handling implementation from `less`):

```bash
git config core.pager "bat --paging=always --pager=builtin --style=plain"
```

(`--global` instead of local scope, for a systemwide fix: `git config --global core.pager "..."`)
