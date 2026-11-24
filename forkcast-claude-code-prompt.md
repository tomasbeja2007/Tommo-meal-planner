# Build "Forkcast": a native SwiftUI weekly meal planner for iPhone

You are building a complete, production-quality iOS app in Swift/SwiftUI from scratch. Read this whole document before writing any code. Every decision you need is in here. **Do not ask me questions.** If something is unclear, make the most sensible choice, write it down in `BUILD_NOTES.md`, and keep going. Plan to work for a long stretch and finish the whole thing.

---

## 0. Critical context: you cannot compile this

- I am on a **Windows laptop**. There is no Xcode, no simulator and no Mac here. You can write Swift but you **cannot build or run the iOS app**.
- My co-founder will open the project on a Mac, build it in Xcode, test it, and fix bugs. Your goal is that **it compiles on the first try, or very close to it**.
- So write **conservative, boringly correct Swift**:
  - **No third-party packages.** Apple frameworks only: SwiftUI, SwiftData, StoreKit 2, WidgetKit, AuthenticationServices, UserNotifications, FoundationModels (gated).
  - Annotate types explicitly wherever inference could be ambiguous. Avoid deeply nested generic view builders. Split large views into small subviews, because huge SwiftUI bodies cause "compiler is unable to type-check this expression in reasonable time" errors.
  - Use only APIs available on **iOS 17**. Anything newer must sit behind `if #available(iOS 26, *)` and/or `#if canImport(FoundationModels)`.
  - Make sure every type you reference exists, every file is included in a target, and every asset or JSON name you load matches a real file name exactly.
  - After writing everything, **do a full self-review pass** looking for compile errors: missing imports, wrong initializers, mismatched optionals, `@MainActor` problems, Sendable warnings that would be errors, and missing `Hashable`/`Identifiable` conformances. Fix what you find.
- **Xcode project:** I can't create a `.xcodeproj` on Windows. Use **XcodeGen**: write a complete `project.yml` with all targets, entitlements, Info.plist keys, capabilities, the app group, and the StoreKit config. My co-founder will run `brew install xcodegen && xcodegen generate`. Do not hand-write a `.pbxproj`.
- **Testable core:** put all pure logic in a local Swift package, `ForkcastCore`, that imports only Foundation (no SwiftUI or UIKit). That covers models-as-structs, the planner algorithm, grocery aggregation, macro and price calculation, unit conversion, recipe text parsing heuristics, and JSON loading. Add unit tests with XCTest. If a `swift` toolchain happens to be installed on this machine (`swift --version`), run `swift build` and `swift test` on the package and fix failures. If it isn't, skip this step and say so in `BUILD_NOTES.md`.
- Initialise git and **commit after each phase** (section 13) with clear messages.

---

## 1. The product in one paragraph

Forkcast plans your **week of dinners around your supermarket and your budget**. A friendly onboarding quiz covers your store, budget, household, cooking days, food "vibe", diet, allergies, dislikes and kitchen appliances. Then Forkcast builds a costed week of dinners, shows the total against your budget, and gives you one consolidated grocery list grouped by aisle. Every recipe has subtle macros and a step-by-step cook mode. You can swap meals, regenerate the week, import recipes from TikTok/Instagram, and create your own recipes. Monetisation: a 3-day free trial, then a subscription.

**Positioning:** warm, food-first, friendly, fast. Fewer features, done really well. The whole app is built around one loop: **plan → shop → cook → rate → better next week**.

---

## 2. Reference screens (study them, do not copy them)

The folder `reference-screens/` contains about 200 screenshots of four competitor apps (mise, NeatEat, Herbi, Potto). Use them **only** to understand the category's flows, information hierarchy and patterns: what a quiz step contains, what a grocery list row needs, how a paywall is structured.

**Do not copy** their layouts pixel for pixel, their copywriting, their illustrations, their colours, their brand names or their reviews. Forkcast has its own visual identity (section 4) and its own voice. Where a reference app does something well, build **our own version** of the idea. Ideas worth borrowing:
- mise's **trial-reminder screen** before the paywall.
- mise's **savings framing**.
- Herbi's **"used Mon & Thu"** note on grocery items.
- Herbi's **"why is the list cheaper than the meals added up?"** explainer.
- Herbi's **like / not for me** buttons and **weekly "how was this week?"** rating.
- NeatEat's **servings stepper**.
- mise's and NeatEat's **step-by-step cook mode**.

---

## 3. Hard constraints and decisions (already made, don't revisit)

| Topic | Decision |
|---|---|
| Platform | iPhone only, portrait only, **iOS 17.0 minimum**, SwiftUI, Swift 5.10+ (compatible with the Swift 6 language mode where easy; use Swift 5 mode in the project settings to avoid strict-concurrency errors) |
| Architecture | MVVM-ish with `@Observable` view models, SwiftData persistence, plus the `ForkcastCore` package for pure logic |
| Backend | **None.** No servers, no API keys, no analytics SDKs. Sync via **iCloud (CloudKit) through SwiftData** |
| AI | **No cloud AI.** The plan is built by a deterministic on-device algorithm. Recipe import uses Apple's on-device **Foundation Models** framework when available (iOS 26+, Apple Intelligence devices), otherwise heuristic parsing plus a pre-filled editable form |
| Recipes | Bundled JSON library shipped in the app (you write the v1 starter set, see section 8) |
| Nutrition | Bundled ingredient database with approximate per-100 g macros (based on USDA FoodData Central values). Recipe macros are **computed** from ingredients |
| Prices | Bundled approximate price table per ingredient × region × store tier. Always labelled "approx." |
| Markets | Multi-country from day one. **US first in every list**, then UK, then EU countries |
| Units | Imperial (US) or metric (everyone else), chosen automatically from the selected country, with an override in Settings |
| Photos | **No food photos in v1.** Build a beautiful generated "dish tile" placeholder system (section 4.5) and an optional `imageName` field so real photos can drop in later |
| Language | English only, but put every user-facing string through `String(localized:)` / a `Localizable.xcstrings` so translation is easy later |
| Appearance | **Light mode only** for v1 (force `.preferredColorScheme(.light)`) |
| Accounts | No account required. **Sign in with Apple is optional**, in Settings only. Never block the user with an account wall |
| Monetisation | StoreKit 2. Yearly **$39.99** with a **3-day free trial**, Monthly **$9.99**. Paywall appears **after the user sees their first plan** (section 7) |
| Extras | Home Screen **widget** ("Tonight's dinner"), and a **Share Extension** for recipe import |

App name: **Forkcast**. Bundle ID placeholder: `com.forkcast.app` (put it in one place in `project.yml` so it's easy to change). App Group: `group.com.forkcast.app`. CloudKit container: `iCloud.com.forkcast.app`.

---

## 4. Visual identity: "warm kitchen, food first"

### 4.1 Palette (create these as named Color assets *and* a `Theme` Swift namespace)

| Token | Hex | Use |
|---|---|---|
| `cream` | `#FBF6EE` | App background |
| `card` | `#FFFFFF` | Cards, sheets |
| `creamDeep` | `#F3E9DA` | Secondary fills, chips at rest, progress-bar tracks |
| `tomato` | `#E8553D` | Primary actions, brand moments, selected states |
| `tomatoDeep` | `#C9402B` | Pressed state, text on light-tomato fills |
| `tomatoSoft` | `#FBE3DC` | Selected-chip background, subtle highlights |
| `aubergine` | `#2B1E2E` | Primary text |
| `aubergineMuted` | `#6E5F6B` | Secondary text |
| `aubergineFaint` | `#A89BA5` | Tertiary text, placeholders, macros line |
| `saffron` | `#F2B544` | Accent: savings, stars, celebration, "best value" |
| `saffronSoft` | `#FCEFD3` | Accent backgrounds |
| `herb` | `#5B8C5A` | **Only** for checkmarks, "under budget" and success. Never as a brand colour |
| `herbSoft` | `#E3EEDF` | Success backgrounds |
| `line` | `#EADFCF` | Hairline borders and dividers |

Do not use green as a primary or brand colour anywhere. The competitors are all green, and we are deliberately not.

### 4.2 Typography
- **SF Pro Rounded** throughout (`.fontDesign(.rounded)` applied at the root).
- Large titles: `.largeTitle`/`.title` bold rounded, aubergine. Quiz questions: 30 pt bold, tight leading, left-aligned.
- Body: `.body` regular. Secondary info: `.subheadline` in `aubergineMuted`.
- Numbers (prices, budget, macros): `.monospacedDigit()` so they don't jiggle when animating.
- Support **Dynamic Type** everywhere. No fixed-height text containers.

### 4.3 Shape, depth, motion
- Corner radius: 20 for cards, 16 for buttons and inputs, capsule for chips.
- Depth: soft single shadow (`black` at 6% opacity, radius 12, y 4) on cards only. No borders on cards; a 1 pt `line` border on unselected option tiles.
- Primary button: full-width, 56 pt tall, tomato fill, white bold rounded text, 16 radius. It scales to 0.97 on press with a light haptic. A disabled-looking state is a 40% opacity tomato.
- Selection: option tiles animate their border to tomato, background to `tomatoSoft`, and show a small tomato checkmark badge, with `.sensoryFeedback(.selection, …)`.
- Motion: springy but quick (`.spring(response: 0.35, dampingFraction: 0.8)`). Count-up animation on money numbers. Use `.contentTransition(.numericText())` for changing numbers. Respect **Reduce Motion**.
- Haptics: selection on chip taps, success on plan generated, trial started, and all groceries checked.

### 4.4 Mascot: "Chef Tomato"
- I'm providing the mascot artwork at `Design/mascot-tomato-chef.png`. It's a 3D tomato with a chef hat and a wooden spoon, on a cream rounded square. Add it to the asset catalog as `Mascot`.
- Also use it as the **App Icon** source (an `AppIcon` set with a single 1024×1024 image). Add a note in `BUILD_NOTES.md` that my co-founder may need a clean 1024×1024 export without the dark outer border.
- Wrap all mascot usage in a single `MascotView(size:mood:)` component. The mascot may later be swapped for a fork character, so **no screen may reference the image directly**. Everything goes through `MascotView`. Moods are subtle effects on the same image: `.idle` (gentle breathing scale), `.cheer` (small bounce plus a sparkle burst made with SF Symbols in saffron), `.thinking` (slow wobble).
- Where the mascot appears: the welcome screen, the "building your week" loader, the plan reveal celebration, empty states (no saved recipes, empty grocery list), the trial reminder screen, and the weekly feedback sheet. **Not** on every screen. Keep it special.

### 4.5 Dish tiles (photo placeholder system)
There are no photos in v1, so build a `DishTileView(recipe:size:)` that looks intentional:
- A rounded rectangle filled with a warm colour chosen deterministically from the recipe ID, from a palette of 8 food-ish tones (tomato, saffron, paprika `#D9733B`, olive `#8A8F4A`, beetroot `#A8435E`, aubergine-light `#7A5C7E`, butter `#E9C46A`, cinnamon `#B5754C`), each at about 85% saturation.
- A large emoji centred on it (the recipe's `emoji` field, e.g. 🍝 🌮 🍛 🥘 🍲 🥗 🍜 🌯).
- A subtle diagonal pattern or soft radial highlight for texture.
- If `recipe.imageName` is set and that image exists in the asset catalog, show the image instead. This is how photos will be added later.

### 4.6 Voice and copy
Short, warm, plain, lowercase-friendly headlines are fine ("what's your weekly budget?"). Talk like a friend who cooks. No exclamation spam, no corporate words. Buttons are verbs: "Continue", "Build my week", "Start free trial". Every empty state invites an action.

---

## 5. Data model

### 5.1 Bundled reference data (JSON in the app bundle, decoded into `ForkcastCore` structs)
- `countries.json`: `id`, `name`, `flagEmoji`, `currencyCode`, `unitSystem` (`imperial`/`metric`), `regionPriceKey` (`US`, `UK`, `EU`). Order: **United States first**, then United Kingdom, Ireland, Portugal, Spain, France, Germany, Netherlands, Italy, Belgium, Austria, then Canada and Australia (both priced from the `US` table with a currency note; that's fine for v1).
- `stores.json`: `id`, `name`, `countryIds`, `tier` (`budget`/`standard`/`premium`), `brandColorHex` (used for a simple coloured monogram tile, **not** the real logo; we must not ship real retailer logos). US: Walmart, Kroger, Aldi, Target, Costco, Trader Joe's, Whole Foods, Publix, Safeway, H-E-B. UK: Tesco, Sainsbury's, Asda, Aldi, Lidl, Morrisons, Waitrose, M&S, Co-op. Portugal: Continente, Pingo Doce, Lidl, Aldi, Auchan, Mercadona, Intermarché. Spain: Mercadona, Carrefour, Lidl, Aldi, Dia. France: Carrefour, Leclerc, Auchan, Intermarché, Lidl, Aldi. Germany: Edeka, Rewe, Aldi, Lidl, Kaufland, Penny. Netherlands: Albert Heijn, Jumbo, Lidl, Aldi, Plus. Italy: Esselunga, Coop, Conad, Lidl, Carrefour. Other EU countries: Lidl, Aldi, Carrefour. Every country also has a final option, "My local store" (tier `standard`). In the store picker, show stores for the selected country, with a search field.
- `ingredients.json` (~150 common ingredients): `id`, `name`, `pluralName`, `aisle` (one of: Produce, Meat & Fish, Dairy & Eggs, Bakery, Pasta, Rice & Grains, Tins & Jars, Sauces & Condiments, Spices & Herbs, Oils & Vinegars, Frozen, Baking, Other), `allergens` (`gluten`, `dairy`, `egg`, `peanut`, `treeNut`, `soy`, `fish`, `shellfish`, `sesame`), `dietFlags` (`isMeat`, `isFish`, `isAnimalProduct`), `per100g` (`kcal`, `protein`, `carbs`, `fat`, `fiber`), `gramsPerUnit` (for "1 onion", "1 clove", "1 cup", "1 tbsp" conversions, where relevant), `pack` (`amount`, `unit`, and a display string like "1 lb bag" / "500 g bag"), `isPantryStaple` (salt, pepper, oil, common spices; shown in a collapsed "you probably have these" section and counted in the cost only once per week, at a small amortised amount), `emoji`.
- `prices.json`: for each ingredient, price per pack for `US` (USD), `UK` (GBP) and `EU` (EUR), at the `standard` tier. Tier multipliers: `budget` ×0.85, `standard` ×1.0, `premium` ×1.25. Realistic 2026 approximate prices. Put a comment in `BUILD_NOTES.md` that prices are estimates to be refined.
- `recipes.json`: see section 8.

### 5.2 User data (SwiftData `@Model`, synced via CloudKit)
CloudKit-compatible SwiftData rules apply: **every stored property must be optional or have a default value, no `@Attribute(.unique)`, and every relationship must be optional with an inverse.** Respect these strictly, because the app will crash on launch with CloudKit if they're violated.
- `UserProfile` (a single instance): `name`, `countryId`, `storeId`, `unitSystemOverride`, `householdAdults`, `householdKids` (kids count as 0.5 portion), `cookingDays` (an array of weekday ints stored as a `String`/`Data` for CloudKit safety), `weeklyBudget` (Decimal stored as Double), `vibes` (up to 3), `diet` (`none`/`vegetarian`/`vegan`/`pescatarian`), `allergens` (set), `dislikedIngredientIds`, `appliances` (`oven`, `stovetop`, `microwave`, `airFryer`, `slowCooker`, `blender`), `maxCookMinutes` (from the time question), `goals`, `referralSource`, `onboardingCompletedAt`, `weeklyReminderEnabled`, `weeklyReminderWeekday`/`hour`, `trialReminderDaysBefore` (1 or 2), `appleUserId` (optional).
- `WeekPlan`: `weekStartDate`, `storeIdSnapshot`, `budgetSnapshot`, `createdAt`, `meals` (relationship to `PlannedMeal`), `feedbackGiven`.
- `PlannedMeal`: `date`, `recipeId` (bundled) **or** `userRecipe` (relationship), `servings`, `orderIndex`, `isCooked`, `cookedAt`.
- `GroceryCheck`: `weekPlan`, `ingredientKey`, `isChecked`. Also `ExtraGroceryItem`: `name`, `quantityText`, `isChecked`.
- `RecipeFeedback`: `recipeId`, `rating` (`like`/`notForMe`), `stars` (optional 1–5), `date`.
- `SavedRecipe`: `recipeId`, `savedAt`.
- `UserRecipe`: `title`, `emoji`, `servings`, `totalMinutes`, `tags`, `steps` (array encoded), `ingredients` (relationship to `UserRecipeIngredient`: `name`, `ingredientId?`, `amount`, `unit`), `macroOverride?` (kcal/protein/carbs/fat), `sourceURL?`, `sourceKind` (`manual`/`tiktok`/`instagram`/`pasted`), `createdAt`, `notes`.

A `RecipeRepository` merges bundled recipes and `UserRecipe`s behind one `RecipeLike` protocol/struct so the plan, recipe detail, swap and cook mode work identically for both.

---

## 6. Screens and flows

### 6.1 Onboarding (one `NavigationStack`, progress bar at the top, back chevron, ~16 steps)
Every question screen has: progress bar (tomato fill on a `creamDeep` track), a big left-aligned question, an optional one-line subtitle explaining *why we ask*, the options, and a pinned bottom primary button. Single-select screens may auto-advance after a 250 ms delay. Multi-select screens need "Continue". Save answers into a draft `OnboardingState` and write `UserProfile` only at the end.

1. **Welcome**: large mascot (`.idle`), "Forkcast", the tagline "dinners for the week, planned around your shop and your budget", a "Get started" button, and a small "I have a code" text button that does nothing yet (TODO).
2. **Name**: "what should we call you?", a text field with autofocus.
3. **Goal** (multi-select): Spend less on food · Stop wondering what's for dinner · Eat healthier · Save time · Cook more at home · Feed my family.
4. **Time**: "how long do you want to spend cooking on a weeknight?" 15–20 min · 20–30 min · 30–45 min · I don't mind. Sets `maxCookMinutes`.
5. **Country**: searchable list, US first, flag + currency badge. Picking it sets the unit system.
6. **Store**: grid of 2-column tiles with coloured monogram (initial letter on `brandColorHex`) and the store name, filtered to the country, with search. Subtitle: "we'll price your week for this shop".
7. **Household**: steppers for Adults (≥1) and Kids (half portions), with a live "X portions per meal" summary.
8. **Cooking days**: seven round day toggles (M T W T F S S, default Mon–Fri), live "5 dinners a week".
9. **Weekly budget**: a big animated currency number and a slider (range depends on region and household; US default $35–$250, step 5, sensible default = portions × days × $3.5). Below it, a live verdict card: **Tight** (saffron) / **Comfortable** (herb) / **Plenty of room** (herb), plus cost-per-serving.
10. **Vibe** (pick up to 3, colourful tiles with SF Symbols): Quick & easy · High protein · Comfort food · Healthy-ish · Family favourites · Fakeaway · Low calorie · One-pan · Batch-friendly.
11. **Diet** (single): No restrictions · Vegetarian · Vegan · Pescatarian.
12. **Allergies** (multi, "None" deselects the rest): Gluten · Dairy · Eggs · Peanuts · Tree nuts · Soy · Fish · Shellfish · Sesame. Subtitle: "we'll never include these, and that includes hidden sources." Allergens are a **hard filter**.
13. **Dislikes**: search field over `ingredients.json`, plus "Common picks" chips (mushrooms, olives, coriander/cilantro, aubergine/eggplant, blue cheese, tofu, prawns/shrimp, spicy food, pork, beef). Selected dislikes appear as removable chips.
14. **Appliances** (multi, at least 1): a 2×3 grid of illustrated tiles built with SF Symbols (oven, stovetop, microwave, air fryer, slow cooker, blender), with friendly labels.
15. **Savings moment**: mascot (`.cheer`) and a number that counts up. Compute it **honestly from their own inputs**: `estimatedWeeklySavings = max(5, portionsPerWeek × typicalTakeawayOrUnplannedCostPerPortion(region) − plannedCostPerPortion × portionsPerWeek) × 0.25` (cap it at a believable value), then show "planning ahead could save you about **$X a week**, that's about **$Y a year**". Add the footnote "estimate based on your answers". Never show a made-up claim.
16. **Social proof**: build a reusable `TestimonialCarousel` component, but **do not invent fake reviews or fake user counts.** Fill it with three clearly-marked placeholder cards (`"Placeholder: replace with a real App Store review before launch"`) and add a `// TODO: real reviews` note, plus a list item in `BUILD_NOTES.md`. The rest of the screen is fine to ship: the headline "built for busy weeknights" and three benefit rows (costed to your shop · one tidy list · recipes that fit your rules).
17. **Notifications primer**: a custom screen explaining "a Sunday nudge to plan your week, and a heads-up before your trial ends". "Continue" triggers the system permission prompt. "Not now" skips.
18. **Building your week**: full-screen loader. Mascot (`.thinking`) and three checklist rows that tick on one after another (~0.9 s each): "pricing ingredients at {Store}" → "matching your tastes and rules" → "writing your grocery list". Run the real planner during this time, so the plan is ready when the checks finish. Success haptic.
19. **Plan reveal**: lands directly on the real **Plan tab** in a *preview* state (section 7). Confetti-like sparkle burst plus the mascot `.cheer` toast: "your week is ready, {name}".

### 6.2 Main app: 4 tabs (custom-styled `TabView`, tomato tint)
**Plan** · **Groceries** · **Recipes** · **You**

#### Plan tab
- Header: "Hi {name}" small, then "this week" as the large title, with a store pill ("planned for Kroger").
- **Budget card**: approx. total `$71.40 / $85` with an animated progress bar (tomato if under budget, saffron if 90–100%, tomatoDeep if over), a status chip ("$13.60 under budget" in herb, or "over by $4.20"), and a small ⓘ button that opens the **"why is the list cheaper than the meals added up?"** explainer sheet (in our own words: shared ingredients and whole packs get used across several dinners).
- **Groceries shortcut card**: "Grocery list · 31 items · 0 checked", which opens the Groceries tab.
- **Day list**: one card per cooking day. Day label (e.g. "MON · 24 Nov"), `DishTileView`, recipe title (2 lines max), a row of meta (⏱ 30 min · 👥 3 · ~$9.20), up to two small vibe tags, and the **subtle macros line**: `520 kcal · 32g P · 45g C · 18g F`, in `.caption`, `aubergineFaint`, monospaced digits. **Macros are always present on meal cards but visually quiet.** A trailing swap icon button (arrow.triangle.2.circlepath). A cooked meal shows a herb check overlay and reduced opacity.
- Non-cooking days show a slim "no dinner planned · add one" row.
- Bottom actions: **"Edit week"** (secondary) and **"Regenerate"** (tomato outline, with confirmation: "keep the meals you've cooked or liked?" → regenerate the rest).
- **Swap sheet** (from the swap button or the recipe detail): title "swap Tuesday's dinner". Section "suggestions": the top 3 alternatives from the planner that fit all rules, each showing the cost change (`+$1.20` / `−$0.80`) and the macros line. Section "from your saved recipes". Tapping one swaps it with a spring animation and updates the budget and groceries.
- **Edit week** (full-screen sheet): reorderable list (`.onMove`) to move dinners between days, remove a dinner (the slot becomes "add a meal"), "add a meal" (opens a recipe picker with search plus Saved / My recipes / All filters, showing only recipes that pass the user's hard filters), and a servings stepper per meal. "Save changes".
- **Weekly feedback sheet**: the first time the app opens on or after the plan's last cooking day (or from a "how was this week?" card at the top of the Plan tab), show each dinner with ♥ like / 👎 not for me, plus "Skip" and "Save & plan next week". Feedback feeds the planner.

#### Recipe detail (pushed from anywhere)
- Hero `DishTileView` (tall), back button, ♡ save toggle, share button (`ShareLink` with the recipe as formatted text).
- Title, meta row (time, servings, approx. cost per serving), vibe tags.
- **Macros card**: a compact, quiet card. Big kcal per serving, then three slim proportional bars (protein, carbs and fat in muted tomato / saffron / aubergine-light), with grams. Caption: "per serving · estimated". Not a giant dashboard.
- **Servings stepper**, which scales the ingredient amounts live (nice fractions: ½, ⅓, ¼, and so on; unit-aware display).
- Segmented control: **Ingredients | Method**.
  - Ingredients: emoji + name + amount. Pantry staples sit at the bottom in a "you probably have these" group. "Add to grocery list" (to Extras) if the recipe isn't in this week's plan.
  - Method: numbered steps, with timers detected from text ("for 20 minutes") as tappable chips that start a simple in-app countdown. A **"Cook step by step"** button.
- Footer actions: **Like / Not for me** (two pill buttons), **Mark as cooked** with an optional 1–5 stars, and **Swap this meal** if it's in the plan, or **Add to plan** (pick a day) if it isn't.
- For `UserRecipe`: an "Edit" button in the toolbar opening the Create/Edit screen.

#### Cook mode (full-screen cover)
- "STEP 2 OF 6" header with segmented progress, a huge readable step text (`.title2`), the ingredients used in this step as small chips (match ingredient names in the step text), and a timer chip if one was detected. Swipe or tap to advance, close button. Keep the screen awake (`UIApplication.shared.isIdleTimerDisabled`). The final screen shows the mascot `.cheer`, "enjoy!", and "Mark as cooked".

#### Groceries tab
- Header: "Grocery list", "for {Store} · 21–27 Nov", total `~$71.40`, and a progress ring "12 / 31".
- Sort toggle: **Aisle** (default) | **A–Z**.
- Sections by aisle (in a sensible walking order: Produce first, Frozen last). Each row: checkbox (tomato check with an herb fill when done), emoji, name, **quantity to buy in packs** ("2 × 400 g tin") with the needed amount underneath in faint text ("you need 1.5 tins"), and **"used Mon & Thu"** in `aubergineFaint`. Checked rows get a strikethrough and move to the bottom of their section with animation.
- "Pantry staples" collapsed section at the end ("you probably have these").
- "Extras" section at the top: user-added items, with a "+ Add item" row (name + optional quantity).
- Toolbar: **Share** (`ShareLink`, plain text grouped by aisle with checkboxes as "☐") and an "Uncheck all" menu item.
- When everything is checked: success haptic and a small mascot toast, "shop done!".
- The list is **derived** from the current `WeekPlan` via `GroceryAggregator` (section 9.2), and only the check states are persisted.

#### Recipes tab
- Segmented control: **Discover | Saved | My recipes**.
- Discover: search bar, a "Your vibes" horizontal carousel (recipes matching their vibes), "Quick (under 25 min)", and "Browse by cuisine" grid. **Only show recipes that pass the user's hard filters**, with a caption "only showing recipes that fit your diet and allergies".
- Saved: grid of saved recipes, plus an empty state with the mascot.
- My recipes: list of `UserRecipe`s, plus two prominent buttons: **"Create a recipe"** and **"Import from TikTok / Instagram"**. Empty state: mascot and the three-step instructions for importing via the Share button.

#### Create / Edit recipe (full-screen sheet)
- Emoji picker (a curated grid of about 40 food emoji), title, servings stepper, total time (minutes stepper or wheel), tags (multi-select chips: the vibe tags + vegetarian/vegan/gluten-free/dairy-free).
- **Ingredients**: rows of `amount` (decimal or fraction text), `unit` (menu: g, kg, ml, l, tsp, tbsp, cup, oz, lb, piece, clove, pinch, to taste) and `name`. Typing the name shows inline suggestions from `ingredients.json`; picking one links `ingredientId`, which enables **automatic macros and price**. Unlinked ingredients still save, and get a small "no nutrition data" note. "+ Add ingredient".
- **Method**: numbered step rows, "+ Add step", reorderable, deletable.
- **Nutrition (per serving)**: auto-calculated live from linked ingredients, shown in the same quiet macros card with the label "estimated from ingredients". An "Edit manually" toggle reveals kcal/protein/carbs/fat fields (`macroOverride`).
- Notes, and an optional source link.
- "Save to My recipes". Validation: the title and at least one ingredient are required, with inline errors.
- User recipes are eligible for the planner (Edit week → add) and for swaps, and the planner may include them if the user turns on "include my recipes in auto-plans" in You → Preferences (default on).

#### Import from TikTok / Instagram
- **Share Extension** target `ForkcastShare`, accepting URLs and plain text. It writes the payload to the App Group container (`pending-import.json`) and shows a tiny branded confirmation ("sent to Forkcast, open the app to finish"). It opens the main app via the URL scheme `forkcast://import` where possible.
- **In-app import screen** (also reachable from My recipes): paste field (link or caption text), and "Import".
- Pipeline (in `RecipeImportService`):
  1. If the input is a TikTok URL, fetch `https://www.tiktok.com/oembed?url=<encoded>` (public, no key) and use the returned `title` (the caption) and `author_name`. Instagram links can't be read without a key, so show "Instagram doesn't let apps read captions. Paste the caption text below" with the field focused.
  2. Parse the text. If `FoundationModels` is available and the model is ready (`SystemLanguageModel.default.availability == .available`), use a `LanguageModelSession` with a `@Generable` struct (`title`, `servings`, `minutes`, `ingredients: [amount, unit, name]`, `steps: [String]`) and clear instructions to extract only what's in the text. Otherwise use a **heuristic parser** in `ForkcastCore`: detect "ingredients"/"method"/"steps" headers, bullet or numbered lines, and leading quantities with units. Unit-test it with 5 sample captions.
  3. Open the **Create recipe** screen **pre-filled** with the result for the user to review, link ingredients and save. Set `sourceKind` and `sourceURL`. If parsing found nothing, open it with only the title/link filled, and a friendly note: "this one's recipe is probably spoken in the video. Add the ingredients and we'll do the rest."
- Wrap all Foundation Models code in `#if canImport(FoundationModels)` plus `@available(iOS 26.0, *)` so the app compiles with Xcode versions that lack it.

#### You tab (profile and settings)
- Profile card: name (editable), "shopping at {Store}", subscription status pill ("Pro · trial ends 27 Nov" / "Pro" / "Free").
- **Preferences** (each row opens the same component used in onboarding, reused, not duplicated): Country · Store · Household · Cooking days · Weekly budget · Vibes · Diet · Allergies · Dislikes · Appliances · Max cook time · Units · "Include my recipes in auto-plans". Changing a preference offers "update this week's plan?" (Regenerate unlocked meals / Keep as is).
- **Notifications**: weekly planning reminder toggle (default Sunday 10:00, with a day and time picker), and the trial reminder (1 or 2 days before).
- **Account**: optional **Sign in with Apple** ("back up your preferences to your Apple ID", purely optional; store the user ID; iCloud sync works without it), and Sign out.
- **Subscription**: Manage subscription (`.manageSubscriptionsSheet`), Restore purchases (`AppStore.sync()`), Redeem code (`.offerCodeRedemption`).
- **Support**: Rate Forkcast (`requestReview`), Contact us (mailto placeholder `hello@forkcast.app`), Request a feature (same mailto with a subject).
- **Legal**: Privacy Policy and Terms (placeholder URLs in one `AppLinks` constant).
- **Danger zone**: Reset this week's plan · Start over (re-run onboarding, keep subscription) · Delete all my data (with confirmation; wipes SwiftData and the App Group).
- Footer: "Forkcast v1.0 · made for busy weeknights" plus the mascot, small.

### 6.3 Widget (`ForkcastWidget` target)
- "Tonight's dinner", small and medium sizes. Small: dish tile (emoji on colour), "tonight", and the recipe title. Medium: adds time, servings and the macros line, plus "tomorrow: {title}" if it exists. Off days and no plan: the mascot and "no dinner planned tonight".
- Data: the main app writes a lightweight `widget-snapshot.json` (today and the next 6 days) to the App Group whenever the plan changes, and calls `WidgetCenter.shared.reloadAllTimelines()`. The widget **does not** use SwiftData.
- Tapping deep-links to `forkcast://recipe/<id>`.

### 6.4 Notifications (local only, `UNUserNotificationCenter`)
- Weekly planning reminder: repeating calendar trigger at the chosen weekday and hour. "your week's dinners are waiting. 2 minutes to plan, one list to shop."
- Trial reminder: when a trial starts, schedule a one-off notification `trialReminderDaysBefore` days before the trial ends: "heads-up: your Forkcast trial ends {date}. Cancel anytime in Settings." **This is a promise we make on the reminder screen, so it must actually be scheduled.** If notifications are denied, show "turn on notifications so we can remind you" with a Settings deep link on the reminder screen.

---

## 7. Paywall and monetisation (StoreKit 2)

- Products (also defined in `Forkcast.storekit` for local testing, referenced by the scheme in `project.yml`):
  - `com.forkcast.app.pro.yearly`: $39.99/year, introductory offer **3-day free trial**.
  - `com.forkcast.app.pro.monthly`: $9.99/month, no trial.
  - Both in subscription group `Forkcast Pro`.
- `SubscriptionManager` (`@Observable`, `@MainActor`): loads products, purchases, listens to `Transaction.updates`, checks `Transaction.currentEntitlements`, and exposes `isPro`, `isInTrial`, `trialEndDate`. Always display **localized prices from StoreKit** (`product.displayPrice`), never hard-coded strings. Compute "per month" for yearly from `product.price / 12`, formatted with `product.priceFormatStyle`.
- **Gating ("value first, then ask")**: after onboarding the user lands on their real Plan tab in **preview mode**. They can scroll it and see dish tiles, titles, total cost against budget and the macros lines. **Any tap** into a recipe, the swap button, the grocery list, Edit week, or the Groceries/Recipes tabs presents the paywall flow. Dismissing it returns them to the preview. Once `isPro` is true, everything unlocks. There is no free tier beyond the preview.
- **Paywall flow** (two screens, full-screen cover):
  1. **Trial reminder screen**: mascot with a bell (an SF Symbol bell badge in saffron), "we'll remind you before your trial ends", "no surprises. Cancel anytime in two taps.", two selectable rows: "1 day before (recommended)" / "2 days before", and "Continue". The choice is saved to the profile.
  2. **Paywall**: headline "Start your 3 days free", three benefit rows with checkmarks (a costed week for your shop · one tidy grocery list · recipes that fit your rules, with macros); a **plan selector** with Yearly preselected (badge "BEST VALUE · {X}% off", "{$3.33}/mo, billed {$39.99} yearly after 3 days free") and Monthly ("{$9.99}/month"); a trial timeline (Today: full access → Day 2: reminder → Day 3: trial ends); a primary button "Start free trial" (yearly) / "Subscribe" (monthly); "No payment due now" under it for yearly; and small links for Restore · Terms · Privacy · "Have a code?". A close (✕) button, top-left, fades in after 2 seconds.
- Debug: a `#if DEBUG` flag `FeatureFlags.bypassPaywall`, plus a hidden debug menu (long-press the version number in the You tab) to toggle Pro, reset onboarding and generate the next week, so my co-founder can test everything quickly.

---

## 8. Starter recipe library (you write it)

Write **40 original recipes** into `recipes.json`, enough for real testing. (A ~200-recipe library will be a separate task later, so make the schema solid.) Schema: `id` (slug), `title`, `emoji`, `cuisine` (Italian, Mexican, Indian, Chinese, Japanese, Thai, Mediterranean, Middle Eastern, American, British, Spanish/Portuguese, Korean), `vibes` (from the vibe list), `diet` (computed in code from the ingredients, **don't hand-label it**), `appliances` (required, e.g. `["oven"]` or `["stovetop"]`; `airFryer`/`slowCooker`/`microwave` recipes should exist too), `prepMinutes`, `cookMinutes`, `baseServings` (2 or 4), `ingredients` (`ingredientId`, `amount`, `unit`, optional `note` like "diced"), `steps` (6–10 clear steps, with temperatures in both °C and °F), `imageName` (null for now), `isLeftoverFriendly`.

Coverage requirements, so the planner always has options:
- ≥ 14 vegetarian (of which ≥ 7 vegan), ≥ 4 pescatarian, the rest meat (chicken, beef, pork, turkey).
- ≥ 12 naturally gluten-free and ≥ 12 dairy-free.
- ≥ 12 recipes at 25 minutes or less total. ≥ 5 air-fryer, ≥ 3 slow-cooker, ≥ 2 microwave-only, ≥ 6 one-pan.
- A spread of costs: cheap (beans, lentils, eggs, pasta) through moderate.
- Every `ingredientId` must exist in `ingredients.json`. Write a unit test that validates this, and that every recipe parses, has steps, and has computed macros between 250 and 950 kcal per serving.

Macros, diet labels and allergens are **always computed from ingredients** (`ForkcastCore.NutritionCalculator` and `RecipeClassifier`), never typed by hand.

---

## 9. Core algorithms (in `ForkcastCore`, unit-tested)

### 9.1 `MealPlanner`
Input: profile constraints, recipe pool (bundled plus eligible user recipes), feedback history, the last 2 weeks of plans, prices for the region and store tier, the number of cooking days, and portions per meal.

1. **Hard filters** (never violated): allergens (the ingredient allergen union must not intersect the user's allergens), diet compatibility, no disliked ingredient, required appliances ⊆ the user's appliances, total time ≤ `maxCookMinutes` + 10 (relax this one, and only this one, if fewer than `cookingDays × 2` candidates remain), and not marked "not for me".
2. **Score** each candidate: +3 per matching vibe, +4 if liked, +1 per star above 3, −5 if used in the last 2 weeks, −1 if used 3+ weeks ago (mild), +0.5 for user recipes when "include my recipes" is on, plus a small seeded random jitter (seed = week start date + regeneration counter), so regenerations differ but stay deterministic in tests.
3. **Build the week greedily** with variety rules: no repeated recipe in a week; at most 2 dinners with the same main protein, and at most 2 with the same cuisine; prefer ingredient overlap with already-chosen meals (+1 per shared non-staple ingredient, capped at +3), because shared ingredients cut cost.
4. **Budget pass:** compute the true basket cost with `GroceryAggregator`. While over budget, swap the most expensive meal for the best-scoring cheaper candidate, for up to 20 iterations. If the plan still can't fit, keep the cheapest valid plan and surface "over by $X" honestly. Never break hard filters to fit the budget.
5. Output: `[PlannedMealDraft]`, plus `estimatedTotal`, and per-meal "allocated cost" (each meal's share of the pack costs, by proportion used) for display.
6. `alternatives(for slot:)` returns the top 3 swaps that keep every rule, with their cost change.

### 9.2 `GroceryAggregator`
- Sum each ingredient across meals (scaled to servings), converting units into a base unit (grams, millilitres or pieces) using `gramsPerUnit` and standard conversions.
- Convert to **packs to buy** (`ceil(needed / pack.amount)`) and cost = packs × pack price × tier multiplier. Pantry staples: a small fixed amortised cost each, flagged separately.
- Return items grouped by aisle, each with `displayQuantity` (in the user's unit system), `neededText`, `usedOnDays` ("used Mon & Thu"), `cost`, `emoji`, and a stable `key` for check-state persistence.
- Plain-text export for sharing.

### 9.3 `NutritionCalculator`, `UnitConverter`, `FractionFormatter`, `RecipeTextParser`
- Macros per serving from linked ingredients (unlinked ones are ignored, and `hasIncompleteData` is reported).
- Imperial/metric display, with sensible rounding (no "0.333 cups"; use "⅓ cup").
- Heuristic caption parser as described in section 6.2.

Unit tests are required for: hard filters (an allergen never appears, across 100 random seeds), budget fitting, variety rules, aggregation maths (two recipes sharing onions produce one onion line with both days), unit conversion and fraction formatting, the parser on 5 sample captions, and the recipe library validation.

---

## 10. Project structure

```
Forkcast/
  project.yml                     # XcodeGen: app, widget, share extension, tests
  BUILD_NOTES.md                  # setup steps for the Mac, assumptions, TODOs
  Design/mascot-tomato-chef.png   # provided by me
  reference-screens/              # provided by me; reference only
  Packages/ForkcastCore/
    Package.swift
    Sources/ForkcastCore/{Models,Planner,Grocery,Nutrition,Parsing,Data}/...
    Tests/ForkcastCoreTests/...
  Forkcast/
    App/ (ForkcastApp.swift, RootView, AppRouter, DeepLinks)
    Theme/ (Theme.swift, Components/: PrimaryButton, OptionTile, Chip, Card, ProgressBar, MacrosLine, MacrosCard, DishTileView, MascotView, MoneyText, SectionHeader, EmptyState)
    Features/
      Onboarding/  Plan/  Groceries/  Recipes/  RecipeDetail/  CookMode/
      CreateRecipe/  Import/  Paywall/  Profile/  Feedback/
    Services/ (RecipeRepository, PlanStore, SubscriptionManager, NotificationManager,
               RecipeImportService, WidgetSnapshotWriter, AppleSignInManager, Haptics)
    Persistence/ (SwiftData models, ModelContainer setup with CloudKit + graceful local fallback)
    Resources/ (Assets.xcassets incl. Mascot + AppIcon + colours, JSON data, Localizable.xcstrings, Forkcast.storekit)
  ForkcastWidget/
  ForkcastShare/
```

`ModelContainer` setup: try the CloudKit-backed configuration first. If it fails (no iCloud account, or the simulator), fall back to a local-only store instead of crashing, and log it.

---

## 11. Quality bar

- **SwiftUI previews for every screen and component**, using an in-memory `PreviewData` (sample profile, plan, recipes). Previews must compile.
- Accessibility: every icon-only button has an `accessibilityLabel`; option tiles expose selected state; the macros line reads naturally ("520 calories, 32 grams protein…"); 44 pt minimum tap targets; Dynamic Type holds up to accessibility sizes (allow wrapping, use `ViewThatFits` where needed).
- Money is always formatted with the user's country currency (`.currency(code:)`) and labelled "approx." on totals.
- No force-unwraps outside of tests and bundled-resource loading (where a missing bundled file should `fatalError` with a clear message so it's caught immediately in development).
- Performance: the planner runs off the main actor (a `Task.detached`, or an actor) and finishes in < 200 ms for 40 recipes.
- Every list empty state is designed (mascot or icon, one line, one action).
- Privacy: no tracking, no ATT prompt, no third-party SDKs. Write the Info.plist usage strings that are needed. Add a `PrivacyInfo.xcprivacy` declaring UserDefaults usage (reason CA92.1) and no tracking.

---

## 12. `BUILD_NOTES.md` (write it for my co-founder)
Include:
1. Steps on the Mac: install XcodeGen, run `xcodegen generate`, open the project, set the Team, change the bundle IDs if needed, enable the iCloud (CloudKit container `iCloud.com.forkcast.app`), App Groups, Sign in with Apple and In-App Purchase capabilities, select the StoreKit configuration in the scheme, and run.
2. How to test: the debug menu, bypassing the paywall, simulating a trial with the StoreKit config, the widget, the share extension from Safari/TikTok, and Foundation Models (iOS 26 device only).
3. Every assumption you made and every TODO: real reviews, real recipe photos, the full recipe library, price refinement, legal URLs, and the App Icon export.
4. A "likely compile hotspots" list: places you were unsure about, so my co-founder looks there first.

---

## 13. Build order (commit after each phase)

1. **Scaffold**: `project.yml`, folders, Theme + all components, `MascotView`, `DishTileView`, previews. Commit.
2. **Core**: `ForkcastCore` package with models, JSON loading, all data files (countries, stores, ~150 ingredients with macros and prices, 40 recipes), planner, aggregator, nutrition, units, parser, and **tests**. Run `swift test` if available. Commit.
3. **Persistence + services**: SwiftData models (CloudKit-safe), `RecipeRepository`, `PlanStore`, `NotificationManager`, `WidgetSnapshotWriter`. Commit.
4. **Onboarding**: all steps, reusable preference editors, the building loader, and plan reveal. Commit.
5. **Plan tab**: budget card, meal cards with macros, swap sheet, edit week, regenerate, why-cheaper sheet, and weekly feedback. Commit.
6. **Recipe detail + cook mode**. Commit.
7. **Groceries tab**. Commit.
8. **Recipes tab + create/edit recipe + import** (in-app, plus the Share Extension). Commit.
9. **Paywall + SubscriptionManager + gating + trial reminder notification**. Commit.
10. **You tab**: settings, Sign in with Apple, danger zone, and the debug menu. Commit.
11. **Widget**. Commit.
12. **Self-review pass for compile errors** (section 0), a polish pass (animations, haptics, empty states, copy), and `BUILD_NOTES.md`. Final commit.

When you finish, reply with: a summary of what was built, the file tree, anything you couldn't do, and the top 10 things my co-founder should check first.
