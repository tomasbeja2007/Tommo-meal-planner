---
name: design-review
description: Visually review and polish an iOS app's UI. Builds and launches the app in the iOS Simulator, walks through its screens, takes real screenshots, finds typography, spacing, alignment, hierarchy, clipping, colour, safe-area and consistency problems, fixes them in code, rebuilds, and compares before/after screenshots, repeating up to 3 rounds. Use when asked to "design review", check how screens look, polish UI, or verify a UI change. Never treat UI work as done just because it compiles.
---

# /design-review

A UI change is **not done until you have seen it rendered**. Compiling proves nothing about how it looks.

Works in any iOS project. Needs macOS with Xcode and the **MobileBuildMCP** server (installed by
`install.sh`, registered for all projects). Optional: `/preview` (XcodePreviews) to render one SwiftUI `#Preview`
quickly.

Arguments (optional): screen names or a feature to focus on, e.g. `/design-review profile, groceries`.
Without arguments, review every main screen.

## 0. Preconditions (stop early and say why if one fails)
- `uname` is `Darwin`, and `xcodebuild -version` works (Xcode 16 or newer).
- MobileBuildMCP tools are available (e.g. `build_run_sim`, `screenshot`, `snapshot_ui`, `tap`). If not:
  tell the user to run the installer, or `claude mcp list` to check it is connected. Don't fall back to guessing.
- The git working tree: note uncommitted changes so you never overwrite the user's work.

## 1. Learn the project (once per run)
- Find the project: `*.xcworkspace`, else `*.xcodeproj`, else `project.yml` (XcodeGen: run `xcodegen generate`
  first if the project file is missing or stale), else `Package.swift`.
- Find the app scheme and bundle id (MobileBuildMCP `discover_projs`, `list_schemes`, `get_app_bundle_id`).
- Read the design rules **before judging anything**: `CLAUDE.md`, `AGENTS.md`, any `STYLE_GUIDE.md`, `DESIGN*.md`,
  and the theme/token files (search for `Theme`, `Colors`, `Spacing`, `Typography`). The project's own rules win
  over generic taste. If there are no rules, use Apple's Human Interface Guidelines.
- Note how to reach screens: tab bar, onboarding, paywalls, debug menus, deep links (URL schemes in Info.plist),
  launch arguments. Prefer a debug-only shortcut over tapping through long flows, but never add one to release code.

## 2. Baseline ("before")
1. Pick a simulator: a current large iPhone (e.g. "iPhone 17 Pro" / "iPhone 16") plus, for the clipping pass, the
   smallest supported one (e.g. "iPhone SE (3rd generation)"). Use `list_sims`.
2. Make screenshots deterministic: `xcrun simctl status_bar booted override --time 9:41 --batteryState charged
   --batteryLevel 100 --cellularBars 4 --wifiBars 3`, light appearance unless the app supports dark mode (then
   check both: `xcrun simctl ui booted appearance dark|light`).
3. `build_run_sim`. If the build fails, fix the build first (smallest change) and say so.
4. For each screen in scope:
   - Navigate with `snapshot_ui` (gives element labels and frames) then `tap` / `swipe` / `type_text`.
     Tap by the element's frame centre from `snapshot_ui`, never by guessed coordinates.
   - Wait for animations to settle (`wait_for_ui`, or ~1 s) before capturing.
   - `screenshot`, then **open the image and look at it**. Scroll long screens and capture each part.
   - Save to `.design-review/<run>/before/<NN>-<screen>.png` (add `.design-review/` to `.gitignore`).
   - Also capture key states: empty, loading, error, long text, a sheet or menu opened.
5. Optional: Dynamic Type check on one or two dense screens
   (`xcrun simctl ui booted content_size extra-extra-large`, then reset to `large`).

## 3. Inspect every screenshot
Write findings as a numbered list: screen, what is wrong, where, severity (high/med/low), rule broken.
Check:
- **Typography**: one type scale; consistent weights for the same role; no truncation of important text; titles
  vs body hierarchy is obvious; numbers use tabular digits where they change.
- **Spacing**: only values from the spacing scale; equal gaps between equal things; consistent screen side margins;
  no empty bands (e.g. an empty toolbar strip above a title); no cramped clusters.
- **Alignment**: shared leading edges; text baselines line up in rows; icons centred to text; grids even.
- **Hierarchy**: one primary action per screen; the most important thing is the most prominent.
- **Clipping and overflow**: cut-off text, chips, shadows or day strips; horizontal scrolling that hides content;
  overlap with the tab bar, home indicator or keyboard.
- **Colour**: only design-system colours; contrast is readable; brand colour not overused; state colours mean one
  thing (e.g. green only for success).
- **Safe areas**: nothing under the notch/Dynamic Island or home indicator unless intentional; backgrounds bleed.
- **Consistency**: the same component looks and behaves the same on every screen (cards, chips, rows, buttons,
  sheets, headers).
- **Touch targets**: at least 44 × 44 pt.

## 4. Fix (targeted, safe)
- Fix high and medium findings. Change the smallest amount of code that fixes the problem.
- Use the project's existing components and tokens; extend the design system before inventing a value.
- **Do not change behaviour**: no new features, no removed features, no changed navigation, data or business logic.
  Styling and layout only, unless a layout bug is the cause.
- Respect project rules (for example, generated project files must not be hand-edited; motion rules; copy rules).
- After changes, run the project's fast checks: build, and unit tests if they exist (`test_sim`, or
  `swift test` for local packages). If anything fails, fix it or revert that change.

## 5. Verify ("after")
- Rebuild and relaunch, navigate to the same screens in the same states, capture to
  `.design-review/<run>/after/` with matching names.
- Look at each before/after pair side by side and confirm every fix is visible and nothing else regressed
  (check neighbouring screens that share the changed component).

## 6. Repeat
- Up to **3 rounds** in total. Stop earlier when no high/medium findings remain.
- If something still looks wrong after 3 rounds, stop and report it instead of looping.

## 7. Report
- For each fixed issue: the before and after screenshot, what changed, which files.
- Remaining low-severity notes and anything you could not check (with why).
- The tests/builds you ran and their result. Commit only if the user asked you to.
