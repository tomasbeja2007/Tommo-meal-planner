# Global Claude Code tools for iOS work

Run once on your Mac (from this folder or anywhere):

```bash
./Tools/claude-global/install.sh
```

It installs, for **every** project on the Mac (not just Tommo):

| Piece | What it does | Licence |
|---|---|---|
| [MobileBuildMCP](https://github.com/getsentry/MobileBuildMCP) | Lets Claude build, run, screenshot, read the screen and tap/swipe/type in the iOS Simulator. Registered at user scope with only the simulator and UI-automation tools on, and its Sentry crash reporting off. | MIT, free |
| [XcodePreviews](https://github.com/Iron-Ham/XcodePreviews) | `/preview` renders a single SwiftUI `#Preview` to a PNG. Cloned to `~/XcodePreviews`. | MIT, free |
| `/design-review` skill | Build → walk the screens → screenshot → find issues → fix → rebuild → compare before/after, up to 3 rounds. Copied to `~/.claude/skills/design-review`. | ours |

Requirements checked by the script: macOS 14.5+, Xcode 16+, an iOS simulator, and Homebrew or Node.js 18+.

Not installed:
- `Jakeintech/claude-ios-skills`: the repository doesn't exist (or isn't public).
- `cliclick` (XcodePreviews' optional tap helper): redundant, MobileBuildMCP already taps.

To update later, run the script again. To edit the skill, change `skills/design-review/SKILL.md` here and re-run.
