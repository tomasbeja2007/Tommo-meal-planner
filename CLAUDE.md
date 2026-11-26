# Forkcast: standing instructions for Claude Code

You are building a native iOS app in SwiftUI: **Forkcast**, a weekly dinner planner built around the user's
supermarket and budget (plan → shop → cook → rate → better next week).
Feature prompts (usually written by Grok) go on top of this file.

## How to work
1. Before writing any code, read the relevant parts of the codebase and reply with a short plan: which files you
   will add or change, where new screens slot in, and any assumptions. Wait for my OK.
2. After I say OK: implement, build, fix compile errors, and test in the Simulator.
   Generate the project with `xcodegen generate` (never hand-edit the .xcodeproj). Run `cd Packages/ForkcastCore && swift test`.
3. Report back with what changed, anything you had to assume, and what I should test by hand.
   If you cannot run the Simulator, say so and still do a syntax check.
   For any UI change, look at real Simulator screenshots before and after (the `/design-review` skill, if installed).
   A UI change is never done just because it compiles.

Do not redesign or reorder existing screens unless the prompt explicitly says to. Reuse the app's existing
components, colours, fonts, and assets. Keep the existing design system. Do not invent a new look.

## This codebase
- Pure logic (planner, groceries, nutrition, units, parser, bundled JSON) lives in `Packages/ForkcastCore`
  (Foundation only, unit-tested). UI lives in `Forkcast/`. Read `BUILD_NOTES.md` first.
- **Style guide: `Design/STYLE_GUIDE.md`** (colours and contrast, type scale, spacing, radii, elevation, components,
  copy, accessibility, a checklist for every screen). Follow it; extend it before inventing anything new.
- Design system: `Forkcast/Theme/Theme.swift` (tomato/cream palette, SF Pro Rounded, radii, `Theme.spring`)
  and `Forkcast/Theme/Components/` (PrimaryButton, OptionTile, Chip, Card, ProgressBar, MacrosLine, MacrosCard,
  DishTileView, MascotView, MoneyText, SectionHeader, EmptyState). Never use green as a brand colour.
- Every user-facing string goes through `String(localized:)` / `Text("…")`.
- The mascot is only ever drawn through `MascotView`. Recipe photos are picked up automatically as `recipe-<id>`.
- SwiftData models must stay CloudKit-safe: every property optional or defaulted, no `.unique`, optional relationships with inverses.

## Make it feel custom, not generic
Personalise copy, cards, plans, and visuals from the user's real answers and real dates. Avoid the default SwiftUI
look, screens made only of stock SF Symbols, and template copy. Never ship fake reviews (the testimonial carousel
holds clearly marked placeholders until real reviews exist). Keep debug and mock-mode labels inside `#if DEBUG`.

## Animation
When a change involves motion, animations, springs, haptics, count-ups, celebration moments, or bringing drawings,
icons or illustrations to life, use the **rossark-motion-skill** (installed in `.agents/skills/rossark-motion-skill`,
https://github.com/rossark0/rossark-motion-skill). Read `Forkcast/Theme/Motion/MOTION.md` first: its Part 2 holds
this project's rules and overrides the skill. The engine is already in `Forkcast/Theme/Motion/Motion.swift`
(SwiftUI templates: `Motion.swift`, `LiveFace.swift`). Implement in SwiftUI with those templates and principles
(one clock for the scene, real pivots, follow-through, idle life that never stops, smooth paths through poses).
Do not use the React Native templates in this iOS app, and do not invent slideshow-style pose swaps or stop-start tweens.

## Images
You cannot generate images, icons, avatars, illustrations, or logos. Never invent placeholder art or use random stock.
If new art is needed, output a section titled **"Image prompts for Grok"** with a list of items, each including:
file name, size, transparent background or not, and style notes that match this app (see `Design/IMAGE_REQUESTS.md`
for the shared style brief). I will get Grok to generate the files and drop them into Assets.

If you need a product decision (for example, should a control be tappable?), ask me before assuming.
I may take that question to Grok.
