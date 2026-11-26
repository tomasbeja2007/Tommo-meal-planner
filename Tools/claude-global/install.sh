#!/usr/bin/env bash
# Installs the global /design-review workflow for Claude Code on this Mac, for every iOS project:
#   1. MobileBuildMCP (free, MIT, getsentry/MobileBuildMCP): build, run, screenshot, read the UI tree, tap, swipe, type
#      in the iOS Simulator. Registered once for your user, so it works in every project.
#   2. XcodePreviews (free, MIT, Iron-Ham/XcodePreviews): optional /preview command that renders one SwiftUI #Preview.
#   3. The /design-review skill (~/.claude/skills/design-review).
# Safe to run again: it updates what's there and skips what's already done. Nothing paid, no accounts.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
bold() { printf '\n\033[1m%s\033[0m\n' "$*"; }
ok() { printf '  ✓ %s\n' "$*"; }
note() { printf '  • %s\n' "$*"; }
fail() { printf '\n  ✗ %s\n\n' "$*" >&2; exit 1; }

bold "Checking this Mac"
[ "$(uname)" = "Darwin" ] || fail "This needs a Mac (the iOS Simulator only runs on macOS)."

os="$(sw_vers -productVersion)"
os_major="${os%%.*}"
os_minor="$(echo "$os" | cut -d. -f2)"
if [ "$os_major" -lt 14 ] || { [ "$os_major" -eq 14 ] && [ "${os_minor:-0}" -lt 5 ]; }; then
  fail "MobileBuildMCP needs macOS 14.5 or newer. This Mac has $os."
fi
ok "macOS $os"

command -v xcodebuild >/dev/null 2>&1 || fail "Xcode isn't installed. Install it from the App Store, open it once, then run this again."
xcode_version="$(xcodebuild -version 2>/dev/null | awk 'NR==1 {print $2}')"
[ -n "$xcode_version" ] || fail "Xcode is installed but not selected. Run: sudo xcode-select -s /Applications/Xcode.app"
[ "${xcode_version%%.*}" -ge 16 ] || fail "MobileBuildMCP needs Xcode 16 or newer. This Mac has Xcode $xcode_version."
ok "Xcode $xcode_version (compatible)"

xcrun simctl list devices available 2>/dev/null | grep -q "iPhone" \
  || fail "No iPhone simulators found. In Xcode: Settings > Components, install an iOS simulator, then run this again."
ok "iOS simulators available"

bold "1/3 MobileBuildMCP (simulator control and screenshots)"
if command -v mobilebuildmcp >/dev/null 2>&1; then
  ok "already installed ($(mobilebuildmcp --version 2>/dev/null || echo 'version unknown'))"
elif command -v brew >/dev/null 2>&1; then
  # Homebrew build: no Node.js needed.
  brew tap getsentry/xcodebuildmcp
  brew install mobilebuildmcp
  ok "installed with Homebrew"
elif command -v node >/dev/null 2>&1 && [ "$(node -p 'process.versions.node.split(".")[0]')" -ge 18 ]; then
  npm install -g mobilebuildmcp@latest
  ok "installed with npm"
else
  fail "Install Homebrew (https://brew.sh) or Node.js 18+, then run this again."
fi
mobilebuildmcp_bin="$(command -v mobilebuildmcp)"

if command -v claude >/dev/null 2>&1; then
  # Register for your user (every project). Only the simulator and UI-automation tools are switched on,
  # and its crash reporting to Sentry is turned off.
  claude mcp remove --scope user MobileBuildMCP >/dev/null 2>&1 || true
  claude mcp add --scope user \
    --env MOBILEBUILDMCP_ENABLED_WORKFLOWS=simulator,ui-automation \
    --env MOBILEBUILDMCP_SENTRY_DISABLED=true \
    MobileBuildMCP -- "$mobilebuildmcp_bin" mcp
  ok "registered with Claude Code for all projects"
else
  note "The 'claude' command isn't installed, so MobileBuildMCP wasn't registered yet."
  note "Install Claude Code's CLI, then run this script again (it will skip what's done)."
fi

bold "2/3 XcodePreviews (/preview for single SwiftUI previews)"
previews_dir="${PREVIEW_BUILD_PATH:-$HOME/XcodePreviews}"
if [ -d "$previews_dir/.git" ]; then
  git -C "$previews_dir" pull --ff-only --quiet && ok "updated in $previews_dir"
else
  git clone --quiet --depth 1 https://github.com/Iron-Ham/XcodePreviews.git "$previews_dir"
  ok "downloaded to $previews_dir"
fi
mkdir -p "$HOME/.claude/commands"
cp "$previews_dir/.claude/commands/preview.md" "$HOME/.claude/commands/preview.md"
ok "/preview command installed (its helper builds itself with Xcode's Swift on first use)"
note "Not installing cliclick: tapping is already handled by MobileBuildMCP."

bold "3/3 /design-review skill"
skill_dir="$HOME/.claude/skills/design-review"
mkdir -p "$skill_dir"
if [ -f "$skill_dir/SKILL.md" ] && ! cmp -s "$HERE/skills/design-review/SKILL.md" "$skill_dir/SKILL.md"; then
  cp "$skill_dir/SKILL.md" "$skill_dir/SKILL.md.bak"
  note "kept your previous version as SKILL.md.bak"
fi
cp "$HERE/skills/design-review/SKILL.md" "$skill_dir/SKILL.md"
ok "installed to $skill_dir"

bold "Checking it all works"
"$mobilebuildmcp_bin" --help >/dev/null 2>&1 && ok "MobileBuildMCP runs"
if command -v claude >/dev/null 2>&1; then
  claude mcp list 2>/dev/null | grep -i "MobileBuildMCP" || note "Open Claude Code once and run: claude mcp list"
fi

bold "Done"
echo "  Open Claude Code in any iOS project folder on this Mac and type:  /design-review"
echo "  (or /design-review profile, groceries  to focus on some screens)"
