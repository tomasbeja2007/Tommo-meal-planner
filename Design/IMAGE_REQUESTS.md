# Image prompts for Grok

Nothing below is required to build or run the app: every image has a code-drawn
fallback. Drop a finished PNG into `Forkcast/Resources/Assets.xcassets` as an
**Image Set with exactly the name given** and the app picks it up automatically,
with no code changes.

## Status (25 Nov 2026)
- **Done and in `Assets.xcassets`:** the 4 mascot moods (section 1), 454 of 544 recipe photos, all 187 ingredient
  cut-outs (this covers the pantry photos of section 6), the goal / diet / appliance tile illustrations (section 4),
  and the splash pieces (section 5, no longer used by the app).
- **25 Nov:** 16 glyphs and 30 clay tiles (no `allergen-sesame` yet) installed, cut from the owner's contact sheet; ask for the
  full-size originals to replace them when convenient (they were cut at ~100 px). Tab outlines and Tommo face layers still to come.
- **Ready-to-send PDF for ChatGPT** (glyphs, tiles, Tommo face layers, kitchen): `Design/Tommo-image-prompts.pdf`.
- **Still open, in priority order:**
  1. **90 recipe photos** (section 7): every recipe without a photo still shows an emoji tile on the Plan tab,
     the reveal and the recipe pages.
  2. ~~Clean app icon export~~: done by the owner.
  3. **31 tile illustrations, round 2** (section 8): obstacles, vibes, allergies, cook time. The app is already
     wired for them and keeps its emoji / symbol until each file exists.
  4. **`MascotRig-body` / `MascotRig-head` redo** (section 1), needed before Chef Tommo can blink and look around.
  5. **8 tab bar icons** (section 10): the app is wired for them and keeps the system icons until they exist.
  6. *Optional:* the kitchen scene for the appliance picker (section 9).
- **Never generate:** supermarket logos, fake reviews or user photos (see "Do NOT generate").

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

## 7. Recipe photos still missing (90)
Same brief as the recipe photos in section 3: square **1200×1200** JPG, **opaque**, top-down or 45°, warm neutral
surface (cream linen, light wood, stoneware), natural daylight, no hands, no text, no brand packaging, the dish
exactly as titled and plated for one or two. File = `recipe-<id>` (drop in as an Image Set with that exact name).
28 dinners, 26 lunches, 20 breakfasts, 16 snacks:

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
| `recipe-berry-baked-oats` | Blended berry baked oats | Breakfast |
| `recipe-cottage-cheese-egg-bites` | Cottage cheese egg bites | Breakfast |
| `recipe-chocolate-pb-overnight-oats` | Chocolate peanut butter overnight oats | Breakfast |
| `recipe-mango-coconut-chia-pudding` | Mango coconut chia pudding | Breakfast |
| `recipe-banana-oat-pancakes` | Three-ingredient banana oat pancakes | Breakfast |
| `recipe-feta-egg-wrap` | Crispy feta egg wrap | Breakfast |
| `recipe-berry-smoothie-bowl` | Thick berry smoothie bowl | Breakfast |
| `recipe-savory-cottage-cheese-toast` | Savory cottage cheese toast | Breakfast |
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
| `recipe-smashed-cucumber-edamame-rice` | Smashed cucumber salad with edamame rice | Lunch |
| `recipe-chopped-italian-sandwich` | Chopped Italian-style sandwich | Lunch |
| `recipe-green-goddess-salad` | Green goddess salad with pita chips | Lunch |
| `recipe-dense-bean-salad` | Dense bean salad | Lunch |
| `recipe-cottage-cheese-flatbread-wrap` | Cottage cheese flatbread wrap | Lunch |
| `recipe-tuna-protein-pasta-salad` | High-protein tuna pasta salad | Lunch |
| `recipe-tofu-rice-paper-rolls` | Rice paper rolls with peanut dip | Lunch |
| `recipe-chicken-caesar-wrap` | Crispy chicken Caesar wrap | Lunch |
| `recipe-crispy-halloumi-salad-bowl` | Crispy halloumi couscous salad | Lunch |
| `recipe-caprese-orzo-salad` | Caprese orzo salad | Lunch |
| `recipe-buffalo-chicken-lettuce-wraps` | Buffalo chicken lettuce wraps | Lunch |
| `recipe-roasted-pepper-feta-soup` | Roasted red pepper soup with feta toast | Lunch |
| `recipe-peanut-sesame-noodle-salad` | Peanut noodle salad | Lunch |
| `recipe-mediterranean-quinoa-bowl` | Mediterranean chickpea quinoa bowl | Lunch |
| `recipe-spicy-tuna-crispy-rice-bowl` | Spicy tuna crispy rice bowl | Dinner |
| `recipe-chicken-burrito-bowl` | Chicken burrito bowl with lime rice | Dinner |
| `recipe-greek-chicken-bowl` | Greek chicken bowl with tzatziki | Dinner |
| `recipe-spicy-pork-gochujang-bowl` | Korean-style spicy pork rice bowl | Dinner |
| `recipe-cajun-chicken-corn-bowl` | Cajun chicken rice bowl with corn & lime yogurt | Dinner |
| `recipe-crispy-tofu-poke-bowl` | Crispy tofu poke-style bowl | Dinner |
| `recipe-baked-falafel-hummus-bowl` | Baked falafel hummus bowl | Dinner |
| `recipe-smoky-chickpea-sweet-potato-bowl` | Smoky chickpea & sweet potato bowl | Dinner |
| `recipe-salmon-sushi-bake` | Salmon sushi bake | Dinner |
| `recipe-sheet-pan-gnocchi` | Sheet-pan crispy gnocchi with peppers | Dinner |
| `recipe-popcorn-chicken-rice-bowl` | Air-fryer popcorn chicken rice bowl | Dinner |
| `recipe-hot-honey-chicken-bowl` | Hot honey chicken & sweet potato bowl | Dinner |
| `recipe-creamy-tuscan-chicken-orzo` | Creamy Tuscan-style chicken orzo | Dinner |
| `recipe-butter-chicken-meal-prep-bowl` | Butter chicken meal-prep bowl | Dinner |
| `recipe-spicy-shrimp-taco-bowl` | Spicy shrimp taco bowl | Dinner |
| `recipe-burger-bowl-special-sauce` | Burger bowl with special sauce | Dinner |
| `recipe-turkey-sweet-potato-bowl` | Turkey taco sweet potato bowl | Dinner |
| `recipe-thai-peanut-chicken-bowl` | Thai peanut chicken bowl | Dinner |
| `recipe-crispy-fish-taco-bowl` | Air-fryer crispy fish taco bowl | Dinner |
| `recipe-crispy-pesto-gnocchi` | Crispy pesto gnocchi with peas | Dinner |
| `recipe-chickpea-shawarma-bowl` | Sheet-pan chickpea shawarma bowl | Dinner |
| `recipe-kimchi-fried-rice` | Kimchi fried rice with a jammy egg | Dinner |
| `recipe-black-bean-enchilada-skillet` | Black bean enchilada skillet | Dinner |
| `recipe-spicy-creamy-tomato-pasta` | Spicy creamy tomato pasta | Dinner |
| `recipe-egg-roll-in-a-bowl` | Egg roll in a bowl | Dinner |
| `recipe-garlic-butter-noodles-chicken` | Garlic butter noodles with crispy chicken | Dinner |
| `recipe-lemon-garlic-salmon-orzo` | One-pan lemon salmon & pea orzo | Dinner |
| `recipe-tofu-satay-noodle-bowl` | Crispy tofu satay noodle bowl | Dinner |
| `recipe-hummus-veg-sticks` | Hummus with veg sticks | Snack |
| `recipe-apple-peanut-butter` | Apple slices with peanut butter | Snack |
| `recipe-paprika-popcorn` | Stovetop paprika popcorn | Snack |
| `recipe-oat-raisin-energy-balls` | Oat & raisin energy balls | Snack |
| `recipe-yogurt-berry-pots` | Yogurt & berry pots | Snack |
| `recipe-avocado-rice-cakes` | Rice cakes with avocado & chilli | Snack |
| `recipe-crispy-spiced-chickpeas` | Crispy spiced chickpeas | Snack |
| `recipe-devilled-eggs` | Devilled eggs | Snack |
| `recipe-frozen-yogurt-bark` | Frozen yogurt berry bark | Snack |
| `recipe-frozen-lime-grapes` | Frozen lime grapes | Snack |
| `recipe-cucumber-tuna-bites` | Cucumber tuna sushi bites | Snack |
| `recipe-cottage-cheese-chocolate-mousse` | Two-minute chocolate cottage cheese mousse | Snack |
| `recipe-banana-pb-sushi` | Banana peanut butter sushi | Snack |
| `recipe-air-fryer-apple-chips` | Air-fryer cinnamon apple chips | Snack |
| `recipe-chili-garlic-edamame` | Chili garlic edamame | Snack |
| `recipe-chili-lime-mango` | Chili lime mango | Snack |

## 8. Tile illustrations, round 2 (31)
Same brief as section 4: **512×512 transparent PNG**, small object-style 3D clay illustrations, soft studio light,
the palette in the shared brief, **no mascot, no text, no faces on objects**, the object centred filling ~75%.
The app shows them on the option tiles (32 pt in rows, 56 pt in grids) instead of today's emoji / SF Symbol.

| Asset names | What to draw |
|---|---|
| `obstacle-overspend` · `obstacle-dontKnowWhat` · `obstacle-planningTakesLong` · `obstacle-tooTired` | A receipt curling up with a coin flying off · an empty plate with a question mark above it · an hourglass beside a notepad · a mug of tea next to a sleeping pillow |
| `obstacle-foodGoesOff` · `obstacle-noList` · `obstacle-messyRecipes` · `obstacle-sameMeals` | A wilted lettuce leaf · a crumpled, blank shopping list · a messy pile of recipe cards · a pan with a looping arrow |
| `vibe-quickEasy` · `vibe-highProtein` · `vibe-comfort` · `vibe-healthyish` · `vibe-family` | A lightning-shaped noodle bowl · a chicken drumstick next to an egg · a steaming bowl of stew · a salad bowl · a big sharing dish with three forks |
| `vibe-fakeaway` · `vibe-lowCalorie` · `vibe-onePan` · `vibe-batchFriendly` · `vibe-fiberForward` | A takeaway box with chopsticks · a light, leafy plate · one frying pan with a full meal in it · three stacked meal-prep boxes · a bowl of beans and grains |
| `allergen-gluten` · `allergen-dairy` · `allergen-egg` · `allergen-peanut` · `allergen-treeNut` | A wheat sheaf · a milk bottle · a brown egg · a peanut in its shell · a walnut and an almond |
| `allergen-soy` · `allergen-fish` · `allergen-shellfish` · `allergen-sesame` | A soy bean pod · a whole fish · a prawn · a small dish of sesame seeds |
| `cooktime-quick` · `cooktime-medium` · `cooktime-relaxed` · `cooktime-dontMind` | A kitchen timer at 15 min · a timer at 30 min · a timer at 45 min next to a wooden spoon · a relaxed timer with a little heart |

## 9. Optional: kitchen scene for the appliance picker
If wanted, the appliance step can show one kitchen where tapping an appliance makes it glow.
- `KitchenScene`: 1200×900 PNG, opaque (cream `#FBF6EE` wall), a cosy front-on home kitchen in the clay style, with
  an oven and a stovetop, a microwave, an air fryer, a slow cooker and a blender, each clearly separated. Tomato and
  saffron accents, warm wood counter, no text, no logos, no dominant green.
- `KitchenHighlight-oven`, `-stovetop`, `-microwave`, `-airFryer`, `-slowCooker`, `-blender`: 1200×900 transparent PNG
  each, the same framing, only that appliance's soft tomato outline glow, so it lines up on top of the scene.

## 10. Tab bar icons (8)
Custom glyphs for the four tabs, so the bar feels like Tommo's own. The app draws them as **template images**
(one colour, tinted tomato when selected, grey when not), so each file must be a **single solid black shape on a
transparent background**: no colour, no shading, no gradients, no text, no fine detail (it shows at 26 pt).
**300×300 transparent PNG**, the glyph centred with ~10% padding, bold rounded strokes that match SF Pro Rounded
semibold (stroke about 9% of the canvas, round caps and joins). Two versions each: outline (`tab-<name>`) for the
unselected tab, and solid filled (`tab-<name>-fill`) for the selected tab.

| Files | What to draw |
|---|---|
| `tab-plan`, `tab-plan-fill` | A calendar page with a small fork and knife crossed on it |
| `tab-groceries`, `tab-groceries-fill` | A rounded shopping basket with a leafy carrot and a baguette poking out |
| `tab-cookbook`, `tab-cookbook-fill` | A closed recipe book with a small chef's hat on the cover |
| `tab-profile`, `tab-profile-fill` | A person's head and shoulders wearing a small chef's hat |

## 11. Interface glyphs (16), same style as the tab icons
Same spec as section 10: **300×300 transparent PNG**, one solid black shape, no colour, no shading, no text, bold
rounded strokes matching the tab icons. Outline style unless noted. Utility symbols (plus, close, chevrons, check,
trash, search) stay as Apple's SF Symbols on purpose.

| File | What to draw | Where it shows |
|---|---|---|
| `glyph-save` | A recipe card with a small bookmark ribbon | Recipe page "Save" |
| `glyph-add-to-plan` | A calendar page with a small plus | Recipe page "Meal Plan" |
| `glyph-add-to-groceries` | A small basket with a plus | Recipe page "Groceries", add buttons |
| `glyph-share` | A plate with an arrow rising out of it | Recipe page "Share" |
| `glyph-time` | A round kitchen timer with a knob on top | Cook time on cards and recipe facts |
| `glyph-calories` | A small flame | Calories |
| `glyph-cost` | A coin with a fork engraved on it | Price per serving |
| `glyph-servings` | Two plates side by side, seen from above | Servings |
| `glyph-swap` | Two curved arrows chasing round a plate | Swap a meal |
| `glyph-cook` | A frying pan with a little steam | "Start cooking" |
| `glyph-step-timer` | An egg timer (hourglass) | Step timers in a recipe |
| `glyph-reminder` | A bell with a small fork as the clapper | Reminders |
| `glyph-pantry` | A jar with a lid and a leaf label | Pantry |
| `glyph-store` | A small shop front with an awning | Shop on the plan header |
| `glyph-favorite` / `glyph-favorite-fill` | A heart made of two leaves (outline / solid) | Favourite a recipe |

## Do NOT generate
- **Supermarket logos.** Never have Grok draw or imitate them. The store tiles are logo-ready:
  once a retailer gives permission (or you use their official press-kit file under its terms), add it as
  an Image Set named `store-<id>` (ids are in `ForkcastCore/Resources/stores.json`, e.g. `store-tesco`).
  Use the official logo as a **wide transparent PNG (about 3:1, at least 600×200)**: it fills the store
  tiles, the globe ring and the "built for the shops in …" wall. Without one, the store's name is set in its
  brand colour (and the small round badges show the coloured monogram).
- **Fake reviews or user photos** for the testimonial carousel.
