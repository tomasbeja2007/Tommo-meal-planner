# Codex prompt: trending recipes, batch 4 (60 recipes)

Paste everything below the line into Codex. It is self-contained: the recipes are written out in full.

---

Read `CLAUDE.md` and `BUILD_NOTES.md` (section 3d) first, and follow the project's rules.

## Task

Add the 60 recipes below (30 dinners, 12 lunches, 10 breakfasts, 8 snacks) to the bundled
library as trending recipes, the same way as `Tools/trending_recipes.py`. Add batches 1 to 3 first (in this order) if they aren't in yet.

1. Create `Tools/trending_batch4.py`. Write each recipe with `T(...)` from `trending_recipes.py` (it adds the `trending` tag),
   passing `meal=L`, `meal=B` or `meal=S` for lunches, breakfasts and snacks. Import the list at the bottom of `Tools/recipes_data.py`
   and append it to `RECIPES`.
2. Every ingredient id below already exists in `Tools/ingredients_data.py` (including `stewing-beef`). Do not add or rename ingredients.
   Keep ids and titles exactly.
3. Run `python3 Tools/generate_data.py`, then `python3 Tools/generate_slideshows.py`.
4. In `LibraryValidationTests.swift`, update the expected recipe counts (total, per meal type, and trending) to match the new library.
5. Run `cd Packages/ForkcastCore && swift test`. If a recipe fails the calorie or step limits in `MealType`, adjust its amounts, never the limits.
6. If `testPlannerIsFast` fails, stop and report it rather than loosening the test.
7. Do not change any screen. Trending recipes show up in Discover's existing "Going viral" row automatically.

Checked before writing this prompt: with all six batches loaded on top of the current library (744 recipes), every recipe passed the
ingredient, unit, calorie, step and temperature tests, and the planner speed test passed. Every recipe also meets the Tommo
recipe rules for busy, budget-focused users: dinners about 30 minutes (45 max), at most 10 non-staple ingredients, at most 2
appliances, and a sensible cost per serving.

Each recipe: `id` · title · emoji · cuisine, then vibes · appliances · prep / cook minutes · servings · leftovers.
Ingredients are `ingredient-id amount unit (note)`. Steps are in order.

## Recipes

### Dinners (30)

#### `unstuffed-cabbage-roll-skillet` · Unstuffed cabbage roll skillet · 🥬 · Other
vibes: onePan, comfort, batchFriendly · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- ground-beef 500 g
- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- paprika 2 tsp
- dried-thyme 1 tsp
- tomato-paste 2 tbsp
- chopped-tomatoes 400 g
- long-grain-rice 150 g
- vegetable-bouillon 1 tsp
- cabbage 500 g (roughly chopped)
- red-wine-vinegar 1 tbsp
- sugar 1 tsp
- sour-cream 100 g
- salt 1 tsp

1. Heat the oil in a deep lidded pan over a high heat and press the beef down in one layer. Leave it for 4 minutes to brown, then break it up.
2. Add the onion for 4 minutes, then the garlic, paprika and thyme for 1 minute.
3. Stir in the tomato paste and cook for 2 minutes until it darkens.
4. Add the tomatoes, rice, 500 ml boiling water, the bouillon and salt, then pile the cabbage on top.
5. Cover and simmer for 20 minutes, stirring once, until the rice is tender and the cabbage silky.
6. Stir in the vinegar and sugar and serve with sour cream.

#### `lasagne-roll-ups` · Spinach & cheese lasagne roll-ups · 🍝 · Italian
vibes: family, comfort, batchFriendly · appliances: oven · prep 15 / cook 30 min · serves 4 · leftovers: yes

- lasagne-sheets 12 piece
- passata 700 g
- garlic 2 clove (crushed)
- italian-herbs 2 tsp
- cottage-cheese 300 g
- spinach-frozen 200 g (thawed and squeezed)
- parmesan 40 g (grated)
- mozzarella 1 piece (torn)
- salt 1 tsp

1. Heat the oven to 200°C (400°F). Soak the lasagne sheets in just-boiled water for 5 minutes until bendy.
2. Mix the passata with the garlic, herbs and salt and spread half in a baking dish.
3. Mix the cottage cheese, spinach and half the parmesan.
4. Spread each sheet with filling, roll up and sit seam-side down in the sauce.
5. Spoon over the rest of the sauce and top with mozzarella and parmesan.
6. Bake for 30 minutes until bubbling and the pasta is tender.

#### `chicken-parmesan-meatballs` · Chicken parmesan meatballs · 🍝 · Italian
vibes: family, highProtein, comfort · appliances: oven, stovetop · prep 15 / cook 25 min · serves 4 · leftovers: no

- chicken-breast 3 piece (very finely chopped or minced)
- breadcrumbs 50 g
- parmesan 60 g (grated)
- eggs 1 piece
- garlic 3 clove (crushed)
- italian-herbs 2 tsp
- olive-oil 1 tbsp
- passata 500 g
- chili-flakes 0.5 tsp
- mozzarella 1 piece (torn)
- spaghetti 300 g
- basil 15 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the chicken, breadcrumbs, half the parmesan, the egg, a third of the garlic, half the herbs and the salt. Roll into 16 meatballs with wet hands.
3. Roast on an oiled tray for 12 minutes until golden.
4. Meanwhile, cook the rest of the garlic and the chili in the oil in an ovenproof pan for 1 minute, add the passata and the rest of the herbs, and simmer for 8 minutes.
5. Nestle the meatballs into the sauce, top with mozzarella and the rest of the parmesan, and bake for 10 minutes until the cheese is blistered.
6. Cook the spaghetti and toss with a few spoons of the sauce.
7. Serve the meatballs over the spaghetti with torn basil.

#### `swedish-meatballs-mash` · Swedish meatballs with mash & gravy · 🍽️ · Other
vibes: comfort, family · appliances: stovetop · prep 15 / cook 25 min · serves 4 · leftovers: no

- ground-beef 500 g
- onion 0.5 piece (grated)
- breadcrumbs 40 g
- milk 300 ml
- eggs 1 piece
- butter 3 tbsp
- flour 2 tbsp
- vegetable-bouillon 2 tsp
- worcestershire 1 tbsp
- dijon-mustard 1 tsp
- potato 5 piece (peeled and chopped)
- salt 1 tsp

1. Mix the beef, onion, breadcrumbs, 3 tbsp milk, the egg and salt and roll into 20 small meatballs.
2. Boil the potatoes for 15 minutes, then mash with 1 tbsp butter and the rest of the milk.
3. Meanwhile, brown the meatballs in 1 tbsp butter for 8 minutes, shaking the pan, then set aside.
4. Melt the rest of the butter in the same pan, whisk in the flour and cook for 1 minute until nutty.
5. Whisk in 400 ml boiling water, the bouillon, Worcestershire and mustard and simmer until glossy.
6. Return the meatballs for 5 minutes and serve over the mash with lots of gravy.

#### `beef-stroganoff` · Beef stroganoff with rice · 🥩 · Other
vibes: comfort, quickEasy · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- beef-steak 2 piece (cut into thin strips)
- olive-oil 1 tbsp
- butter 1 tbsp
- onion 1 piece (thinly sliced)
- mushrooms 300 g (sliced)
- garlic 2 clove (crushed)
- paprika 1 tsp
- dijon-mustard 1 tbsp
- worcestershire 1 tbsp
- vegetable-bouillon 1 tsp
- sour-cream 150 g
- long-grain-rice 250 g
- salt 1 tsp
- black-pepper 1 pinch

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Season the beef and sear in the oil over a very high heat in two batches, 1 minute per side, so it stays pink. Set aside.
3. Add the butter, onion and mushrooms and cook for 8 minutes until golden and dry.
4. Stir in the garlic and paprika, then the mustard, Worcestershire, bouillon and 200 ml water, and bubble for 3 minutes.
5. Take off the heat, stir in the sour cream and return the beef to warm through.
6. Serve over the rice with plenty of black pepper.

#### `air-fryer-steak-frites` · Steak frites with garlic herb butter · 🥩 · Other
vibes: highProtein, comfort · appliances: airFryer, stovetop · prep 15 / cook 25 min · serves 2 · leftovers: no

- beef-steak 1 piece (at room temperature)
- potato 3 piece (cut into thin fries)
- olive-oil 1 tbsp
- butter 2 tbsp (softened)
- garlic 1 clove (crushed)
- parsley 10 g (finely chopped)
- lettuce 0.25 piece
- dijon-mustard 1 tsp
- salt 1 tsp
- black-pepper 1 pinch

1. Soak the fries in cold water for 10 minutes, then dry them really well — the secret to crisp fries.
2. Toss with half the oil and air-fry at 200°C (400°F) for 20 minutes, shaking every 5 minutes. Salt straight away.
3. Mash the butter with the garlic and parsley.
4. Season the steak and sear in a smoking-hot pan with the rest of the oil for 3 minutes on each side.
5. Rest for 5 minutes under a spoon of the herb butter, then slice — one big steak is plenty for two.
6. Serve with the fries and a lettuce salad dressed with the mustard and resting juices.

#### `homemade-doner-kebab` · Crispy doner-style lamb pittas · 🥙 · Middle Eastern
vibes: fakeaway, family, quickEasy · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- lamb-mince 500 g
- garlic 2 clove (crushed)
- cumin 2 tsp
- paprika 2 tsp
- dried-oregano 1 tsp
- ground-coriander 1 tsp
- salt 1 tsp
- pita-bread 4 piece
- lettuce 0.5 piece (shredded)
- red-onion 0.5 piece (thinly sliced)
- tomato 2 piece (sliced)
- greek-yogurt 150 g
- hot-sauce 2 tbsp

1. Mix the lamb with the spices, salt and half the garlic.
2. Press it thinly over a large hot dry pan and leave for 5 minutes until a deep crust forms underneath.
3. Flip in pieces and cook for 5 minutes more, then break into thin crispy shreds — just like shaved doner.
4. Mix the yogurt with the rest of the garlic and a pinch of salt.
5. Warm the pittas.
6. Stuff with lamb, lettuce, onion, tomato, garlic sauce and hot sauce.

#### `crispy-hoisin-pork-pancakes` · Crispy hoisin pork pancakes · 🥢 · Chinese
vibes: fakeaway, family · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- ground-pork 500 g
- five-spice 1 tsp
- garlic 2 clove (crushed)
- hoisin-sauce 5 tbsp
- soy-sauce 1 tbsp
- honey 1 tbsp
- vegetable-oil 1 tbsp
- tortillas 8 piece
- cucumber 1 piece (cut into matchsticks)
- spring-onion 5 piece (shredded)
- sesame-seeds 1 tsp

1. Heat the oil in a large pan over a high heat and press the pork into one layer.
2. Leave for 5 minutes until a crisp brown crust forms, then break up and keep frying for 4 minutes until crispy.
3. Add the garlic and five-spice for 30 seconds.
4. Stir in 3 tbsp hoisin, the soy sauce and honey and toss until sticky and glossy.
5. Warm the tortillas in a dry pan and cut each in half.
6. Spread each piece with a little hoisin, add pork, cucumber and spring onion, and roll up like a Peking duck pancake.
7. Scatter with sesame seeds.

#### `cashew-chicken` · Cashew chicken stir-fry · 🌰 · Chinese
vibes: fakeaway, quickEasy, highProtein · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- chicken-thighs 500 g (cut into bite-size pieces)
- cornstarch 2 tsp
- soy-sauce 3 tbsp
- vegetable-oil 1 tbsp
- cashews 60 g
- bell-pepper 1 piece (diced)
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- hoisin-sauce 2 tbsp
- honey 1 tsp
- spring-onion 3 piece (sliced)
- long-grain-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the chicken with the cornstarch and 1 tbsp soy sauce.
3. Toast the cashews in a dry wok for 3 minutes until golden, then tip out.
4. Heat the oil until smoking and stir-fry the chicken for 5 minutes until browned.
5. Add the pepper, onion and garlic for 3 minutes, then the rest of the soy, the hoisin and honey for 1 minute.
6. Toss through the cashews and spring onions and serve over the rice.

#### `firecracker-turkey-meatballs` · Firecracker turkey meatballs · 🧨 · American
vibes: fakeaway, highProtein, family · appliances: oven, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- ground-turkey 500 g
- breadcrumbs 40 g
- eggs 1 piece
- garlic 3 clove (crushed)
- spring-onion 4 piece (sliced)
- soy-sauce 2 tbsp
- hot-sauce 4 tbsp
- honey 4 tbsp
- chili-flakes 0.5 tsp
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)
- sesame-seeds 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the turkey, breadcrumbs, egg, half the garlic, half the spring onions and 1 tbsp soy sauce, and roll into 20 meatballs.
3. Roast on a lined tray for 15 minutes until golden.
4. Cook the rice, adding the broccoli for the last 4 minutes, then drain.
5. Simmer the hot sauce, honey, chili, the rest of the garlic and soy sauce for 3 minutes until sticky, then toss the meatballs in it.
6. Serve over the rice and broccoli with the rest of the spring onions and sesame.

#### `hot-honey-chorizo-flatbread-pizza` · Hot honey chorizo flatbread pizza · 🍕 · Italian
vibes: fakeaway, family · appliances: oven · prep 15 / cook 12 min · serves 4 · leftovers: no

- flour 250 g
- greek-yogurt 250 g
- baking-powder 2 tsp
- passata 150 g
- dried-oregano 1 tsp
- garlic 1 clove (crushed)
- mozzarella 2 piece (torn)
- chorizo 80 g (thinly sliced)
- honey 2 tbsp
- chili-flakes 1 tsp
- arugula 40 g
- salt 1 pinch

1. Heat the oven to its highest setting, at least 240°C (465°F), with a tray inside.
2. Mix the flour, yogurt, baking powder and salt into a soft dough and knead for 1 minute. Split in two and roll out thinly.
3. Mix the passata with the oregano, garlic and a pinch of salt.
4. Carefully lay the bases on the hot tray and spread thinly with the sauce.
5. Top with mozzarella and chorizo and bake for 10–12 minutes until the base is crisp and the chorizo curls up.
6. Warm the honey with the chili flakes.
7. Drizzle the hot honey over the pizzas and top with arugula.

#### `yogurt-dough-margherita` · Two-ingredient dough margherita pizza · 🍕 · Italian
vibes: family, quickEasy · appliances: oven · prep 15 / cook 12 min · serves 4 · leftovers: no

- flour 250 g
- greek-yogurt 250 g
- baking-powder 2 tsp
- chopped-tomatoes 400 g
- garlic 1 clove (crushed)
- olive-oil 2 tbsp
- mozzarella 2 piece (torn and patted dry)
- parmesan 20 g (grated)
- basil 20 g
- salt 1 tsp

1. Heat the oven to its highest setting, at least 240°C (465°F), with a tray inside.
2. Drain the tomatoes in a sieve for 5 minutes, then mix with the garlic, 1 tbsp oil and the salt — draining stops a soggy base.
3. Mix the flour, yogurt and baking powder into a soft dough, knead briefly, split in two and roll out thinly.
4. Lay the bases on the hot tray, spread with the tomato and dot with mozzarella.
5. Bake for 10–12 minutes until blistered and crisp underneath.
6. Finish with parmesan, lots of basil and the rest of the oil.

#### `yogurt-dough-calzone` · Ham, mushroom & cheese calzones · 🥟 · Italian
vibes: family, fakeaway · appliances: oven, stovetop · prep 20 / cook 18 min · serves 4 · leftovers: no

- flour 300 g
- greek-yogurt 300 g
- baking-powder 2 tsp
- mushrooms 150 g (sliced)
- olive-oil 1 tbsp
- ham 4 slice (torn)
- passata 200 g
- dried-oregano 1 tsp
- mozzarella 1 piece (torn)
- spinach 60 g
- eggs 1 piece (beaten)
- parmesan 20 g (grated)
- salt 1 pinch

1. Heat the oven to 220°C (425°F).
2. Fry the mushrooms in the oil for 6 minutes until golden and dry.
3. Mix the flour, yogurt, baking powder and salt into a dough and split into 4. Roll each into a 20 cm circle.
4. Mix half the passata with the oregano and spread over one half of each circle, leaving a border.
5. Top with ham, mushrooms, spinach and mozzarella, fold over and crimp the edges tightly.
6. Brush with egg, sprinkle with parmesan, cut a small slit in each and bake for 18 minutes until puffed and golden.
7. Warm the rest of the passata for dipping.

#### `cheesy-chicken-broccoli-rice` · Cheesy chicken & broccoli rice · 🥦 · American
vibes: comfort, family, onePan · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chicken-breast 2 piece (diced)
- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- long-grain-rice 200 g
- vegetable-bouillon 2 tsp
- broccoli 1 piece (cut into small florets)
- cream-cheese 80 g
- cheddar 150 g (grated)
- dijon-mustard 1 tsp
- salt 1 tsp

1. Brown the chicken in the oil in a deep lidded pan for 5 minutes, then add the onion and garlic for 3 minutes.
2. Stir in the rice, 600 ml boiling water, the bouillon and salt, cover and simmer for 12 minutes.
3. Lay the broccoli on top, cover and cook for 5 minutes more.
4. Stir in the cream cheese, mustard and most of the cheddar until creamy.
5. Scatter with the rest of the cheese and cover for 1 minute to melt.
6. Serve straight from the pan.

#### `chicken-fajita-pasta` · Creamy chicken fajita pasta · 🌶️ · Mexican
vibes: family, quickEasy · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- penne 300 g
- chicken-breast 2 piece (sliced)
- olive-oil 1 tbsp
- paprika 2 tsp
- cumin 1 tsp
- chili-powder 1 tsp
- garlic-powder 1 tsp
- bell-pepper 2 piece (sliced)
- red-onion 1 piece (sliced)
- chopped-tomatoes 400 g
- cream-cheese 80 g
- cheddar 50 g (grated)
- lime 1 piece
- cilantro 15 g
- salt 1 tsp

1. Cook the pasta in salted boiling water, saving a mug of water before draining.
2. Toss the chicken with the spices and salt.
3. Sear the chicken in the oil over a high heat for 5 minutes until charred, then set aside.
4. Cook the peppers and onion in the same pan for 5 minutes until blistered at the edges.
5. Add the tomatoes and cream cheese and stir into a smoky, creamy sauce.
6. Toss in the pasta, chicken, cheddar and a splash of pasta water.
7. Finish with lime juice and cilantro.

#### `lemon-butter-salmon-pasta` · Lemon garlic butter salmon pasta · 🍋 · Italian
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- spaghetti 350 g
- salmon-fillet 2 piece
- butter 3 tbsp
- garlic 3 clove (crushed)
- lemon 1 piece
- spinach-frozen 150 g
- parmesan 30 g (grated)
- chili-flakes 0.5 tsp
- salt 1 tsp

1. Cook the spaghetti in salted boiling water, saving a mug of water before draining.
2. Season the salmon and cook in 1 tbsp butter for 4 minutes on each side, then flake into big chunks.
3. Melt the rest of the butter in the pan with the garlic and chili for 1 minute.
4. Add the spinach and the lemon zest and juice and stir until hot.
5. Toss in the spaghetti, parmesan and a splash of pasta water until glossy.
6. Fold through the salmon gently and serve — two fillets go a long way this way.

#### `crispy-chicken-burgers` · Air-fryer crispy chicken burgers with slaw · 🍔 · American
vibes: fakeaway, family, highProtein · appliances: airFryer · prep 15 / cook 15 min · serves 4 · leftovers: no

- chicken-breast 2 piece (halved horizontally)
- greek-yogurt 100 g
- hot-sauce 1 tbsp
- breadcrumbs 80 g
- paprika 2 tsp
- garlic-powder 1 tsp
- burger-buns 4 piece
- cabbage 150 g (finely shredded)
- carrot 1 piece (grated)
- mayonnaise 3 tbsp
- lime 1 piece
- lettuce 0.25 piece
- salt 1 tsp

1. Marinate the chicken in the yogurt, hot sauce and salt for at least 10 minutes — the yogurt keeps it juicy.
2. Mix the breadcrumbs, paprika and garlic powder and press the chicken into them firmly.
3. Air-fry at 200°C (400°F) for 12–14 minutes, turning halfway, until deep golden and cooked through.
4. Toss the cabbage and carrot with 2 tbsp mayonnaise and the lime juice for a crunchy slaw.
5. Toast the buns cut-side down in a dry pan.
6. Build with mayonnaise, lettuce, crispy chicken and a pile of slaw.

#### `halloumi-burgers` · Halloumi burgers with sweet chili mayo · 🍔 · Mediterranean
vibes: quickEasy, family · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- halloumi 500 g (cut into 8 thick slices)
- burger-buns 4 piece
- mayonnaise 3 tbsp
- sweet-chili-sauce 2 tbsp
- roasted-peppers 120 g
- arugula 40 g
- red-onion 0.5 piece (thinly sliced)
- lime 0.5 piece
- avocado 1 piece (sliced)

1. Toss the onion with the lime juice and a pinch of salt and leave for 5 minutes to quick-pickle.
2. Mix the mayonnaise with the sweet chili sauce.
3. Fry the halloumi in a dry pan over a medium-high heat for 2 minutes on each side until deeply golden.
4. Warm the roasted peppers in the same pan.
5. Toast the buns cut-side down.
6. Build with sweet chili mayo, arugula, two slices of halloumi, peppers, avocado and pickled onion.

#### `steak-potato-foil-packets` · Garlic butter steak & potato foil packets · 🥩 · American
vibes: highProtein, family · appliances: oven, stovetop · prep 15 / cook 25 min · serves 4 · leftovers: no

- beef-steak 2 piece (cut into chunks)
- potato 4 piece (cut into small cubes)
- green-beans 250 g
- butter 3 tbsp (melted)
- garlic 4 clove (crushed)
- paprika 1 tsp
- dried-thyme 1 tsp
- worcestershire 1 tbsp
- salt 1 tsp
- black-pepper 1 pinch

1. Heat the oven to 220°C (425°F).
2. Par-boil the potatoes for 5 minutes, then drain well.
3. Mix the butter, garlic, paprika, thyme, Worcestershire, salt and pepper.
4. Toss the steak, potatoes and beans in the garlic butter.
5. Split between 4 large sheets of foil and fold into sealed packets.
6. Bake for 18–20 minutes so the steak stays juicy, then open carefully.

#### `moroccan-lamb-meatballs` · Moroccan lamb meatballs with couscous · 🧆 · Middle Eastern
vibes: family, comfort · appliances: stovetop · prep 15 / cook 25 min · serves 4 · leftovers: no

- lamb-mince 500 g
- onion 1 piece (half grated, half diced)
- cumin 2 tsp
- cinnamon 1 tsp
- paprika 1 tsp
- garlic 3 clove (crushed)
- olive-oil 1 tbsp
- chopped-tomatoes 400 g
- honey 1 tbsp
- chickpeas 240 g (drained)
- couscous 250 g
- vegetable-bouillon 1 tsp
- greek-yogurt 150 g
- lemon 1 piece
- salt 1 tsp

1. Mix the lamb with the grated onion, half the spices, a third of the garlic and the salt, and roll into 20 meatballs.
2. Brown them in the oil in a deep pan for 6 minutes, then set aside.
3. Cook the diced onion for 5 minutes, then the rest of the garlic and spices for 1 minute.
4. Add the tomatoes, honey and chickpeas, return the meatballs and simmer for 12 minutes.
5. Pour 350 ml boiling water and the bouillon over the couscous, cover for 5 minutes, fluff and add the lemon zest.
6. Serve the meatballs over the couscous with yogurt and lemon wedges.

#### `cajun-shrimp-boil-traybake` · Cajun shrimp boil traybake · 🦐 · American
vibes: family, onePan · appliances: oven · prep 10 / cook 35 min · serves 4 · leftovers: no

- potato 4 piece (cut into chunks)
- corn-on-cob 3 piece (cut into thirds)
- sausages 3 piece (sliced)
- shrimp 250 g
- butter 3 tbsp (melted)
- garlic 4 clove (crushed)
- paprika 2 tsp
- garlic-powder 1 tsp
- onion-powder 1 tsp
- dried-thyme 1 tsp
- chili-powder 0.5 tsp
- lemon 1 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the melted butter with the garlic, spices and salt.
3. Toss the potatoes and corn with half the Cajun butter on a large tray and roast for 20 minutes.
4. Add the sausage and roast for 8 minutes.
5. Toss the shrimp in the rest of the Cajun butter, add to the tray and roast for 6 minutes until pink.
6. Squeeze over the lemon and serve straight from the tray.

#### `no-stir-baked-mushroom-risotto` · No-stir baked chicken & mushroom risotto · 🍄 · Italian
vibes: comfort, onePan, family · appliances: stovetop, oven · prep 10 / cook 30 min · serves 4 · leftovers: no

- olive-oil 1 tbsp
- butter 2 tbsp
- chicken-thighs 400 g (diced)
- mushrooms 300 g (sliced)
- onion 1 piece (finely diced)
- garlic 2 clove (crushed)
- arborio-rice 300 g
- chicken-stock 1000 ml
- dried-thyme 1 tsp
- parmesan 60 g (grated)
- spinach 80 g
- lemon 0.5 piece
- black-pepper 1 pinch

1. Heat the oven to 200°C (400°F).
2. Brown the chicken and mushrooms in the oil and 1 tbsp butter in an ovenproof pan for 7 minutes.
3. Add the onion, garlic and thyme for 3 minutes, then stir in the rice for 1 minute until glossy.
4. Pour in the hot stock, cover and bake for 20 minutes.
5. Stir in the spinach, parmesan and the rest of the butter vigorously for 1 minute — this makes it creamy.
6. Finish with lemon juice and pepper and serve straight away.

#### `butternut-squash-mac-cheese` · One-pot butternut squash mac & cheese · 🧀 · American
vibes: comfort, family, healthyish · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- butternut-squash 0.5 piece (peeled and cut into small cubes)
- garlic 2 clove (peeled)
- milk 500 ml
- penne 300 g
- cheddar 150 g (grated)
- dijon-mustard 1 tsp
- paprika 1 tsp
- salt 1 tsp

1. Simmer the squash and garlic in the milk with the salt in a large pan for 12 minutes until very soft.
2. Mash it right in the pan with a potato masher until smooth — no blender needed.
3. Meanwhile, cook the pasta, then drain.
4. Stir the cheddar, mustard and paprika into the squash sauce until melted and silky.
5. Toss in the pasta, loosening with a splash of milk or water.
6. Serve with an extra pinch of paprika.

#### `butternut-chickpea-curry` · Butternut squash & chickpea coconut curry · 🎃 · Indian
vibes: healthyish, batchFriendly, comfort · appliances: stovetop · prep 15 / cook 30 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- curry-powder 1 tbsp
- garam-masala 1 tsp
- turmeric 1 tsp
- butternut-squash 0.5 piece (peeled and cubed)
- chickpeas 480 g (drained)
- chopped-tomatoes 400 g
- coconut-milk 400 ml
- lime 1 piece
- basmati-rice 250 g

1. Cook the onion in the oil for 6 minutes until soft and golden.
2. Add the garlic, ginger and spices and cook for 1 minute until fragrant.
3. Add the squash, chickpeas, tomatoes and coconut milk and simmer for 20 minutes until the squash is tender.
4. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
5. Crush a few pieces of squash into the sauce to thicken it and brighten with the lime juice.
6. Serve over the rice.

#### `peanut-chicken-mafe` · West African-style peanut chicken stew · 🥜 · Other
vibes: comfort, batchFriendly · appliances: stovetop · prep 10 / cook 35 min · serves 4 · leftovers: yes

- chicken-thighs 600 g
- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- chili-powder 1 tsp
- chopped-tomatoes 400 g
- peanut-butter 5 tbsp
- vegetable-bouillon 1 tsp
- sweet-potato 1 piece (cubed)
- long-grain-rice 250 g
- peanuts 30 g (chopped)
- lime 1 piece
- salt 1 tsp

1. Season the chicken and brown in the oil for 6 minutes, then set aside.
2. Cook the onion for 5 minutes, then the garlic and chili for 1 minute.
3. Whisk the peanut butter into 400 ml boiling water with the bouillon, then add it with the tomatoes, sweet potato and chicken.
4. Simmer gently for 25 minutes until rich and the chicken is tender.
5. Cook the rice in salted boiling water for 12 minutes, then drain.
6. Serve over rice with chopped peanuts and lime.

#### `chicken-chorizo-potato-traybake` · Chicken, chorizo & potato traybake · 🥘 · Spanish/Portuguese
vibes: onePan, family · appliances: oven · prep 10 / cook 35 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- chorizo 120 g (sliced)
- potato 4 piece (cut into small chunks)
- red-onion 2 piece (cut into wedges)
- bell-pepper 2 piece (chopped)
- olive-oil 1 tbsp
- paprika 2 tsp
- garlic 4 clove (bashed)
- dried-oregano 1 tsp
- lemon 1 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the potatoes, onions, peppers and garlic with the oil, paprika, oregano and salt on a large tray — small potato chunks cook in time with the chicken.
3. Sit the chicken on top and scatter the chorizo around.
4. Roast for 35 minutes until the chicken is crisp and the chorizo oil has run into the potatoes.
5. Squeeze over the lemon.
6. Serve straight from the tray.

#### `baked-orzo-zucchini-feta` · Baked lemon orzo with zucchini & feta · 🍋 · Mediterranean
vibes: onePan, healthyish, family · appliances: oven · prep 10 / cook 30 min · serves 4 · leftovers: no

- orzo 300 g
- zucchini 2 piece (grated)
- garlic 3 clove (crushed)
- vegetable-stock 800 ml
- lemon 1 piece
- cherry-tomatoes 200 g
- feta 200 g
- olive-oil 2 tbsp
- dried-oregano 1 tsp
- spinach 80 g
- basil 15 g
- chili-flakes 0.5 tsp

1. Heat the oven to 200°C (400°F).
2. Stir the orzo, zucchini, garlic, spinach, oregano, lemon zest and hot stock together in a baking dish.
3. Scatter the tomatoes over, sit the block of feta in the middle and drizzle everything with the oil.
4. Cover tightly with foil and bake for 20 minutes.
5. Uncover and bake for 10 minutes until the orzo is tender and the feta is golden at the edges.
6. Break up the feta, squeeze over the lemon and finish with basil and chili.

#### `slow-cooker-chicken-sausage-cassoulet` · Slow-cooker chicken & sausage cassoulet · 🫘 · Other
vibes: batchFriendly, comfort, family · appliances: slowCooker, stovetop · prep 15 / cook 360 min · serves 4 · leftovers: yes

- chicken-thighs 500 g
- sausages 4 piece
- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- garlic 4 clove (crushed)
- tomato-paste 2 tbsp
- chopped-tomatoes 400 g
- cannellini-beans 480 g (drained)
- vegetable-bouillon 1 tsp
- dried-thyme 1 tsp
- breadcrumbs 50 g
- baguette 1 piece
- salt 1 tsp

1. Brown the sausages and chicken in the oil for 6 minutes — colour here means flavour later — and put them in the slow cooker.
2. Soften the onion and carrot in the same pan for 5 minutes, then stir in the garlic and tomato paste for 2 minutes.
3. Add to the slow cooker with the tomatoes, beans, bouillon, thyme, salt and 300 ml water.
4. Cook on low for 6 hours until the chicken is falling apart, then slice the sausages back in.
5. Toast the breadcrumbs in a dry pan with a drizzle of oil until golden and scatter over.
6. Serve with crusty bread.

#### `slow-cooker-beef-ragu` · Slow-cooker beef ragù with penne · 🍝 · Italian
vibes: batchFriendly, comfort, family · appliances: slowCooker, stovetop · prep 15 / cook 420 min · serves 4 · leftovers: yes

- stewing-beef 600 g
- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- celery 2 piece (diced)
- garlic 3 clove (crushed)
- tomato-paste 2 tbsp
- chopped-tomatoes 800 g
- italian-herbs 2 tsp
- balsamic-vinegar 1 tbsp
- penne 350 g
- parmesan 40 g (grated)
- salt 1 tsp

1. Season the beef and brown hard in the oil for 5 minutes, then put in the slow cooker.
2. Cook the onion, carrot and celery in the same pan for 6 minutes, then the garlic and tomato paste for 2 minutes.
3. Add to the slow cooker with the tomatoes, herbs and salt.
4. Cook on low for 7 hours until the beef falls apart.
5. Shred the beef into the sauce and stir in the balsamic.
6. Toss with the cooked pasta and a splash of pasta water and serve with parmesan.

#### `slow-cooker-thai-peanut-chicken` · Slow-cooker Thai peanut chicken · 🥜 · Thai
vibes: batchFriendly, family · appliances: slowCooker, stovetop · prep 10 / cook 240 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- peanut-butter 5 tbsp
- coconut-milk 400 ml
- soy-sauce 3 tbsp
- thai-curry-paste 1 tbsp
- honey 1 tbsp
- garlic 3 clove (crushed)
- bell-pepper 2 piece (sliced)
- lime 2 piece
- basmati-rice 250 g

1. Whisk the peanut butter, coconut milk, soy sauce, curry paste, honey and garlic in the slow cooker.
2. Add the chicken and peppers and turn to coat.
3. Cook on low for 4 hours until tender.
4. Shred the chicken into the sauce and squeeze in the juice of 1 lime.
5. Cook the rice in salted boiling water for 12 minutes, then drain.
6. Serve over rice with lime wedges.

### Lunchs (12)

#### `folded-tortilla-wrap-hack` · Folded tortilla wrap hack · 🌯 · American
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- tortillas 2 piece
- ham 4 slice
- cheddar 60 g (grated)
- avocado 1 piece (mashed)
- tomato 1 piece (sliced)
- spinach 30 g
- mayonnaise 1 tbsp
- sriracha 1 tsp

1. Cut a slit from the centre of each tortilla to the edge.
2. Picture four quarters: cover one with ham, one with cheddar, one with avocado and one with tomato, spinach and sriracha mayo.
3. Fold the first quarter up over the next, and keep folding round into a layered triangle.
4. Toast in a dry pan for 2 minutes on each side, pressing down, until crisp and the cheese melts.

#### `crispy-chickpea-caesar` · Crispy chickpea Caesar salad · 🥗 · American
vibes: healthyish, quickEasy · appliances: oven · prep 10 / cook 20 min · serves 2 · leftovers: no

- chickpeas 240 g (drained and patted dry)
- sourdough 1 slice (torn)
- olive-oil 2 tbsp
- paprika 1 tsp
- lettuce 0.5 piece (chopped)
- greek-yogurt 60 g
- parmesan 20 g (finely grated)
- lemon 1 piece
- dijon-mustard 1 tsp
- garlic 1 clove (crushed)

1. Heat the oven to 200°C (400°F). Toss the chickpeas and bread with the oil and paprika and roast for 20 minutes until crunchy.
2. Whisk the yogurt, half the parmesan, the lemon juice, mustard and garlic into a punchy dressing.
3. Toss the lettuce in the dressing until every leaf is coated.
4. Pile on the crispy chickpeas and croutons and finish with the rest of the parmesan.

#### `khao-soi-style-chicken-soup` · Khao soi-style curry noodle soup · 🍜 · Thai
vibes: comfort, fakeaway · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- vegetable-oil 1 tbsp
- thai-curry-paste 3 tbsp
- curry-powder 1 tsp
- turmeric 0.5 tsp
- coconut-milk 400 ml
- chicken-stock 600 ml
- chicken-thighs 400 g (sliced)
- fish-sauce 1 tbsp
- sugar 1 tsp
- egg-noodles 250 g
- red-onion 0.5 piece (thinly sliced)
- lime 1 piece
- cilantro 15 g
- chili-flakes 0.5 tsp

1. Fry the curry paste, curry powder and turmeric in the oil for 1 minute until fragrant.
2. Add the coconut milk, stock and chicken and simmer for 12 minutes until the chicken is tender. Season with fish sauce and sugar.
3. Cook the noodles, and fry a small handful of them in a little oil until crisp for the topping.
4. Ladle the curry over the soft noodles and top with crispy noodles, red onion, cilantro, chili and lime.

#### `kimbap-rolls` · Tuna & egg kimbap rolls · 🍙 · Korean
vibes: family, highProtein · appliances: stovetop, microwave · prep 20 / cook 8 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- sesame-oil 2 tsp
- nori 3 piece
- eggs 2 piece (beaten)
- canned-tuna 145 g (drained)
- mayonnaise 1 tbsp
- carrot 1 piece (cut into matchsticks)
- spinach 60 g
- cucumber 0.5 piece (cut into long strips)
- sesame-seeds 1 tsp

1. Heat the rice and season with half the sesame oil and a pinch of salt.
2. Cook the egg as a thin omelette and cut into strips. Quickly fry the carrot, then wilt the spinach with a pinch of salt.
3. Lay a nori sheet on a board, spread a thin layer of rice over two-thirds, and line up tuna mayo, egg, carrot, spinach and cucumber near the bottom edge.
4. Roll up tightly, brush with the rest of the sesame oil, sprinkle with sesame and slice with a wet knife. Repeat.

#### `butternut-red-pepper-soup` · Butternut squash & red pepper soup · 🎃 · Other
vibes: comfort, healthyish, batchFriendly · appliances: stovetop, blender · prep 10 / cook 25 min · serves 4 · leftovers: yes

- butternut-squash 1 piece (peeled and cubed)
- bell-pepper 2 piece (chopped)
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- olive-oil 2 tbsp
- paprika 1 tsp
- vegetable-bouillon 3 tsp
- sour-cream 80 g
- sourdough 4 slice
- salt 1 tsp

1. Cook the onion, peppers and garlic in the oil for 6 minutes, then stir in the paprika.
2. Add the squash, 900 ml boiling water and the bouillon and simmer for 18 minutes until soft.
3. Blend until velvety and season.
4. Serve with a swirl of sour cream and toast.

#### `crispy-chicken-cheese-quesadillas` · Crispy chicken & cheese quesadillas · 🫓 · Mexican
vibes: family, highProtein · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- chicken-breast 1 piece (diced)
- paprika 1 tsp
- cumin 0.5 tsp
- olive-oil 1 tsp
- tortillas 2 piece
- cheddar 80 g (grated)
- spring-onion 2 piece (sliced)
- salsa 80 g
- sour-cream 60 g
- lime 0.5 piece

1. Toss the chicken with the spices and cook in the oil for 6 minutes until golden.
2. Scatter cheese over half of each tortilla, add the chicken and spring onion and top with more cheese — cheese on both sides glues it together.
3. Fold and cook in a dry pan over a medium heat for 3 minutes on each side until deep golden.
4. Cut into wedges and serve with salsa, sour cream and lime.

#### `freezer-bean-cheese-burritos` · Freezer bean & cheese burritos · 🌯 · Mexican
vibes: batchFriendly, family · appliances: stovetop · prep 15 / cook 10 min · serves 4 · leftovers: no

- black-beans 480 g (drained)
- olive-oil 1 tbsp
- onion 0.5 piece (diced)
- cumin 1 tsp
- chili-powder 1 tsp
- microwave-rice 1 piece
- salsa 150 g
- cheddar 120 g (grated)
- tortillas 4 piece
- lime 1 piece

1. Cook the onion in the oil for 5 minutes, add the spices and beans and mash roughly with a splash of water.
2. Heat the rice and mix with the lime juice.
3. Fill each tortilla with beans, rice, salsa and cheese, fold in the sides and roll tightly.
4. Toast seam-side down in a dry pan until golden, or wrap in foil and freeze. Microwave from frozen for 3 minutes.

#### `thai-beef-salad` · Thai beef & noodle salad · 🥩 · Thai
vibes: highProtein, healthyish · appliances: stovetop · prep 15 / cook 8 min · serves 4 · leftovers: no

- beef-steak 1 piece
- vegetable-oil 1 tsp
- rice-noodles 150 g
- cucumber 1 piece (sliced)
- red-onion 0.5 piece (thinly sliced)
- cilantro 15 g
- lettuce 0.5 piece
- lime 2 piece
- fish-sauce 1 tbsp
- sugar 1 tsp
- chili-flakes 0.5 tsp
- peanuts 30 g (chopped)

1. Soak the noodles in just-boiled water for 6 minutes, then rinse cold.
2. Sear the steak in the oil in a smoking-hot pan for 3 minutes on each side, rest for 5 minutes and slice thinly — one steak flavours the whole salad.
3. Whisk the lime juice, fish sauce, sugar and chili; it should taste hot, sour, salty and sweet at once.
4. Toss the noodles, lettuce, cucumber, onion and cilantro with most of the dressing, top with the beef and peanuts and spoon over the rest.

#### `antipasto-chickpea-salad` · Antipasto chickpea salad · 🫒 · Italian
vibes: healthyish, batchFriendly · appliances: none · prep 15 / cook 0 min · serves 4 · leftovers: yes

- chickpeas 480 g (drained)
- roasted-peppers 150 g (sliced)
- olives 80 g (halved)
- mozzarella 1 piece (torn)
- ham 4 slice (torn)
- tomato 2 piece (diced)
- red-onion 0.25 piece (thinly sliced)
- olive-oil 3 tbsp
- red-wine-vinegar 2 tbsp
- dried-oregano 1 tsp

1. Whisk the oil, vinegar and oregano.
2. Toss the chickpeas, peppers, olives, tomato and onion in the dressing and leave for 10 minutes.
3. Fold in the ham and mozzarella.
4. It keeps for 3 days in the fridge.

#### `miso-glazed-eggplant-bowl` · Miso glazed eggplant rice bowl · 🍆 · Japanese
vibes: healthyish, comfort · appliances: oven, microwave · prep 10 / cook 25 min · serves 2 · leftovers: no

- eggplant 1 piece (halved lengthways and scored)
- vegetable-oil 1 tbsp
- miso-paste 2 tbsp
- honey 1 tbsp
- rice-vinegar 1 tsp
- microwave-rice 1 piece
- edamame-frozen 100 g
- cucumber 0.5 piece (sliced)
- spring-onion 2 piece (sliced)
- sesame-seeds 1 tsp

1. Heat the oven to 220°C (425°F). Brush the cut side of the eggplant with oil and roast cut-side down for 20 minutes until meltingly soft.
2. Mix the miso, honey and vinegar, flip the eggplant, spread with the glaze and roast for 5 minutes until bubbling and caramelised.
3. Heat the rice with the edamame.
4. Serve the eggplant over the rice with cucumber, spring onion and sesame.

#### `zucchini-corn-fritters` · Zucchini & corn fritters with tomato salsa · 🌽 · Other
vibes: healthyish, family · appliances: stovetop · prep 15 / cook 12 min · serves 2 · leftovers: no

- zucchini 1 piece (grated and squeezed very dry)
- corn-frozen 150 g (thawed)
- eggs 2 piece
- flour 60 g
- feta 50 g (crumbled)
- spring-onion 2 piece (sliced)
- olive-oil 2 tbsp
- tomato 2 piece (diced)
- lime 1 piece

1. Mix the zucchini, corn, eggs, flour, feta and spring onion — squeezing the zucchini dry keeps them crisp.
2. Fry heaped spoonfuls in the oil for 3 minutes on each side until golden.
3. Mix the tomato with the lime juice and a pinch of salt.
4. Serve the hot fritters with the salsa on top.

#### `chicken-gyro-pitta-salad` · Chicken gyro chopped salad with pitta croutons · 🥙 · Mediterranean
vibes: highProtein, healthyish · appliances: stovetop · prep 15 / cook 10 min · serves 2 · leftovers: no

- chicken-breast 1 piece (sliced)
- dried-oregano 1 tsp
- paprika 1 tsp
- lemon 1 piece
- olive-oil 2 tbsp
- pita-bread 1 piece (cut into squares)
- cucumber 0.5 piece (diced)
- tomato 1 piece (diced)
- lettuce 0.5 piece (chopped)
- feta 25 g (crumbled)
- greek-yogurt 60 g
- garlic 1 clove (crushed)

1. Toss the chicken with the oregano, paprika, half the lemon juice and 1 tbsp oil, then fry for 7 minutes until charred.
2. Fry the pitta squares in the rest of the oil until crunchy.
3. Mix the yogurt with the garlic and the rest of the lemon juice.
4. Toss everything together with the garlic yogurt and top with feta.

### Breakfasts (10)

#### `pesto-eggs-on-toast` · Crispy pesto eggs on toast · 🍳 · Italian
vibes: quickEasy, highProtein · appliances: stovetop · prep 2 / cook 5 min · serves 2 · leftovers: no

- pesto 2 tbsp
- eggs 4 piece
- sourdough 2 slice
- chili-flakes 1 pinch

1. Spoon the pesto into a cold non-stick pan and heat until it sizzles.
2. Crack the eggs straight into the pesto and fry for 3 minutes until the edges are lacy and crisp.
3. Toast the bread.
4. Slide the eggs on top and finish with chili.

#### `cheesy-egg-in-a-hole` · Cheesy egg-in-a-hole toast · 🍞 · American
vibes: quickEasy, family · appliances: stovetop · prep 2 / cook 6 min · serves 2 · leftovers: no

- sourdough 2 slice
- butter 1 tbsp
- eggs 2 piece
- cheddar 40 g (grated)
- spring-onion 1 piece (sliced)
- black-pepper 1 pinch
- cherry-tomatoes 100 g

1. Cut a hole in the middle of each slice of bread with a glass.
2. Melt the butter in a frying pan, add the bread and crack an egg into each hole.
3. Scatter cheese around the edge, cook for 2 minutes, then flip carefully and cook for 1 minute so the cheese crisps underneath.
4. Fry the cut-out circles alongside for dipping and serve with blistered tomatoes and spring onion.

#### `mini-pancake-cereal` · Mini pancake cereal · 🥞 · American
vibes: family, comfort · appliances: stovetop · prep 5 / cook 12 min · serves 2 · leftovers: no

- flour 100 g
- baking-powder 1 tsp
- eggs 1 piece
- milk 150 ml
- maple-syrup 2 tbsp
- vegetable-oil 1 tsp
- berries-frozen 100 g (thawed)
- greek-yogurt 100 g

1. Whisk the flour, baking powder, egg, milk and 1 tbsp maple syrup into a smooth batter and pour into a zip bag with a corner snipped off.
2. Wipe a non-stick pan with oil and squeeze in lots of coin-sized dots.
3. Cook for 1 minute until bubbles appear, flip and cook for 30 seconds.
4. Pile into bowls with berries, yogurt and the rest of the maple syrup, and eat with a spoon like cereal.

#### `sheet-pan-pancakes` · Sheet-pan berry pancakes · 🥞 · American
vibes: family, batchFriendly · appliances: oven · prep 5 / cook 15 min · serves 4 · leftovers: no

- flour 250 g
- baking-powder 3 tsp
- eggs 2 piece
- milk 350 ml
- butter 2 tbsp (melted)
- maple-syrup 3 tbsp
- berries-frozen 200 g

1. Heat the oven to 220°C (425°F) and line a baking tray.
2. Whisk the flour, baking powder, eggs, milk, butter and 1 tbsp maple syrup into a smooth batter.
3. Pour onto the tray and scatter with the berries.
4. Bake for 15 minutes until golden and springy, then cut into squares and drizzle with the rest of the maple syrup.

#### `breakfast-cookies` · Peanut butter breakfast cookies · 🍪 · Other
vibes: batchFriendly, family · appliances: oven · prep 10 / cook 14 min · serves 4 · leftovers: no

- rolled-oats 150 g
- banana 2 piece (mashed)
- peanut-butter 4 tbsp
- eggs 1 piece
- cinnamon 1 tsp
- raisins 30 g
- dark-chocolate 30 g (chopped)
- baking-powder 0.5 tsp

1. Heat the oven to 180°C (350°F) and line a tray.
2. Mix everything together into a thick, sticky dough.
3. Scoop 8 mounds onto the tray and flatten slightly — they don't spread.
4. Bake for 12–14 minutes until golden at the edges. Keep for 4 days.

#### `make-ahead-breakfast-strata` · Make-ahead ham & cheese breakfast strata · 🍳 · American
vibes: batchFriendly, family, highProtein · appliances: oven · prep 15 / cook 45 min · serves 4 · leftovers: yes

- wholemeal-bread 6 slice (cubed)
- eggs 6 piece
- milk 350 ml
- ham 4 slice (chopped)
- cheddar 100 g (grated)
- butter 1 tsp
- salt 1 pinch

1. Layer the bread, ham and most of the cheese in a buttered baking dish.
2. Whisk the eggs, milk and salt, pour over and press the bread down. Chill overnight.
3. Top with the rest of the cheese and bake at 180°C (350°F) for 40–45 minutes until puffed and set.
4. Rest for 5 minutes before cutting into squares.

#### `honey-roasted-grape-yogurt-toast` · Honey roasted grapes on yogurt toast · 🍇 · Other
vibes: comfort · appliances: oven · prep 5 / cook 15 min · serves 2 · leftovers: no

- grapes 200 g
- honey 1 tbsp
- olive-oil 1 tsp
- sourdough 2 slice
- greek-yogurt 150 g
- black-pepper 1 pinch

1. Heat the oven to 200°C (400°F) and roast the grapes with the honey and oil for 15 minutes until they burst and turn jammy.
2. Toast the sourdough.
3. Spread thickly with the yogurt.
4. Spoon over the hot grapes and their juices and add a crack of pepper.

#### `avocado-egg-tostadas` · Avocado & fried egg tostadas · 🥑 · Mexican
vibes: quickEasy, healthyish · appliances: oven, stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- corn-tortillas 4 piece
- olive-oil 1 tbsp
- black-beans 120 g (drained)
- avocado 1 piece
- lime 0.5 piece
- eggs 3 piece
- chili-flakes 1 pinch

1. Brush the tortillas with a little oil and bake at 200°C (400°F) for 6–8 minutes until crisp.
2. Warm and mash the beans, and mash the avocado with the lime juice and a pinch of salt.
3. Fry the eggs in the rest of the oil until crisp at the edges.
4. Layer the tostadas with beans, avocado and eggs and finish with chili flakes.

#### `eggs-in-purgatory` · Eggs in purgatory · 🍅 · Italian
vibes: comfort, onePan · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- olive-oil 1 tbsp
- garlic 2 clove (sliced)
- chili-flakes 0.5 tsp
- chopped-tomatoes 400 g
- italian-herbs 0.5 tsp
- eggs 4 piece
- parmesan 10 g (grated)
- wholemeal-bread 2 slice

1. Warm the oil with the garlic and chili until the garlic just turns gold.
2. Add the tomatoes and herbs and simmer for 8 minutes until thick.
3. Make 4 wells, crack in the eggs, cover and cook for 5 minutes until the whites set and the yolks are runny.
4. Finish with parmesan and serve with toast for dipping.

#### `sweet-potato-pancakes` · Sweet potato cinnamon pancakes · 🍠 · American
vibes: family, healthyish · appliances: microwave, stovetop · prep 10 / cook 15 min · serves 2 · leftovers: no

- sweet-potato 1 piece
- eggs 2 piece
- flour 60 g
- baking-powder 1 tsp
- cinnamon 1 tsp
- milk 80 ml
- butter 1 tsp
- greek-yogurt 100 g

1. Prick the sweet potato and microwave for 6 minutes until soft, then scoop out and mash.
2. Whisk the mash with the eggs, flour, baking powder, cinnamon and milk.
3. Cook spoonfuls in a buttered non-stick pan for 2 minutes on each side over a medium-low heat — they colour fast.
4. Stack with yogurt and a pinch of cinnamon.

### Snacks (8)

#### `air-fryer-pasta-chips` · Air-fryer pasta chips with marinara · 🍝 · Italian
vibes: family, fakeaway · appliances: stovetop, airFryer · prep 5 / cook 20 min · serves 4 · leftovers: no

- penne 150 g
- olive-oil 1 tbsp
- parmesan 30 g (finely grated)
- garlic-powder 1 tsp
- italian-herbs 1 tsp
- passata 150 g
- chili-flakes 1 pinch

1. Cook the pasta in salted water until just tender, drain and pat dry.
2. Toss with the oil, parmesan, garlic powder and herbs.
3. Air-fry at 200°C (400°F) for 10–12 minutes, shaking twice, until golden and crunchy. Warm the passata with the chili to dip.

#### `kimchi-pancake-bites` · Crispy kimchi pancake bites · 🥞 · Korean
vibes: fakeaway, quickEasy · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- kimchi 80 g (chopped)
- flour 60 g
- cornstarch 1 tbsp
- spring-onion 2 piece (sliced)
- vegetable-oil 2 tbsp
- soy-sauce 1 tbsp

1. Mix the flour, cornstarch, kimchi and its juice, spring onions and 4 tbsp cold water into a thick batter.
2. Fry small spoonfuls in the oil for 2–3 minutes on each side until lacy and crisp.
3. Serve with soy sauce for dipping.

#### `cheesy-garlic-bread-bites` · Cheesy garlic bread bites · 🧄 · Italian
vibes: family, comfort · appliances: oven · prep 10 / cook 15 min · serves 4 · leftovers: no

- flour 150 g
- greek-yogurt 150 g
- baking-powder 1 tsp
- butter 2 tbsp (melted)
- garlic 2 clove (crushed)
- parsley 10 g (finely chopped)
- mozzarella 1 piece (grated)

1. Heat the oven to 200°C (400°F). Mix the flour, yogurt and baking powder into a dough and roll into 16 balls.
2. Mix the butter, garlic and parsley, roll the balls in it and pack into a small baking dish.
3. Scatter with mozzarella and bake for 15 minutes until golden and stretchy.

#### `tortilla-quiche-cups` · Tortilla mini quiche cups · 🧁 · Other
vibes: family, highProtein · appliances: oven · prep 10 / cook 15 min · serves 4 · leftovers: no

- tortillas 2 piece
- eggs 4 piece
- milk 50 ml
- cheddar 40 g (grated)
- spinach 30 g (chopped)
- cherry-tomatoes 6 piece (halved)
- salt 1 pinch

1. Heat the oven to 190°C (375°F). Cut 12 circles from the tortillas and press into a muffin tin.
2. Whisk the eggs, milk and salt and stir in the spinach and cheese.
3. Fill the cups, top each with a tomato half and bake for 15 minutes until set and the edges are crisp.

#### `pizza-pinwheels` · Two-ingredient dough pizza pinwheels · 🍕 · Italian
vibes: family, batchFriendly · appliances: oven · prep 10 / cook 18 min · serves 4 · leftovers: no

- flour 150 g
- greek-yogurt 150 g
- baking-powder 1 tsp
- passata 80 g
- dried-oregano 1 tsp
- ham 2 slice (chopped)
- mozzarella 1 piece (grated)

1. Heat the oven to 200°C (400°F). Mix the flour, yogurt and baking powder into a dough and roll into a rectangle.
2. Spread with passata, sprinkle with oregano, ham and mozzarella, roll up tightly and cut into 12 slices.
3. Bake cut-side up on a lined tray for 16–18 minutes until golden.

#### `chocolate-hummus-apple` · Chocolate hummus with apple slices · 🍫 · Other
vibes: healthyish, family · appliances: blender, microwave · prep 5 / cook 1 min · serves 4 · leftovers: no

- chickpeas 240 g (drained)
- dark-chocolate 40 g (melted)
- maple-syrup 2 tbsp
- peanut-butter 1 tbsp
- milk 3 tbsp
- apple 2 piece (sliced)

1. Blend the chickpeas, melted chocolate, maple syrup, peanut butter and milk until completely smooth like brownie batter.
2. Chill for 10 minutes.
3. Serve with apple slices for dipping.

#### `air-fryer-wedges-garlic-yogurt` · Air-fryer potato wedges with garlic yogurt · 🥔 · Other
vibes: family, comfort · appliances: airFryer · prep 5 / cook 20 min · serves 2 · leftovers: no

- potato 2 piece (cut into wedges)
- olive-oil 1 tbsp
- paprika 1 tsp
- garlic-powder 0.5 tsp
- salt 1 pinch
- greek-yogurt 80 g
- garlic 1 clove (crushed)
- chili-flakes 1 pinch

1. Toss the wedges with the oil, paprika, garlic powder and salt.
2. Air-fry at 200°C (400°F) for 18–20 minutes, shaking twice, until crisp outside and fluffy inside.
3. Mix the yogurt with the garlic and chili and serve for dipping.

#### `mango-lassi-pops` · Frozen mango lassi pops · 🥭 · Indian
vibes: healthyish, family · appliances: blender · prep 10 / cook 0 min · serves 4 · leftovers: no

- mango 2 piece (chopped)
- greek-yogurt 250 g
- honey 2 tbsp
- lime 0.5 piece
- cinnamon 1 pinch

1. Blend the mango, yogurt, honey, lime juice and cinnamon until smooth.
2. Pour into lolly moulds or small cups with sticks.
3. Freeze for at least 4 hours.
