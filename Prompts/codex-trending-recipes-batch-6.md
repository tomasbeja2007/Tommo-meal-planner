# Codex prompt: trending recipes, batch 6 (100 recipes)

Paste everything below the line into Codex. It is self-contained: the recipes are written out in full.

---

Read `CLAUDE.md` and `BUILD_NOTES.md` (section 3d) first, and follow the project's rules.

## Task

Add the 100 recipes below (45 dinners, 20 lunches, 20 breakfasts, 15 snacks) to the bundled
library as trending recipes, the same way as `Tools/trending_recipes.py`. Add batches 1 to 5 first (in this order) if they aren't in yet.

1. Create `Tools/trending_batch6.py`. Write each recipe with `T(...)` from `trending_recipes.py` (it adds the `trending` tag),
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

### Dinners (45)

#### `crispy-chicken-gyros` · Crispy sheet-pan chicken gyros · 🥙 · Mediterranean
vibes: fakeaway, highProtein, family · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: no

- chicken-thighs 600 g (thinly sliced)
- greek-yogurt 200 g
- garlic 3 clove (crushed)
- dried-oregano 2 tsp
- paprika 2 tsp
- lemon 1 piece
- pita-bread 4 piece
- cucumber 1 piece
- tomato 2 piece (sliced)
- red-onion 0.5 piece (thinly sliced)
- salt 1 tsp

1. Heat the oven to 230°C (450°F).
2. Toss the chicken with 3 tbsp yogurt, two-thirds of the garlic, the oregano, paprika, half the lemon juice and salt.
3. Spread thinly over a lined tray and roast for 20–25 minutes until the edges char and crisp — like gyro meat off the spit.
4. Grate half the cucumber into the rest of the yogurt with the rest of the garlic and lemon for tzatziki; slice the other half.
5. Warm the pittas.
6. Load them with crispy chicken, tzatziki, tomato, cucumber and onion.

#### `big-mac-wraps` · Burger sauce beef wraps · 🍔 · American
vibes: fakeaway, family, quickEasy · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- ground-beef 500 g
- onion 0.5 piece (finely diced)
- tortillas 4 piece
- cheddar 80 g (grated)
- lettuce 0.5 piece (shredded)
- cucumber 0.5 piece (finely diced)
- mayonnaise 3 tbsp
- ketchup 1 tbsp
- dijon-mustard 1 tsp
- salt 1 tsp

1. Mix the mayonnaise, ketchup, mustard and cucumber into burger sauce.
2. Brown the beef and onion with the salt for 8 minutes until crisp at the edges.
3. Lay cheddar down the middle of each tortilla and spoon the hot beef on top so it melts.
4. Add lettuce and a good drizzle of sauce.
5. Roll up tightly.
6. Toast seam-side down in the pan for 1 minute.

#### `honey-sriracha-chicken-bowl` · Honey sriracha chicken rice bowl · 🌶️ · Other
vibes: fakeaway, highProtein, quickEasy · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-thighs 600 g (diced)
- cornstarch 1 tbsp
- vegetable-oil 1 tbsp
- honey 3 tbsp
- sriracha 2 tbsp
- soy-sauce 2 tbsp
- garlic 2 clove (crushed)
- long-grain-rice 250 g
- cucumber 1 piece (sliced)
- spring-onion 2 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the chicken in the cornstarch and fry in the oil over a high heat for 8 minutes until golden.
3. Mix the honey, sriracha, soy sauce and garlic.
4. Pour into the pan and bubble for 2 minutes until sticky and glossy.
5. Serve over the rice with cucumber.
6. Scatter with spring onions.

#### `chicken-fajita-soup` · Chicken fajita soup · 🫑 · Mexican
vibes: comfort, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- chicken-thighs 500 g (sliced)
- onion 1 piece (sliced)
- bell-pepper 2 piece (sliced)
- paprika 2 tsp
- cumin 1 tsp
- chili-powder 1 tsp
- chopped-tomatoes 400 g
- black-beans 240 g (drained)
- vegetable-bouillon 2 tsp
- lime 1 piece
- greek-yogurt 100 g

1. Brown the chicken in the oil for 5 minutes.
2. Add the onion, peppers and spices and cook for 5 minutes.
3. Add the tomatoes, beans, 1 litre boiling water and the bouillon.
4. Simmer for 15 minutes.
5. Squeeze in the lime and season.
6. Serve with a spoon of yogurt.

#### `one-pot-chicken-alfredo-orzo` · One-pot chicken alfredo orzo · 🧀 · Italian
vibes: onePan, comfort, family · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 2 piece (diced)
- olive-oil 1 tbsp
- garlic 3 clove (crushed)
- orzo 300 g
- vegetable-bouillon 1 tsp
- milk 200 ml
- cream-cheese 60 g
- parmesan 40 g (grated)
- broccoli 0.5 piece (cut into small florets)
- black-pepper 1 tsp
- salt 1 tsp

1. Brown the chicken in the oil for 5 minutes, then add the garlic.
2. Stir in the orzo, 600 ml boiling water and the bouillon and simmer for 6 minutes.
3. Add the broccoli and milk and simmer for 5 minutes more, stirring often.
4. Take off the heat and stir in the cream cheese and parmesan.
5. Season with lots of pepper.
6. Serve straight away while it's creamy.

#### `egg-roll-noodles` · Egg roll noodles · 🥡 · Chinese
vibes: quickEasy, fakeaway, onePan · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- egg-noodles 200 g
- ground-pork 400 g
- vegetable-oil 1 tbsp
- garlic 3 clove (crushed)
- ginger 10 g (grated)
- cabbage 400 g (shredded)
- carrot 2 piece (grated)
- soy-sauce 3 tbsp
- sriracha 1 tsp
- spring-onion 3 piece (sliced)

1. Cook the noodles for 4 minutes, then drain.
2. Brown the pork in the oil for 6 minutes until crispy.
3. Add the garlic and ginger for 30 seconds.
4. Add the cabbage and carrot and stir-fry for 3 minutes.
5. Toss in the noodles, soy sauce and sriracha.
6. Finish with spring onions.

#### `crispy-potato-chicken-traybake` · Crispy smashed potato & chicken traybake · 🥔 · Other
vibes: onePan, family, comfort · appliances: oven, stovetop · prep 10 / cook 35 min · serves 4 · leftovers: no

- potato 6 piece (small)
- chicken-thighs 600 g
- olive-oil 2 tbsp
- garlic-powder 1 tsp
- paprika 2 tsp
- parmesan 30 g (grated)
- green-beans 250 g
- lemon 1 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Boil the whole potatoes for 12 minutes, then drain.
2. Rub the chicken with the paprika, garlic powder, half the oil and salt and roast on a large tray for 10 minutes.
3. Smash the potatoes flat on the tray, drizzle with the rest of the oil and scatter with parmesan.
4. Roast for 20 minutes until crisp, adding the green beans for the last 8.
5. Squeeze over the lemon.
6. Serve straight from the tray.

#### `ground-turkey-sweet-potato-skillet` · Turkey & sweet potato skillet · 🍠 · American
vibes: onePan, healthyish, highProtein · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: yes

- ground-turkey 500 g
- olive-oil 1 tbsp
- sweet-potato 2 piece (finely diced)
- onion 1 piece (diced)
- bell-pepper 1 piece (diced)
- paprika 2 tsp
- cumin 1 tsp
- spinach 80 g
- cheddar 60 g (grated)
- salt 1 tsp

1. Fry the sweet potato in the oil in a lidded pan, covered, for 8 minutes until nearly tender.
2. Add the turkey, onion and pepper and cook for 8 minutes until browned.
3. Stir in the spices and salt.
4. Add the spinach until wilted.
5. Scatter with cheddar and cover for 2 minutes to melt.
6. Great for meal prep: it keeps 4 days.

#### `chicken-tikka-traybake-rice` · Chicken tikka & pepper traybake · 🍗 · Indian
vibes: onePan, highProtein, fakeaway · appliances: oven, stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- chicken-thighs 600 g (cut into chunks)
- greek-yogurt 150 g
- curry-powder 1 tbsp
- garam-masala 2 tsp
- garlic 2 clove (crushed)
- bell-pepper 2 piece (cut into chunks)
- red-onion 2 piece (cut into wedges)
- olive-oil 1 tbsp
- basmati-rice 250 g
- lemon 1 piece

1. Heat the oven to 220°C (425°F).
2. Mix 100 g yogurt with the spices, garlic and a pinch of salt and coat the chicken.
3. Toss the peppers and onions with the oil on a tray and add the chicken.
4. Roast for 25 minutes until charred.
5. Cook the rice in salted boiling water for 12 minutes, then drain.
6. Serve with the rest of the yogurt and lemon wedges.

#### `cheesy-bean-enchiladas` · Cheesy bean & spinach enchiladas · 🌯 · Mexican
vibes: family, comfort, batchFriendly · appliances: oven, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: yes

- black-beans 480 g (drained)
- spinach-frozen 150 g
- cumin 1 tsp
- chili-powder 1 tsp
- passata 400 g
- garlic 1 clove (crushed)
- tortillas 6 piece
- cheddar 120 g (grated)
- greek-yogurt 100 g
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Warm the beans and spinach with the cumin and salt, mashing roughly.
3. Simmer the passata with the chili powder and garlic for 3 minutes.
4. Fill and roll the tortillas, lay in a dish and pour over the sauce.
5. Scatter with cheddar and bake for 20 minutes.
6. Serve with yogurt.

#### `crispy-orange-tofu` · Sweet & tangy crispy tofu with broccoli · 🥢 · Chinese
vibes: fakeaway, healthyish · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- tofu 800 g (pressed and cubed)
- cornstarch 3 tbsp
- vegetable-oil 2 tbsp
- honey 3 tbsp
- soy-sauce 3 tbsp
- rice-vinegar 2 tbsp
- lemon 1 piece
- garlic 2 clove (crushed)
- broccoli 1 piece (cut into florets)
- long-grain-rice 250 g

1. Cook the rice, adding the broccoli for the last 4 minutes, then drain.
2. Toss the tofu in 2 tbsp cornstarch and fry in the oil for 10 minutes until crisp.
3. Whisk the honey, soy sauce, vinegar, lemon zest and juice, garlic, the rest of the cornstarch and 4 tbsp water.
4. Pour into the pan and bubble until thick.
5. Toss the tofu through the sauce.
6. Serve over rice and broccoli.

#### `brown-butter-gnocchi-peas` · Brown butter gnocchi with peas & parmesan · 🧈 · Italian
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- gnocchi 1000 g
- butter 3 tbsp
- garlic 2 clove (sliced)
- peas-frozen 250 g
- lemon 1 piece
- parmesan 40 g (grated)
- black-pepper 1 tsp

1. Fry the gnocchi in 1 tbsp butter in a large pan for 6 minutes until golden.
2. Add the peas and a splash of water and cook for 3 minutes.
3. Push aside, add the rest of the butter and cook until it foams and smells nutty, about 1 minute.
4. Add the garlic for 30 seconds, then toss everything together.
5. Squeeze over the lemon.
6. Finish with parmesan and lots of black pepper.

#### `chicken-noodle-stir-fry-satay` · 15-minute satay chicken noodles · 🥜 · Thai
vibes: quickEasy, highProtein, fakeaway · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- egg-noodles 250 g
- chicken-breast 2 piece (sliced)
- vegetable-oil 1 tbsp
- mixed-veg-frozen 300 g
- peanut-butter 4 tbsp
- soy-sauce 3 tbsp
- lime 1 piece
- honey 1 tbsp
- sriracha 1 tsp

1. Cook the noodles for 4 minutes, then drain.
2. Whisk the peanut butter, soy sauce, lime juice, honey, sriracha and 5 tbsp hot water.
3. Stir-fry the chicken in the oil for 5 minutes.
4. Add the frozen veg and stir-fry for 3 minutes.
5. Toss in the noodles and sauce for 2 minutes.
6. Serve hot.

#### `lentil-tacos` · Smoky lentil tacos · 🌮 · Mexican
vibes: healthyish, quickEasy, batchFriendly · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: yes

- red-lentils 200 g
- onion 1 piece (diced)
- olive-oil 1 tbsp
- paprika 2 tsp
- cumin 1 tsp
- chili-powder 1 tsp
- tomato-paste 2 tbsp
- corn-tortillas 12 piece
- cabbage 200 g (shredded)
- lime 2 piece
- greek-yogurt 100 g

1. Cook the onion in the oil for 5 minutes, then add the spices and tomato paste for 1 minute.
2. Add the lentils and 500 ml water and simmer for 12 minutes until thick and almost dry — it eats just like taco meat.
3. Toss the cabbage with the juice of 1 lime.
4. Mix the yogurt with the rest of the lime juice.
5. Warm the tortillas.
6. Fill with lentils, slaw and lime yogurt.

#### `black-pepper-chicken` · Black pepper chicken & peppers · 🌶️ · Chinese
vibes: quickEasy, highProtein, fakeaway · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- chicken-thighs 500 g (sliced)
- cornstarch 1 tbsp
- vegetable-oil 1 tbsp
- bell-pepper 2 piece (sliced)
- onion 1 piece (sliced)
- soy-sauce 3 tbsp
- honey 1 tbsp
- black-pepper 2 tsp
- garlic 2 clove (crushed)
- long-grain-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the chicken in the cornstarch and stir-fry in the oil over a high heat for 6 minutes.
3. Add the peppers and onion and cook for 3 minutes.
4. Add the garlic, soy sauce, honey and plenty of black pepper.
5. Toss for 1 minute until glossy and peppery.
6. Serve over the rice.

#### `sweet-potato-curry-soup` · Thai red curry sweet potato & lentil soup · 🥣 · Thai
vibes: comfort, healthyish, batchFriendly · appliances: stovetop, blender · prep 5 / cook 25 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- thai-curry-paste 2 tbsp
- sweet-potato 2 piece (cubed)
- red-lentils 120 g
- coconut-milk 400 ml
- vegetable-bouillon 2 tsp
- lime 1 piece
- naan 2 piece

1. Cook the onion in the oil for 5 minutes, then fry the curry paste for 1 minute.
2. Add the sweet potato, lentils, coconut milk, 800 ml boiling water and the bouillon.
3. Simmer for 20 minutes until everything is soft.
4. Blend until smooth.
5. Squeeze in the lime.
6. Serve with warm naan for dunking.

#### `pesto-salmon-gnocchi` · Pesto salmon gnocchi traybake · 🌿 · Italian
vibes: onePan, quickEasy · appliances: oven · prep 5 / cook 20 min · serves 4 · leftovers: no

- gnocchi 750 g
- salmon-fillet 2 piece
- zucchini 2 piece (chopped)
- olive-oil 1 tbsp
- pesto 4 tbsp
- lemon 1 piece

1. Heat the oven to 220°C (425°F).
2. Toss the gnocchi and zucchini with the oil on a large tray and roast for 10 minutes.
3. Nestle in the salmon and spread with half the pesto.
4. Roast for 10–12 minutes until the salmon flakes and the gnocchi are crisp.
5. Flake the salmon through and dot with the rest of the pesto.
6. Squeeze over the lemon.

#### `ham-pea-pasta` · Creamy ham & pea pasta · 🍝 · British
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- penne 350 g
- peas-frozen 200 g
- ham 6 slice (torn)
- cream-cheese 100 g
- garlic 1 clove (crushed)
- lemon 0.5 piece
- parmesan 30 g (grated)

1. Cook the pasta, adding the peas for the last 3 minutes. Save a mug of water and drain.
2. Melt the cream cheese with the garlic and a splash of pasta water in the empty pan.
3. Toss in the pasta, peas and ham.
4. Add the lemon zest and juice and a splash more water until silky.
5. Season with pepper.
6. Finish with parmesan.

#### `chicken-souvlaki-bowl` · Chicken souvlaki rice bowl · 🍋 · Mediterranean
vibes: healthyish, highProtein, batchFriendly · appliances: stovetop · prep 15 / cook 15 min · serves 4 · leftovers: yes

- chicken-thighs 600 g (cubed)
- lemon 2 piece
- dried-oregano 2 tsp
- garlic 3 clove (crushed)
- olive-oil 2 tbsp
- long-grain-rice 250 g
- cucumber 1 piece (diced)
- tomato 2 piece (diced)
- greek-yogurt 150 g
- feta 60 g (crumbled)

1. Marinate the chicken in the juice of 1 lemon, the oregano, garlic and oil for 10 minutes.
2. Cook the rice in salted boiling water for 12 minutes, then drain and add the zest of the other lemon.
3. Fry the chicken over a high heat for 8 minutes until charred.
4. Toss the cucumber and tomato with a squeeze of lemon.
5. Fill bowls with rice, chicken and salad.
6. Top with yogurt and feta.

#### `spicy-black-bean-burgers` · Spicy black bean smash burgers · 🍔 · Mexican
vibes: fakeaway, healthyish · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- black-beans 480 g (drained and patted dry)
- breadcrumbs 50 g
- eggs 1 piece
- chili-powder 1 tsp
- cumin 1 tsp
- olive-oil 2 tbsp
- burger-buns 4 piece
- cheddar 60 g (sliced)
- lettuce 0.25 piece
- salsa 100 g

1. Mash the beans roughly, then mix with the breadcrumbs, egg, spices and a pinch of salt.
2. Split into 4 balls.
3. Smash each into the hot oiled pan with a spatula and cook for 4 minutes until a crust forms.
4. Flip, add cheese, and cook for 3 minutes.
5. Toast the buns.
6. Build with lettuce, the burger and salsa.

#### `thai-red-curry-chicken-noodles` · Red curry chicken noodle stir-fry · 🍜 · Thai
vibes: quickEasy, fakeaway · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- rice-noodles 200 g
- chicken-thighs 500 g (sliced)
- vegetable-oil 1 tbsp
- thai-curry-paste 2 tbsp
- coconut-milk 200 ml
- bell-pepper 2 piece (sliced)
- fish-sauce 1 tbsp
- lime 1 piece
- basil 10 g

1. Soak the noodles in just-boiled water for 8 minutes, then drain.
2. Stir-fry the chicken in the oil for 5 minutes.
3. Add the curry paste and peppers for 2 minutes.
4. Pour in the coconut milk and bubble for 2 minutes.
5. Toss in the noodles, fish sauce and lime juice.
6. Tear over the basil.

#### `baked-potato-bar` · Loaded baked potato bar · 🥔 · American
vibes: family, comfort · appliances: microwave, stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- potato 4 piece
- ground-beef 300 g
- chili-powder 1 tsp
- kidney-beans 240 g (drained)
- passata 150 g
- cheddar 80 g (grated)
- greek-yogurt 100 g
- spring-onion 2 piece (sliced)

1. Prick the potatoes and microwave for 12–15 minutes, turning halfway, until soft.
2. Brown the beef with the chili powder for 6 minutes.
3. Add the beans and passata and simmer for 6 minutes for a quick chili.
4. Split the potatoes and fluff the insides.
5. Put the chili, cheese, yogurt and spring onions in bowls.
6. Let everyone load their own.

#### `shrimp-taco-skillet-rice` · Cajun shrimp & rice skillet · 🍤 · American
vibes: onePan, quickEasy · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: no

- shrimp 250 g
- paprika 2 tsp
- garlic-powder 1 tsp
- dried-thyme 1 tsp
- olive-oil 1 tbsp
- onion 1 piece (diced)
- bell-pepper 2 piece (diced)
- long-grain-rice 250 g
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- lemon 1 piece

1. Toss the shrimp with half the spices.
2. Cook the onion and peppers in the oil for 5 minutes with the rest of the spices.
3. Stir in the rice, tomatoes, 450 ml boiling water and the bouillon, cover and simmer for 15 minutes.
4. Nestle in the shrimp, cover and cook for 4 minutes until pink.
5. Leave to stand for 2 minutes.
6. Squeeze over the lemon.

#### `pork-meatball-pho-noodles` · Pork meatball noodle soup · 🍜 · Other
vibes: comfort, family · appliances: stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- ground-pork 400 g
- garlic 2 clove (crushed)
- ginger 20 g (grated)
- soy-sauce 2 tbsp
- vegetable-bouillon 3 tsp
- fish-sauce 1 tbsp
- rice-noodles 200 g
- bok-choy 2 piece (sliced)
- lime 1 piece
- spring-onion 3 piece (sliced)

1. Mix the pork with the garlic, half the ginger and 1 tbsp soy sauce and roll into small meatballs.
2. Simmer 1.5 litres water with the bouillon and the rest of the ginger.
3. Drop in the meatballs and simmer for 8 minutes.
4. Add the bok choy, fish sauce and the rest of the soy sauce for 2 minutes.
5. Soak the noodles in just-boiled water for 8 minutes and drain into bowls.
6. Ladle over the soup and finish with lime and spring onions.

#### `veggie-fried-rice-tofu` · Crispy tofu veggie fried rice · 🍚 · Chinese
vibes: healthyish, quickEasy, fakeaway · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- long-grain-rice 300 g
- tofu 400 g (crumbled)
- vegetable-oil 2 tbsp
- mixed-veg-frozen 300 g
- garlic 2 clove (crushed)
- soy-sauce 3 tbsp
- eggs 2 piece (beaten)
- spring-onion 3 piece (sliced)

1. Cook the rice, drain and spread out to steam dry.
2. Fry the crumbled tofu in the oil until golden and crispy, about 8 minutes.
3. Add the veg and garlic for 3 minutes.
4. Push aside and scramble the eggs.
5. Add the rice and soy sauce and stir-fry until hot.
6. Finish with spring onions.

#### `chicken-broccoli-pasta-bake` · Cheesy chicken & broccoli pasta bake · 🥦 · Italian
vibes: family, comfort, batchFriendly · appliances: stovetop, oven · prep 10 / cook 25 min · serves 4 · leftovers: yes

- penne 300 g
- broccoli 1 piece (cut into small florets)
- chicken-thighs 400 g (diced)
- olive-oil 1 tsp
- milk 300 ml
- cream-cheese 80 g
- cheddar 100 g (grated)
- dijon-mustard 1 tsp

1. Heat the oven to 220°C (425°F). Cook the pasta for 2 minutes less than the pack says, adding the broccoli for the last 3, then drain.
2. Fry the chicken in the oil for 7 minutes.
3. Warm the milk with the cream cheese, mustard and half the cheddar into a quick sauce.
4. Toss everything together in a baking dish and top with the rest of the cheese.
5. Bake for 12–15 minutes until golden.
6. Rest for 2 minutes before serving.

#### `beef-ramen-noodles` · Sticky beef ramen noodles · 🍜 · Japanese
vibes: quickEasy, fakeaway · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- egg-noodles 250 g
- ground-beef 400 g
- vegetable-oil 1 tsp
- garlic 3 clove (crushed)
- soy-sauce 3 tbsp
- honey 2 tbsp
- sriracha 1 tbsp
- broccoli 0.5 piece (cut into small florets)
- spring-onion 3 piece (sliced)
- sesame-seeds 1 tsp

1. Cook the noodles with the broccoli for 4 minutes, then drain.
2. Brown the beef in the oil for 7 minutes until crispy.
3. Add the garlic, then the soy sauce, honey and sriracha and bubble for 1 minute.
4. Toss in the noodles and broccoli.
5. Coat everything in the sticky sauce.
6. Top with spring onions and sesame.

#### `chickpea-curry-in-a-hurry` · 10-minute chickpea curry · 🍛 · Indian
vibes: quickEasy, healthyish · appliances: stovetop · prep 2 / cook 10 min · serves 4 · leftovers: no

- vegetable-oil 1 tbsp
- garlic 2 clove (crushed)
- ginger 10 g (grated)
- curry-powder 1 tbsp
- chickpeas 720 g (drained)
- passata 400 g
- coconut-milk 200 ml
- spinach-frozen 150 g
- microwave-rice 2 piece

1. Fry the garlic, ginger and curry powder in the oil for 1 minute.
2. Add the chickpeas, passata and coconut milk and simmer for 6 minutes.
3. Stir in the spinach until hot.
4. Heat the rice.
5. Season the curry.
6. Dinner in ten minutes.

#### `italian-sausage-peppers` · Italian sausage & peppers with potatoes · 🌭 · Italian
vibes: onePan, family · appliances: oven · prep 10 / cook 35 min · serves 4 · leftovers: no

- sausages 8 piece
- bell-pepper 3 piece (sliced)
- onion 2 piece (sliced)
- potato 4 piece (cubed)
- olive-oil 1 tbsp
- italian-herbs 2 tsp
- balsamic-vinegar 1 tbsp
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the potatoes, peppers and onions with the oil, herbs and salt on a large tray.
3. Add the sausages.
4. Roast for 35 minutes, turning once, until everything is golden and sticky.
5. Drizzle with the balsamic.
6. Serve straight from the tray.

#### `butter-bean-chorizo-stew` · Chorizo, potato & white bean stew · 🥘 · Spanish/Portuguese
vibes: comfort, onePan · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: yes

- chorizo 100 g (diced)
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- paprika 1 tsp
- potato 2 piece (diced)
- chopped-tomatoes 400 g
- cannellini-beans 480 g (drained)
- vegetable-bouillon 1 tsp
- spinach 80 g
- baguette 1 piece

1. Fry the chorizo for 3 minutes until it releases its oil.
2. Add the onion for 5 minutes, then the garlic and paprika.
3. Add the potatoes, tomatoes, beans, 400 ml boiling water and the bouillon.
4. Simmer for 15 minutes until the potatoes are tender.
5. Stir in the spinach.
6. Serve with bread.

#### `lemony-tuna-white-bean-pasta` · Lemony tuna & white bean pasta · 🍋 · Italian
vibes: quickEasy, highProtein · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- spaghetti 350 g
- canned-tuna 290 g (drained)
- cannellini-beans 240 g (drained)
- olive-oil 3 tbsp
- garlic 3 clove (sliced)
- chili-flakes 0.5 tsp
- lemon 1 piece
- spinach 80 g

1. Cook the spaghetti, saving a mug of water before draining.
2. Warm the oil with the garlic and chili for 2 minutes until the garlic is golden.
3. Add the beans and cook for 2 minutes, crushing a few.
4. Toss in the spaghetti, tuna, spinach, lemon zest and juice and a splash of pasta water.
5. Season well.
6. Serve with extra lemon.

#### `korean-style-chicken-tacos` · Gochujang chicken tacos with quick pickles · 🌮 · Korean
vibes: fakeaway, family · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- chicken-thighs 500 g (sliced)
- gochujang 2 tbsp
- honey 1 tbsp
- soy-sauce 1 tbsp
- vegetable-oil 1 tbsp
- corn-tortillas 12 piece
- cucumber 1 piece (thinly sliced)
- rice-vinegar 2 tbsp
- cabbage 150 g (shredded)
- mayonnaise 2 tbsp

1. Toss the cucumber with the vinegar and a pinch of sugar and salt.
2. Mix the gochujang, honey and soy sauce and coat the chicken.
3. Fry in the oil for 8 minutes until charred and sticky.
4. Warm the tortillas.
5. Fill with cabbage, chicken and pickled cucumber.
6. Drizzle with mayonnaise.

#### `cauliflower-chickpea-tikka` · Roasted cauliflower & chickpea tikka · 🥦 · Indian
vibes: healthyish, onePan · appliances: oven, stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- cauliflower 1 piece (cut into florets)
- chickpeas 480 g (drained)
- greek-yogurt 150 g
- curry-powder 1 tbsp
- garam-masala 1 tsp
- olive-oil 2 tbsp
- passata 300 g
- basmati-rice 250 g
- cilantro 10 g

1. Heat the oven to 220°C (425°F).
2. Toss the cauliflower and chickpeas with the oil, half the spices and 3 tbsp yogurt.
3. Roast for 25 minutes until charred.
4. Cook the rice. Warm the passata with the rest of the spices for 5 minutes, then stir in 3 tbsp yogurt.
5. Toss the roast tray with the sauce.
6. Serve with rice, the rest of the yogurt and cilantro.

#### `bacon-cabbage-pasta` · Crispy bacon & cabbage pasta · 🥓 · Italian
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 350 g
- bacon 6 slice (chopped)
- cabbage 300 g (finely shredded)
- garlic 3 clove (sliced)
- chili-flakes 0.5 tsp
- parmesan 40 g (grated)
- lemon 0.5 piece

1. Cook the pasta, saving a mug of water before draining.
2. Fry the bacon until crisp.
3. Add the cabbage, garlic and chili and cook for 6 minutes until soft and sweet.
4. Toss in the pasta, parmesan and a splash of pasta water.
5. Add a squeeze of lemon.
6. Serve with extra parmesan.

#### `air-fryer-honey-mustard-salmon` · Honey mustard salmon with potatoes · 🐟 · Other
vibes: healthyish, quickEasy · appliances: airFryer, stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- salmon-fillet 2 piece (each cut in half)
- dijon-mustard 1 tbsp
- honey 1 tbsp
- potato 5 piece (cubed)
- green-beans 300 g
- butter 1 tbsp
- lemon 1 piece
- salt 1 tsp

1. Boil the potatoes for 12 minutes, adding the green beans for the last 4, then drain and toss with the butter and salt.
2. Mix the mustard and honey and brush over the salmon pieces.
3. Air-fry at 190°C (375°F) for 8 minutes until glazed and flaky.
4. Squeeze over the lemon.
5. Serve with the buttery potatoes and beans.
6. Two fillets stretch to four with plenty of veg.

#### `pizza-pasta-bake` · Pizza pasta bake · 🍕 · Italian
vibes: family, comfort · appliances: stovetop, oven · prep 10 / cook 20 min · serves 4 · leftovers: yes

- penne 350 g
- passata 500 g
- dried-oregano 1 tsp
- garlic 1 clove (crushed)
- ham 4 slice (chopped)
- bell-pepper 1 piece (diced)
- mozzarella 2 piece (torn)
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Cook the pasta for 2 minutes less than the pack says, then drain.
2. Mix the passata with the oregano, garlic and salt.
3. Toss the pasta with the sauce, ham and pepper in a baking dish.
4. Top with mozzarella.
5. Bake for 15 minutes until bubbling and golden like a pizza.
6. Serve hot.

#### `thai-turkey-lettuce-cups` · Sweet chili turkey lettuce cups · 🥬 · Thai
vibes: quickEasy, highProtein, lowCalorie · appliances: stovetop · prep 5 / cook 10 min · serves 4 · leftovers: no

- ground-turkey 500 g
- vegetable-oil 1 tbsp
- garlic 2 clove (crushed)
- sweet-chili-sauce 3 tbsp
- soy-sauce 2 tbsp
- lime 1 piece
- lettuce 1 piece (leaves separated)
- carrot 2 piece (grated)
- cucumber 1 piece (diced)
- long-grain-rice 200 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Brown the turkey in the oil for 7 minutes.
3. Add the garlic, sweet chili sauce, soy sauce and lime juice and toss for 1 minute.
4. Spoon into the lettuce cups.
5. Top with carrot and cucumber.
6. Serve with the rice.

#### `one-pot-cajun-chicken-pasta` · One-pot Cajun chicken pasta · 🌶️ · American
vibes: onePan, comfort, family · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 2 piece (diced)
- paprika 2 tsp
- garlic-powder 1 tsp
- onion-powder 1 tsp
- chili-powder 0.5 tsp
- olive-oil 1 tbsp
- penne 300 g
- chopped-tomatoes 400 g
- vegetable-bouillon 1 tsp
- cream-cheese 60 g
- bell-pepper 1 piece (diced)

1. Toss the chicken with the spices and brown in the oil for 5 minutes.
2. Add the pepper for 2 minutes.
3. Stir in the pasta, tomatoes, 500 ml boiling water and the bouillon.
4. Simmer for 12 minutes, stirring often, until the pasta is tender.
5. Stir in the cream cheese until creamy.
6. Season and serve.

#### `chicken-schnitzel-potato-salad` · Crispy chicken schnitzel with potato salad · 🍗 · Other
vibes: family, comfort, highProtein · appliances: stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 3 piece (halved and flattened)
- flour 2 tbsp
- eggs 1 piece (beaten)
- breadcrumbs 100 g
- vegetable-oil 3 tbsp
- potato 5 piece (cubed)
- greek-yogurt 120 g
- dijon-mustard 1 tbsp
- spring-onion 3 piece (sliced)
- lemon 1 piece
- salt 1 tsp

1. Boil the potatoes for 12 minutes, then drain and cool slightly.
2. Mix the yogurt, mustard, spring onion and salt and toss with the potatoes.
3. Season the chicken, dust in flour, dip in egg, then press into the breadcrumbs.
4. Fry in the oil for 3–4 minutes on each side until deep golden and cooked through.
5. Drain on paper.
6. Serve with the potato salad and lemon wedges.

#### `chicken-stir-fry-noodles-honey-soy` · Honey soy chicken udon · 🍜 · Japanese
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- udon-noodles 4 piece
- chicken-thighs 500 g (sliced)
- vegetable-oil 1 tbsp
- honey 2 tbsp
- soy-sauce 3 tbsp
- garlic 2 clove (crushed)
- bell-pepper 1 piece (sliced)
- carrot 1 piece (cut into matchsticks)
- spring-onion 2 piece (sliced)

1. Loosen the udon in boiling water for 2 minutes, then drain.
2. Stir-fry the chicken in the oil for 6 minutes until golden.
3. Add the pepper and carrot for 2 minutes.
4. Add the honey, soy sauce and garlic.
5. Toss in the noodles until glossy.
6. Scatter with spring onions.

#### `mexican-street-corn-pasta` · Mexican street corn pasta · 🌽 · Mexican
vibes: family, comfort · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 300 g
- corn-frozen 300 g
- butter 1 tbsp
- chili-powder 1 tsp
- garlic 2 clove (crushed)
- greek-yogurt 100 g
- mayonnaise 1 tbsp
- lime 1 piece
- feta 80 g (crumbled)
- cilantro 10 g

1. Cook the pasta, saving a mug of water before draining.
2. Char the corn in the butter over a high heat for 6 minutes until blackened in spots.
3. Add the garlic and chili powder for 30 seconds.
4. Toss in the pasta, yogurt, mayonnaise, lime juice and a splash of pasta water.
5. Fold through most of the feta.
6. Top with the rest of the feta and cilantro.

#### `lemon-orzo-chickpea-soup` · Lemon orzo & chickpea soup · 🍋 · Mediterranean
vibes: comfort, healthyish · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- garlic 2 clove (crushed)
- orzo 150 g
- chickpeas 480 g (drained)
- vegetable-bouillon 3 tsp
- lemon 2 piece
- spinach 80 g
- parmesan 30 g (grated)

1. Cook the onion and carrot in the oil for 6 minutes, then add the garlic.
2. Add 1.2 litres boiling water, the bouillon, orzo and chickpeas and simmer for 10 minutes.
3. Stir in the spinach.
4. Squeeze in the lemon juice — be generous.
5. Season well.
6. Serve with parmesan.

#### `sticky-pork-rice-bowl` · Sticky soy & ginger pork rice bowl · 🐖 · Chinese
vibes: fakeaway, quickEasy · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- ground-pork 500 g
- vegetable-oil 1 tsp
- ginger 20 g (grated)
- garlic 2 clove (crushed)
- soy-sauce 3 tbsp
- honey 2 tbsp
- long-grain-rice 250 g
- cucumber 1 piece (sliced)
- carrot 2 piece (grated)
- spring-onion 3 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Brown the pork in the oil over a high heat for 8 minutes until crispy.
3. Add the ginger and garlic for 1 minute.
4. Add the soy sauce and honey and cook until sticky.
5. Serve over rice with cucumber and carrot.
6. Scatter with spring onions.

#### `veggie-chili-mac` · Veggie chili mac · 🌶️ · American
vibes: onePan, family, healthyish · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- olive-oil 1 tbsp
- onion 1 piece (diced)
- bell-pepper 1 piece (diced)
- chili-powder 2 tsp
- cumin 1 tsp
- kidney-beans 480 g (drained)
- chopped-tomatoes 400 g
- penne 250 g
- vegetable-bouillon 1 tsp
- cheddar 80 g (grated)

1. Cook the onion and pepper in the oil for 5 minutes, then add the spices.
2. Add the beans, tomatoes, pasta, 600 ml boiling water and the bouillon.
3. Simmer for 12 minutes, stirring often, until the pasta is tender.
4. Stir in most of the cheddar.
5. Top with the rest.
6. Serve hot.

#### `spanish-chickpeas-spinach` · Spanish chickpeas with spinach · 🫘 · Spanish/Portuguese
vibes: quickEasy, healthyish, onePan · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- olive-oil 3 tbsp
- garlic 4 clove (sliced)
- sourdough 2 slice (cubed)
- paprika 2 tsp
- cumin 1 tsp
- chickpeas 720 g (drained)
- spinach-frozen 300 g
- red-wine-vinegar 1 tbsp
- chopped-tomatoes 200 g
- baguette 1 piece

1. Fry the bread cubes and garlic in the oil until golden, then mash them into a paste with the paprika and cumin — it thickens the sauce, the Spanish way.
2. Add the tomatoes and chickpeas with 150 ml water.
3. Simmer for 6 minutes.
4. Stir in the spinach until hot.
5. Add the vinegar and season.
6. Serve with bread.

### Lunchs (20)

#### `chicken-salad-croissant-style` · Creamy herb chicken salad on toast · 🥪 · American
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- chicken-breast 1 piece
- greek-yogurt 60 g
- mayonnaise 1 tbsp
- celery 1 piece (finely diced)
- parsley 5 g (chopped)
- lemon 0.5 piece
- sourdough 2 slice

1. Poach the chicken in simmering water for 12 minutes, then cool and shred.
2. Mix the yogurt, mayonnaise, celery, parsley, lemon juice and a pinch of salt.
3. Fold in the chicken.
4. Pile onto toasted sourdough.

#### `crunchy-tuna-salad-wraps` · Crunchy tuna salad wraps · 🐟 · American
vibes: highProtein, quickEasy · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- canned-tuna 145 g (drained)
- greek-yogurt 40 g
- dijon-mustard 1 tsp
- celery 1 piece (finely diced)
- red-onion 0.25 piece (finely diced)
- lettuce 0.25 piece (shredded)
- carrot 1 piece (grated)
- tortillas 2 piece

1. Mix the tuna with the yogurt, mustard, celery and onion.
2. Lay lettuce and carrot over the tortillas.
3. Spoon over the crunchy tuna.
4. Roll up tightly and cut in half.

#### `greek-chickpea-pasta-salad` · Greek chickpea pasta salad · 🫒 · Mediterranean
vibes: healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: yes

- penne 250 g
- chickpeas 240 g (drained)
- cucumber 1 piece (diced)
- tomato 3 piece (diced)
- red-onion 0.5 piece (finely diced)
- feta 100 g (crumbled)
- olive-oil 3 tbsp
- red-wine-vinegar 2 tbsp
- dried-oregano 1 tsp

1. Cook the pasta, then rinse under cold water and drain.
2. Whisk the oil, vinegar and oregano with a pinch of salt.
3. Toss the pasta with the chickpeas, vegetables and dressing.
4. Top with feta and pack for the week.

#### `chicken-quinoa-power-bowl` · Chicken & quinoa power bowl · 💪 · Other
vibes: highProtein, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: yes

- quinoa 200 g
- chicken-thighs 400 g
- paprika 1 tsp
- olive-oil 1 tbsp
- edamame-frozen 150 g
- carrot 2 piece (grated)
- red-cabbage 150 g (shredded)
- peanut-butter 2 tbsp
- soy-sauce 2 tbsp

1. Simmer the quinoa in 500 ml water for 15 minutes, adding the edamame for the last 3, then drain.
2. Season the chicken with paprika and salt and fry in the oil for 6 minutes on each side, then slice.
3. Whisk the peanut butter, soy sauce and 3 tbsp hot water.
4. Build bowls with quinoa, chicken, carrot and cabbage and drizzle with the sauce.

#### `caprese-chicken-wrap` · Caprese chicken wrap · 🍅 · Italian
vibes: highProtein, quickEasy · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- chicken-breast 1 piece (sliced)
- olive-oil 1 tsp
- tortillas 2 piece
- mozzarella 0.5 piece (sliced)
- tomato 1 piece (sliced)
- pesto 1 tbsp
- spinach 30 g

1. Cook the chicken in the oil for 7 minutes until golden.
2. Spread the tortillas with pesto.
3. Fill with spinach, tomato, mozzarella and chicken.
4. Roll up and toast seam-side down until the cheese melts.

#### `ramen-egg-drop-soup` · Egg drop noodle soup · 🍜 · Chinese
vibes: quickEasy, comfort · appliances: stovetop · prep 3 / cook 8 min · serves 2 · leftovers: no

- egg-noodles 100 g
- vegetable-bouillon 2 tsp
- ginger 10 g (grated)
- soy-sauce 1 tbsp
- eggs 2 piece (beaten)
- spinach 40 g
- spring-onion 2 piece (sliced)

1. Simmer 800 ml water with the bouillon, ginger and soy sauce.
2. Cook the noodles in it for 4 minutes, adding the spinach at the end.
3. Slowly drizzle in the egg while stirring gently so it forms ribbons.
4. Top with spring onions.

#### `crispy-halloumi-wraps` · Crispy halloumi & hummus wraps · 🧀 · Mediterranean
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- halloumi 125 g (sliced)
- tortillas 2 piece
- hummus 60 g
- cucumber 0.5 piece (sliced)
- tomato 1 piece (sliced)
- sweet-chili-sauce 1 tbsp

1. Fry the halloumi in a dry pan for 2 minutes on each side.
2. Spread the tortillas with hummus.
3. Fill with cucumber, tomato, halloumi and a drizzle of sweet chili.
4. Roll up and cut in half.

#### `broccoli-pesto-pasta-salad` · Broccoli pesto pasta salad · 🥦 · Italian
vibes: healthyish, batchFriendly · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: yes

- penne 250 g
- broccoli 1 piece (cut into small florets)
- pesto 4 tbsp
- lemon 1 piece
- cherry-tomatoes 200 g (halved)
- parmesan 30 g (grated)
- cannellini-beans 240 g (drained)

1. Cook the pasta, adding the broccoli for the last 3 minutes, then rinse cold and drain.
2. Toss with the pesto, lemon juice and beans.
3. Fold in the tomatoes.
4. Top with parmesan and pack for the week.

#### `sweet-potato-soup-lime` · Spiced sweet potato & coconut soup · 🍠 · Other
vibes: comfort, healthyish, batchFriendly · appliances: stovetop, blender · prep 5 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- curry-powder 1 tbsp
- sweet-potato 3 piece (cubed)
- red-lentils 80 g
- coconut-milk 200 ml
- vegetable-bouillon 2 tsp
- lime 1 piece

1. Cook the onion in the oil for 5 minutes, then add the curry powder.
2. Add the sweet potato, lentils, 900 ml boiling water and the bouillon and simmer for 20 minutes.
3. Blend with the coconut milk.
4. Finish with lime juice.

#### `chicken-pesto-quesadilla` · Chicken pesto quesadilla · 🫓 · Italian
vibes: quickEasy, highProtein · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- chicken-breast 1 piece (diced)
- olive-oil 1 tsp
- tortillas 2 piece
- pesto 2 tbsp
- mozzarella 0.5 piece (grated)
- spinach 30 g

1. Cook the chicken in the oil for 6 minutes.
2. Spread half of each tortilla with pesto, then add chicken, spinach and mozzarella and fold.
3. Cook in a dry pan for 3 minutes on each side until golden.
4. Cut into wedges.

#### `lentil-salad-feta` · Warm lentil, roasted pepper & feta salad · 🫑 · Mediterranean
vibes: healthyish, highProtein · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- red-lentils 100 g
- roasted-peppers 100 g (sliced)
- feta 50 g (crumbled)
- spinach 40 g
- red-onion 0.25 piece (finely diced)
- olive-oil 1 tbsp
- red-wine-vinegar 1 tbsp

1. Simmer the lentils in plenty of water for 6–7 minutes until just tender but holding their shape, then drain.
2. Whisk the oil and vinegar with a pinch of salt and toss with the warm lentils.
3. Fold in the peppers, onion and spinach.
4. Top with feta.

#### `turkey-hummus-pinwheels` · Turkey & hummus pinwheel lunchbox · 🌀 · Other
vibes: family, quickEasy · appliances: stovetop · prep 10 / cook 5 min · serves 2 · leftovers: no

- ground-turkey 150 g
- paprika 1 tsp
- tortillas 2 piece
- hummus 80 g
- spinach 30 g
- carrot 1 piece (grated)
- grapes 100 g

1. Brown the turkey with the paprika and a pinch of salt for 5 minutes, then cool.
2. Spread the tortillas with hummus and scatter with turkey, spinach and carrot.
3. Roll up tightly and slice into pinwheels.
4. Pack with grapes.

#### `miso-noodle-salad` · Miso sesame noodle salad · 🥢 · Japanese
vibes: healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 8 min · serves 4 · leftovers: yes

- rice-noodles 200 g
- miso-paste 2 tbsp
- rice-vinegar 2 tbsp
- honey 1 tbsp
- sesame-oil 1 tbsp
- edamame-frozen 150 g
- cucumber 1 piece (cut into matchsticks)
- carrot 2 piece (grated)
- sesame-seeds 1 tsp

1. Soak the noodles in just-boiled water for 8 minutes, adding the edamame for the last 3, then rinse cold.
2. Whisk the miso, vinegar, honey and sesame oil with 2 tbsp warm water.
3. Toss the noodles and edamame with the cucumber, carrot and dressing.
4. Scatter with sesame seeds.

#### `cheesy-broccoli-rice-cakes` · Cheesy broccoli rice fritters · 🥦 · Other
vibes: family, healthyish · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- broccoli 0.5 piece (finely chopped)
- eggs 2 piece
- cheddar 50 g (grated)
- flour 2 tbsp
- vegetable-oil 1 tbsp
- greek-yogurt 60 g

1. Mix the rice, broccoli, eggs, cheddar, flour and a pinch of salt.
2. Fry heaped spoonfuls in the oil, pressing flat, for 3 minutes on each side until golden.
3. Season the yogurt with a pinch of salt.
4. Serve the fritters with the yogurt for dipping.

#### `chili-garlic-tofu-rice-bowl` · Chili garlic tofu rice bowl · 🌶️ · Chinese
vibes: healthyish, quickEasy · appliances: stovetop, microwave · prep 5 / cook 12 min · serves 2 · leftovers: no

- tofu 300 g (cubed)
- cornstarch 1 tbsp
- vegetable-oil 1 tbsp
- garlic 3 clove (crushed)
- chili-flakes 1 tsp
- soy-sauce 2 tbsp
- honey 1 tsp
- microwave-rice 1 piece
- cucumber 0.5 piece (sliced)

1. Toss the tofu in the cornstarch and fry in the oil for 8 minutes until crisp.
2. Add the garlic and chili for 30 seconds, then the soy sauce and honey.
3. Heat the rice.
4. Serve the tofu over rice with cucumber.

#### `white-bean-tuna-toast` · Lemony white bean & tuna toast · 🍞 · Mediterranean
vibes: highProtein, quickEasy · appliances: none · prep 5 / cook 2 min · serves 2 · leftovers: no

- cannellini-beans 240 g (drained)
- canned-tuna 145 g (drained)
- lemon 1 piece
- olive-oil 1 tbsp
- sourdough 2 slice
- chili-flakes 1 pinch

1. Lightly crush the beans with the lemon juice, oil and a pinch of salt.
2. Fold in the tuna.
3. Pile onto toasted sourdough.
4. Finish with chili and a crack of pepper.

#### `chicken-noodle-salad-jars` · Thai chicken noodle salad jars · 🫙 · Thai
vibes: batchFriendly, highProtein · appliances: stovetop · prep 15 / cook 10 min · serves 4 · leftovers: yes

- rice-noodles 150 g
- chicken-breast 2 piece
- red-cabbage 150 g (shredded)
- carrot 2 piece (grated)
- cucumber 1 piece (diced)
- sweet-chili-sauce 3 tbsp
- lime 2 piece
- soy-sauce 1 tbsp
- peanuts 30 g (chopped)

1. Poach the chicken for 12 minutes, then shred. Soak the noodles in just-boiled water for 8 minutes, then rinse cold.
2. Mix the sweet chili sauce, lime juice and soy sauce and pour into the bottom of 4 jars.
3. Layer in the noodles, chicken, vegetables and peanuts.
4. Shake into a bowl at lunch.

#### `tomato-basil-soup-quick` · 5-ingredient tomato soup with cheese toasties · 🍅 · British
vibes: comfort, quickEasy, family · appliances: stovetop, blender · prep 5 / cook 15 min · serves 4 · leftovers: no

- chopped-tomatoes 800 g
- onion 1 piece (diced)
- vegetable-bouillon 2 tsp
- cream-cheese 50 g
- wholemeal-bread 8 slice
- cheddar 100 g (grated)
- butter 1 tbsp

1. Soften the onion in a little oil for 5 minutes, add the tomatoes, 300 ml water and the bouillon and simmer for 10 minutes.
2. Blend with the cream cheese until silky.
3. Make cheese sandwiches, butter the outsides and fry for 3 minutes on each side.
4. Cut into soldiers and dunk.

#### `spinach-feta-wrap-baked` · Crispy spinach & feta baked wraps · 🌯 · Mediterranean
vibes: healthyish, quickEasy · appliances: oven · prep 5 / cook 12 min · serves 2 · leftovers: no

- tortillas 2 piece
- spinach-frozen 150 g (thawed and squeezed)
- feta 60 g (crumbled)
- cottage-cheese 80 g
- garlic-powder 0.5 tsp
- olive-oil 1 tsp

1. Heat the oven to 200°C (400°F).
2. Mix the spinach, feta, cottage cheese and garlic powder.
3. Fill the tortillas, roll up and brush with oil.
4. Bake seam-side down for 12 minutes until crisp — like a quick spanakopita.

#### `crunchy-cabbage-peanut-salad` · Crunchy cabbage peanut salad · 🥜 · Thai
vibes: healthyish, lowCalorie, batchFriendly · appliances: none · prep 15 / cook 0 min · serves 4 · leftovers: yes

- cabbage 300 g (finely shredded)
- red-cabbage 200 g (finely shredded)
- carrot 2 piece (grated)
- edamame-frozen 150 g (thawed)
- peanut-butter 3 tbsp
- soy-sauce 2 tbsp
- lime 2 piece
- honey 1 tbsp
- peanuts 40 g (chopped)

1. Whisk the peanut butter, soy sauce, lime juice and honey with 2 tbsp warm water.
2. Toss the cabbages, carrot and edamame in the dressing.
3. Scatter with peanuts.
4. It stays crunchy in the fridge for 3 days.

### Breakfasts (20)

#### `protein-oats-egg-whites` · Fluffy egg-white protein oats · 🥣 · Other
vibes: highProtein, quickEasy · appliances: stovetop · prep 2 / cook 8 min · serves 2 · leftovers: no

- rolled-oats 80 g
- milk 300 ml
- eggs 2 piece
- banana 1 piece (sliced)
- peanut-butter 1 tbsp
- cinnamon 1 pinch

1. Simmer the oats in the milk for 4 minutes.
2. Whisk in the eggs and keep stirring for 2 minutes — the oats turn fluffy and creamy.
3. Spoon into bowls.
4. Top with banana, peanut butter and cinnamon.

#### `tiramisu-style-overnight-oats` · Chocolate cheesecake overnight oats · 🍫 · Other
vibes: family, batchFriendly · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 200 ml
- greek-yogurt 100 g
- cream-cheese 40 g
- honey 1 tbsp
- dark-chocolate 15 g (grated)

1. Stir the oats, milk and half the yogurt together and split between jars.
2. Whisk the rest of the yogurt with the cream cheese and honey and spoon on top.
3. Chill overnight.
4. Grate over the chocolate before eating.

#### `egg-avocado-toast-chili` · Jammy egg avocado toast · 🥑 · Other
vibes: quickEasy, healthyish · appliances: stovetop · prep 3 / cook 7 min · serves 2 · leftovers: no

- eggs 2 piece
- avocado 1 piece
- lime 0.5 piece
- sourdough 2 slice
- chili-flakes 1 pinch
- sesame-seeds 1 tsp

1. Boil the eggs for 6½ minutes, then cool and peel.
2. Mash the avocado with the lime juice and salt.
3. Spread onto toasted sourdough and top with the halved jammy eggs.
4. Finish with chili and sesame.

#### `banana-bread-overnight-oats` · Banana bread overnight oats · 🍌 · Other
vibes: family, batchFriendly · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- banana 2 piece (1 mashed, 1 sliced)
- milk 200 ml
- greek-yogurt 100 g
- cinnamon 1 tsp
- walnuts 15 g (chopped)

1. Mash one banana and stir with the oats, milk, yogurt and cinnamon.
2. Split between jars and chill overnight.
3. Top with the sliced banana and walnuts.
4. It tastes like banana bread batter.

#### `breakfast-egg-fried-rice-kimchi` · Kimchi breakfast rice with fried egg · 🍳 · Korean
vibes: quickEasy, comfort · appliances: stovetop, microwave · prep 2 / cook 8 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- kimchi 100 g (chopped)
- butter 1 tbsp
- soy-sauce 1 tsp
- eggs 2 piece
- spring-onion 1 piece (sliced)

1. Fry the kimchi in the butter for 2 minutes.
2. Add the rice and soy sauce and stir-fry for 3 minutes until hot.
3. Fry the eggs until crispy at the edges.
4. Serve the rice topped with an egg and spring onion.

#### `strawberry-style-yogurt-toast` · Berry yogurt toast · 🍓 · Other
vibes: quickEasy, healthyish · appliances: none · prep 3 / cook 2 min · serves 2 · leftovers: no

- sourdough 2 slice
- greek-yogurt 120 g
- berries-frozen 100 g (thawed)
- honey 1 tsp

1. Toast the sourdough.
2. Spread thickly with the yogurt.
3. Top with the berries and their juice.
4. Drizzle with honey.

#### `spinach-mushroom-omelette` · Mushroom & spinach omelette · 🍄 · Other
vibes: highProtein, quickEasy · appliances: stovetop · prep 3 / cook 7 min · serves 2 · leftovers: no

- eggs 5 piece (beaten)
- mushrooms 120 g (sliced)
- spinach 40 g
- butter 1 tbsp
- cheddar 30 g (grated)
- wholemeal-bread 2 slice

1. Fry the mushrooms in half the butter for 4 minutes until golden, then add the spinach.
2. Set aside, melt the rest of the butter and pour in half the egg.
3. Add half the filling and cheese when nearly set, fold and slide out. Repeat.
4. Serve with toast.

#### `baked-oats-cups-chocolate` · Chocolate chip baked oat cups · 🧁 · Other
vibes: batchFriendly, family · appliances: oven · prep 10 / cook 20 min · serves 4 · leftovers: yes

- rolled-oats 200 g
- banana 2 piece (mashed)
- eggs 2 piece
- milk 200 ml
- dark-chocolate 30 g (chopped)
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F) and line a 12-hole muffin tin.
2. Mix everything except half the chocolate.
3. Divide between the cases and press the rest of the chocolate on top.
4. Bake for 20 minutes. They keep 4 days — grab-and-go breakfast.

#### `chia-free-berry-smoothie` · Berry oat breakfast smoothie · 🫐 · Other
vibes: quickEasy, healthyish · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- berries-frozen 200 g
- banana 1 piece
- rolled-oats 30 g
- greek-yogurt 150 g
- milk 250 ml

1. Put everything in the blender.
2. Blend until smooth and thick.
3. Add a splash more milk if needed.
4. Pour into two glasses.

#### `cottage-cheese-scramble-wrap` · Cottage cheese scramble breakfast wrap · 🌯 · Other
vibes: highProtein, quickEasy · appliances: stovetop · prep 2 / cook 6 min · serves 2 · leftovers: no

- eggs 3 piece
- cottage-cheese 80 g
- spinach 30 g
- tortillas 2 piece
- salsa 60 g

1. Whisk the eggs with the cottage cheese.
2. Scramble gently with the spinach until just set.
3. Fill the tortillas and add salsa.
4. Roll up and eat warm.

#### `sheet-pan-egg-bake` · Sheet-pan breakfast egg bake · 🍳 · American
vibes: batchFriendly, highProtein, family · appliances: oven · prep 10 / cook 20 min · serves 4 · leftovers: yes

- eggs 10 piece
- milk 100 ml
- bell-pepper 1 piece (diced)
- spinach 60 g (chopped)
- cheddar 80 g (grated)
- ham 3 slice (chopped)

1. Heat the oven to 190°C (375°F) and line a baking tray with a rim.
2. Whisk the eggs and milk with a pinch of salt.
3. Scatter the pepper, spinach, ham and cheese over the tray and pour over the eggs.
4. Bake for 18–20 minutes until set, then cut into squares. They keep 4 days.

#### `apple-cinnamon-yogurt-bowl` · Warm apple cinnamon yogurt bowl · 🍎 · Other
vibes: comfort, healthyish · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- apple 2 piece (diced)
- butter 1 tsp
- cinnamon 1 tsp
- honey 1 tbsp
- greek-yogurt 250 g
- rolled-oats 30 g

1. Cook the apple in the butter with the cinnamon for 5 minutes until soft.
2. Add the oats and honey for 1 minute until toasty.
3. Spoon the yogurt into bowls.
4. Top with the warm apple crumble.

#### `hash-brown-egg-cups` · Hash brown egg cups · 🥔 · American
vibes: family, batchFriendly · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: yes

- potato 3 piece (grated and squeezed dry)
- olive-oil 1 tbsp
- eggs 8 piece
- cheddar 60 g (grated)
- spring-onion 2 piece (sliced)
- salt 1 tsp

1. Heat the oven to 200°C (400°F) and oil a 12-hole muffin tin.
2. Toss the potato with the oil and salt and press into the holes to make nests. Bake for 12 minutes.
3. Crack an egg into 8 of the nests (beat the rest and split between the other 4) and top with cheese and spring onion.
4. Bake for 12 minutes until set.

#### `peanut-butter-oat-smoothie` · Peanut butter oat breakfast smoothie · 🥜 · Other
vibes: quickEasy, highProtein · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- banana 2 piece
- peanut-butter 2 tbsp
- rolled-oats 40 g
- milk 350 ml
- cinnamon 1 pinch

1. Put everything in the blender.
2. Blend until smooth.
3. Add ice or more milk to your liking.
4. Pour into two glasses.

#### `savory-yogurt-bowl-egg` · Savory Greek yogurt bowl with jammy egg · 🥣 · Middle Eastern
vibes: highProtein, quickEasy · appliances: stovetop · prep 3 / cook 7 min · serves 2 · leftovers: no

- greek-yogurt 250 g
- eggs 2 piece
- cucumber 0.5 piece (diced)
- tomato 1 piece (diced)
- olive-oil 1 tbsp
- paprika 1 pinch
- pita-bread 1 piece

1. Boil the eggs for 6½ minutes, then cool and peel.
2. Spread the yogurt in bowls and season with salt.
3. Top with cucumber, tomato and the halved eggs, then drizzle with oil and paprika.
4. Serve with warm pitta.

#### `blueberry-pancake-bites` · Blueberry pancake muffin bites · 🫐 · American
vibes: family, batchFriendly · appliances: oven · prep 5 / cook 15 min · serves 4 · leftovers: no

- flour 150 g
- baking-powder 2 tsp
- eggs 1 piece
- milk 180 ml
- maple-syrup 2 tbsp
- berries-frozen 120 g

1. Heat the oven to 190°C (375°F) and oil a 24-hole mini muffin tin.
2. Whisk the flour, baking powder, egg, milk and maple syrup into a batter.
3. Spoon into the holes and press in the berries.
4. Bake for 12–15 minutes. Freeze extras and reheat for busy mornings.

#### `breakfast-burrito-freezer` · Freezer egg & potato breakfast burritos · 🌯 · Mexican
vibes: batchFriendly, highProtein · appliances: stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- potato 2 piece (diced)
- olive-oil 1 tbsp
- eggs 6 piece (beaten)
- cheddar 80 g (grated)
- salsa 100 g
- tortillas 4 piece

1. Fry the potato in the oil for 12 minutes until crisp.
2. Add the eggs and scramble until just set.
3. Fill the tortillas with eggs, potatoes, cheese and salsa and roll tightly.
4. Eat now, or wrap and freeze. Microwave from frozen for 2–3 minutes.

#### `oat-banana-waffle-pancakes` · Banana oat pancakes with yogurt · 🥞 · Other
vibes: family, quickEasy · appliances: blender, stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- rolled-oats 80 g
- banana 1 piece
- eggs 1 piece
- milk 120 ml
- baking-powder 1 tsp
- greek-yogurt 100 g

1. Blend the oats, banana, egg, milk and baking powder until smooth.
2. Rest for 2 minutes to thicken.
3. Cook small pancakes in a lightly oiled pan for 2 minutes on each side.
4. Stack with yogurt.

#### `tomato-egg-stir-fry` · Chinese-style tomato & egg stir-fry · 🍅 · Chinese
vibes: quickEasy, comfort · appliances: stovetop · prep 3 / cook 15 min · serves 2 · leftovers: no

- eggs 4 piece (beaten)
- tomato 3 piece (cut into wedges)
- vegetable-oil 1 tbsp
- sugar 1 tsp
- soy-sauce 1 tsp
- spring-onion 2 piece (sliced)
- long-grain-rice 80 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Meanwhile, softly scramble the eggs in half the oil and set aside.
3. Fry the tomatoes in the rest of the oil for 3 minutes until juicy, with the sugar and soy sauce.
4. Return the eggs, fold through and serve over the rice with spring onions.

#### `cinnamon-raisin-porridge` · Cinnamon raisin porridge · 🥣 · British
vibes: comfort, family · appliances: stovetop · prep 2 / cook 6 min · serves 2 · leftovers: no

- rolled-oats 90 g
- milk 450 ml
- raisins 30 g
- cinnamon 1 tsp
- honey 1 tbsp

1. Put the oats, milk, raisins and cinnamon in a pan.
2. Simmer for 5 minutes, stirring, until thick and creamy.
3. Spoon into bowls.
4. Drizzle with honey.

### Snacks (15)

#### `cottage-cheese-pizza-bowl` · Cottage cheese pizza bowl · 🍕 · Italian
vibes: highProtein, quickEasy · appliances: microwave · prep 3 / cook 2 min · serves 2 · leftovers: no

- cottage-cheese 200 g
- passata 60 g
- mozzarella 0.25 piece (grated)
- dried-oregano 0.5 tsp

1. Split the cottage cheese between two mugs or bowls.
2. Top with passata, mozzarella and oregano.
3. Microwave for 1–2 minutes until melted and bubbling.

#### `frozen-yogurt-berry-bites` · Frozen yogurt berry bites · 🫐 · Other
vibes: healthyish, family · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- greek-yogurt 300 g
- honey 1 tbsp
- berries-frozen 120 g

1. Mix the yogurt and honey.
2. Coat each berry and drop in clusters onto a lined tray.
3. Freeze for 2 hours.

#### `peanut-butter-protein-dip` · Peanut butter protein dip with apples · 🍎 · Other
vibes: highProtein, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- greek-yogurt 120 g
- peanut-butter 2 tbsp
- honey 1 tsp
- apple 1 piece (sliced)

1. Whisk the yogurt, peanut butter and honey until smooth.
2. Slice the apple.
3. Dip and enjoy.

#### `everything-cucumber-salad` · Everything bagel cucumber salad · 🥒 · American
vibes: lowCalorie, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- cucumber 1.5 piece (thinly sliced)
- cream-cheese 40 g
- sesame-seeds 2 tsp
- garlic-powder 0.5 tsp
- onion-powder 0.5 tsp
- lemon 0.5 piece

1. Whisk the cream cheese with the lemon juice and a splash of water.
2. Toss with the cucumber in a container.
3. Shake with the sesame, garlic and onion powder and a pinch of salt.

#### `air-fryer-chickpea-crunch` · Air-fryer honey chili chickpeas · 🫘 · Other
vibes: healthyish, batchFriendly · appliances: airFryer · prep 2 / cook 15 min · serves 4 · leftovers: no

- chickpeas 480 g (drained and patted dry)
- olive-oil 1 tbsp
- honey 1 tbsp
- chili-flakes 0.5 tsp
- salt 1 tsp

1. Toss the chickpeas with the oil.
2. Air-fry at 200°C (400°F) for 12 minutes, shaking halfway.
3. Toss with the honey, chili and salt and air-fry for 3 minutes more.

#### `banana-oat-energy-bites` · Banana oat energy bites · 🍌 · Other
vibes: batchFriendly, family · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- banana 1 piece (mashed)
- rolled-oats 100 g
- peanut-butter 2 tbsp
- dark-chocolate 20 g (chopped)
- cinnamon 0.5 tsp

1. Mash everything together.
2. Roll into 12 balls.
3. Chill for 30 minutes. Keep for 4 days.

#### `cheesy-tortilla-crisps` · Cheesy tortilla crisps with salsa · 🧀 · Mexican
vibes: family, quickEasy · appliances: oven · prep 3 / cook 8 min · serves 2 · leftovers: no

- tortillas 2 piece (cut into triangles)
- cheddar 30 g (finely grated)
- paprika 1 pinch
- salsa 80 g

1. Heat the oven to 200°C (400°F) and spread the triangles on a tray.
2. Sprinkle with cheese and paprika and bake for 7–8 minutes until crisp.
3. Serve with salsa.

#### `mango-chili-lime-yogurt` · Mango chili-lime yogurt cups · 🥭 · Mexican
vibes: healthyish, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- mango 1 piece (diced)
- greek-yogurt 150 g
- lime 0.5 piece
- chili-powder 1 pinch
- honey 1 tsp

1. Toss the mango with the lime juice and chili.
2. Spoon the yogurt into cups with the honey.
3. Top with the mango.

#### `hummus-veggie-snack-cups` · Hummus veggie snack cups · 🥕 · Middle Eastern
vibes: healthyish, quickEasy, family · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- hummus 200 g
- carrot 2 piece (cut into sticks)
- cucumber 1 piece (cut into sticks)
- bell-pepper 1 piece (cut into strips)

1. Spoon the hummus into the bottom of 4 small cups or jars.
2. Stand the veg sticks upright in the hummus.
3. Cover and keep in the fridge for grab-and-go snacks.

#### `dark-chocolate-banana-bites` · Dark chocolate banana coins · 🍫 · Other
vibes: family, healthyish · appliances: microwave · prep 10 / cook 1 min · serves 4 · leftovers: no

- banana 2 piece (sliced into coins)
- dark-chocolate 40 g
- sesame-seeds 1 tsp

1. Melt the chocolate in the microwave.
2. Dip half of each banana coin, sprinkle with sesame and lay on a lined tray.
3. Chill or freeze for 30 minutes.

#### `popcorn-parmesan-garlic` · Garlic parmesan popcorn · 🍿 · Italian
vibes: family, quickEasy · appliances: stovetop · prep 2 / cook 5 min · serves 2 · leftovers: no

- popcorn-kernels 50 g
- vegetable-oil 1 tbsp
- parmesan 15 g (finely grated)
- garlic-powder 0.5 tsp

1. Heat the oil in a large lidded pan with 3 kernels until they pop, then add the rest and shake until the popping slows.
2. Toss with the parmesan and garlic powder.
3. Eat warm.

#### `cucumber-tuna-boats` · Cucumber tuna boats · 🥒 · Other
vibes: highProtein, lowCalorie · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- cucumber 1 piece (halved lengthways and seeded)
- canned-tuna 145 g (drained)
- greek-yogurt 30 g
- sriracha 1 tsp
- sesame-seeds 1 tsp

1. Mix the tuna with the yogurt and sriracha.
2. Spoon into the cucumber boats.
3. Sprinkle with sesame and cut into pieces.

#### `baked-apple-chips-oven` · Oven-baked cinnamon apple chips · 🍏 · Other
vibes: healthyish, family · appliances: oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- apple 2 piece (very thinly sliced)
- cinnamon 1 tsp

1. Heat the oven to 150°C (300°F).
2. Lay the apple slices on lined trays and dust with cinnamon.
3. Bake for 25 minutes, flipping once, then cool to crisp up.

#### `protein-hot-chocolate` · Protein hot chocolate · ☕ · Other
vibes: highProtein, comfort · appliances: stovetop · prep 2 / cook 4 min · serves 2 · leftovers: no

- milk 400 ml
- dark-chocolate 30 g (chopped)
- greek-yogurt 60 g
- honey 1 tsp

1. Warm the milk with the chocolate, whisking until melted.
2. Take off the heat and whisk in the yogurt and honey until frothy.
3. Pour into mugs.

#### `egg-muffin-bites-snack` · Mini egg & cheese snack bites · 🧁 · Other
vibes: highProtein, batchFriendly · appliances: oven · prep 5 / cook 15 min · serves 4 · leftovers: no

- eggs 4 piece
- cheddar 40 g (grated)
- spinach 20 g (finely chopped)
- milk 2 tbsp

1. Heat the oven to 180°C (350°F) and oil a 12-hole mini muffin tin.
2. Whisk everything with a pinch of salt and divide between the holes.
3. Bake for 12–15 minutes. Keep in the fridge for 4 days.
