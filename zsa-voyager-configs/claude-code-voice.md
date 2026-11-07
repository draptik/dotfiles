# Claude Code voice input on the Voyager

Push-to-talk in Claude Code is bound to **Alt+V**.

## Usage

1. Turn voice mode on in Claude Code with `/voice` (once per session).
2. Hold **L** (home-row Alt), wait a moment until it becomes Alt.
3. Hold **V** and speak.
4. **Keep both keys held** for the whole time you speak.
5. Release: the transcript appears in the prompt. Edit if needed, then press Enter.

Spoken commands like "delete line" are typed literally. Edit with the keyboard instead:
Ctrl+U deletes to line start, Esc twice clears the input.

## Why not Space

Claude Code's default push-to-talk key is Space, but on the Voyager Space is a layer-tap
(tap = Space, hold = layer 3 Brd+Sys), so holding it never sends a held Space.
The laptop's own Space bar still works as fallback.

L + V works because:

- L is the home-row Alt (tapping term 250 ms); chordal hold allows it with V on the other hand.
- V is a plain key, so it auto-repeats while held, which push-to-talk needs.

## Config

`~/.claude/keybindings.json`:

```json
{
  "$schema": "https://www.schemastore.org/claude-code-keybindings.json",
  "$docs": "https://code.claude.com/docs/en/keybindings",
  "bindings": [
    {
      "context": "Chat",
      "bindings": {
        "meta+v": "voice:pushToTalk"
      }
    }
  ]
}
```

`meta` and `alt` are the same key in terminals.

## Microphone (Samson Q2U)

- Card profile must be **Analog Stereo Duplex** (`output:analog-stereo+input:analog-stereo`).
  The Digital (IEC958) input profile has no hardware gain and is far too quiet.
- Mic level: **100 %** (the Q2U is a low-output dynamic mic and needs the +22 dB boost).

```sh
pactl set-card-profile alsa_card.usb-Samson_Technologies_Samson_Q2U_Microphone-00 output:analog-stereo+input:analog-stereo
pactl set-source-volume @DEFAULT_SOURCE@ 100%
```
