# Forkcast — build notes

Native SwiftUI weekly meal planner for iPhone (iOS 17+). No backend, no third-party packages.

```
project.yml                  XcodeGen spec (app, widget, share extension, StoreKit scheme)
Packages/ForkcastCore/       Pure-Foundation logic + bundled JSON + 53 unit tests
Forkcast/                    The app (App, Theme, Features, Services, Persistence, Resources)
ForkcastWidget/              "Tonight's dinner" widget (reads an App Group JSON snapshot)
ForkcastShare/               Share Extension for TikTok / Instagram / text imports
Design/                      Mascot source art + IMAGE_REQUESTS.md (art still to make)
Tools/                       Python scripts used to bootstrap the JSON data
reference-screens/           Competitor screenshots (reference only, not shipped)
```

---

## 1. First run on the Mac

1. Install XcodeGen and generate the project:
   ```bash
   brew install xcodegen
   ```
   ```bash
   xcodegen generate
   ```
2. Open `Forkcast.xcodeproj` (Xcode 16+; Xcode 26 if you want Foundation Models).
3. For **each target** (Forkcast, ForkcastWidget, ForkcastShare) → *Signing & Capabilities* → choose your **Team**.
   Or set `DEVELOPMENT_TEAM` once in `project.yml` and re-run `xcodegen generate`.
4. **Bundle IDs**: change `BUNDLE_ID_PREFIX` in `project.yml` (one place). If you do, also update:
   - the App Group (`group.com.forkcast.app`) and iCloud container (`iCloud.com.forkcast.app`) in `project.yml` entitlements, **and**
   - `SharedConstants.appGroupId` / `cloudKitContainerId` in `Packages/ForkcastCore/Sources/ForkcastCore/Shared/SharedConstants.swift`.
5. Capabilities (already declared in the generated entitlements; Xcode just needs to provision them):
   - **iCloud** → CloudKit, container `iCloud.com.forkcast.app` (create it in the developer portal if Xcode doesn't).
   - **Push Notifications** (`aps-environment`, used by CloudKit sync) + Background Modes → Remote notifications.
   - **App Groups** → `group.com.forkcast.app` on the app, widget **and** share extension.
   - **Sign in with Apple** on the app.
   - **In-App Purchase** (add it in Signing & Capabilities if Xcode asks).
6. The `Forkcast` scheme already points at `Forkcast/Resources/Forkcast.storekit`
   (Edit Scheme → Run → Options → StoreKit Configuration). Check it's selected.
7. Run on an iPhone simulator or device.

If CloudKit isn't set up (no iCloud account, simulator, missing container), the app falls back
to a local SwiftData store instead of crashing; the debug menu shows which store is in use.

---

## 2. How to test

**Core logic (fast, no simulator):**
```bash
cd Packages/ForkcastCore && swift test
```
On this side we ran it in a Linux Swift 5.10 toolchain (Docker): **53/53 tests pass**, and the planner
takes ~155 ms in release for the worst case (7 dinners, impossible budget, 20 swap iterations). Tests cover:
allergens never appearing across 100 seeds, diet/dislike/appliance filters, the time-relaxation rule,
variety rules, budget fitting, determinism, aggregation maths (shared onions → one line, "used Mon & Thu"),
packs/rounding, unit conversion + fractions, the caption parser on 5 samples, and full library validation
(every ingredient exists, converts, has prices; 6–10 steps; 250–950 kcal per serving; coverage counts).
`PublicAPITests` imports the package *without* `@testable`, so any access-level mistake the app would hit fails there first.

**Debug menu**: You tab → long-press the version text in the footer (DEBUG builds only).
- *Pro override*: unlock everything without StoreKit.
- *Show paywall*, *Generate next week*, *Show plan reveal toast*, *Ask for weekly feedback again*,
  *Reset onboarding*, *Trial reminder in ~1 minute*, and which persistence store is active.
- Or set `FeatureFlags.bypassPaywall = true` in `Forkcast/App/FeatureFlags.swift` (DEBUG only).

**Paywall / trial (StoreKit config):**
- Products: `com.forkcast.app.pro.yearly` ($39.99/yr, 3-day free trial) and `com.forkcast.app.pro.monthly` ($9.99/mo), group "Forkcast Pro".
- After onboarding you land on the Plan tab in *preview* mode. Tapping a meal, swap, grocery card, Edit week,
  Regenerate, or the Groceries/Recipes tabs opens the paywall (reminder screen → plans).
- Speed up time: Debug → StoreKit → Manage Transactions, or Editor → Subscription Renewal Rate in the `.storekit` file.
- Starting the trial schedules a local notification `trialReminderDaysBefore` days before it ends
  (with sandbox time it fires about a minute later instead of never).

**Widget**: run the app once (it writes `widget-snapshot.json` to the App Group whenever the plan changes),
then add "Tonight's dinner" (small/medium). Tap → `forkcast://recipe/<id>`.

**Share Extension**: in Safari or TikTok, Share → Forkcast (may be under "More"). It saves
`pending-import.json` to the App Group and tries to open `forkcast://import`. Next time Forkcast becomes
active it opens the import screen pre-filled.
- TikTok links: the caption comes from the public oEmbed endpoint (`https://www.tiktok.com/oembed?url=…`).
- Instagram links: captions can't be read, so the user is asked to paste the caption.

**Foundation Models**: only on an iOS 26 device with Apple Intelligence enabled, built with Xcode 26.
Older SDKs compile the code out (`#if canImport(FoundationModels)`) and the heuristic parser is used.

**Deep links**: `forkcast://recipe/<id>`, `forkcast://import`, `forkcast://plan`, `forkcast://groceries`.

**Motion (rossark-motion-skill)**: installed in `.agents/skills/rossark-motion-skill` (pinned in
`skills-lock.json`; `.claude/skills` links to it so Claude Code finds it). Demo videos are not committed; reinstall with
`npx skills@latest add rossark0/rossark-motion-skill` if you want them. Project rules: `Forkcast/Theme/Motion/MOTION.md`.
- `MascotView` runs one 12 s `LoopClock` per mascot: breathing with volume kept, sway and tilt around the feet,
  weight drift; `.cheer` adds a hop (crouch → stretch → gravity fall → squash → settle) with a floor shadow that
  shrinks in the air and saffron sparkles in one `Canvas`; `.thinking` holds a slow tilt one way, then the other.
- Bars and rings draw on once with ease-out (macro bars staggered 60 ms); money counts up with ease-out.
- Check with **Reduce Motion on**: mascots sit still on a neutral frame, bars and numbers show final values.
- `CLAUDE.md` holds the standing instructions for Claude Code sessions (plan first, image prompts for Grok, motion skill).

---

## 3. Assumptions and decisions

- **Toolchain**: no Mac here, so the SwiftUI app has **never been compiled**. `ForkcastCore` was built and
  tested with Swift 5.10 on Linux. The app sources went through a manual review plus scripted checks
  (no undefined or duplicate types, every service member referenced exists, every memberwise-init call
  uses labels in declaration order, every core API used by the app is public).
- **Swift 5 language mode** with `SWIFT_STRICT_CONCURRENCY: minimal`, as requested.
- **Bundled JSON lives in the package** (`ForkcastCore/Resources`, loaded with `Bundle.module`), so the tests and the
  app share one copy. `Tools/generate_data.py` regenerates it from the Python tables; the JSON is the source of truth.
- **Diet, allergens and macros are always computed** from ingredients (`RecipeClassifier`, `NutritionCalculator`).
  Hidden sources are encoded on ingredients: soy sauce → gluten, pesto → tree nuts + dairy, Worcestershire → fish,
  UK-style sausages → gluten, Thai curry paste → shellfish (so Thai red curries count as pescatarian), honey → not vegan,
  kimchi → fish.
- **Slow-cooker recipes**: the time limit uses hands-on time (prep + 10 min), otherwise they'd never pass a weeknight limit.
- **Time limit**: "15–20 / 20–30 / 30–45 / don't mind" stores 20 / 30 / 45 / no limit, and recipes up to limit + 10 min qualify.
  It's the only rule ever relaxed (when fewer than `days × 2` recipes remain).
- **Variety**: max 2 dinners per main protein and per cuisine. Relaxed only if nothing else fits; as a last resort a recipe may repeat rather than leave a night empty.
- **Week window**: a plan covers 7 days from the day it's built (not Monday–Sunday). "Next week" starts the day after it ends.
- **Costs**: grocery total = whole packs × pack price × store tier (budget 0.85, standard 1.0, premium 1.25)
  × country multiplier. Pantry staples cost a small amortised amount (8% of a pack, clamped to 0.05–0.60).
  Meal cards show each meal's *share* of the basket, so meal costs add up to the total. The "why is it cheaper"
  sheet compares that with the "bought each dinner on its own" total.
- **Canada and Australia** are priced from the US table × 1.37 / 1.52 with a note in the budget step.
  Their store lists are short (Walmart/Costco, Aldi) plus "My local store".
- **Savings moment**: implemented exactly as briefed: `max(5, portions/week × unplanned − budget) × 0.25`,
  capped at 40/week and rounded to 0.50. Unplanned cost per portion: US $9, UK £7, EU €7.50.
- **User recipes** are stored in SwiftData; `PlannedMeal.recipeId` holds `user:<uuid>` and the
  `userRecipe` relationship is also set. User recipes have no appliance requirements, so they pass the appliance filter.
- **Unlinked user ingredients** count towards allergen/diet filters via fuzzy matching against the catalog,
  carry no price, and show "no nutrition data".
- **Colours** exist both as named colour sets and as hex values in `Theme` (code uses `Theme`, so previews,
  widgets and extensions never depend on asset lookup). Asset-symbol generation is switched off to avoid name clashes.
- **Feedback**: tapping the active like / not-for-me again clears it. Stars only count above 3 (+1 each).
- **Light mode only**, portrait only, iPhone only.

---

## 4. TODO before launch

- [ ] **Real reviews**: `Testimonial.placeholders` in `Features/Onboarding/Steps/SocialProofStep.swift` are clearly
      marked placeholders. Replace them with genuine App Store reviews (or remove the carousel). Never invent reviews or user counts.
- [ ] **Artwork**: see `Design/IMAGE_REQUESTS.md` (mascot moods, clean app icon, 40 recipe photos, optional
      onboarding illustrations). Drop images into the asset catalog with the listed names; no code changes needed.
- [ ] **App icon**: `AppIcon-1024.png` was cropped from the provided mascot art with the dark border removed.
      A clean 1024×1024 export (opaque, cream to the edges, no rounded corners) would look better.
- [ ] **Full recipe library** (~200 recipes). Schema is in `Models/Recipe.swift`; add to `Tools/recipes_data.py`
      and run `python3 Tools/generate_data.py`. `LibraryValidationTests` will catch bad ids, units or macros.
- [ ] **Prices** in `prices.json` are rough 2026 estimates per pack (standard tier) and must be refined per market.
      Pack sizes use one metric pack with an imperial label (e.g. "500 g pack" / "1 lb pack").
- [ ] **Legal URLs**: `AppLinks.privacyPolicy`, `AppLinks.terms` and the support email `hello@forkcast.app` in `App/FeatureFlags.swift`.
- [ ] **"I have a code"** on the welcome screen does nothing yet (marked TODO).
- [ ] **Localisation**: all copy goes through `String(localized:)` / `Text("…")`. `Localizable.xcstrings` is empty and
      Xcode fills it on build. Some enum display names in `ForkcastCore` are plain English strings, so move them to the app layer or the package's catalog before translating.
- [ ] App Store Connect: create the two products and the "Forkcast Pro" group to match the `.storekit` file.

---

## 5. Likely compile hotspots (look here first)

1. **`Services/FoundationModelRecipeExtractor.swift`**: `@Generable` / `@Guide` on `@available(iOS 26.0, *)` structs.
   If the macro complains about availability, wrap the structs in an `@available` extension or delete the file
   (the heuristic parser still works).
2. **SwiftData models** (`Persistence/Models.swift`): relationship inverses declared on one side only;
   computed accessors (`cookingDays`, `vibes`, `steps`…) on `@Model` classes. `#Predicate<…>` captures in `LibraryStore`.
3. **Optional-chained writes through `private(set)` references**, e.g. `profileStore.profile?.trialReminderDaysBefore = 1`
   and `planStore.currentPlan?.feedbackGiven = false` (fine for classes, but check if the compiler disagrees).
4. **Main-actor isolation**: `@State private var state = OnboardingState()` and `@State var services = AppServices()`
   create `@MainActor` objects in property initialisers. Swift 5 mode should only warn.
5. **`Features/Plan/EditWeekSheet.swift`**: `ForEach(Array(rows.enumerated()), id: \.element.id)` with `.onMove`.
6. **Big view bodies** that may hit "unable to type-check in reasonable time": `PlanView`, `RecipeDetailContent`,
   `PaywallView`, `CreateRecipeView`. They're already split into subviews; split further if needed.
7. **`Theme/Components/MoneyText.swift`**: count-up via an `Animatable` `ViewModifier`.
8. **`Forkcast.storekit`** was hand-written (format version 3). If Xcode rejects it, recreate it in Xcode with the
   two products listed above. Takes 2 minutes.
9. **`SubscriptionManager`**: `transaction.offerType` is deprecated in iOS 17.2 (warning only). Introductory-offer
   eligibility is checked on the yearly product.
10. **Share Extension** opening the host app uses the responder chain (`openURL:`). iOS 18 may ignore it; the user
    then sees "open the app to finish", and the import is picked up when the app becomes active.
11. **`project.yml`**: XcodeGen generates the Info.plists and entitlements. If a key isn't applied, check the
    `info:` / `entitlements:` blocks; `CODE_SIGN_ENTITLEMENTS` is set explicitly for every target.
12. **`Theme/Components/MascotView.swift`**: the `Canvas` sparkle field (`context.resolve(Image(systemName:))`,
    `shading = .color(...)`) and `LoopClock` from `Theme/Motion/Motion.swift`. If `Animation.open(_:)` clashes
    with anything, rename it in `Motion.swift` (it's only used in `ProgressBar` and `MoneyText`).
13. **SF Symbols**: all are iOS 16/17 symbols (`frying.pan`, `figure.2.and.child.holdinghands`, `oven`, `microwave`, `fan`…).
    Swap any that show as missing.
