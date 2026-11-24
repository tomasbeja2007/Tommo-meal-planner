---
name: tomo-motion-design
description: Design, animate, and review Forkcast's SwiftUI screens, transitions, haptics, interaction feedback, photography, and accessibility within the existing Tomo project.
---

# Tomo motion design

The shipping app is branded Forkcast. Keep its name, AppIcon, Chef Tomato, navigation, and existing data and entitlement flows. Use native SwiftUI on iOS 17+ and existing components. Read `Forkcast/Theme/Theme.swift` for live tokens and `Forkcast/Theme/Motion/MOTION.md` for mascot and motion-engine rules.

## Brand and components

- The cream screen is `cream` (#FBF6EE). White cards use `card` and the shared card shadow. Use `creamDeep` (#F3E9DA) for inset controls. Tomato (#E8553D), its dark variant (#C9402B), and soft variant (#FBE3DC) carry actions and selection. Text is aubergine (#2B1E2E) with the muted variant (#6E5F6B) for supporting copy. Saffron is a secondary accent. Herb green indicates success. Use theme values directly.
- Use system rounded type for titles and controls, system body for readable copy, and monospaced digits for money, portions and timers. Use Dynamic Type, including scaled metrics for any fixed display size.
- Spacing uses 4, 8, 12, 16, 24, and 32 points with a 20-point page gutter. Card corners are 20 points, inputs and buttons 16. Reuse `cardStyle`, `PrimaryButtonStyle`, `OptionTile`, and system SF Symbols. Keep controls at least 44 by 44 points.
- Use the existing mascot via `MascotView`. Reserve it for welcome, meaningful progress, and celebration. Reuse transparent photoreal `ingredient-<id>` assets and shared thumbnails. Groceries use unframed cutouts. Reuse actual dish photography and label illustrative recipe imagery. Use a real app screenshot for any phone mockup.
- The bundled rossark motion skill is MIT licensed. Use `LoopClock`, `OneShotClock`, and the SwiftUI helpers already in the repo. The app requires no external animation runtime.

## Motion and interaction

- `Theme.Motion` defines press (100 ms), release (180 ms spring), selection (350 ms response, 0.8 damping), frequent updates (240 ms response, 0.9 damping), fades (180/150 ms), reveal (360 ms), and a 50 ms stagger. Use the native tab, sheet, and navigation transitions for their interactive gestures and dismissal.
- Mark state first. Apply the animation to a single value or the changed row. A checked grocery has a state mark, haptic, count update, and an accessible toggle. A swap crossfades the changed card and keeps the day and scroll position. Keep price and billing disclosures stable and immediately readable.
- Match haptics to discrete interaction: light impact on CTA press, selection on a changed choice or value, success on actual plan or shopping completion. Avoid repeat haptics for pressing and releasing the same control or for each timer tick.
- Pause ambient motion while hidden or backgrounded. Animate transforms and opacity on a single clock per decorative scene. Keep every loop seamless with periods that divide the enclosing clock. Use modest phase offsets and limit shadow and layout work on scrolling surfaces.
- Reduce Motion shows final UI state immediately and freezes decoration. Preserve text, focus, traits, progress values, and native gesture alternatives. Countdown state comes from the monotonic timer. Loading state comes from real work and uses an indeterminate indicator if progress is unknown.
- Good: a quick check mark with a stable row target, ingredients drifting gently around a static headline, a short scoped fade around a real task. Avoid springing an entire list, replaying entrance motion on every scroll, staged loading delays, and moving legal copy.
- Verify large Dynamic Type, VoiceOver order, contrast, Reduce Motion, rapid repeat actions, scrolling during row changes, and interrupted or backgrounded animations on an iPhone. Measure frame pacing with Instruments before reporting frame-rate results. Run the ForkcastCore suite and available SwiftUI build checks before pushing.
