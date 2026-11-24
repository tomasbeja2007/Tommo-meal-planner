# Image requests (for an image-generation agent)

Nothing below is required to build or run the app: every image has a code-drawn
fallback. Drop a finished PNG into `Forkcast/Resources/Assets.xcassets` as an
**Image Set with exactly the name given** and the app picks it up automatically,
with no code changes.

## Shared style brief (give this to the agent with every request)
- Character: **Chef Tomato** (see `Design/mascot-tomato-chef.png`): glossy 3D tomato,
  white chef hat with a tomato-red band, green leaves, wooden spoon, friendly face.
- Palette: cream `#FBF6EE`, tomato `#E8553D`, saffron `#F2B544`, aubergine `#2B1E2E`.
  **Avoid green as a dominant colour** (green leaves on the tomato are fine).
- Soft 3D / clay render, gentle studio light, no text, no logos, no brand names.
- **Transparent background** for character/illustration assets (PNG, sRGB).

## 1. Mascot moods (highest impact)
1024×1024 transparent PNG, character centred and filling about 85% of the canvas.

| Asset name | Pose | Used on |
|---|---|---|
| `MascotIdle` | Standing, relaxed smile, spoon held at side | Welcome, empty states, weekly feedback |
| `MascotCheer` | Jumping, both arms up, spoon raised, eyes happy-closed | Savings moment, plan reveal, cook-mode "enjoy!", "shop done!" |
| `MascotThinking` | Spoon tapping chin, eyes looking up, small thought sparkle | "Building your week" loader, regenerating |
| `MascotBell` | Holding a small golden bell, reassuring smile | Trial-reminder screen before the paywall |

(The app still adds a subtle breathing/bounce/wobble animation on top.)

## 2. App icon (clean export)
- `AppIcon` → replace `Forkcast/Resources/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png`
- 1024×1024, **opaque** (no transparency), cream background to the edges, **no rounded
  corners and no dark border** (iOS applies the mask). Mascot centred, slightly larger
  than in the current source image.

## 3. Recipe photos (40)
Square 1200×1200 JPG/PNG, top-down or 45° food photography on a warm neutral surface,
natural light, no hands, no text. Each dish should match the recipe title.
Asset name = `recipe-<id>` (DishTileView uses it automatically in place of the emoji tile).

| Asset name | Dish | Placeholder emoji |
|---|---|---|
| `recipe-chickpea-spinach-curry` | Chickpea & spinach coconut curry | 🍛 |
| `recipe-slow-cooker-red-lentil-dahl` | Slow-cooker red lentil dahl | 🍲 |
| `recipe-black-bean-tacos` | Smoky black bean tacos with lime slaw | 🌮 |
| `recipe-peanut-noodle-stir-fry` | Peanut noodle stir-fry | 🍜 |
| `recipe-roast-veg-chickpea-couscous` | Roast veg & chickpea couscous | 🥗 |
| `recipe-sticky-sesame-cauliflower` | Sticky sesame cauliflower with rice | 🥦 |
| `recipe-lentil-ragu-spaghetti` | Lentil ragù spaghetti | 🍝 |
| `recipe-sweet-potato-peanut-curry` | Sweet potato & peanut curry | 🥘 |
| `recipe-microwave-chickpea-curry-bowl` | Microwave chickpea curry rice bowls | 🍛 |
| `recipe-air-fryer-halloumi-wraps` | Air-fryer halloumi & pepper wraps | 🌯 |
| `recipe-shakshuka` | Shakshuka with crusty bread | 🍳 |
| `recipe-creamy-tomato-gnocchi-bake` | Creamy tomato & spinach gnocchi bake | 🍝 |
| `recipe-mushroom-pea-risotto` | Mushroom & pea risotto | 🍄 |
| `recipe-two-minute-burrito-bowls` | 2-minute burrito bowls | 🥙 |
| `recipe-veggie-egg-fried-rice` | Veggie egg fried rice | 🍳 |
| `recipe-paneer-tikka-traybake` | Paneer tikka traybake with naan | 🍢 |
| `recipe-air-fryer-honey-soy-salmon` | Air-fryer honey-soy salmon with greens | 🐟 |
| `recipe-thai-red-prawn-curry` | Thai red prawn curry | 🍤 |
| `recipe-tuna-sweetcorn-pasta-bake` | Tuna & sweetcorn pasta bake | 🧀 |
| `recipe-lemon-cod-traybake` | Lemon cod with crushed potatoes & beans | 🐟 |
| `recipe-garlic-prawn-spaghetti` | Garlic prawn spaghetti | 🍝 |
| `recipe-air-fryer-lemon-chicken-potatoes` | Air-fryer lemon chicken thighs & potatoes | 🍗 |
| `recipe-slow-cooker-beef-chili` | Slow-cooker beef & bean chili | 🌶️ |
| `recipe-slow-cooker-bbq-pulled-chicken` | Slow-cooker BBQ pulled chicken buns | 🍔 |
| `recipe-sheet-pan-chicken-fajitas` | Sheet-pan chicken fajitas | 🌯 |
| `recipe-honey-garlic-chicken-stir-fry` | Honey-garlic chicken stir-fry | 🥢 |
| `recipe-chicken-tikka-masala` | Chicken tikka masala | 🍛 |
| `recipe-air-fryer-turkey-meatballs` | Air-fryer turkey meatballs & spaghetti | 🍝 |
| `recipe-turkey-taco-lettuce-cups` | Turkey taco lettuce cups | 🥬 |
| `recipe-weeknight-spaghetti-bolognese` | Weeknight spaghetti bolognese | 🍝 |
| `recipe-beef-broccoli-rice` | Beef & broccoli with rice | 🥦 |
| `recipe-korean-beef-rice-bowls` | Korean beef rice bowls | 🍚 |
| `recipe-chicken-chorizo-rice` | One-pan chicken & chorizo rice | 🥘 |
| `recipe-sausage-white-bean-casserole` | Sausage & white bean casserole | 🌭 |
| `recipe-miso-pork-sesame-greens` | Miso-glazed pork with sesame greens | 🥢 |
| `recipe-bangers-mash-onion-gravy` | Bangers & mash with onion gravy | 🌭 |
| `recipe-chicken-caesar-salad` | Chicken Caesar-style salad | 🥗 |
| `recipe-pesto-chicken-pasta` | Pesto chicken pasta | 🍝 |
| `recipe-thai-basil-chicken` | Thai basil chicken with fried egg | 🌶️ |
| `recipe-beef-kofta-pittas` | Beef kofta pittas with garlic yogurt | 🥙 |

## 4. Onboarding illustrations (optional, nice polish)
512×512 transparent PNG, small object-style 3D illustrations in the same clay style,
no mascot. They replace the SF Symbol on the matching tile.

| Asset names | What to draw |
|---|---|
| `appliance-oven`, `appliance-stovetop`, `appliance-microwave`, `appliance-airFryer`, `appliance-slowCooker`, `appliance-blender` | The appliance, cute and simplified |
| `vibe-quickEasy`, `vibe-highProtein`, `vibe-comfort`, `vibe-healthyish`, `vibe-family`, `vibe-fakeaway`, `vibe-lowCalorie`, `vibe-onePan`, `vibe-batchFriendly` | Lightning bowl · dumbbell with steak · steaming stew pot · salad bowl · family dinner table · takeaway box · light salad with measuring tape · frying pan · stacked meal-prep boxes |
| `diet-none`, `diet-vegetarian`, `diet-vegan`, `diet-pescatarian` | Plate with mixed food · carrot & cheese · sprouting leaf · fish |
| `goal-spendLess`, `goal-stopWondering`, `goal-eatHealthier`, `goal-saveTime`, `goal-cookMore`, `goal-feedFamily` | Coin jar · question mark over a plate · apple · clock · pan on a hob · family of three at a table |

## Do NOT generate
- **Supermarket logos.** The store picker deliberately uses coloured monogram tiles;
  real retailer logos can't ship without permission.
- **Fake reviews or user photos** for the testimonial carousel.
