# Forkcast — build notes

## Identifiers (renamed to Tommo, Nov 2026)

Bundle ID `com.tomasbeja.tommo` (widget `.widget`, share extension `.share`), App Group `group.com.tomasbeja.tommo`,
iCloud container `iCloud.com.tomasbeja.tommo`, products `com.tomasbeja.tommo.pro.yearly` / `.monthly` in group
"Tommo Pro". Home-screen name "Tommo"; App Store name "Tommo: Meal Planner" (set in App Store Connect).
Target, folder and package names (`Forkcast`, `ForkcastCore`), the SwiftData store name and the `forkcast://` URL
scheme are intentionally unchanged.

Native SwiftUI weekly meal planner for iPhone (iOS 17+). No backend, no third-party packages.

```
project.yml                  XcodeGen spec (app, widget, share extension, StoreKit scheme)
Packages/ForkcastCore/       Pure-Foundation logic + bundled JSON + 53 unit tests
Forkcast/                    The app (App, Theme, Features, Services, Persistence, Resources)
ForkcastWidget/              "Tonight's dinner" widget (reads an App Group JSON snapshot)
ForkcastShare/               Share Extension for TikTok / Instagram / text imports
Design/                      Mascot source art + IMAGE_REQUESTS.md (art still to make)
Tools/                       Catalog and marketing generators
```

Run `python3 Tools/generate_slideshows.py` to export the slideshow scripts and photo prompts into the ignored `Marketing/` directory.

---

## 1. First run on the Mac

**Quick start:** from the repo folder run `./setup-mac.sh`. It installs XcodeGen with Homebrew if needed,
generates `Forkcast.xcodeproj` and opens it. Then do step 3 (Team) below and press Run.
Run it again after pulling changes that add or remove files or touch `project.yml`, because the
`.xcodeproj` is generated and not committed (it's in `.gitignore`).

Step by step:

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
   - the App Group (`group.com.tomasbeja.tommo`) and iCloud container (`iCloud.com.tomasbeja.tommo`) in `project.yml` entitlements, **and**
   - `SharedConstants.appGroupId` / `cloudKitContainerId` in `Packages/ForkcastCore/Sources/ForkcastCore/Shared/SharedConstants.swift`.
5. Capabilities (already declared in the generated entitlements; Xcode just needs to provision them):
   - **iCloud** → CloudKit, container `iCloud.com.tomasbeja.tommo` (create it in the developer portal if Xcode doesn't).
   - **Push Notifications** (`aps-environment`, used by CloudKit sync) + Background Modes → Remote notifications.
   - **App Groups** → `group.com.tomasbeja.tommo` on the app, widget **and** share extension.
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
- Products: `com.tomasbeja.tommo.pro.yearly` ($39.99/yr, 3-day free trial) and `com.tomasbeja.tommo.pro.monthly` ($9.99/mo), group "Tommo Pro".
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
- **Several shops**: users can pick as many shops as they like. The first one picked is the *main shop*
  (`UserProfile.storeId`) and sets the price tier; the others live in `extraStoreIdsRaw`. Headers read
  "Tesco & Lidl" or "Tesco +2". Per-shop pricing or splitting the list by shop is a later feature.
- **Store logos**: tiles show `store-<id>` from the asset catalog if present (only with permission), else the monogram.
- **Light mode only**, portrait only, iPhone only.

---

## 3b. Onboarding (Nov 2026 rebuild)

Order: splash → welcome → goals → obstacles → mirror → household → cooking days → eating style →
nutrition → dislikes → vibe → kitchen → shops → budget → pantry → savings example → catalog preview →
reminders → subscriptions → build week → plan reveal → Sign in with Apple → welcome home.
Code: `Features/Onboarding/` (`OnboardingFlow.swift` drives it, `OnboardingStep` holds the order).

- **Answers**: the planner fields stay on `UserProfile`; everything else is `OnboardingAnswers` (Codable), stored as
  JSON in `UserProfile.onboardingAnswersJSON`. `ProfileStore.plannerProfile` merges both.
- **Planner effects**: "High-protein" / "Lighter meals" add the matching vibe, "Mediterranean" adds a cuisine bonus,
  Meal prep mode favours leftover-friendly dinners, pantry items are left off the **first** week's list and total.
- **Country** comes from the phone's region (falls back to the US) and can be changed on the shops screen.
- **Subscriptions** use StoreKit pricing and trial eligibility. Existing subscribers skip this step, and other users can continue without a subscription.
- **Debug**: You tab → long-press the version → *Reset onboarding*. The splash plays once per app launch.

**What to check in the Simulator** (iPhone 16 and iPhone SE 3rd gen):
1. Cold launch: cream launch screen with Chef Tommo, no white flash; the splash pops, then hands off to Welcome. Tap during the splash skips it.
2. Every question screen: tile tick and bounce, light haptic, "Continue · N selected", Skip on obstacles / dislikes / pantry.
3. Mirror: the sentence types in and echoes your picks; Continue works straight away.
4. 0 kids vs 2 kids (portion line, checklist row "Matching 2 adults + 2 kids").
5. No allergies (preselected) vs peanuts + gluten (the "No allergies" chip clears, checklist "Avoiding peanuts…").
6. Budget at the minimum and the maximum: corner mascot switches thinking / idle / cheer, verdict card updates.
7. Pantry: tick 3 items, then check the first week's grocery list shows them under "check you have" at no cost.
8. Savings and plan reveal: the hypothetical annual savings count up. The generated plan shows day cards and estimated costs.
9. Reminders and subscriptions: check the system permission prompt, the current StoreKit offer, and "Continue without a subscription".
10. Settings → Accessibility → Motion → **Reduce Motion ON**: no splash burst (cross-fade), no confetti, no shake or bounce, numbers show final values.
11. iPhone SE: nothing clipped on the store, pantry and reveal screens; the welcome headline fits.

## 3c. Breakfast, lunch and snacks (Nov 2026)

- **Meal types**: `MealType` (breakfast, lunch, dinner, snack) lives in ForkcastCore. Recipes, plan slots, planned meals
  (`PlannedMeal.mealTypeRaw`), user recipes and the profile (`UserProfile.mealTypesRaw`, default "dinner") all carry it.
  Anything saved before this change counts as dinner.
- **Planning**: every chosen meal is planned on every cooking day. Each slot only takes recipes of its own type; lunches and
  dinners follow the variety rules; a breakfast or snack may repeat once a week. Swaps and "add a meal" stay in type.
- **Budget**: one budget covers all meals. Suggestions and verdicts count breakfast as 0.35 of a dinner, lunch 0.6,
  snack 0.2 (`MealType.budgetWeight`). With dinners only, nothing changes.
- **Recipes**: 12 breakfasts, 12 lunches and 8 snacks in `Tools/meal_recipes.py` (8 new ingredients with prices in
  `Tools/ingredients_data.py`). Regenerate with `python3 Tools/generate_data.py`. Library tests check calories and step
  counts per meal type, and diet/allergy coverage for each type.
- **Plan tab**: dinners only looks exactly as before. With more meals, each day gets a heading and a card (or "add" row)
  per meal. Edit week edits one meal type at a time and never touches the others. The widget still shows the dinner.
- **Where to change it**: onboarding "Your week", and You tab → Meals. Your own recipes get a Meal picker.

**Check on the Mac**: `cd Packages/ForkcastCore && swift test` (new planner and library tests), then in the app: pick
Breakfast + Dinner in onboarding, check the budget suggestion rises, the plan shows both per day, swapping a breakfast only
offers breakfasts, Edit week's Breakfast tab saves without touching dinners, and the widget shows the dinner.

## 3d. On-device recipe tailoring

`RecipeTraits` derives recipe effort, everyday appeal, family fit, nutrition, cost, freshness and batch suitability
from the catalog. The planner caches classifications and traits by recipe value and pricing context. Cost bands
use the region's meal-size reference price. Cheap means below 65% of that reference and treat means above 110%.
The basket uses whole packs, the main shop's price tier and the first week's pantry answers.

`TailoringWeights` maps onboarding answers to soft points. Matching signals on the same row use the strongest value.

| Signal | Default weights | Onboarding adjustment |
| --- | --- | --- |
| Everyday effort and one-pan | 2.0 everyday, 1.2 effort, 0.25 one-pan | Save time, planning takes too long or too tired raises them to 4.0, 4.0 and 1.2. The planner prefers meals within the stated time Monday through Thursday. |
| Confidence cooking | 2.0 everyday, 0.65 novelty | Stop wondering, don’t know what to cook or cook more raises them to 3.0 and 1.2. |
| Cost and sharing | 1.15 cheapness, 0.9 reuse | Spend less or overspend raises them to 4.0 and 2.3. Shopping without a list raises reuse to 2.3. The planner compares incremental pack cost against a meal-weighted budget from the first slot. |
| Family | 0 | Feed my family adds 4.0. Children raise it to 7.0. Mild recipes get first preference when available. |
| Nutrition | 0.55 health, 0 protein | Eat healthier or lighter raises health to 2.8. High protein adds 5.0, scaled to 30 g per dinner-equivalent. Mediterranean still prefers its cuisine. |
| Perishable ingredients | 0.7 fresh timing, 0.9 reuse | Food goes off raises them to 4.0 and 7.0. Fresh ingredients influence early slots and the planner rewards using the unspent part of a pack. |
| Rotation and saved recipes | 0.65 novelty, 0.35 saved | Same meals every week raises novelty to 2.0. Saved recipes are a mess raises the saved bonus to 1.1. |
| Batch cooking | Off | Meal prep or too tired enables one batch pair when a suitable recipe and consecutive dinner slots are available. Both portions count toward shopping once for that cook. |

Monday through Thursday get a larger effort penalty. The planner uses the existing hard filters and time relaxation rules,
and applies variety limits to distinct cooks. Leftovers stay within the next day. The first dinner in a batch opens with
both portions selected in recipe detail. Moving, removing or swapping either meal clears the pairing. Plan explanations
are typed data stored with drafts and planned meals.

`RecipeBehavior` stores dated cook, plan, swap, save and feedback observations in the existing SwiftData store. On the
first planning request after a week ends, unfinished meals in that week are recorded once. The core ignores exposures
when calculating affinity, halves evidence every four weeks, caps evidence per recipe, and bounds the contribution of
each affinity. Explicit likes, exclusions and stars have higher weights than cooking and swaps. Learning can nominate
one unfamiliar recipe close to positive feedback. The latest explicit exclusion remains a hard rule.

On Linux run `swift test` in `Packages/ForkcastCore` with the documented Swift 5.10 toolchain.
On a Mac, run `xcodegen generate` and use the iPhone Simulator to verify a tired-parent week, scaled batch ingredient
quantities and both meals' grocery allocations. Swap or move a batch meal and verify the pair clears. Mark a cook,
undo it, rate a meal, save a recipe and generate a fresh week. Open a copy of a pre-change SwiftData store and verify
its plans and feedback still appear. Deploy the updated CloudKit schema before testing the new records in production.

---

## 4. TODO before launch

- [ ] **Real reviews**: the social-proof screen was removed from onboarding (Nov 2026). Only bring it back with
      genuine App Store reviews. Never invent reviews, ratings or user counts.
- [x] **Artwork**: mascot moods, recipe photos and onboarding illustrations are in the asset catalog.
      Still open (see `Design/IMAGE_REQUESTS.md`): the optional `MascotRig` layers and a clean app icon.
- [ ] **App icon**: `AppIcon-1024.png` was cropped from the provided mascot art with the dark border removed.
      A clean 1024×1024 export (opaque, cream to the edges, no rounded corners) would look better.
- [ ] **Full recipe library** (~200 recipes). Schema is in `Models/Recipe.swift`; add to `Tools/recipes_data.py`
      and run `python3 Tools/generate_data.py`. `LibraryValidationTests` will catch bad ids, units or macros.
- [ ] **Prices** in `prices.json` are rough 2026 estimates per pack (standard tier) and must be refined per market.
      Pack sizes use one metric pack with an imperial label (e.g. "500 g pack" / "1 lb pack").
- [ ] **Legal URLs**: `AppLinks.privacyPolicy`, `AppLinks.terms` and the support email `hello@forkcast.app` in `App/FeatureFlags.swift`.
- [ ] **Accounts beyond Apple**: "Sign in", Google, Email and "Join with a household code" are hidden until there's a
      backend. The welcome screen has one button; "Save your plan" offers Sign in with Apple only.
- [ ] **More breakfasts, lunches and snacks**: 32 to start; aim for 25+ breakfasts and lunches so weeks don't repeat.
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

### Welcome phone artwork

The Welcome screen uses the asset name `WelcomePlanScreenshot` for its native SwiftUI phone frame. Capture the real Forkcast Plan screen in the iOS Simulator with demo data and no personal details, then add the captured portrait image to `Forkcast/Resources/Assets.xcassets/WelcomePlanScreenshot.imageset`. The existing Chef Tommo composition appears until that image is present. Preview on compact and tall iPhones with Reduce Motion enabled and disabled.
