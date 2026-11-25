# Tommo style guide

The single source of truth for how Tommo looks, reads and moves. Every screen follows it.
The tokens live in code in `Forkcast/Theme/Theme.swift`; motion rules live in
`Forkcast/Theme/Motion/MOTION.md`; art requests follow `Design/IMAGE_REQUESTS.md`.
If a screen needs something this guide doesn't cover, add it here first, then use it.

**The feel:** a warm kitchen, food first. Cream paper, ripe tomato, aubergine ink. Calm, generous, a little playful
(Chef Tommo), never loud. Real food photos do the talking; the interface stays quiet around them.

---

## 1. Colour

Light mode only. Use the `Theme` names in code, never raw hex (the one exception is `Theme.Illustration`).

| Token | Hex | Role |
|---|---|---|
| `cream` | `#FBF6EE` | App background, every screen, edge to edge (`.creamBackground()`). |
| `card` | `#FFFFFF` | Cards, inputs, sheets' inner cards, logo capsules. |
| `creamDeep` | `#F3E9DA` | Sunken surfaces: unselected chips and tiles, tracks, empty plates, placeholders. |
| `line` | `#EADFCF` | Hairlines, dividers, card and button outlines, dashed "add" rows. |
| `tomato` | `#E8553D` | **The** brand colour: primary buttons, selection outlines, progress, icons, large text. |
| `tomatoDeep` | `#C9402B` | Pressed primary, **small tomato text** (links, eyebrows, prices), big numbers, "today". |
| `tomatoSoft` | `#FBE3DC` | Selected fills, icon discs, the soft "sun" behind Chef Tommo. |
| `aubergine` | `#2B1E2E` | Primary text and titles. |
| `aubergineMuted` | `#6E5F6B` | Secondary text: subtitles, meta, captions. |
| `aubergineFaint` | `#A89BA5` | Disabled, placeholders, completed items. **Never for information.** |
| `saffron` | `#F2B544` | Warm accent: sparkles, confetti, the carbs bar. Not for text. |
| `saffronSoft` | `#FCEFD3` | Warm glows and highlights. |
| `herb` | `#5B8C5A` | Success only: checkmarks, "under budget", "saved". **Never a brand colour.** |
| `herbSoft` | `#E3EEDF` | Success backgrounds. |
| `macroProtein` / `macroCarbs` / `macroFat` | tomato 75% / saffron 85% / `#7A5C7E` 80% | Macro bars and dots only. |
| `Illustration.*` | ocean, land, coast, atmosphere | The globe only. Never interface chrome. |

**Contrast (measured, WCAG):**

| Text colour | on cream | on card | Use it for |
|---|---|---|---|
| aubergine | 14.7 : 1 | 15.8 : 1 | anything |
| aubergineMuted | 5.6 : 1 | 6.0 : 1 | any secondary text |
| tomatoDeep | 4.6 : 1 | 4.9 : 1 | small tomato text (≥ caption, semibold) |
| tomato | 3.4 : 1 | 3.6 : 1 | large text (≥ 18 pt, or ≥ 14 pt bold) and icons only |
| herb | 3.7 : 1 | 3.9 : 1 | bold text ≥ 14 pt, icons |
| aubergineFaint | 2.5 : 1 | 2.7 : 1 | disabled / decorative only |
| white on tomato | 3.6 : 1 | | button labels (headline bold counts as large) |

**Rules**
- One tomato action per screen. Everything else is secondary (outline), quiet (text) or a chip.
- Selected = `tomatoSoft` fill + `tomato` outline (1.5–2 pt) + `tomatoDeep` text. Unselected = `creamDeep`, no outline.
- Success is the only green. Errors and "over budget" use `tomatoDeep`, never a new red.
- No gradients in interface chrome. Gradients are allowed inside illustrations (globe, pin, glows).

## 2. Typography

**SF Pro Rounded everywhere**, set once at the root (`.fontDesign(.rounded)`). Text uses Dynamic Type styles so it
scales; only `display` and the number styles are fixed sizes. Tokens: `Theme.Typography`.

| Token | Spec | Use |
|---|---|---|
| `display` | 44 heavy (scale with `@ScaledMetric`) | Welcome headline only. |
| `title` (`Theme.questionFont`) | 30 bold | Screen and question titles. |
| `largeTitle` | largeTitle bold | Main tab titles ("Meal Plan"). |
| `title2` | title2 bold | Big statements in a screen ("a year!"). |
| `title3` | title3 bold | Section headers (`SectionHeader`), empty-state titles, card headlines. |
| `headline` | headline (semibold/bold) | Recipe names, card titles, button labels. |
| `body` | body | Option titles (semibold), reading text (steps). |
| `subheadline` | subheadline | Subtitles, secondary copy, chips (medium). |
| `caption` | caption | Meta (time, servings, cost), helper text. |
| `eyebrow` | caption bold, UPPERCASE | Small labels above a title: "TODAY", "FIRST UP, MONDAY". |
| `footnote` | footnote | Fine print: "Example based on…", terms. |
| `heroNumber` | 72 black | One hero number per screen (the yearly saving). |
| `bigNumber` | 44 black | Counters and big amounts. |

**Rules**
- Weights: **heavy/black** for display and numbers only; **bold** for titles; **semibold** for labels, buttons, list
  titles; **medium** for chips; **regular** for reading text. Never light or thin.
- Every changing number is `.monospacedDigit()`; numbers that change in place also use
  `.contentTransition(.numericText())` or a clock-driven count-up (`MoneyText(countUp:)`).
- Money always goes through `MoneyFormat` / `ProfileStore.formatMoney` (the user's currency and locale:
  "1.040 €", "£78.40"). Estimates read "~82,11 €".
- Line length: titles wrap at most 3 lines; recipe names 2 lines (`lineLimit(2, reservesSpace: true)` in grids).
- Left-aligned by default. Centre only on celebration and single-message screens (welcome, savings, reveal, empty
  states).

## 3. Spacing and layout

A 4-point scale with one 6 for tight inline gaps. Tokens: `Theme.Spacing`. No other numbers.

| Token | pt | Use |
|---|---|---|
| `xxs` | 2 | Title + caption in a tight stack. |
| `xs` | 4 | Icon + label in meta rows, tag padding. |
| `inline` | 6 | Chip rows, compact grids, avatar stacks. |
| `s` | 8 | Between lines of a block, small stacks. |
| `m` | 12 | Between rows of options, inside list rows. |
| `l` | 16 | **Card padding**, between related blocks, button horizontal padding. |
| `gutter` | 20 | **Screen side margins.** Every screen. |
| `xl` | 24 | Between sections, around empty states. |
| `xxl` | 32 | Bottom breathing room above pinned buttons. |
| `xxxl` | 48 | Top breathing room on celebration screens. |

**Layout rules**
- Screens: `gutter` left and right, content in a `ScrollView`, the primary action **pinned at the bottom** with
  `.safeAreaInset(edge: .bottom)` on a `cream` (97%) background, padded `gutter` × `s`.
- Question screens use `QuestionScaffold`: title + subtitle top-left, optional 48 pt mascot top-right, content
  `xl` below, pinned Continue.
- Sections are separated by `xl`; items inside a section by `m`; lines inside an item by `xs`–`s`.
- Minimum tap target 44 × 44 (`Theme.Size.tapTarget`), including icon buttons and checkboxes.
- Don't leave a hole: if content ends far above the pinned button, grow the content (another row, larger art) or
  centre it vertically; never let it float at the top with an empty half screen.

## 4. Shape

`Theme.Radius`, always `style: .continuous`.

| Token | pt | Use |
|---|---|---|
| `small` | 10 | Thumbnails ≤ 48 pt, small badges and fields. |
| `medium` | 14 | Day pills, mid-size tiles inside cards. |
| `button` / `input` | 16 | Buttons, inputs, option tiles, list tiles. |
| `card` | 20 | Cards. |
| `large` | 24 | Dish photos ≥ 100 pt. |
| `hero` | 32 | Hero dish photos ≥ 130 pt. |
| Capsule | | Chips, tags, progress bars, logo capsules, toasts. |
| Circle | | Avatars, icon discs, round icon buttons, check badges. |

Nested corners: an inner shape's radius = outer radius − padding (a 20 pt card with 16 pt padding holds 4–10 pt
inner corners; use `small`).

## 5. Elevation

Three shadows only (`Theme.Elevation`, applied with `.elevation(_:)`):
- `card`: black 6%, blur 12, y 4. Every card (`.cardStyle()`). The default.
- `lifted`: aubergine 16%, blur 10, y 6. Things that float above a card: dealt dish photos, hero dishes.
- `subtle`: aubergine 10%, blur 5, y 3. Small pieces on cream: ingredient cut-outs, logo capsules.

No shadows on buttons, chips or text. Depth inside illustrations (contact shadows, floor shadows) belongs to the
illustration.

## 6. Components

Reuse these; don't rebuild them per screen (`Forkcast/Theme/Components/`).

- **PrimaryButton**: full width, 56 pt, `tomato` fill, white `headline` bold, radius 16; pressed → `tomatoDeep` +
  98% scale + light haptic; disabled 40% opacity. One per screen.
- **SecondaryButtonStyle**: 50 pt; outlined = white fill + 1.5 pt tomato stroke + tomato text; quiet = `creamDeep`
  fill + aubergine text.
- **QuietButtonStyle**: text only, `subheadline` semibold, `aubergineMuted` (or `tomatoDeep` for links), 44 pt tall.
  For "Skip", "Maybe later", "Not now".
- **Card** / `.cardStyle()`: white, radius 20, padding 16, `card` shadow.
- **OptionTile**: radius 16, padding 16, `creamDeep` → selected `tomatoSoft` + 2 pt tomato stroke + check badge;
  `body` semibold title, `subheadline` muted subtitle; light haptic on select.
- **Chip**: capsule, min 36 pt, `subheadline` medium, `creamDeep` → selected `tomatoSoft` + 1 pt tomato stroke +
  `tomatoDeep` text; selection haptic.
- **TagLabel**: capsule, `caption` semibold, `creamDeep` fill, muted text. Max two per card.
- **SectionHeader**: `title3` bold + optional `subheadline` muted subtitle + optional tomato action.
- **DishTileView**: the only way to show a recipe image (photo `recipe-<id>` or the emoji fallback).
- **StoreLogo / StoreMonogram**: the only way to show a shop (official logo asset `store-<id>` or brand-colour name).
- **ProgressBar / ProgressRing, MacrosLine / MacrosCard, MoneyText, EmptyState, MascotView, CheckCircle**: as named.
- **Segmented control** (`CapsuleSegments`): a `creamDeep` capsule with a white pill (`subtle` shadow) that slides
  to the selected option; selected text aubergine bold, others muted semibold. Use instead of the system segmented
  picker.
- **Detail pages** (the recipe page is the reference): full-bleed photo (stretch on pull, 35% parallax), a cream sheet
  with 28 pt top corners rising over it, glass buttons in the navigation bar, frosted pills on the photo, a facts
  card, a row of round actions, and one pinned primary action ("Start cooking").
- **Top bar (onboarding)**: 44 pt round white back button with a `line` stroke, 6 pt tomato progress bar, optional
  quiet "Skip".

## 7. Iconography

- SF Symbols, `.semibold` (bold for chevrons and checkmarks), sized with text styles where they sit next to text.
- Icon on its own: tomato on a `tomatoSoft` disc (36–44 pt), or aubergine on white with a `line` stroke.
- Never build a screen out of stock symbols alone: pair them with real food photos, ingredient cut-outs or
  Chef Tommo.

## 8. Imagery and Chef Tommo

- **Recipe photos**: warm, top-down or 45°, on neutral ceramics, no text. Through `DishTileView` only.
- **Ingredients**: transparent cut-outs (`ingredient-<id>`), shown with the `subtle` shadow or a contact shadow.
- **Chef Tommo** (two m's): only through `MascotView`, only on special moments (welcome, onboarding corners and
  celebrations, empty states, building/reveal, cook-mode finish, savings, shop done). Never on everyday screens.
- **Shop logos**: official files only, with permission. Never drawn or imitated.
- New art: request it from Grok with `Design/IMAGE_REQUESTS.md`; never invent placeholder art.

## 9. Motion and haptics

Read `Forkcast/Theme/Motion/MOTION.md` (rossark-motion-skill rules, Part 2 for this project). In short:
- Interface: `Theme.spring` (response 0.35, damping 0.8) for selection, `Theme.Motion.update` for state changes,
  `fadeIn` 0.18 s / `fadeOut` 0.15 s. Interface moves stay under 300 ms; exits are faster than entrances.
- Moments: one clock per scene (`OneShotClock` + `LoopClock`), ease-out to arrive, ease-in-out to travel, nothing
  appears from scale 0, idle life never stops, Reduce Motion shows the final frame.
- Haptics: selection on chip/option taps and checklist ticks; light impact on primary presses and landings; medium
  on a big reveal beat; success when a plan is ready, a saving lands, a trial starts, all groceries are checked.
  Never more than one haptic per 100 ms.

## 10. Voice and copy

- Warm, short, second person. Chef Tommo is friendly, never cute-for-cute's-sake.
- **Onboarding questions are lower case** ("what's in your kitchen?"); buttons, tab titles, section headers and
  everything else are sentence case ("Continue", "Edit week", "Grocery list").
- Personal whenever we know something: their name, their shop, their budget, their days ("Dinis, here's your week",
  "5 dinners for 2 adults, priced at Carrefour").
- Honest: estimates say "~" or "estimated"; examples say "Example"; no fake reviews, no invented statistics.
- Every user-facing string goes through `String(localized:)` / `Text("…")`.

## 11. Accessibility

- Dynamic Type: text styles everywhere; fixed-size numbers use `.minimumScaleFactor` and `lineLimit(1)`.
- Contrast: follow the table in §1 (no information in `aubergineFaint`, small tomato text in `tomatoDeep`).
- VoiceOver: decorative art `accessibilityHidden`, combined labels on cards, `.isHeader` on titles, `.isSelected` on
  selected tiles.
- Reduce Motion: every animation has a still, final-frame version.
- Tap targets ≥ 44 pt.

## 12. Checklist for every new screen

1. Cream background, 20 pt gutters, one tomato action pinned at the bottom.
2. Only `Theme` colours, `Theme.Typography` / text styles, `Theme.Spacing`, `Theme.Radius`, `Theme.Elevation`.
3. Existing components reused; images through `DishTileView` / `MascotView` / `StoreLogo`.
4. Copy personal, honest, localised; lower case only for onboarding questions.
5. Motion and haptics per §9; Reduce Motion checked.
6. No empty half screen above the button.
