# Image prompts for Grok

Nothing below is required to build or run the app: every image has a code-drawn
fallback. Drop a finished PNG into `Forkcast/Resources/Assets.xcassets` as an
**Image Set with exactly the name given** and the app picks it up automatically,
with no code changes.

## Status (Nov 2026)
- **Done and in `Assets.xcassets`:** the 4 mascot moods (section 1), all 40 recipe photos (section 3),
  the onboarding illustrations (section 4), and the six splash pieces (section 5).
- **MascotRig, round 1:** arms and both mouths are good and kept in `Design/MascotRig/` (not in the app until the
  live face is built). `MascotRig-body` and `MascotRig-head` need a redo, see section 1.
- **Still open:** the clean app icon export (section 2), the 80 pantry photos (section 6), the 32 breakfast, lunch
  and snack photos (section 7), and the `MascotRig-body` / `MascotRig-head` redo (section 1).

## Shared style brief (give this to the agent with every request)
- Character: **Chef Tommo** (see `Design/mascot-tomato-chef.png`): glossy 3D tomato,
  white chef hat with a tomato-red band, green leaves, wooden spoon, friendly face.
- Palette: cream `#FBF6EE`, tomato `#E8553D`, saffron `#F2B544`, aubergine `#2B1E2E`.
  **Avoid green as a dominant colour** (green leaves on the tomato are fine).
- Soft 3D / clay render, gentle studio light, no text, no logos, no brand names.
- **Transparent background** for character/illustration assets (PNG, sRGB).
- **No baked ground shadow** under the mascot: the app draws its own floor shadow, which shrinks when
  Chef Tommo hops (see `Forkcast/Theme/Motion/MOTION.md`).

## 1. Mascot moods (highest impact)
1024×1024 transparent PNG, character centred and filling about 85% of the canvas.

| Asset name | Pose | Used on |
|---|---|---|
| `MascotIdle` | Standing, relaxed smile, spoon held at side | Welcome, empty states, weekly feedback |
| `MascotCheer` | Jumping, both arms up, spoon raised, eyes happy-closed | Savings moment, plan reveal, cook-mode "enjoy!", "shop done!" |
| `MascotThinking` | Spoon tapping chin, eyes looking up, small thought sparkle | "Building your week" loader, regenerating |
| `MascotBell` | Holding a small golden bell, reassuring smile | Trial-reminder screen before the paywall |

The app animates every mood on top of the art (breathing, sway around the feet, a hop with
squash-and-stretch, sparkles), so draw each pose **standing, feet on the bottom edge area, centred**,
with nothing touching the canvas edges.

### Optional: `MascotRig` (unlocks blinking and eye movement)
Separate 1024×1024 transparent PNG layers, all aligned on the same canvas so they stack perfectly:

| Asset name | Layer |
|---|---|
| `MascotRig-body` | Tomato body and legs, no arms, no face |
| `MascotRig-head` | Leaves + chef hat, plus the face with the **eyes drawn as plain whites, no pupils** |
| `MascotRig-armLeft` / `MascotRig-armRight` | Each arm on its own (the right one holding the spoon) |
| `MascotRig-mouth-closed` / `MascotRig-mouth-open` | The mouth shapes only |

**Redo notes (round 1):** the body layer was made by erasing the old face, so it shows a flat smudged circle where
the mouth was and dark marks where the pupils were, which peek out from under the new eye whites. Ask for:
- `MascotRig-body`: **clean, continuous glossy tomato skin across the whole face area**, as if the face had never been
  drawn (no eye marks, no mouth patch, no circles), same shape, position and lighting as before.
- `MascotRig-head`: the same layer again with **smooth, anti-aliased edges on the eye whites** (no jagged pixels),
  and a little larger eye whites so they fully cover where the old eyes were. Keep the brows and cheeks.

With these, the app can use the motion skill's live face (gliding pupils, blinks every 3–4 s, a happy squint)
and wave the spoon arm with follow-through.

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
| `diet-none`, `diet-vegetarian`, `diet-vegan`, `diet-pescatarian` | Plate with mixed food · carrot & cheese · sprouting leaf · fish |
| `goal-spendLess`, `goal-stopWondering`, `goal-eatHealthier`, `goal-saveTime`, `goal-cookMore`, `goal-feedFamily` | Coin jar · question mark over a plate · apple · clock · pan on a hob · family of three at a table |

## 5. Onboarding extras (Nov 2026)
Same clay style and palette as section 4. The app works without them: missing pieces are skipped.

| Asset name | Size | Background | What to draw |
|---|---|---|---|
| `splash-tomato` | 256×256 | transparent | A small whole cherry tomato with a green calyx |
| `splash-basil` | 256×256 | transparent | A single basil leaf, slightly curled |
| `splash-garlic` | 256×256 | transparent | One garlic bulb, cream with faint aubergine streaks |
| `splash-chilli` | 256×256 | transparent | A small red chilli, gentle curve |
| `splash-lemon` | 256×256 | transparent | A lemon slice (saffron yellow), seen from the front |
| `splash-pepper` | 256×256 | transparent | Three black peppercorns in a little cluster |

Style notes: each piece is a single object, centred, filling ~80% of the canvas, no shadow under it, no text,
soft studio light from the top left. They float around Chef Tommo on the splash and welcome screens, so they
should read clearly at about 60 pt.

## 6. Pantry photos (80)
Real photos (not illustrations) for the "what do you already have?" screen. Each tile shows the photo at about
60 pt in a rounded square; until a photo exists the tile shows the ingredient's emoji. The screen shows the most-used
ingredients, so the list covers every ingredient it can show.

- **File:** `ingredient-<id>.jpg`, **512×512**, **opaque**.
- **Style:** realistic food photography, the ingredient alone, centred, filling about 70% of the frame, on a plain
  warm cream background (#FBF6EE), seen from slightly above (about 45°), soft natural light, no hands, no text,
  **no packaging, labels or brand names** (show tins and jars as their contents in a small plain bowl).
- **Prompt template:** "Realistic food photo of [what to show], alone on a plain warm cream background (#FBF6EE),
  seen from slightly above, soft natural light, no hands, no text, no packaging or labels, square."

| File | What to show |
|---|---|
| `ingredient-baguette` | A whole crusty baguette |
| `ingredient-tortillas` | A small stack of soft flour tortillas |
| `ingredient-wholemeal-bread` | A few slices of wholemeal bread |
| `ingredient-flour` | Plain flour in a small ceramic bowl with a wooden scoop |
| `ingredient-butter` | A block of butter on a small plate, one slice cut |
| `ingredient-cheddar` | A wedge of orange cheddar |
| `ingredient-coconut-yogurt` | Coconut yogurt in a small bowl |
| `ingredient-cream-cheese` | Cream cheese in a small bowl with a knife |
| `ingredient-eggs` | Three brown eggs |
| `ingredient-feta` | A block of feta, a few crumbles beside it |
| `ingredient-halloumi` | A block of halloumi, one slice cut |
| `ingredient-heavy-cream` | Double cream in a small glass jug |
| `ingredient-hummus` | Hummus in a small bowl with a swirl of olive oil |
| `ingredient-milk` | A glass bottle of milk, no label |
| `ingredient-mozzarella` | A ball of fresh mozzarella |
| `ingredient-parmesan` | A wedge of parmesan |
| `ingredient-greek-yogurt` | Thick Greek yogurt in a small bowl |
| `ingredient-sour-cream` | Sour cream in a small bowl |
| `ingredient-soy-milk` | A glass of soy milk, no label |
| `ingredient-berries-frozen` | Frozen mixed berries with a light frost in a small bowl |
| `ingredient-peas-frozen` | Frozen peas with a light frost in a small bowl |
| `ingredient-mixed-veg-frozen` | Frozen stir-fry vegetables (peppers, broccoli, carrot) with a light frost in a small bowl |
| `ingredient-corn-frozen` | Frozen sweetcorn kernels with a light frost in a small bowl |
| `ingredient-chicken-thighs` | Two raw boneless chicken thighs on baking paper |
| `ingredient-chicken-breast` | A raw chicken breast on baking paper |
| `ingredient-chorizo` | A chorizo sausage, a few slices cut |
| `ingredient-white-fish` | A raw cod fillet on baking paper |
| `ingredient-ground-beef` | Raw beef mince on baking paper |
| `ingredient-ground-turkey` | Raw turkey mince on baking paper |
| `ingredient-sausages` | Four raw pork sausages |
| `ingredient-shrimp` | Raw king prawns in a small bowl |
| `ingredient-sesame-oil` | Toasted sesame oil in a small glass bottle, no label |
| `ingredient-chia-seeds` | Chia seeds in a small bowl |
| `ingredient-penne` | Dry penne pasta in a small heap |
| `ingredient-spaghetti` | A bundle of dry spaghetti |
| `ingredient-arugula` | A handful of rocket leaves |
| `ingredient-avocado` | A whole avocado and a half with the stone |
| `ingredient-basil` | A bunch of fresh basil |
| `ingredient-bell-pepper` | A red bell pepper |
| `ingredient-broccoli` | A head of broccoli |
| `ingredient-cabbage` | A white cabbage, cut in half |
| `ingredient-carrot` | Three carrots |
| `ingredient-celery` | A few sticks of celery |
| `ingredient-cherry-tomatoes` | Cherry tomatoes on the vine |
| `ingredient-cilantro` | A bunch of fresh coriander |
| `ingredient-cucumber` | A cucumber, one end sliced |
| `ingredient-ginger` | A knob of fresh ginger |
| `ingredient-garlic` | A garlic bulb and two cloves |
| `ingredient-green-beans` | A handful of green beans |
| `ingredient-lemon` | A lemon and a lemon half |
| `ingredient-lime` | A lime and a lime half |
| `ingredient-onion` | A brown onion, one half cut |
| `ingredient-parsley` | A bunch of flat-leaf parsley |
| `ingredient-potato` | Three potatoes |
| `ingredient-red-onion` | A red onion, one half cut |
| `ingredient-spring-onion` | A bunch of spring onions |
| `ingredient-spinach` | A pile of baby spinach |
| `ingredient-basmati-rice` | Dry basmati rice in a small bowl |
| `ingredient-long-grain-rice` | Dry long-grain rice in a small bowl |
| `ingredient-microwave-rice` | Cooked rice in a plain unlabelled pouch, slightly open |
| `ingredient-red-lentils` | Dry red lentils in a small bowl |
| `ingredient-rolled-oats` | Rolled oats in a small bowl |
| `ingredient-dijon-mustard` | Dijon mustard in a small dish |
| `ingredient-chicken-stock` | A stock cube next to a small bowl of golden broth |
| `ingredient-fish-sauce` | Fish sauce in a small glass bottle, no label |
| `ingredient-honey` | Honey in a small jar with a wooden dipper, no label |
| `ingredient-mayonnaise` | Mayonnaise in a small dish |
| `ingredient-soy-sauce` | Soy sauce in a small dipping dish |
| `ingredient-vegetable-stock` | A stock cube next to a small bowl of clear vegetable broth |
| `ingredient-black-beans` | Cooked black beans in a small bowl |
| `ingredient-canned-tuna` | Flaked tuna in a small bowl |
| `ingredient-cannellini-beans` | Cooked white cannellini beans in a small bowl |
| `ingredient-chickpeas` | Cooked chickpeas in a small bowl |
| `ingredient-coconut-milk` | Coconut milk in a small bowl, half a coconut beside it |
| `ingredient-chopped-tomatoes` | Chopped tomatoes in a small bowl |
| `ingredient-peanut-butter` | Smooth peanut butter in a small jar, no label |
| `ingredient-curry-paste` | Red curry paste in a small dish |
| `ingredient-tomato-paste` | Tomato purée in a small dish |
| `ingredient-salsa` | Chunky tomato salsa in a small bowl |
| `ingredient-passata` | Passata in a small glass jug |

## 7. Breakfast, lunch and snack photos (32)
Same brief as the recipe photos in section 3: square **1200×1200** JPG, top-down or 45°, warm neutral surface,
natural light, no hands, no text, matching the title. File = `recipe-<id>`.

| File | Dish | Meal |
|---|---|---|
| `recipe-berry-overnight-oats` | Berry overnight oats | Breakfast |
| `recipe-peanut-banana-porridge` | Peanut butter & banana porridge | Breakfast |
| `recipe-spinach-tomato-scrambled-eggs` | Spinach & tomato scrambled eggs on toast | Breakfast |
| `recipe-bean-egg-breakfast-burritos` | Bean & egg breakfast burritos | Breakfast |
| `recipe-avocado-toast-fried-egg` | Smashed avocado toast with a fried egg | Breakfast |
| `recipe-greek-yogurt-berry-bowl` | Greek yogurt berry bowl | Breakfast |
| `recipe-berry-chia-pudding` | Berry chia pudding | Breakfast |
| `recipe-berry-banana-smoothie` | Berry & banana smoothie | Breakfast |
| `recipe-sweet-potato-breakfast-hash` | Sweet potato & pepper breakfast hash | Breakfast |
| `recipe-cinnamon-french-toast` | Cinnamon French toast with berries | Breakfast |
| `recipe-turmeric-tofu-scramble` | Turmeric tofu scramble | Breakfast |
| `recipe-ham-cheese-omelette` | Ham & cheese omelette | Breakfast |
| `recipe-chicken-hummus-wraps` | Chicken, hummus & spinach wraps | Lunch |
| `recipe-tuna-sweetcorn-sandwiches` | Tuna & sweetcorn sandwiches | Lunch |
| `recipe-greek-chickpea-salad` | Greek salad with feta & chickpeas | Lunch |
| `recipe-black-bean-quinoa-bowl` | Quinoa, black bean & avocado bowl | Lunch |
| `recipe-red-lentil-carrot-soup` | Red lentil & carrot soup | Lunch |
| `recipe-lemon-couscous-halloumi` | Lemon couscous with halloumi | Lunch |
| `recipe-chicken-noodle-soup` | Ginger chicken noodle soup | Lunch |
| `recipe-caprese-pesto-toastie` | Tomato, mozzarella & pesto toastie | Lunch |
| `recipe-smashed-chickpea-sandwiches` | Smashed chickpea salad sandwiches | Lunch |
| `recipe-cheesy-bean-jacket-potatoes` | Microwave jacket potatoes with cheesy beans | Lunch |
| `recipe-tuna-white-bean-salad` | Tuna & white bean salad | Lunch |
| `recipe-sweet-potato-bean-quesadillas` | Sweet potato & black bean quesadillas | Lunch |
| `recipe-hummus-veg-sticks` | Hummus with veg sticks | Snack |
| `recipe-apple-peanut-butter` | Apple slices with peanut butter | Snack |
| `recipe-paprika-popcorn` | Stovetop paprika popcorn | Snack |
| `recipe-oat-raisin-energy-balls` | Oat & raisin energy balls | Snack |
| `recipe-yogurt-berry-pots` | Yogurt & berry pots | Snack |
| `recipe-avocado-rice-cakes` | Rice cakes with avocado & chilli | Snack |
| `recipe-crispy-spiced-chickpeas` | Crispy spiced chickpeas | Snack |
| `recipe-devilled-eggs` | Devilled eggs | Snack |

## Do NOT generate
- **Supermarket logos.** Never have Grok draw or imitate them. The store tiles are logo-ready:
  once a retailer gives permission (or you use their official press-kit file under its terms), add it as
  an Image Set named `store-<id>` (ids are in `ForkcastCore/Resources/stores.json`, e.g. `store-tesco`).
  Use the official logo as a **wide transparent PNG (about 3:1, at least 600×200)**: it fills the store
  tiles, the globe ring and the "built for the shops in …" wall. Without one, the store's name is set in its
  brand colour (and the small round badges show the coloured monogram).
- **Fake reviews or user photos** for the testimonial carousel.
