# Codex prompt: trending recipes, batch 1 (150 recipes)

Paste everything below the line into Codex. It is self-contained: the recipes are written out in full.

---

Read `CLAUDE.md` and `BUILD_NOTES.md` (section 3d) first, and follow the project's rules.

## Task

Add the 150 recipes below (70 dinners, 30 lunches, 25 breakfasts, 25 snacks) to the bundled
library as trending recipes, the same way as `Tools/trending_recipes.py`.

1. Create `Tools/trending_batch1.py`. Write each recipe with `T(...)` from `trending_recipes.py` (it adds the `trending` tag),
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

### Dinners (70)

#### `chicken-shawarma-rice-bowl` · Chicken shawarma rice bowl · 🥙 · Middle Eastern
vibes: highProtein, batchFriendly · appliances: oven, stovetop · prep 15 / cook 25 min · serves 4 · leftovers: yes

- chicken-thighs 600 g
- greek-yogurt 150 g
- cumin 2 tsp
- paprika 2 tsp
- turmeric 1 tsp
- cinnamon 0.5 tsp
- garlic 3 clove (crushed)
- lemon 1 piece
- basmati-rice 250 g
- cucumber 1 piece (diced)
- tomato 2 piece (diced)
- red-onion 0.5 piece (sliced)
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix half the yogurt with the spices, two-thirds of the garlic, half the lemon juice and the salt, and coat the chicken.
3. Roast on a lined tray for 25 minutes until charred at the edges.
4. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
5. Stir the rest of the garlic and lemon into the rest of the yogurt.
6. Slice the chicken and serve over rice with cucumber, tomato, onion and garlic yogurt.

#### `teriyaki-chicken-rice-bowl` · Teriyaki chicken rice bowl · 🍱 · Japanese
vibes: quickEasy, family, fakeaway · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: yes

- chicken-thighs 500 g (cut into strips)
- vegetable-oil 1 tbsp
- soy-sauce 4 tbsp
- honey 2 tbsp
- rice-vinegar 1 tbsp
- ginger 10 g (grated)
- garlic 2 clove (crushed)
- cornstarch 1 tsp
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)
- carrot 1 piece (sliced)
- sesame-seeds 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, adding the broccoli and carrot for the last 4, then drain.
2. Whisk the soy sauce, honey, vinegar, ginger, garlic, cornstarch and 3 tbsp water.
3. Heat the oil in a large frying pan over a medium-high heat.
4. Fry the chicken for 7 minutes until golden and cooked through.
5. Pour in the sauce and bubble for 2 minutes until thick and glossy.
6. Serve over the rice and vegetables with sesame seeds.

#### `bang-bang-shrimp-bowl` · Crispy bang bang shrimp bowl · 🍤 · American
vibes: fakeaway, quickEasy · appliances: airFryer, stovetop · prep 15 / cook 12 min · serves 2 · leftovers: no

- shrimp 200 g
- cornstarch 2 tbsp
- eggs 1 piece (beaten)
- breadcrumbs 50 g
- long-grain-rice 150 g
- mayonnaise 2 tbsp
- sweet-chili-sauce 2 tbsp
- sriracha 1 tsp
- cabbage 150 g (shredded)
- cucumber 0.5 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Dust the shrimp in cornstarch, dip in egg, then roll in the breadcrumbs.
3. Air-fry at 200°C (400°F) for 8–10 minutes, shaking halfway, until crisp.
4. Mix the mayonnaise, sweet chili sauce and sriracha into bang bang sauce.
5. Toss the shrimp in half the sauce.
6. Serve over rice with cabbage and cucumber and the rest of the sauce.

#### `gochujang-tofu-bowl` · Gochujang glazed tofu rice bowl · 🌶️ · Korean
vibes: healthyish, fakeaway · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- tofu 800 g (pressed and cubed)
- cornstarch 2 tbsp
- vegetable-oil 2 tbsp
- gochujang 2 tbsp
- honey 2 tbsp
- soy-sauce 2 tbsp
- garlic 2 clove (crushed)
- long-grain-rice 250 g
- cucumber 1 piece (sliced)
- rice-vinegar 1 tbsp
- spring-onion 3 piece (sliced)
- sesame-seeds 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the cucumber with the vinegar and a pinch of salt.
3. Toss the tofu in the cornstarch and fry in the oil for 10 minutes, turning, until crisp all over.
4. Mix the gochujang, honey, soy sauce, garlic and 2 tbsp water.
5. Pour into the pan and toss for 1 minute until the tofu is sticky and glazed.
6. Serve over the rice with the cucumber, spring onions and sesame.

#### `miso-chicken-greens-traybake` · Miso chicken & broccoli traybake · 🍗 · Japanese
vibes: onePan, healthyish · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: no

- chicken-thighs 600 g
- miso-paste 2 tbsp
- honey 1 tbsp
- soy-sauce 1 tbsp
- broccoli 1 piece (cut into florets)
- vegetable-oil 1 tbsp
- long-grain-rice 250 g
- spring-onion 2 piece (sliced)
- sesame-seeds 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the miso, honey and soy sauce into a paste and rub over the chicken.
3. Roast the chicken on a lined tray for 15 minutes.
4. Toss the broccoli with the oil, add to the tray and roast for 10 minutes more until the chicken is caramelised.
5. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
6. Serve with spring onions and sesame seeds.

#### `sticky-chili-tofu-bowl` · Sticky chili tofu bowl · 🌶️ · Chinese
vibes: fakeaway, healthyish · appliances: stovetop · prep 10 / cook 15 min · serves 2 · leftovers: no

- tofu 400 g (pressed and cubed)
- cornstarch 2 tbsp
- vegetable-oil 1 tbsp
- sweet-chili-sauce 3 tbsp
- soy-sauce 2 tbsp
- garlic 2 clove (crushed)
- lime 1 piece
- basmati-rice 150 g
- bell-pepper 1 piece (sliced)
- spring-onion 2 piece (sliced)
- sesame-seeds 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the tofu in the cornstarch.
3. Fry the tofu in the oil over a medium-high heat for 10 minutes, turning, until crisp.
4. Add the pepper and garlic and cook for 2 minutes.
5. Stir in the sweet chili sauce, soy sauce and lime juice and toss until sticky.
6. Serve over rice with spring onion and sesame seeds.

#### `sticky-lemon-chicken-bowl` · Air-fryer sticky lemon chicken bowl · 🍋 · Chinese
vibes: fakeaway, family · appliances: airFryer, stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-breast 3 piece (cut into chunks)
- cornstarch 3 tbsp
- eggs 1 piece (beaten)
- lemon 2 piece
- honey 3 tbsp
- soy-sauce 1 tbsp
- garlic 2 clove (crushed)
- long-grain-rice 250 g
- green-beans 200 g
- sesame-seeds 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, adding the green beans for the last 4, then drain.
2. Dip the chicken in egg, then toss in 2 tbsp cornstarch.
3. Air-fry at 200°C (400°F) for 12 minutes, shaking halfway, until golden.
4. Simmer the lemon zest and juice, honey, soy sauce and garlic in a pan for 2 minutes.
5. Stir in the rest of the cornstarch mixed with 2 tbsp water until thick.
6. Toss the chicken in the sauce and serve over rice and beans with sesame seeds.

#### `sweet-chili-chicken-bowl` · Sweet chili chicken & veg bowl · 🍗 · Thai
vibes: quickEasy, family · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- chicken-breast 3 piece (sliced)
- vegetable-oil 1 tbsp
- bell-pepper 2 piece (sliced)
- zucchini 1 piece (sliced)
- sweet-chili-sauce 4 tbsp
- soy-sauce 2 tbsp
- lime 1 piece
- basmati-rice 250 g
- cilantro 15 g (chopped)
- peanuts 30 g (chopped)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Heat the oil in a wok over a high heat and stir-fry the chicken for 5 minutes.
3. Add the peppers and zucchini and cook for 4 minutes.
4. Stir in the sweet chili sauce, soy sauce and lime juice and toss for 1 minute.
5. Spoon over the rice.
6. Finish with cilantro and peanuts.

#### `garlic-butter-steak-bites` · Garlic butter steak bites & potatoes · 🥩 · American
vibes: highProtein, comfort · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- beef-steak 2 piece (cut into cubes)
- potato 5 piece (cubed)
- olive-oil 1 tbsp
- butter 3 tbsp
- garlic 5 clove (crushed)
- green-beans 250 g
- chili-flakes 1 pinch
- salt 1 tsp
- black-pepper 1 pinch

1. Boil the potatoes for 8 minutes, adding the green beans for the last 3, then drain well.
2. Fry the potatoes in the oil over a high heat for 6 minutes until crisp, then push to one side with the beans.
3. Season the steak with salt and pepper.
4. Sear it in the hot pan for 2–3 minutes, turning, so it's browned outside and pink inside.
5. Add the butter, garlic and chili and toss everything for 1 minute until coated.
6. Serve straight from the pan.

#### `steak-chimichurri-bowl` · Steak & chimichurri rice bowl · 🌿 · Other
vibes: highProtein, healthyish · appliances: stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- beef-steak 2 piece
- parsley 25 g (finely chopped)
- garlic 1 clove (crushed)
- red-wine-vinegar 1 tbsp
- olive-oil 3 tbsp
- chili-flakes 0.5 tsp
- dried-oregano 0.5 tsp
- long-grain-rice 250 g
- tomato 2 piece (diced)
- black-beans 240 g (drained)
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Mix the parsley, garlic, vinegar, 2 tbsp oil, chili, oregano and a pinch of salt into a chimichurri.
3. Rub the steaks with the rest of the oil and salt and sear in a smoking-hot pan for 3 minutes on each side.
4. Rest for 5 minutes, then slice thinly.
5. Warm the beans in the same pan to pick up the juices.
6. Serve the steak over rice with beans and tomato, spooning over the chimichurri.

#### `chicken-fajita-rice-bowl` · Sheet-pan chicken fajita rice bowl · 🫑 · Mexican
vibes: onePan, family, batchFriendly · appliances: oven, stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- chicken-breast 3 piece (sliced)
- bell-pepper 3 piece (sliced)
- red-onion 1 piece (sliced)
- olive-oil 2 tbsp
- paprika 2 tsp
- cumin 1 tsp
- chili-powder 1 tsp
- garlic-powder 1 tsp
- long-grain-rice 250 g
- lime 1 piece
- greek-yogurt 150 g
- salsa 150 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the chicken, peppers and onion with the oil, spices and salt on a large tray.
3. Roast for 22 minutes until the chicken is cooked and the peppers are charred.
4. Cook the rice in salted boiling water for 12 minutes, then drain and add the lime juice.
5. Mix the yogurt with a pinch of salt.
6. Serve the fajita tray over lime rice with salsa and yogurt.

#### `beef-taco-rice-skillet` · One-pan beef taco rice skillet · 🌮 · Mexican
vibes: onePan, family, comfort · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: yes

- ground-beef 500 g
- onion 1 piece (diced)
- chili-powder 2 tsp
- cumin 1 tsp
- paprika 1 tsp
- long-grain-rice 200 g
- chopped-tomatoes 400 g
- vegetable-stock 400 ml
- black-beans 240 g (drained)
- cheddar 80 g (grated)
- lettuce 0.25 piece (shredded)
- salt 1 tsp

1. Brown the beef and onion in a large lidded pan for 7 minutes.
2. Stir in the spices and cook for 1 minute.
3. Add the rice, tomatoes, stock, beans and salt and bring to a simmer.
4. Cover and cook on a low heat for 15 minutes until the rice is tender.
5. Scatter with cheddar, cover for 2 minutes to melt.
6. Serve topped with shredded lettuce.

#### `one-pot-cheeseburger-pasta` · One-pot cheeseburger pasta · 🍔 · American
vibes: onePan, family, comfort · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- ground-beef 400 g
- onion 1 piece (diced)
- garlic-powder 1 tsp
- tomato-paste 2 tbsp
- ketchup 1 tbsp
- dijon-mustard 1 tsp
- penne 300 g
- vegetable-stock 800 ml
- milk 100 ml
- cheddar 120 g (grated)
- salt 1 tsp

1. Brown the beef and onion in a large pan for 7 minutes.
2. Stir in the garlic powder, tomato paste, ketchup and mustard.
3. Add the pasta and stock and bring to the boil.
4. Simmer for 12 minutes, stirring often, until the pasta is tender.
5. Stir in the milk and cheddar until creamy.
6. Season with salt and serve.

#### `pesto-chicken-orzo` · Pesto chicken orzo with tomatoes · 🌿 · Italian
vibes: onePan, quickEasy, family · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 3 piece (diced)
- olive-oil 1 tbsp
- garlic 2 clove (crushed)
- orzo 250 g
- chicken-stock 750 ml
- pesto 4 tbsp
- cherry-tomatoes 200 g (halved)
- spinach 80 g
- parmesan 30 g (grated)
- salt 1 pinch

1. Heat the oil in a deep pan and cook the chicken for 5 minutes until golden.
2. Add the garlic and orzo and stir for 1 minute.
3. Pour in the stock and simmer for 10 minutes, stirring often.
4. Stir in the tomatoes and spinach for 2 minutes.
5. Take off the heat and stir through the pesto and parmesan.
6. Season and serve.

#### `lemon-pepper-chicken-rice` · One-pan lemon pepper chicken & rice · 🍋 · American
vibes: onePan, family · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- chicken-thighs 600 g
- long-grain-rice 250 g
- vegetable-bouillon 1 tsp
- lemon 2 piece
- black-pepper 2 tsp
- garlic-powder 1 tsp
- olive-oil 1 tbsp
- peas-frozen 150 g
- salt 1 tsp

1. Rub the chicken with the lemon zest, pepper, garlic powder and salt.
2. Brown it in the oil in a deep lidded pan for 4 minutes on each side, then set aside.
3. Stir the rice into the pan juices, then add 550 ml boiling water, the bouillon and the juice of 1 lemon.
4. Sit the chicken on top, cover and cook on a low heat for 15 minutes.
5. Scatter over the peas, cover and cook for 3 minutes more.
6. Serve with the other lemon in wedges.

#### `cajun-chicken-pasta` · Creamy Cajun chicken pasta · 🌶️ · American
vibes: comfort, family · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-breast 2 piece (sliced)
- paprika 2 tsp
- garlic-powder 1 tsp
- onion-powder 1 tsp
- dried-thyme 1 tsp
- chili-powder 0.5 tsp
- olive-oil 1 tbsp
- bell-pepper 1 piece (sliced)
- penne 300 g
- heavy-cream 100 ml
- chicken-stock 150 ml
- parmesan 30 g (grated)
- salt 1 tsp

1. Cook the pasta in salted boiling water, then drain.
2. Mix the spices with the salt and toss with the chicken.
3. Heat the oil in a large pan and cook the chicken for 6 minutes until cooked through.
4. Add the pepper and cook for 3 minutes.
5. Pour in the stock and cream and simmer for 2 minutes.
6. Toss in the pasta and parmesan and serve.

#### `tuscan-white-bean-skillet` · Tuscan white bean skillet · 🫘 · Italian
vibes: onePan, healthyish, quickEasy · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- olive-oil 1 tbsp
- garlic 3 clove (sliced)
- chopped-tomatoes 200 g
- roasted-peppers 100 g (sliced)
- cannellini-beans 480 g (drained)
- italian-herbs 1 tsp
- spinach-frozen 100 g
- lemon 0.5 piece
- sourdough 2 slice
- salt 1 pinch

1. Heat the oil in a frying pan and cook the garlic for 1 minute.
2. Add the tomatoes, peppers, beans and herbs and simmer for 6 minutes.
3. Lightly crush some beans to thicken the sauce.
4. Stir in the spinach until hot.
5. Add a squeeze of lemon and season.
6. Serve with toasted sourdough.

#### `creamy-gochujang-pasta` · Creamy gochujang pasta · 🍝 · Korean
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- penne 200 g
- butter 1 tbsp
- garlic 2 clove (crushed)
- gochujang 2 tbsp
- heavy-cream 80 ml
- parmesan 20 g (grated)
- spring-onion 2 piece (sliced)
- sesame-seeds 1 tsp
- spinach 50 g

1. Cook the pasta in salted boiling water, saving a mug of water before draining.
2. Melt the butter in a pan and cook the garlic for 1 minute.
3. Stir in the gochujang, then the cream.
4. Add the pasta, spinach, parmesan and a splash of pasta water.
5. Toss until glossy and the spinach wilts.
6. Top with spring onion and sesame seeds.

#### `creamy-pepper-chickpeas-orzo` · Creamy red pepper chickpeas with orzo · 🫑 · Mediterranean
vibes: onePan, comfort, healthyish · appliances: stovetop, blender · prep 10 / cook 15 min · serves 4 · leftovers: no

- roasted-peppers 300 g
- garlic 2 clove
- cream-cheese 100 g
- olive-oil 1 tbsp
- onion 1 piece (diced)
- paprika 1 tsp
- chickpeas 480 g (drained)
- orzo 250 g
- vegetable-stock 700 ml
- spinach 100 g
- basil 10 g
- salt 1 tsp

1. Blend the peppers, garlic and cream cheese until smooth.
2. Heat the oil in a deep pan and cook the onion for 5 minutes.
3. Add the paprika, orzo and stock and simmer for 10 minutes, stirring often.
4. Stir in the pepper sauce and chickpeas and heat for 3 minutes.
5. Fold through the spinach until wilted and season.
6. Serve topped with basil.

#### `coconut-lime-chicken-curry` · Coconut lime chicken curry · 🥥 · Thai
vibes: quickEasy, comfort, batchFriendly · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: yes

- chicken-thighs 500 g (diced)
- vegetable-oil 1 tbsp
- thai-curry-paste 2 tbsp
- coconut-milk 400 ml
- fish-sauce 1 tbsp
- lime 2 piece
- bell-pepper 1 piece (sliced)
- green-beans 150 g
- basmati-rice 250 g
- cilantro 15 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Heat the oil in a deep pan and fry the curry paste for 1 minute.
3. Add the chicken and cook for 5 minutes.
4. Pour in the coconut milk and simmer for 8 minutes.
5. Add the pepper and beans and simmer for 4 minutes.
6. Stir in the fish sauce and lime juice and serve over rice with cilantro.

#### `red-curry-chickpea-traybake` · Red curry chickpea & sweet potato traybake · 🥥 · Thai
vibes: onePan, healthyish, batchFriendly · appliances: oven, stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chickpeas 480 g (drained)
- sweet-potato 2 piece (cubed)
- broccoli 1 piece (cut into florets)
- vegetable-oil 1 tbsp
- thai-curry-paste 2 tbsp
- coconut-milk 400 ml
- lime 1 piece
- basmati-rice 250 g
- cilantro 10 g

1. Heat the oven to 220°C (425°F).
2. Toss the sweet potato and chickpeas with the oil and half the curry paste and roast for 15 minutes.
3. Add the broccoli and roast for 10 minutes more.
4. Meanwhile, cook the rice and warm the coconut milk with the rest of the curry paste for a quick sauce.
5. Pour the sauce over the tray and squeeze over the lime.
6. Serve over the rice with cilantro.

#### `shrimp-fried-rice` · Shrimp fried rice · 🍤 · Chinese
vibes: quickEasy, onePan, fakeaway · appliances: stovetop · prep 5 / cook 22 min · serves 2 · leftovers: no

- long-grain-rice 150 g
- shrimp 150 g
- eggs 2 piece (beaten)
- vegetable-oil 1 tbsp
- garlic 2 clove (crushed)
- peas-frozen 100 g
- corn-frozen 80 g
- soy-sauce 2 tbsp
- spring-onion 3 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, drain and spread on a plate to steam dry — dry rice fries, wet rice goes mushy.
2. Heat the oil in a wok over a high heat and cook the shrimp for 2 minutes. Set aside.
3. Scramble the eggs in the wok until just set, then push to one side.
4. Add the garlic, peas and corn and cook for 2 minutes.
5. Add the rice and stir-fry for 3 minutes until hot and starting to crisp.
6. Return the shrimp with the soy sauce and spring onions, toss and serve.

#### `garlic-shrimp-zucchini-pasta` · Garlic shrimp & zucchini spaghetti · 🍝 · Italian
vibes: quickEasy, healthyish · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- spaghetti 150 g
- shrimp 150 g
- zucchini 2 piece (cut into ribbons)
- olive-oil 2 tbsp
- garlic 3 clove (sliced)
- chili-flakes 0.5 tsp
- lemon 1 piece
- parmesan 15 g (grated)
- salt 1 pinch

1. Cook the spaghetti in salted boiling water, saving a mug of water before draining.
2. Heat the oil in a large pan and fry the garlic and chili for 1 minute.
3. Add the shrimp and cook for 3 minutes until pink.
4. Add the zucchini ribbons and toss for 2 minutes until just soft.
5. Toss in the spaghetti, lemon zest and juice and a splash of pasta water.
6. Finish with parmesan.

#### `pesto-chicken-potato-traybake` · Pesto chicken traybake with potatoes · 🌿 · Italian
vibes: onePan, family · appliances: oven · prep 10 / cook 35 min · serves 4 · leftovers: no

- chicken-thighs 600 g
- potato 5 piece (cubed)
- green-beans 250 g
- olive-oil 1 tbsp
- pesto 4 tbsp
- lemon 1 piece
- parmesan 20 g (grated)
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the potatoes with the oil and salt on a large tray and roast for 10 minutes.
3. Toss the chicken with half the pesto and add to the tray.
4. Roast for 20 minutes, add the green beans and roast for 5 minutes more.
5. Dot with the rest of the pesto and squeeze over the lemon.
6. Scatter with parmesan.

#### `fish-tacos-mango-salsa` · Fish tacos with mango salsa · 🌮 · Mexican
vibes: quickEasy, healthyish, family · appliances: stovetop · prep 15 / cook 8 min · serves 4 · leftovers: no

- white-fish 3 piece
- paprika 1 tsp
- cumin 1 tsp
- olive-oil 1 tbsp
- mango 1 piece (diced)
- red-onion 0.5 piece (finely diced)
- lime 2 piece
- cilantro 15 g (chopped)
- cabbage 150 g (shredded)
- greek-yogurt 100 g
- corn-tortillas 12 piece
- salt 1 tsp

1. Mix the mango, onion, juice of 1 lime and half the cilantro for the salsa.
2. Season the fish with the paprika, cumin and salt.
3. Cook in the oil for 3 minutes on each side until it flakes.
4. Warm the tortillas in a dry pan.
5. Mix the yogurt with the rest of the lime juice.
6. Fill the tortillas with cabbage, fish, salsa and lime yogurt, then top with cilantro.

#### `tuna-puttanesca` · Tuna puttanesca spaghetti · 🍝 · Italian
vibes: quickEasy, onePan · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- spaghetti 350 g
- olive-oil 2 tbsp
- garlic 3 clove (sliced)
- chili-flakes 0.5 tsp
- chopped-tomatoes 400 g
- olives 80 g (halved)
- canned-tuna 290 g (drained)
- parsley 15 g (chopped)
- lemon 0.5 piece

1. Cook the spaghetti in salted boiling water, saving some water before draining.
2. Heat the oil and fry the garlic and chili for 1 minute.
3. Add the tomatoes and olives and simmer for 10 minutes.
4. Flake in the tuna and warm through.
5. Toss with the spaghetti and a splash of pasta water.
6. Finish with parsley and a squeeze of lemon.

#### `chicken-souvlaki-pittas` · Chicken souvlaki pittas · 🥙 · Mediterranean
vibes: family, highProtein · appliances: oven · prep 15 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 3 piece (cubed)
- lemon 1 piece
- olive-oil 2 tbsp
- dried-oregano 2 tsp
- garlic 3 clove (crushed)
- greek-yogurt 150 g
- cucumber 1 piece
- tomato 2 piece (sliced)
- red-onion 0.5 piece (sliced)
- pita-bread 4 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the chicken with half the lemon juice, the oil, oregano, two-thirds of the garlic and salt.
3. Spread on a tray and roast for 18 minutes until golden.
4. Grate half the cucumber into the yogurt with the rest of the garlic and lemon.
5. Slice the rest of the cucumber.
6. Warm the pittas and fill with chicken, tzatziki, cucumber, tomato and onion.

#### `lamb-kofta-bowl` · Lamb kofta bowl with herby couscous · 🧆 · Middle Eastern
vibes: highProtein, family · appliances: oven · prep 15 / cook 15 min · serves 4 · leftovers: no

- lamb-mince 500 g
- onion 0.5 piece (grated)
- cumin 1 tsp
- ground-coriander 1 tsp
- cinnamon 0.5 tsp
- couscous 250 g
- vegetable-stock 350 ml
- mint 10 g (chopped)
- parsley 15 g (chopped)
- cucumber 1 piece (diced)
- hummus 150 g
- lemon 1 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the lamb, onion, spices and salt and shape into 12 koftas.
3. Bake on a lined tray for 15 minutes until browned.
4. Pour the hot stock over the couscous, cover for 5 minutes, then fluff.
5. Stir the herbs, cucumber and lemon juice through the couscous.
6. Serve the koftas over the couscous with hummus.

#### `spiced-lamb-naan-pizzas` · Spiced lamb naan pizzas · 🍕 · Middle Eastern
vibes: fakeaway, family · appliances: oven, stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- lamb-mince 300 g
- onion 1 piece (finely diced)
- cumin 1 tsp
- paprika 1 tsp
- tomato-paste 2 tbsp
- naan 4 piece
- feta 100 g (crumbled)
- greek-yogurt 100 g
- mint 5 g
- arugula 40 g
- lemon 0.5 piece

1. Heat the oven to 220°C (425°F).
2. Brown the lamb and onion in a frying pan for 7 minutes.
3. Stir in the spices and tomato paste with a splash of water.
4. Spread the lamb over the naan and scatter with feta.
5. Bake for 8 minutes until crisp at the edges.
6. Top with arugula, a squeeze of lemon and the yogurt mixed with mint.

#### `turkey-green-bean-stir-fry` · Ground turkey & green bean stir-fry · 🦃 · Chinese
vibes: quickEasy, highProtein, healthyish · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- ground-turkey 500 g
- vegetable-oil 1 tbsp
- green-beans 300 g (halved)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- soy-sauce 3 tbsp
- hoisin-sauce 2 tbsp
- chili-flakes 0.5 tsp
- long-grain-rice 250 g
- spring-onion 2 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Heat the oil in a wok over a high heat and stir-fry the green beans for 4 minutes until blistered.
3. Add the turkey and cook for 6 minutes, breaking it up.
4. Add the garlic, ginger and chili for 1 minute.
5. Stir in the soy and hoisin sauces.
6. Serve over rice with spring onions.

#### `turkey-stuffed-peppers` · Turkey taco stuffed peppers · 🫑 · American
vibes: healthyish, family, highProtein · appliances: oven, stovetop · prep 15 / cook 30 min · serves 4 · leftovers: yes

- bell-pepper 4 piece (halved)
- ground-turkey 400 g
- onion 1 piece (diced)
- chili-powder 2 tsp
- cumin 1 tsp
- microwave-rice 1 piece
- black-beans 240 g (drained)
- salsa 150 g
- cheddar 80 g (grated)
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Roast the pepper halves on a tray for 10 minutes.
3. Brown the turkey and onion for 7 minutes, then add the spices.
4. Stir in the rice, beans, salsa and salt.
5. Pack into the peppers and top with cheddar.
6. Bake for 15 minutes until the cheese is bubbling.

#### `chicken-enchilada-bake` · Chicken enchilada bake · 🌯 · Mexican
vibes: family, comfort, batchFriendly · appliances: oven, stovetop · prep 15 / cook 25 min · serves 4 · leftovers: yes

- chicken-breast 2 piece
- passata 500 g
- chili-powder 2 tsp
- cumin 1 tsp
- garlic-powder 1 tsp
- black-beans 240 g (drained)
- sweetcorn-tin 165 g (drained)
- tortillas 4 piece
- cheddar 100 g (grated)
- sour-cream 100 g
- cilantro 10 g
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Poach the chicken in simmering water for 12 minutes, then shred.
3. Simmer the passata with the spices and salt for 5 minutes.
4. Mix the chicken with the beans, sweetcorn and a third of the sauce.
5. Fill and roll the tortillas, lay in a dish and pour over the rest of the sauce.
6. Top with cheddar and bake for 20 minutes.
7. Serve with sour cream and cilantro.

#### `chicken-tortilla-soup` · Chicken tortilla soup · 🥣 · Mexican
vibes: comfort, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- bell-pepper 1 piece (diced)
- garlic 2 clove (crushed)
- cumin 2 tsp
- chili-powder 1 tsp
- chicken-breast 2 piece
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- black-beans 240 g (drained)
- corn-frozen 150 g
- corn-tortillas 6 piece (cut into strips)
- lime 1 piece

1. Cook the onion and pepper in the oil for 5 minutes, then add the garlic and spices for 1 minute.
2. Add the whole chicken breasts, tomatoes, 1 litre boiling water and the bouillon and simmer for 15 minutes.
3. Lift out the chicken, shred it and return it with the beans and corn.
4. Toast the tortilla strips in a dry pan until crisp.
5. Squeeze in the lime and season.
6. Serve topped with the crispy tortilla strips.

#### `slow-cooker-chicken-carnitas-bowl` · Slow-cooker chicken carnitas-style bowl · 🌮 · Mexican
vibes: batchFriendly, family · appliances: slowCooker, stovetop · prep 10 / cook 300 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- cumin 2 tsp
- dried-oregano 1 tsp
- garlic 4 clove (crushed)
- lime 2 piece
- onion 1 piece (sliced)
- long-grain-rice 250 g
- black-beans 240 g (drained)
- red-cabbage 150 g (shredded)
- salsa 150 g
- salt 1 tsp

1. Rub the chicken with the cumin, oregano, garlic and salt.
2. Put the onion in the slow cooker, add the chicken and the juice of 1 lime.
3. Cook on low for 5 hours until it pulls apart.
4. Shred the chicken and crisp it in a hot dry pan for 5 minutes — the crispy edges make it.
5. Cook the rice in salted boiling water for 12 minutes, then drain.
6. Serve over rice with beans, cabbage, salsa and lime wedges.

#### `honey-mustard-pork-traybake` · Honey mustard pork traybake · 🍯 · British
vibes: onePan, family · appliances: oven · prep 10 / cook 30 min · serves 4 · leftovers: no

- pork-tenderloin 1 piece
- potato 4 piece (cubed)
- carrot 3 piece (sliced)
- red-onion 1 piece (cut into wedges)
- olive-oil 2 tbsp
- dijon-mustard 2 tbsp
- honey 2 tbsp
- dried-thyme 1 tsp
- green-beans 150 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the potatoes, carrots and onion with the oil, thyme and salt on a tray and roast for 15 minutes.
3. Mix the mustard and honey and brush over the pork.
4. Add the pork and green beans to the tray.
5. Roast for 15–18 minutes until the pork is just cooked.
6. Rest for 5 minutes, slice and serve with the vegetables.

#### `pork-banh-mi-bowl` · Pork banh mi-style rice bowl · 🥖 · Other
vibes: quickEasy, fakeaway · appliances: stovetop · prep 15 / cook 10 min · serves 4 · leftovers: no

- ground-pork 500 g
- garlic 2 clove (crushed)
- soy-sauce 2 tbsp
- honey 1 tbsp
- carrot 2 piece (cut into matchsticks)
- cucumber 1 piece (sliced)
- rice-vinegar 3 tbsp
- sugar 1 tsp
- long-grain-rice 250 g
- mayonnaise 2 tbsp
- sriracha 1 tsp

1. Toss the carrot and cucumber with the vinegar, sugar and a pinch of salt to quick-pickle.
2. Cook the rice in salted boiling water for 12 minutes, then drain.
3. Brown the pork in a frying pan for 7 minutes until crispy.
4. Add the garlic, soy sauce and honey and cook until sticky.
5. Mix the mayonnaise and sriracha.
6. Serve the pork over rice with the pickles and sriracha mayo.

#### `sausage-gnocchi-traybake` · Sausage & gnocchi traybake · 🌭 · Italian
vibes: onePan, comfort, family · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: no

- sausages 6 piece (cut into chunks)
- gnocchi 500 g
- bell-pepper 2 piece (chopped)
- red-onion 1 piece (cut into wedges)
- cherry-tomatoes 250 g
- olive-oil 1 tbsp
- italian-herbs 2 tsp
- balsamic-vinegar 1 tbsp
- arugula 40 g

1. Heat the oven to 220°C (425°F).
2. Tip the sausages, gnocchi, peppers, onion and tomatoes onto a large tray.
3. Toss with the oil and herbs and spread out.
4. Roast for 25 minutes, shaking halfway, until the sausages are browned and the gnocchi crisp.
5. Drizzle with the balsamic.
6. Top with arugula and serve.

#### `chorizo-chickpea-stew` · Chorizo & chickpea stew · 🥘 · Spanish/Portuguese
vibes: onePan, comfort · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: yes

- chorizo 120 g (sliced)
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- paprika 1 tsp
- chopped-tomatoes 400 g
- chickpeas 480 g (drained)
- vegetable-stock 300 ml
- spinach 100 g
- baguette 1 piece
- parsley 10 g

1. Fry the chorizo in a dry pan for 3 minutes until it releases its oil.
2. Add the onion and cook for 5 minutes.
3. Stir in the garlic and paprika for 1 minute.
4. Add the tomatoes, chickpeas and stock and simmer for 10 minutes.
5. Stir through the spinach until wilted.
6. Scatter with parsley and serve with the baguette.

#### `creamy-bacon-pea-orzo` · Creamy bacon & pea orzo · 🥓 · British
vibes: comfort, quickEasy, onePan · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- bacon 6 slice (chopped)
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- orzo 300 g
- chicken-stock 900 ml
- peas-frozen 200 g
- cream-cheese 60 g
- parmesan 30 g (grated)
- lemon 0.5 piece
- black-pepper 1 pinch

1. Fry the bacon in a deep pan for 4 minutes until crisp.
2. Add the onion and garlic and cook for 4 minutes.
3. Stir in the orzo and stock and simmer for 10 minutes, stirring often.
4. Add the peas for the last 3 minutes.
5. Stir in the cream cheese, parmesan and a squeeze of lemon.
6. Season with pepper and serve.

#### `lighter-chicken-alfredo` · Lighter chicken & broccoli alfredo · 🥦 · Italian
vibes: highProtein, comfort · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- penne 300 g
- broccoli 1 piece (cut into florets)
- chicken-breast 2 piece (sliced)
- olive-oil 1 tbsp
- garlic 3 clove (crushed)
- milk 250 ml
- cream-cheese 80 g
- parmesan 50 g (grated)
- black-pepper 1 pinch
- salt 1 tsp

1. Cook the pasta in salted boiling water, adding the broccoli for the last 4 minutes, then drain.
2. Season the chicken with salt.
3. Cook the chicken in the oil for 6 minutes until golden and cooked.
4. Add the garlic for 1 minute, then the milk and cream cheese.
5. Whisk over a low heat until smooth, then stir in the parmesan.
6. Toss in the pasta and broccoli and season with pepper.

#### `lasagne-soup` · Lasagne soup · 🍲 · Italian
vibes: comfort, family, onePan · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- ground-beef 400 g
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- italian-herbs 2 tsp
- tomato-paste 2 tbsp
- chopped-tomatoes 400 g
- vegetable-stock 1000 ml
- lasagne-sheets 8 piece (broken)
- spinach 80 g
- mozzarella 1 piece (torn)
- parmesan 20 g (grated)

1. Brown the beef and onion in a large pan for 7 minutes.
2. Add the garlic, herbs and tomato paste for 1 minute.
3. Pour in the tomatoes and stock and bring to the boil.
4. Add the broken lasagne sheets and simmer for 12 minutes, stirring often.
5. Stir in the spinach.
6. Ladle into bowls and top with torn mozzarella and parmesan.

#### `french-onion-chicken-bake` · French onion chicken bake · 🧅 · Other
vibes: comfort, family · appliances: stovetop, oven · prep 10 / cook 35 min · serves 4 · leftovers: no

- onion 3 piece (thinly sliced)
- butter 2 tbsp
- dried-thyme 1 tsp
- balsamic-vinegar 1 tbsp
- chicken-breast 4 piece
- chicken-stock 200 ml
- mozzarella 1 piece (sliced)
- parmesan 20 g (grated)
- green-beans 300 g
- baguette 1 piece
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Cook the onions in the butter with the thyme and salt over a medium heat for 15 minutes until golden.
3. Add the balsamic and stock and bubble for 2 minutes.
4. Lay the chicken in a baking dish and spoon over the onions.
5. Top with mozzarella and parmesan and bake for 20 minutes.
6. Steam the green beans and serve with the chicken and baguette.

#### `slow-cooker-salsa-chicken` · Slow-cooker salsa chicken burrito bowls · 🌯 · Mexican
vibes: batchFriendly, family, highProtein · appliances: slowCooker, stovetop · prep 10 / cook 240 min · serves 4 · leftovers: yes

- chicken-breast 4 piece
- salsa 400 g
- cumin 1 tsp
- chili-powder 1 tsp
- black-beans 240 g (drained)
- corn-frozen 150 g
- long-grain-rice 250 g
- lime 1 piece
- avocado 1 piece (sliced)
- sour-cream 100 g

1. Put the chicken in the slow cooker with the salsa and spices.
2. Cook on low for 4 hours until tender.
3. Shred the chicken in the sauce with two forks.
4. Stir in the beans and corn for the last 15 minutes.
5. Cook the rice in salted boiling water for 12 minutes, drain and add the lime juice.
6. Serve over rice with avocado and sour cream.

#### `slow-cooker-honey-garlic-chicken` · Slow-cooker honey garlic chicken · 🍯 · Chinese
vibes: batchFriendly, family · appliances: slowCooker, stovetop · prep 10 / cook 240 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- honey 4 tbsp
- soy-sauce 4 tbsp
- garlic 5 clove (crushed)
- ginger 15 g (grated)
- cornstarch 1 tbsp
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)
- sesame-seeds 1 tsp
- spring-onion 2 piece (sliced)

1. Whisk the honey, soy sauce, garlic and ginger in the slow cooker.
2. Add the chicken and turn to coat.
3. Cook on low for 4 hours.
4. Stir the cornstarch with 2 tbsp water into the sauce and cook on high for 15 minutes to thicken.
5. Cook the rice in salted boiling water for 12 minutes, adding the broccoli for the last 4, then drain.
6. Serve the chicken and sauce over rice with sesame and spring onion.

#### `slow-cooker-chickpea-tikka` · Slow-cooker chickpea tikka masala · 🍛 · Indian
vibes: batchFriendly, healthyish · appliances: slowCooker, stovetop · prep 10 / cook 300 min · serves 4 · leftovers: yes

- chickpeas 720 g (drained)
- onion 1 piece (diced)
- garlic 4 clove (crushed)
- ginger 15 g (grated)
- garam-masala 2 tsp
- curry-powder 1 tbsp
- passata 500 g
- coconut-milk 400 ml
- spinach 100 g
- basmati-rice 250 g
- cilantro 15 g
- salt 1 tsp

1. Put everything except the spinach, rice and cilantro into the slow cooker.
2. Stir well and cook on low for 5 hours.
3. Stir in the spinach for the last 10 minutes.
4. Cook the rice in salted boiling water for 12 minutes, then drain.
5. Taste and add more salt if needed.
6. Serve over rice with cilantro.

#### `air-fryer-chicken-tenders-fries` · Air-fryer chicken tenders & sweet potato fries · 🍟 · American
vibes: family, fakeaway, highProtein · appliances: airFryer · prep 15 / cook 30 min · serves 4 · leftovers: no

- chicken-breast 3 piece (cut into strips)
- eggs 1 piece (beaten)
- breadcrumbs 80 g
- paprika 2 tsp
- garlic-powder 1 tsp
- sweet-potato 3 piece (cut into fries)
- olive-oil 1 tbsp
- greek-yogurt 100 g
- honey 1 tbsp
- dijon-mustard 1 tbsp
- salt 1 tsp

1. Toss the sweet potato fries with the oil and a pinch of salt.
2. Air-fry at 200°C (400°F) for 18 minutes, shaking twice, then keep warm.
3. Mix the breadcrumbs, paprika, garlic powder and salt.
4. Dip the chicken in egg, then press into the crumbs.
5. Air-fry at 200°C (400°F) for 12 minutes, turning halfway, until golden.
6. Mix the yogurt, honey and mustard into a dip and serve with the tenders and fries.

#### `air-fryer-salmon-bites` · Air-fryer salmon bites with sesame rice · 🍣 · Japanese
vibes: quickEasy, healthyish, highProtein · appliances: airFryer, stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- salmon-fillet 2 piece (cut into cubes)
- soy-sauce 3 tbsp
- honey 1 tbsp
- garlic-powder 0.5 tsp
- long-grain-rice 250 g
- edamame-frozen 200 g
- cucumber 1 piece (sliced)
- sriracha 1 tsp
- sesame-seeds 2 tsp

1. Cook the rice in salted boiling water for 12 minutes, adding the edamame for the last 3, then drain.
2. Toss the salmon with 1 tbsp soy sauce, the honey and garlic powder.
3. Air-fry at 200°C (400°F) for 7–8 minutes until caramelised.
4. Toss the rice and edamame with the rest of the soy sauce and half the sesame seeds.
5. Pile into bowls with the cucumber.
6. Top with the salmon bites, sriracha and the rest of the sesame.

#### `crispy-cauliflower-tacos` · Air-fryer crispy cauliflower tacos · 🌮 · Mexican
vibes: healthyish, fakeaway · appliances: airFryer · prep 15 / cook 18 min · serves 4 · leftovers: no

- cauliflower 1 piece (cut into small florets)
- flour 50 g
- milk 100 ml
- breadcrumbs 60 g
- paprika 2 tsp
- garlic-powder 1 tsp
- corn-tortillas 12 piece
- red-cabbage 150 g (shredded)
- avocado 1 piece
- lime 2 piece
- sour-cream 100 g
- hot-sauce 1 tsp
- salt 1 tsp

1. Whisk the flour and milk into a batter and toss the cauliflower in it.
2. Mix the breadcrumbs, paprika, garlic powder and salt, then coat the cauliflower.
3. Air-fry at 200°C (400°F) for 18 minutes, shaking halfway, until crisp.
4. Mash the avocado with the juice of 1 lime.
5. Mix the sour cream with the hot sauce.
6. Fill warm tortillas with cabbage, cauliflower, avocado and spicy crema, with lime wedges.

#### `air-fryer-chicken-parm` · Air-fryer chicken parm with spaghetti · 🍝 · Italian
vibes: family, comfort, highProtein · appliances: airFryer, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 2 piece (halved horizontally)
- eggs 1 piece (beaten)
- breadcrumbs 60 g
- parmesan 40 g (grated)
- italian-herbs 1 tsp
- passata 400 g
- garlic 2 clove (crushed)
- mozzarella 1 piece (sliced)
- spaghetti 300 g
- basil 10 g
- salt 1 tsp

1. Mix the breadcrumbs with half the parmesan and the herbs.
2. Dip the chicken in egg, then press into the crumbs.
3. Air-fry at 200°C (400°F) for 10 minutes, turning halfway.
4. Simmer the passata with the garlic and salt for 10 minutes while the spaghetti cooks.
5. Top each chicken piece with a spoon of sauce and mozzarella and air-fry for 3 minutes more until melted.
6. Toss the spaghetti with the rest of the sauce and serve with the chicken, parmesan and basil.

#### `halloumi-veg-traybake` · Halloumi & veg traybake · 🧀 · Mediterranean
vibes: onePan, quickEasy · appliances: oven · prep 10 / cook 30 min · serves 4 · leftovers: no

- halloumi 250 g (sliced)
- sweet-potato 1 piece (cubed)
- bell-pepper 2 piece (chopped)
- zucchini 1 piece (chopped)
- red-onion 1 piece (cut into wedges)
- chickpeas 480 g (drained)
- olive-oil 2 tbsp
- paprika 1 tsp
- honey 1 tbsp
- lemon 1 piece
- mint 5 g

1. Heat the oven to 220°C (425°F).
2. Toss the vegetables and chickpeas with the oil and paprika on a large tray.
3. Roast for 20 minutes.
4. Lay the halloumi on top and roast for 10 minutes more until golden.
5. Drizzle with the honey and lemon juice.
6. Scatter with mint and serve.

#### `matar-paneer` · Paneer & pea curry · 🧀 · Indian
vibes: comfort, quickEasy · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- paneer 225 g (cubed)
- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- garam-masala 2 tsp
- turmeric 1 tsp
- chopped-tomatoes 400 g
- peas-frozen 200 g
- heavy-cream 50 ml
- basmati-rice 250 g
- cilantro 10 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Fry the paneer in the oil until golden, then set aside.
3. Cook the onion in the same pan for 6 minutes.
4. Add the garlic, ginger and spices for 1 minute, then the tomatoes.
5. Simmer for 8 minutes, then add the peas, paneer and cream for 3 minutes.
6. Season and serve with the rice and cilantro.

#### `quick-chana-masala` · 15-minute chana masala · 🍛 · Indian
vibes: quickEasy, healthyish, batchFriendly · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- cumin 1 tsp
- garam-masala 2 tsp
- chili-powder 0.5 tsp
- chopped-tomatoes 400 g
- chickpeas 720 g (drained)
- lemon 0.5 piece
- naan 4 piece
- cilantro 10 g
- salt 1 tsp

1. Heat the oil and cook the onion for 5 minutes.
2. Add the garlic, ginger and spices for 1 minute.
3. Add the tomatoes and chickpeas with a splash of water.
4. Simmer for 8 minutes, crushing a few chickpeas to thicken.
5. Season with salt and lemon juice.
6. Serve with warm naan and cilantro.

#### `tofu-tikka-masala-bowl` · Tofu tikka masala bowl · 🍛 · Indian
vibes: healthyish, fakeaway · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- tofu 400 g (cubed)
- cornstarch 1 tbsp
- vegetable-oil 2 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- garam-masala 2 tsp
- curry-powder 1 tbsp
- passata 400 g
- coconut-milk 200 ml
- basmati-rice 250 g
- spinach 100 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the tofu in cornstarch and fry in half the oil until golden. Set aside.
3. Cook the onion in the rest of the oil for 5 minutes.
4. Add the garlic, ginger and spices for 1 minute.
5. Add the passata and coconut milk and simmer for 8 minutes.
6. Stir in the tofu and spinach and serve over the rice.

#### `mushroom-stroganoff` · Mushroom stroganoff with rice · 🍄 · Other
vibes: comfort, quickEasy · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- mushrooms 500 g (sliced)
- butter 1 tbsp
- olive-oil 1 tbsp
- onion 1 piece (sliced)
- garlic 2 clove (crushed)
- paprika 2 tsp
- vegetable-stock 250 ml
- dijon-mustard 1 tsp
- sour-cream 150 g
- long-grain-rice 250 g
- parsley 10 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Heat the butter and oil in a large pan and cook the onion for 4 minutes.
3. Add the mushrooms and cook over a high heat for 7 minutes until golden.
4. Stir in the garlic and paprika for 1 minute.
5. Add the stock and mustard and bubble for 3 minutes, then stir in the sour cream.
6. Serve over rice with parsley.

#### `mushroom-carnitas-tacos` · Crispy mushroom carnitas tacos · 🍄 · Mexican
vibes: healthyish, fakeaway · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: no

- mushrooms 600 g (torn into strips)
- olive-oil 2 tbsp
- cumin 1 tsp
- paprika 2 tsp
- dried-oregano 1 tsp
- lime 2 piece
- corn-tortillas 12 piece
- black-beans 240 g (drained)
- red-onion 0.5 piece (finely diced)
- cilantro 15 g
- avocado 1 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the mushrooms with the oil, spices and salt on a tray.
3. Roast for 25 minutes until crisp at the edges, then squeeze over a lime.
4. Warm the beans with a splash of water and lightly mash.
5. Warm the tortillas in a dry pan.
6. Fill with beans, mushrooms, avocado, onion and cilantro, with lime wedges.

#### `black-bean-burgers` · Crispy black bean burgers · 🍔 · American
vibes: family, fakeaway · appliances: oven, blender · prep 15 / cook 25 min · serves 4 · leftovers: no

- black-beans 480 g (drained and patted dry)
- breadcrumbs 60 g
- eggs 1 piece
- cumin 1 tsp
- paprika 1 tsp
- garlic-powder 1 tsp
- burger-buns 4 piece
- lettuce 0.25 piece
- tomato 1 piece (sliced)
- cheddar 60 g (sliced)
- mayonnaise 2 tbsp
- sweet-potato 2 piece (cut into wedges)
- olive-oil 1 tbsp
- salt 1 tsp

1. Heat the oven to 200°C (400°F) and roast the sweet potato wedges in the oil for 25 minutes.
2. Pulse three-quarters of the beans with the egg and spices in a blender.
3. Stir in the rest of the beans, the breadcrumbs and salt, then shape into 4 patties.
4. Bake on a lined tray for 20 minutes, turning halfway, adding the cheese for the last 3 minutes.
5. Toast the buns.
6. Build the burgers with mayonnaise, lettuce and tomato and serve with the wedges.

#### `sweet-potato-black-bean-chili` · Sweet potato & black bean chili · 🌶️ · Mexican
vibes: healthyish, batchFriendly, comfort · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- sweet-potato 2 piece (cubed)
- chili-powder 2 tsp
- cumin 2 tsp
- paprika 1 tsp
- chopped-tomatoes 800 g
- black-beans 480 g (drained)
- vegetable-stock 300 ml
- long-grain-rice 200 g
- lime 1 piece
- cilantro 10 g
- salt 1 tsp

1. Heat the oil and cook the onion for 5 minutes.
2. Add the garlic and spices for 1 minute.
3. Add the sweet potato, tomatoes, beans and stock.
4. Simmer for 25 minutes until the sweet potato is tender.
5. Cook the rice in salted boiling water for 12 minutes, then drain.
6. Season the chili with lime juice and salt and serve over rice with cilantro.

#### `lentil-shepherds-pie` · Lentil shepherd's pie · 🥧 · British
vibes: comfort, batchFriendly, family · appliances: stovetop, oven · prep 10 / cook 30 min · serves 4 · leftovers: yes

- potato 5 piece (peeled and chopped)
- olive-oil 2 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- garlic 2 clove (crushed)
- tomato-paste 2 tbsp
- red-lentils 200 g
- vegetable-bouillon 2 tsp
- dried-thyme 1 tsp
- milk 100 ml
- peas-frozen 150 g
- salt 1 tsp

1. Boil the potatoes for 15 minutes until soft, then mash with the milk, half the oil and salt.
2. At the same time, cook the onion and carrot in the rest of the oil for 6 minutes.
3. Add the garlic, tomato paste, lentils, thyme, bouillon and 600 ml boiling water and simmer for 15 minutes until thick.
4. Stir in the peas and tip into a baking dish.
5. Spread over the mash and rough it up with a fork.
6. Grill or bake at 220°C (425°F) for 10 minutes until golden.

#### `loaded-sweet-potatoes` · Loaded sweet potatoes with beans & salsa · 🍠 · Mexican
vibes: healthyish, family, quickEasy · appliances: microwave, stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- sweet-potato 4 piece
- black-beans 480 g (drained)
- cumin 1 tsp
- chili-powder 1 tsp
- salsa 200 g
- greek-yogurt 150 g
- cheddar 60 g (grated)
- lime 1 piece
- salt 1 tsp

1. Prick the sweet potatoes and microwave for 10–12 minutes, turning halfway, until soft.
2. Meanwhile, warm the beans with the spices, salt and a splash of water for 5 minutes, crushing a few.
3. Mix the yogurt with the lime juice.
4. Split the potatoes and fluff the insides with a fork.
5. Pile in the beans and cheddar so it melts.
6. Top with salsa and lime yogurt.

#### `cauliflower-fried-rice` · Cauliflower egg fried rice · 🥚 · Chinese
vibes: quickEasy, lowCalorie, healthyish · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- cauliflower 1 piece (grated into rice)
- vegetable-oil 1 tbsp
- eggs 3 piece (beaten)
- garlic 2 clove (crushed)
- peas-frozen 100 g
- carrot 1 piece (diced)
- soy-sauce 2 tbsp
- sesame-oil 1 tsp
- spring-onion 3 piece (sliced)
- cashews 30 g

1. Heat the oil in a wok over a high heat.
2. Scramble the eggs until just set, then set aside.
3. Stir-fry the carrot and garlic for 2 minutes.
4. Add the cauliflower rice and peas and stir-fry for 5 minutes until tender.
5. Add the soy sauce, sesame oil and eggs and toss.
6. Finish with spring onions and cashews.

#### `cottage-cheese-tomato-pasta` · Creamy cottage cheese tomato pasta · 🍅 · Italian
vibes: highProtein, quickEasy, family · appliances: blender, stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 350 g
- cottage-cheese 300 g
- roasted-peppers 150 g
- tomato-paste 2 tbsp
- garlic 2 clove
- parmesan 30 g (grated)
- olive-oil 1 tbsp
- spinach 100 g
- basil 10 g
- salt 1 tsp

1. Cook the pasta in salted boiling water, saving a mug of water before draining.
2. Blend the cottage cheese, peppers, tomato paste, garlic, parmesan and salt until smooth.
3. Warm the oil in the empty pasta pan and wilt the spinach.
4. Pour in the sauce and warm gently without boiling.
5. Toss in the pasta with a splash of pasta water.
6. Serve with basil.

#### `cottage-cheese-mac-cheese` · High-protein cottage cheese mac & cheese · 🧀 · American
vibes: highProtein, comfort, family · appliances: blender, stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- penne 300 g
- cottage-cheese 300 g
- milk 150 ml
- cheddar 120 g (grated)
- dijon-mustard 1 tsp
- garlic-powder 0.5 tsp
- broccoli 0.5 piece (cut into small florets)
- paprika 1 pinch
- black-pepper 1 pinch

1. Cook the pasta in salted boiling water, adding the broccoli for the last 4 minutes, then drain.
2. Blend the cottage cheese, milk, mustard and garlic powder until smooth.
3. Pour into the empty pan over a low heat.
4. Stir in the cheddar until melted.
5. Add the pasta and broccoli and toss.
6. Dust with paprika and pepper.

#### `naan-pizza-night` · Naan pizza night · 🍕 · Italian
vibes: quickEasy, family, fakeaway · appliances: oven · prep 10 / cook 10 min · serves 4 · leftovers: no

- naan 4 piece
- passata 200 g
- dried-oregano 1 tsp
- mozzarella 2 piece (torn)
- ham 4 slice (torn)
- mushrooms 100 g (sliced)
- bell-pepper 1 piece (sliced)
- arugula 40 g
- olive-oil 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the passata with the oregano.
3. Spread the sauce over the naan.
4. Top with mozzarella, ham, mushrooms and pepper.
5. Bake for 8–10 minutes until bubbling.
6. Scatter with arugula and a drizzle of oil.

#### `garlic-chili-udon` · Garlic chili udon · 🍜 · Japanese
vibes: quickEasy, fakeaway · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- udon-noodles 2 piece
- vegetable-oil 2 tbsp
- garlic 4 clove (finely chopped)
- chili-flakes 1 tsp
- soy-sauce 3 tbsp
- honey 1 tbsp
- rice-vinegar 1 tsp
- bok-choy 2 piece (halved)
- eggs 2 piece
- spring-onion 2 piece (sliced)
- sesame-seeds 1 tsp

1. Boil the eggs for 6½ minutes, cool and peel.
2. Loosen the udon in boiling water for 2 minutes with the bok choy, then drain.
3. Heat the oil gently with the garlic and chili flakes until the garlic is golden.
4. Stir in the soy sauce, honey and vinegar.
5. Toss the noodles and bok choy in the chili garlic sauce.
6. Top with the halved eggs, spring onion and sesame seeds.

#### `dan-dan-noodles` · Peanut dan dan-style noodles · 🥜 · Chinese
vibes: quickEasy, fakeaway · appliances: stovetop · prep 5 / cook 12 min · serves 2 · leftovers: no

- egg-noodles 150 g
- ground-pork 200 g
- vegetable-oil 1 tsp
- garlic 2 clove (crushed)
- hoisin-sauce 1 tbsp
- peanut-butter 2 tbsp
- soy-sauce 2 tbsp
- chili-flakes 1 tsp
- rice-vinegar 1 tbsp
- bok-choy 2 piece (halved)
- spring-onion 2 piece (sliced)
- peanuts 20 g (chopped)

1. Cook the noodles with the bok choy for 4 minutes, then drain, saving some water.
2. Fry the pork in the oil for 6 minutes until crispy.
3. Add the garlic and hoisin and cook for 1 minute.
4. Whisk the peanut butter, soy sauce, chili, vinegar and 4 tbsp noodle water.
5. Toss the noodles in the sauce.
6. Top with the crispy pork, bok choy, spring onion and peanuts.

#### `upgraded-ramen-bowl` · Upgraded ramen bowl with jammy egg · 🍜 · Japanese
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- egg-noodles 150 g
- vegetable-bouillon 2 tsp
- miso-paste 2 tbsp
- soy-sauce 1 tbsp
- garlic 2 clove (crushed)
- ginger 10 g (grated)
- eggs 2 piece
- spinach 60 g
- spring-onion 2 piece (sliced)
- chili-flakes 1 pinch

1. Boil the eggs for 6½ minutes, cool and peel.
2. Simmer 800 ml water with the bouillon, garlic and ginger for 5 minutes.
3. Whisk in the miso and soy sauce.
4. Cook the noodles in the broth for 4 minutes, adding the spinach at the end.
5. Ladle into bowls.
6. Top with halved eggs, spring onion and chili.

#### `pho-style-chicken-noodle-soup` · Pho-style chicken noodle soup · 🍲 · Other
vibes: healthyish, comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- vegetable-bouillon 3 tsp
- onion 1 piece (halved)
- ginger 30 g (sliced)
- cinnamon 0.5 tsp
- five-spice 0.5 tsp
- fish-sauce 2 tbsp
- chicken-breast 2 piece
- rice-noodles 200 g
- bean-sprouts 150 g
- lime 2 piece
- cilantro 15 g

1. Char the onion and ginger in a dry pan for 5 minutes — this gives the broth its depth.
2. Add 1.5 litres boiling water, the bouillon, cinnamon and five-spice and bring to a simmer.
3. Add the chicken and simmer for 15 minutes, then lift out and shred.
4. Stir the fish sauce into the broth.
5. Soak the noodles in just-boiled water for 8 minutes, then drain.
6. Serve the noodles and chicken in the hot broth with sprouts, cilantro and lime.

#### `thai-chicken-larb-bowl` · Thai chicken larb rice bowl · 🥬 · Thai
vibes: quickEasy, healthyish, highProtein · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- chicken-breast 3 piece (finely chopped)
- vegetable-oil 1 tbsp
- red-onion 1 piece (finely sliced)
- fish-sauce 2 tbsp
- lime 3 piece
- chili-flakes 1 tsp
- sugar 1 tsp
- mint 15 g (chopped)
- cilantro 15 g (chopped)
- lettuce 1 piece (leaves separated)
- cucumber 1 piece (sliced)
- basmati-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Heat the oil in a wok and cook the chicken for 6 minutes until cooked.
3. Take off the heat and stir in the fish sauce, lime juice, chili and sugar.
4. Fold through the red onion and herbs.
5. Pile the rice into bowls with lettuce leaves and cucumber.
6. Spoon over the larb and scoop up with the lettuce.

#### `sheet-pan-chicken-satay` · Sheet-pan chicken satay with cucumber salad · 🥜 · Thai
vibes: onePan, family, highProtein · appliances: oven, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- chicken-thighs 600 g (cut into strips)
- peanut-butter 4 tbsp
- soy-sauce 3 tbsp
- curry-powder 1 tsp
- honey 1 tbsp
- lime 2 piece
- cucumber 1 piece (sliced)
- rice-vinegar 2 tbsp
- basmati-rice 250 g
- peanuts 30 g

1. Heat the oven to 220°C (425°F).
2. Mix 2 tbsp peanut butter, 2 tbsp soy sauce, the curry powder and honey and coat the chicken.
3. Roast on a lined tray for 18–20 minutes until charred.
4. Cook the rice in salted boiling water for 12 minutes, then drain.
5. Whisk the rest of the peanut butter and soy with the lime juice and 4 tbsp hot water for a satay sauce, and toss the cucumber with the vinegar.
6. Serve the chicken over rice with satay sauce, cucumber salad and peanuts.

#### `miso-butter-mushroom-gnocchi` · Miso butter mushroom gnocchi · 🍄 · Other
vibes: quickEasy, onePan, comfort · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- gnocchi 500 g
- olive-oil 1 tbsp
- mushrooms 250 g (sliced)
- butter 2 tbsp
- miso-paste 1 tbsp
- garlic 2 clove (crushed)
- spinach 80 g
- parmesan 20 g (grated)
- spring-onion 2 piece (sliced)
- black-pepper 1 pinch

1. Heat the oil in a large non-stick pan and fry the gnocchi for 8 minutes until golden all over. Set aside.
2. Add the mushrooms to the pan and cook over a high heat for 5 minutes.
3. Add the butter and garlic and cook for 1 minute.
4. Stir in the miso with 3 tbsp water until glossy.
5. Return the gnocchi with the spinach and toss until wilted.
6. Finish with parmesan, spring onion and pepper.

### Lunchs (30)

#### `chicken-shawarma-wrap` · Chicken shawarma wrap · 🌯 · Middle Eastern
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- chicken-breast 1 piece (thinly sliced)
- cumin 1 tsp
- paprika 1 tsp
- turmeric 0.5 tsp
- olive-oil 1 tsp
- tortillas 2 piece
- hummus 60 g
- lettuce 0.25 piece (shredded)
- tomato 1 piece (sliced)
- cucumber 0.25 piece (sliced)
- lemon 0.5 piece

1. Toss the chicken with the spices, oil and a squeeze of lemon.
2. Cook in a hot pan for 6 minutes until charred and cooked through.
3. Spread the tortillas with hummus.
4. Fill with lettuce, tomato, cucumber and chicken, then roll up and toast seam-side down for 1 minute.

#### `tuna-melt-quesadilla` · Tuna melt quesadilla · 🧀 · American
vibes: quickEasy, highProtein · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- canned-tuna 145 g (drained)
- mayonnaise 1 tbsp
- sweetcorn-tin 80 g (drained)
- spring-onion 1 piece (sliced)
- cheddar 60 g (grated)
- tortillas 2 piece
- hot-sauce 1 tsp

1. Mix the tuna, mayonnaise, sweetcorn, spring onion and hot sauce.
2. Spread over half of each tortilla and scatter with cheddar.
3. Fold over and cook in a dry pan for 3 minutes on each side until golden and melted.
4. Cut into wedges.

#### `protein-egg-salad-sandwich` · High-protein egg salad sandwich · 🥚 · American
vibes: highProtein, quickEasy · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- eggs 4 piece
- greek-yogurt 60 g
- mayonnaise 1 tbsp
- dijon-mustard 1 tsp
- spring-onion 1 piece (sliced)
- wholemeal-bread 4 slice
- lettuce 0.25 piece
- paprika 1 pinch
- salt 1 pinch

1. Boil the eggs for 10 minutes, then cool in cold water and peel.
2. Mash with the yogurt, mayonnaise, mustard, spring onion and salt.
3. Pile onto the bread with lettuce and a pinch of paprika.
4. Close the sandwiches and cut in half.

#### `cobb-chopped-salad` · Cobb-style chopped salad · 🥗 · American
vibes: highProtein · appliances: stovetop · prep 10 / cook 15 min · serves 2 · leftovers: no

- chicken-breast 1 piece
- bacon 2 slice
- eggs 2 piece
- lettuce 0.5 piece (chopped)
- tomato 1 piece (diced)
- cheddar 30 g (diced)
- red-wine-vinegar 1 tbsp
- olive-oil 2 tbsp
- dijon-mustard 1 tsp

1. Boil the eggs for 9 minutes, then cool, peel and chop.
2. Cook the chicken and bacon in a frying pan until cooked and crisp, then chop.
3. Whisk the vinegar, oil and mustard.
4. Arrange the lettuce, tomato, egg, chicken, bacon and cheddar in rows and drizzle with dressing.

#### `turkey-taco-salad` · Turkey taco salad bowl · 🌮 · Mexican
vibes: highProtein, healthyish · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- ground-turkey 250 g
- chili-powder 1 tsp
- cumin 1 tsp
- lettuce 0.5 piece (shredded)
- tomato 1 piece (diced)
- black-beans 120 g (drained)
- corn-frozen 80 g
- salsa 80 g
- greek-yogurt 60 g
- corn-tortillas 2 piece (cut into strips)

1. Brown the turkey with the spices for 7 minutes, adding the beans and corn for the last 2.
2. Toast the tortilla strips in a dry pan until crisp.
3. Pile the lettuce and tomato into bowls.
4. Top with the turkey, salsa, yogurt and crispy tortilla strips.

#### `crunchy-asian-chicken-salad` · Crunchy Asian-style chicken salad · 🥬 · Chinese
vibes: healthyish, highProtein · appliances: stovetop · prep 15 / cook 10 min · serves 2 · leftovers: no

- chicken-breast 1 piece
- red-cabbage 250 g (shredded)
- carrot 1 piece (grated)
- edamame-frozen 80 g
- spring-onion 2 piece (sliced)
- peanut-butter 1 tbsp
- soy-sauce 1 tbsp
- rice-vinegar 1 tbsp
- honey 1 tsp

1. Poach the chicken in simmering water for 12 minutes, adding the edamame for the last 3, then shred.
2. Whisk the peanut butter, soy sauce, vinegar, honey and 1 tbsp warm water.
3. Toss the cabbage, carrot, edamame and spring onion with the dressing.
4. Top with the chicken.

#### `thai-mango-shrimp-salad` · Thai mango & shrimp noodle salad · 🥭 · Thai
vibes: healthyish, quickEasy · appliances: stovetop · prep 15 / cook 4 min · serves 2 · leftovers: no

- shrimp 100 g
- mango 1 piece (cut into matchsticks)
- cucumber 0.5 piece (cut into matchsticks)
- red-onion 0.25 piece (finely sliced)
- rice-noodles 80 g
- lime 1.5 piece
- fish-sauce 1 tbsp
- sugar 1 tsp
- chili-flakes 0.5 tsp
- peanuts 20 g (chopped)

1. Soak the noodles in just-boiled water for 5 minutes, then rinse cold.
2. Cook the shrimp in boiling water for 3 minutes until pink, then drain.
3. Whisk the lime juice, fish sauce, sugar and chili.
4. Toss everything with the dressing and top with peanuts.

#### `chickpea-tabbouleh` · Chickpea tabbouleh · 🌿 · Middle Eastern
vibes: healthyish, batchFriendly · appliances: none · prep 15 / cook 0 min · serves 4 · leftovers: yes

- bulgur 150 g
- chickpeas 480 g (drained)
- parsley 50 g (finely chopped)
- mint 15 g (chopped)
- tomato 3 piece (diced)
- cucumber 1 piece (diced)
- spring-onion 3 piece (sliced)
- lemon 2 piece
- olive-oil 3 tbsp
- salt 1 tsp

1. Cover the bulgur with 300 ml boiling water and leave for 15 minutes, then fluff.
2. Whisk the lemon juice, oil and salt.
3. Toss the bulgur with the chickpeas, herbs, tomato, cucumber and spring onion.
4. Pour over the dressing and toss again.

#### `cottage-cheese-tuna-wrap` · Cottage cheese tuna crunch wrap · 🌯 · American
vibes: highProtein, quickEasy · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- canned-tuna 145 g (drained)
- cottage-cheese 120 g
- celery 1 piece (finely diced)
- red-onion 0.25 piece (finely diced)
- dijon-mustard 1 tsp
- lemon 0.5 piece
- tortillas 2 piece
- lettuce 0.25 piece (shredded)
- cucumber 0.25 piece (sliced)
- black-pepper 1 pinch

1. Mix the tuna, cottage cheese, celery, onion, mustard, lemon juice and pepper.
2. Lay lettuce and cucumber on each tortilla.
3. Spoon over the tuna mixture.
4. Roll up tightly and cut in half.

#### `rainbow-hummus-wrap` · Rainbow hummus wrap · 🌈 · Mediterranean
vibes: healthyish, quickEasy · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- tortillas 2 piece
- hummus 100 g
- carrot 1 piece (grated)
- red-cabbage 60 g (shredded)
- bell-pepper 0.5 piece (sliced)
- cucumber 0.25 piece (sliced)
- chickpeas 120 g (drained)
- lemon 0.5 piece

1. Spread the hummus over the tortillas.
2. Lay the vegetables and chickpeas in stripes down the middle.
3. Squeeze over a little lemon.
4. Roll up tightly and cut on the diagonal to show the colours.

#### `pesto-chicken-sandwich` · Pesto chicken & mozzarella sandwich · 🥪 · Italian
vibes: highProtein, family · appliances: stovetop · prep 5 / cook 12 min · serves 2 · leftovers: no

- chicken-breast 1 piece (halved horizontally)
- olive-oil 1 tsp
- baguette 0.75 piece (halved)
- pesto 2 tbsp
- mozzarella 0.5 piece (sliced)
- tomato 1 piece (sliced)
- spinach 30 g

1. Cook the chicken in the oil for 5 minutes on each side until cooked through, then slice.
2. Split the baguette pieces and spread with pesto.
3. Fill with chicken, mozzarella, tomato and spinach.
4. Press the sandwiches in the hot pan for 1 minute on each side.

#### `broccoli-cheddar-soup` · Broccoli cheddar soup · 🥦 · American
vibes: comfort, batchFriendly · appliances: stovetop, blender · prep 10 / cook 20 min · serves 4 · leftovers: yes

- butter 1 tbsp
- onion 1 piece (diced)
- potato 1 piece (diced)
- broccoli 1 piece (chopped)
- vegetable-bouillon 2 tsp
- milk 200 ml
- cheddar 120 g (grated)
- sourdough 4 slice

1. Melt the butter and cook the onion for 5 minutes.
2. Add the potato, broccoli, 900 ml boiling water and the bouillon and simmer for 15 minutes.
3. Blend until smooth, then stir in the milk and most of the cheddar.
4. Serve with toast and the rest of the cheese on top.

#### `tomato-soup-grilled-cheese` · Tomato basil soup with grilled cheese · 🍅 · American
vibes: comfort, family · appliances: stovetop, blender · prep 10 / cook 20 min · serves 4 · leftovers: no

- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- chopped-tomatoes 800 g
- vegetable-stock 400 ml
- basil 15 g
- heavy-cream 50 ml
- sourdough 8 slice
- cheddar 120 g (grated)
- butter 1 tbsp
- salt 1 tsp

1. Cook the onion in the oil for 5 minutes, then add the garlic.
2. Add the tomatoes and stock and simmer for 15 minutes.
3. Blend with the basil and cream and season.
4. Make cheese sandwiches, butter the outsides and fry for 3 minutes on each side.
5. Cut into soldiers and dunk.

#### `lemon-chicken-orzo-soup` · Lemon chicken orzo soup · 🍋 · Mediterranean
vibes: comfort, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- celery 2 piece (diced)
- garlic 2 clove (crushed)
- chicken-breast 2 piece
- chicken-stock 1500 ml
- orzo 150 g
- spinach 80 g
- lemon 2 piece
- dried-oregano 1 tsp
- salt 1 tsp

1. Cook the onion, carrot and celery in the oil for 6 minutes.
2. Add the garlic, oregano, chicken and stock and simmer for 15 minutes.
3. Lift out and shred the chicken, add the orzo and simmer for 9 minutes.
4. Return the chicken with the spinach and lemon juice, and season.

#### `miso-tofu-noodle-soup` · Miso tofu noodle soup · 🍜 · Japanese
vibes: healthyish, quickEasy · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- vegetable-bouillon 1 tsp
- miso-paste 2 tbsp
- ginger 10 g (grated)
- tofu 200 g (cubed)
- rice-noodles 100 g
- bok-choy 1 piece (sliced)
- mushrooms 100 g (sliced)
- spring-onion 2 piece (sliced)

1. Simmer 800 ml water with the bouillon, ginger and mushrooms for 5 minutes.
2. Add the noodles and bok choy and cook for 4 minutes.
3. Take off the heat and whisk in the miso, then add the tofu.
4. Serve topped with spring onions.

#### `thai-sweet-potato-soup` · Thai coconut sweet potato soup · 🥥 · Thai
vibes: comfort, healthyish, batchFriendly · appliances: stovetop, blender · prep 10 / cook 20 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- thai-curry-paste 2 tbsp
- sweet-potato 3 piece (cubed)
- vegetable-stock 700 ml
- coconut-milk 400 ml
- lime 1 piece
- cilantro 10 g
- naan 2 piece

1. Cook the onion in the oil for 5 minutes, then fry the curry paste for 1 minute.
2. Add the sweet potato, stock and most of the coconut milk and simmer for 15 minutes.
3. Blend until smooth and add the lime juice.
4. Swirl in the rest of the coconut milk and serve with cilantro and warm naan.

#### `white-bean-kale-soup` · Tuscan white bean & kale soup · 🥬 · Italian
vibes: healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: yes

- olive-oil 2 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- garlic 3 clove (crushed)
- italian-herbs 1 tsp
- chopped-tomatoes 400 g
- cannellini-beans 480 g (drained)
- vegetable-stock 1000 ml
- kale 100 g (shredded)
- parmesan 30 g (grated)
- baguette 1 piece

1. Cook the onion and carrot in the oil for 6 minutes.
2. Add the garlic and herbs, then the tomatoes, beans and stock.
3. Simmer for 12 minutes, then add the kale for 3 minutes.
4. Serve topped with parmesan and with the baguette.

#### `smoky-black-bean-soup` · Smoky black bean soup · 🥣 · Mexican
vibes: healthyish, batchFriendly · appliances: stovetop, blender · prep 10 / cook 20 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- cumin 2 tsp
- paprika 2 tsp
- black-beans 720 g (drained)
- chopped-tomatoes 400 g
- vegetable-stock 700 ml
- lime 1 piece
- sour-cream 80 g
- corn-tortillas 4 piece (cut into strips)
- avocado 1 piece

1. Cook the onion in the oil for 5 minutes, then add the garlic and spices.
2. Add the beans, tomatoes and stock and simmer for 15 minutes.
3. Blend half the soup and stir it back in, then add the lime juice.
4. Toast the tortilla strips in a dry pan.
5. Serve with sour cream, avocado and the crispy strips.

#### `deconstructed-sushi-salad` · Deconstructed sushi salad bowl · 🍱 · Japanese
vibes: healthyish, quickEasy · appliances: microwave · prep 10 / cook 3 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- rice-vinegar 1 tbsp
- edamame-frozen 100 g
- cucumber 0.5 piece (diced)
- avocado 1 piece (diced)
- carrot 1 piece (grated)
- nori 2 piece (cut into strips)
- soy-sauce 2 tbsp
- sesame-seeds 1 tsp
- sriracha 1 tsp

1. Microwave the rice and edamame, covered, for 3 minutes, then stir in the vinegar.
2. Split between bowls.
3. Top with cucumber, avocado and carrot.
4. Finish with nori strips, soy sauce, sriracha and sesame seeds.

#### `crunchy-thai-quinoa-salad` · Crunchy Thai quinoa salad · 🥜 · Thai
vibes: healthyish, batchFriendly · appliances: stovetop · prep 15 / cook 15 min · serves 4 · leftovers: yes

- quinoa 200 g
- red-cabbage 200 g (shredded)
- carrot 2 piece (grated)
- bell-pepper 1 piece (diced)
- edamame-frozen 150 g
- peanut-butter 3 tbsp
- soy-sauce 2 tbsp
- lime 2 piece
- peanuts 40 g (chopped)

1. Simmer the quinoa in 500 ml water for 15 minutes, adding the edamame for the last 3, then drain and cool.
2. Whisk the peanut butter, soy sauce, lime juice and 2 tbsp warm water.
3. Toss the quinoa and edamame with the cabbage, carrot and pepper.
4. Pour over the dressing and top with peanuts.

#### `bulgur-apple-feta-salad` · Bulgur salad with apple & feta · 🍎 · Mediterranean
vibes: healthyish, batchFriendly · appliances: none · prep 15 / cook 0 min · serves 4 · leftovers: yes

- bulgur 200 g
- apple 2 piece (diced)
- feta 100 g (crumbled)
- arugula 60 g
- walnuts 40 g (chopped)
- red-onion 0.25 piece (finely diced)
- olive-oil 3 tbsp
- balsamic-vinegar 1 tbsp
- honey 1 tsp
- salt 1 pinch

1. Cover the bulgur with 400 ml boiling water for 15 minutes, then fluff and cool.
2. Whisk the oil, balsamic, honey and salt.
3. Toss the bulgur with the apple, onion and arugula.
4. Top with feta and walnuts and drizzle over the dressing.

#### `italian-pasta-salad` · Italian pasta salad · 🍝 · Italian
vibes: family, batchFriendly · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: yes

- penne 250 g
- ham 4 slice (chopped)
- mozzarella 1 piece (diced)
- olives 60 g (halved)
- roasted-peppers 100 g (diced)
- cherry-tomatoes 200 g (halved)
- red-onion 0.25 piece (finely sliced)
- olive-oil 3 tbsp
- red-wine-vinegar 2 tbsp
- dried-oregano 1 tsp
- basil 10 g

1. Cook the pasta in salted boiling water, then rinse cold and drain.
2. Whisk the oil, vinegar and oregano.
3. Toss the pasta with everything else.
4. Chill for 30 minutes before eating, or pack for the week.

#### `lemony-chicken-orzo-salad` · Lemony chicken orzo salad · 🍋 · Mediterranean
vibes: highProtein, batchFriendly · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: yes

- orzo 250 g
- chicken-breast 2 piece
- cucumber 1 piece (diced)
- cherry-tomatoes 200 g (halved)
- feta 80 g (crumbled)
- spinach 60 g (chopped)
- lemon 2 piece
- olive-oil 3 tbsp
- dried-oregano 1 tsp
- salt 1 tsp

1. Poach the chicken in simmering water for 12 minutes, then shred.
2. Cook the orzo for 9 minutes in salted boiling water, then rinse cold.
3. Whisk the lemon zest and juice, oil, oregano and salt.
4. Toss everything together with the dressing.

#### `crispy-smashed-potato-salad` · Warm crispy smashed potato salad · 🥔 · American
vibes: comfort, family · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: no

- potato 6 piece (small, or halved)
- olive-oil 3 tbsp
- greek-yogurt 150 g
- dijon-mustard 1 tbsp
- spring-onion 3 piece (sliced)
- bacon 4 slice
- eggs 2 piece
- salt 1 tsp

1. Boil the potatoes for 12 minutes with the eggs for the last 9, then drain and cool the eggs.
2. Smash the potatoes flat and fry with the bacon in the oil for 8 minutes until crisp.
3. Mix the yogurt, mustard, spring onion and salt.
4. Toss the potatoes with the dressing, crumble over the bacon and top with the eggs, quartered.

#### `greek-cucumber-yogurt-salad` · Greek cucumber salad with pita · 🥒 · Mediterranean
vibes: healthyish, quickEasy · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- cucumber 1 piece (sliced)
- greek-yogurt 150 g
- garlic 1 clove (crushed)
- lemon 0.5 piece
- mint 5 g (chopped)
- chickpeas 240 g (drained)
- cherry-tomatoes 100 g (halved)
- olive-oil 1 tbsp
- pita-bread 2 piece
- salt 1 pinch

1. Mix the yogurt with the garlic, lemon juice and salt.
2. Toss the cucumber, chickpeas, tomatoes and mint with the oil.
3. Spread the yogurt on plates and pile the salad on top.
4. Serve with warm pita.

#### `tuna-sweet-potato-jacket` · Microwave tuna sweet potato jacket · 🍠 · British
vibes: highProtein, quickEasy · appliances: microwave · prep 5 / cook 10 min · serves 2 · leftovers: no

- sweet-potato 2 piece
- canned-tuna 145 g (drained)
- greek-yogurt 60 g
- sweetcorn-tin 80 g (drained)
- spring-onion 1 piece (sliced)
- arugula 30 g
- salt 1 pinch

1. Prick the sweet potatoes and microwave for 8–10 minutes until soft, turning halfway.
2. Mix the tuna, yogurt, sweetcorn, spring onion and salt.
3. Split the potatoes open.
4. Fill with the tuna mixture and serve with arugula.

#### `air-fryer-pizza-toast` · Air-fryer pizza toast · 🍕 · Italian
vibes: quickEasy, family · appliances: airFryer · prep 5 / cook 6 min · serves 2 · leftovers: no

- sourdough 4 slice
- passata 80 g
- dried-oregano 0.5 tsp
- mozzarella 0.75 piece (torn)
- ham 2 slice (torn)

1. Spread the passata over the bread and sprinkle with oregano.
2. Top with mozzarella and ham.
3. Air-fry at 190°C (375°F) for 5–6 minutes until bubbling.
4. Cut into soldiers and eat hot.

#### `kimchi-grilled-cheese` · Kimchi grilled cheese · 🧀 · Korean
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- sourdough 4 slice
- cheddar 80 g (grated)
- mozzarella 0.5 piece (grated)
- kimchi 80 g (drained and chopped)
- butter 1 tbsp
- spring-onion 1 piece (sliced)

1. Fill the bread with the cheeses, kimchi and spring onion.
2. Butter the outsides.
3. Fry over a medium heat for 3 minutes on each side, pressing down, until golden and melted.
4. Cut in half and serve hot.

#### `chicken-tikka-wrap` · Chicken tikka wrap · 🌯 · Indian
vibes: highProtein, fakeaway · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- chicken-breast 1 piece (diced)
- greek-yogurt 80 g
- curry-powder 1 tsp
- garam-masala 1 tsp
- olive-oil 1 tsp
- tortillas 2 piece
- red-onion 0.25 piece (sliced)
- cucumber 0.25 piece (sliced)
- lettuce 0.25 piece (shredded)
- mint 5 g
- lemon 0.5 piece

1. Mix half the yogurt with the spices and coat the chicken.
2. Cook in the oil in a hot pan for 8 minutes until charred and cooked.
3. Mix the rest of the yogurt with the mint and lemon juice.
4. Fill the tortillas with lettuce, cucumber, onion, chicken and mint yogurt, then roll up.

#### `avocado-chickpea-tostadas` · Avocado & chickpea 'ceviche' tostadas · 🥑 · Mexican
vibes: healthyish, quickEasy · appliances: stovetop · prep 15 / cook 4 min · serves 2 · leftovers: no

- chickpeas 240 g (drained)
- avocado 1 piece (diced)
- tomato 2 piece (diced)
- cucumber 0.5 piece (diced)
- red-onion 0.25 piece (finely diced)
- lime 2 piece
- cilantro 10 g (chopped)
- corn-tortillas 4 piece
- salt 1 pinch

1. Toss the chickpeas with the lime juice, onion and salt and leave for 5 minutes, crushing a few.
2. Fold in the tomato, cucumber, avocado and cilantro.
3. Toast the tortillas in a dry pan until crisp.
4. Pile the salad onto the crisp tortillas.

### Breakfasts (25)

#### `cottage-cheese-protein-pancakes` · Cottage cheese protein pancakes · 🥞 · American
vibes: highProtein, family · appliances: blender, stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- cottage-cheese 200 g
- eggs 2 piece
- rolled-oats 60 g
- baking-powder 1 tsp
- maple-syrup 1 tbsp
- butter 1 tsp
- berries-frozen 100 g (thawed)

1. Blend the cottage cheese, eggs, oats and baking powder until smooth.
2. Heat a little butter in a non-stick pan over a medium heat.
3. Cook small pancakes for 2 minutes until bubbles form, then flip for 1 minute.
4. Stack with berries and maple syrup.

#### `breakfast-quesadilla` · Egg & bean breakfast quesadilla · 🫓 · Mexican
vibes: quickEasy, highProtein · appliances: stovetop · prep 3 / cook 8 min · serves 2 · leftovers: no

- eggs 3 piece (beaten)
- black-beans 100 g (drained)
- cheddar 40 g (grated)
- spinach 30 g
- tortillas 2 piece
- salsa 60 g
- salt 1 pinch

1. Scramble the eggs with the salt until just set.
2. Fill half of each tortilla with egg, beans, spinach and cheese.
3. Fold and toast in a dry pan for 2 minutes on each side.
4. Cut into wedges and serve with salsa.

#### `green-shakshuka` · Green shakshuka with feta · 🍳 · Middle Eastern
vibes: healthyish, onePan · appliances: stovetop · prep 5 / cook 12 min · serves 2 · leftovers: no

- olive-oil 1 tbsp
- spring-onion 3 piece (sliced)
- garlic 2 clove (crushed)
- cumin 0.5 tsp
- spinach-frozen 200 g
- eggs 4 piece
- feta 50 g (crumbled)
- wholemeal-bread 2 slice

1. Cook the spring onions, garlic and cumin in the oil for 2 minutes.
2. Add the spinach and cook until hot and most of the water has gone.
3. Make 4 wells, crack in the eggs, cover and cook for 5 minutes until the whites set.
4. Scatter with feta and serve with toast.

#### `turkish-eggs` · Turkish-style eggs with chili butter · 🥚 · Middle Eastern
vibes: comfort, highProtein · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- greek-yogurt 150 g
- garlic 1 clove (crushed)
- eggs 4 piece
- butter 2 tbsp
- paprika 1 tsp
- chili-flakes 0.5 tsp
- sourdough 2 slice
- salt 1 pinch

1. Mix the yogurt with the garlic and salt and spread on two plates.
2. Poach the eggs in barely simmering water for 3 minutes.
3. Melt the butter with the paprika and chili until foaming.
4. Sit the eggs on the yogurt, spoon over the chili butter and serve with toast.

#### `smoky-beans-on-toast` · Smoky homemade beans on toast · 🫘 · British
vibes: comfort, quickEasy · appliances: stovetop · prep 3 / cook 10 min · serves 2 · leftovers: no

- cannellini-beans 240 g (drained)
- passata 150 g
- paprika 1 tsp
- maple-syrup 1 tsp
- worcestershire 1 tsp
- sourdough 2 slice
- cheddar 30 g (grated)
- salt 1 pinch

1. Simmer the beans with the passata, paprika, maple syrup, Worcestershire and salt for 8 minutes.
2. Toast the sourdough.
3. Spoon the beans over the toast.
4. Top with grated cheddar.

#### `apple-pie-overnight-oats` · Apple pie overnight oats · 🍏 · Other
vibes: batchFriendly, family · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 240 ml
- greek-yogurt 100 g
- apple 1 piece (grated)
- cinnamon 1 tsp
- maple-syrup 1 tbsp
- walnuts 20 g (chopped)

1. Mix the oats, milk, yogurt, apple, cinnamon and maple syrup.
2. Split between two jars.
3. Cover and chill overnight.
4. Top with walnuts and an extra pinch of cinnamon.

#### `carrot-cake-overnight-oats` · Carrot cake overnight oats · 🥕 · Other
vibes: batchFriendly, healthyish · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 240 ml
- carrot 1 piece (finely grated)
- raisins 20 g
- cinnamon 1 tsp
- maple-syrup 1 tbsp
- cream-cheese 30 g

1. Mix the oats, milk, carrot, raisins, cinnamon and maple syrup.
2. Split between two jars and chill overnight.
3. Loosen the cream cheese with a splash of milk.
4. Top the oats with the cream cheese 'frosting'.

#### `banana-bread-baked-oats` · Banana bread baked oats · 🍌 · Other
vibes: family, comfort · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 100 g
- banana 2 piece
- eggs 1 piece
- milk 120 ml
- baking-powder 1 tsp
- cinnamon 1 tsp
- walnuts 20 g
- dark-chocolate 10 g (chopped)

1. Heat the oven to 180°C (350°F).
2. Blend the oats, 1½ bananas, egg, milk, baking powder and cinnamon.
3. Pour into two small dishes, top with the rest of the banana, walnuts and chocolate.
4. Bake for 25 minutes until risen and golden.

#### `chia-jam-toast` · Peanut butter & berry chia jam toast · 🍓 · Other
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- berries-frozen 150 g
- chia-seeds 1 tbsp
- maple-syrup 1 tsp
- wholemeal-bread 2 slice
- peanut-butter 2 tbsp
- banana 1 piece (sliced)

1. Simmer the berries for 5 minutes, mashing as they soften.
2. Stir in the chia and maple syrup and leave to thicken for 5 minutes.
3. Toast the bread and spread with peanut butter.
4. Top with chia jam and banana.

#### `mango-lassi-smoothie` · Mango lassi smoothie · 🥭 · Indian
vibes: quickEasy, healthyish · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- mango 2 piece (chopped)
- greek-yogurt 200 g
- milk 150 ml
- honey 1 tbsp
- cinnamon 1 pinch
- rolled-oats 30 g

1. Put everything in the blender.
2. Blend until completely smooth.
3. Add a splash more milk if it's too thick.
4. Pour into glasses and dust with a pinch of cinnamon.

#### `green-glow-smoothie` · Green glow smoothie · 🥬 · Other
vibes: quickEasy, healthyish · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- spinach 60 g
- banana 2 piece
- mango 1 piece (chopped)
- greek-yogurt 150 g
- milk 200 ml

1. Blend the spinach with the milk first until no leaves are left.
2. Add the banana, mango and yogurt.
3. Blend until smooth.
4. Pour into two glasses.

#### `chocolate-pb-protein-smoothie` · Chocolate peanut butter smoothie · 🍫 · Other
vibes: quickEasy, highProtein · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- banana 2 piece
- milk 300 ml
- greek-yogurt 150 g
- peanut-butter 2 tbsp
- rolled-oats 30 g
- dark-chocolate 15 g (grated)

1. Put the banana, milk, yogurt, peanut butter and oats in the blender.
2. Add most of the chocolate.
3. Blend until thick and smooth.
4. Pour and top with the rest of the chocolate.

#### `stovetop-granola-pots` · Stovetop granola yogurt pots · 🥣 · Other
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- rolled-oats 60 g
- walnuts 20 g (chopped)
- maple-syrup 1 tbsp
- cinnamon 0.5 tsp
- butter 1 tsp
- greek-yogurt 250 g
- berries-frozen 120 g (thawed)

1. Melt the butter in a frying pan and add the oats, walnuts and cinnamon.
2. Toast for 4 minutes, then stir in the maple syrup and cook until clustered.
3. Spread out to cool and crisp up.
4. Layer the yogurt, berries and granola in glasses.

#### `breakfast-burrito-bowl` · Breakfast burrito bowl · 🌯 · Mexican
vibes: highProtein, comfort · appliances: stovetop · prep 10 / cook 15 min · serves 2 · leftovers: no

- potato 2 piece (diced)
- olive-oil 1 tbsp
- paprika 1 tsp
- eggs 4 piece
- black-beans 120 g (drained)
- salsa 80 g
- cheddar 30 g (grated)
- salt 1 pinch

1. Fry the potato in the oil with the paprika and salt for 12 minutes until crisp.
2. Warm the beans in a small pan.
3. Scramble the eggs until just set.
4. Build bowls with potatoes, eggs, beans, salsa and cheddar.

#### `savory-egg-oats` · Savory oats with a jammy egg · 🥣 · Other
vibes: comfort, quickEasy · appliances: stovetop · prep 3 / cook 8 min · serves 2 · leftovers: no

- rolled-oats 80 g
- vegetable-bouillon 1 tsp
- eggs 2 piece
- spinach 40 g
- soy-sauce 1 tsp
- spring-onion 1 piece (sliced)
- chili-flakes 1 pinch
- parmesan 15 g (grated)

1. Boil the eggs for 6½ minutes, then cool and peel.
2. Simmer the oats in 400 ml water with the bouillon for 5 minutes, stirring, then stir in the spinach.
3. Stir in the parmesan and soy sauce.
4. Top with halved eggs, spring onion and chili.

#### `breakfast-fried-rice` · Breakfast fried rice · 🍳 · Chinese
vibes: quickEasy, onePan · appliances: stovetop · prep 3 / cook 8 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- bacon 2 slice (chopped)
- eggs 3 piece
- spring-onion 2 piece (sliced)
- peas-frozen 60 g
- soy-sauce 1 tbsp

1. Fry the bacon in a wok until crisp.
2. Add the rice and peas and stir-fry for 3 minutes.
3. Push to one side, scramble 1 egg into the rice and toss with the soy sauce.
4. Fry the other eggs and serve on top with spring onion.

#### `sweet-potato-toast` · Air-fryer sweet potato toast · 🍠 · Other
vibes: healthyish, quickEasy · appliances: airFryer · prep 5 / cook 12 min · serves 2 · leftovers: no

- sweet-potato 1 piece (cut lengthways into 1 cm slices)
- olive-oil 1 tsp
- peanut-butter 2 tbsp
- banana 1 piece (sliced)
- cinnamon 1 pinch
- greek-yogurt 100 g
- honey 1 tsp

1. Brush the sweet potato slices with oil.
2. Air-fry at 200°C (400°F) for 10–12 minutes, turning halfway, until tender.
3. Spread with peanut butter and top with banana and cinnamon.
4. Serve with yogurt and a drizzle of honey.

#### `baked-oat-cups` · Grab-and-go baked oat cups · 🧁 · Other
vibes: batchFriendly, family · appliances: oven · prep 10 / cook 20 min · serves 4 · leftovers: yes

- rolled-oats 200 g
- banana 2 piece (mashed)
- eggs 2 piece
- milk 200 ml
- baking-powder 1 tsp
- cinnamon 1 tsp
- maple-syrup 2 tbsp
- berries-frozen 120 g

1. Heat the oven to 180°C (350°F) and line a 12-hole muffin tin.
2. Mix the oats, banana, eggs, milk, baking powder, cinnamon and maple syrup.
3. Fold in the berries and divide between the cases.
4. Bake for 20 minutes until set and golden. Keep in the fridge for 4 days.

#### `cinnamon-apple-porridge` · Cinnamon apple porridge · 🍎 · British
vibes: comfort, family · appliances: stovetop · prep 3 / cook 8 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 500 ml
- apple 1 piece (diced)
- cinnamon 1 tsp
- butter 1 tsp
- maple-syrup 1 tbsp
- walnuts 20 g

1. Cook the apple in the butter with half the cinnamon for 3 minutes until soft.
2. Simmer the oats in the milk with the rest of the cinnamon for 5 minutes, stirring.
3. Spoon into bowls.
4. Top with the cinnamon apples, walnuts and maple syrup.

#### `tofu-breakfast-tacos` · Tofu scramble breakfast tacos · 🌮 · Mexican
vibes: healthyish, quickEasy · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- tofu 250 g (crumbled)
- olive-oil 1 tbsp
- turmeric 0.5 tsp
- cumin 0.5 tsp
- spinach 40 g
- corn-tortillas 6 piece
- salsa 80 g
- salt 1 pinch

1. Fry the tofu in the oil with the turmeric, cumin and salt for 5 minutes.
2. Stir in the spinach until wilted.
3. Warm the tortillas in a dry pan.
4. Fill with tofu scramble and salsa.

#### `ham-egg-cups` · Ham & egg breakfast cups · 🥚 · British
vibes: highProtein, quickEasy · appliances: oven · prep 5 / cook 15 min · serves 2 · leftovers: no

- ham 4 slice
- eggs 4 piece
- cheddar 20 g (grated)
- wholemeal-bread 2 slice
- black-pepper 1 pinch

1. Heat the oven to 200°C (400°F).
2. Line 4 muffin holes with the ham to make cups.
3. Crack in an egg and top with cheddar and pepper.
4. Bake for 12–15 minutes until set and serve with toast.

#### `veggie-frittata-squares` · Veggie frittata squares · 🍳 · Italian
vibes: batchFriendly, highProtein · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: yes

- eggs 8 piece
- milk 80 ml
- bell-pepper 1 piece (diced)
- spinach 80 g (chopped)
- spring-onion 3 piece (sliced)
- feta 80 g (crumbled)
- olive-oil 1 tsp
- salt 1 pinch

1. Heat the oven to 180°C (350°F) and oil a square baking tin.
2. Whisk the eggs, milk and salt.
3. Scatter the vegetables and feta in the tin and pour over the eggs.
4. Bake for 25 minutes until set, then cut into squares. They keep for 4 days.

#### `mango-lime-yogurt-bowl` · Mango lime yogurt crunch bowl · 🥭 · Other
vibes: quickEasy, healthyish · appliances: stovetop · prep 5 / cook 3 min · serves 2 · leftovers: no

- greek-yogurt 300 g
- mango 1 piece (diced)
- rolled-oats 40 g
- honey 1 tbsp
- lime 0.5 piece

1. Toast the oats in a dry pan for 3 minutes until golden, then stir in half the honey.
2. Spoon the yogurt into bowls.
3. Top with the mango and a squeeze of lime.
4. Scatter over the crunchy oats and drizzle with the rest of the honey.

#### `apple-bircher-muesli` · Apple bircher muesli · 🍏 · Other
vibes: batchFriendly, healthyish · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- apple 1 piece (grated)
- milk 200 ml
- greek-yogurt 100 g
- raisins 20 g
- honey 1 tsp

1. Mix the oats, grated apple, milk, yogurt and raisins.
2. Cover and chill overnight.
3. Stir and loosen with a splash of milk.
4. Drizzle with honey.

#### `banana-split-yogurt-bowl` · Banana split yogurt bowl · 🍌 · Other
vibes: quickEasy, family · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- banana 2 piece (halved lengthways)
- greek-yogurt 250 g
- berries-frozen 100 g (thawed)
- peanut-butter 1 tbsp
- dark-chocolate 10 g (grated)
- peanuts 15 g (chopped)

1. Lay the banana halves in two bowls.
2. Spoon the yogurt down the middle.
3. Top with berries and a drizzle of peanut butter.
4. Finish with grated chocolate and peanuts.

### Snacks (25)

#### `cottage-cheese-ranch-dip` · Cottage cheese ranch dip · 🥕 · American
vibes: highProtein, quickEasy · appliances: blender · prep 5 / cook 0 min · serves 4 · leftovers: no

- cottage-cheese 250 g
- garlic-powder 0.5 tsp
- onion-powder 0.5 tsp
- parsley 10 g
- lemon 0.5 piece
- carrot 2 piece (cut into sticks)
- cucumber 1 piece (cut into sticks)
- bell-pepper 1 piece (cut into strips)

1. Blend the cottage cheese, garlic and onion powders, parsley and lemon juice until smooth.
2. Chill for 10 minutes.
3. Serve with the veg sticks.

#### `whipped-feta-dip` · Whipped feta dip with cucumber · 🧀 · Mediterranean
vibes: quickEasy · appliances: blender · prep 5 / cook 0 min · serves 4 · leftovers: no

- feta 150 g
- greek-yogurt 100 g
- olive-oil 1 tbsp
- lemon 0.5 piece
- honey 1 tsp
- chili-flakes 1 pinch
- cucumber 1 piece (sliced)
- pita-bread 1 piece (cut into triangles)

1. Blend the feta, yogurt, lemon juice and half the oil until whipped and smooth.
2. Spread in a bowl and swirl with the rest of the oil, the honey and chili.
3. Serve with cucumber and pita.

#### `edamame-hummus` · Edamame hummus · 🫛 · Japanese
vibes: healthyish, quickEasy · appliances: blender, stovetop · prep 5 / cook 4 min · serves 4 · leftovers: no

- edamame-frozen 200 g
- tahini 2 tbsp
- lemon 1 piece
- garlic 1 clove
- olive-oil 1 tbsp
- salt 1 pinch
- carrot 2 piece (cut into sticks)
- rice-cakes 4 piece

1. Boil the edamame for 4 minutes, then drain and cool.
2. Blend with the tahini, lemon juice, garlic, oil, salt and 3 tbsp water until smooth.
3. Serve with carrot sticks and rice cakes.

#### `air-fryer-zucchini-chips` · Air-fryer parmesan zucchini chips · 🥒 · Italian
vibes: healthyish, family · appliances: airFryer · prep 10 / cook 12 min · serves 2 · leftovers: no

- zucchini 2 piece (sliced into thin rounds)
- eggs 1 piece (beaten)
- breadcrumbs 40 g
- parmesan 20 g (grated)
- paprika 0.5 tsp

1. Mix the breadcrumbs, parmesan and paprika.
2. Dip the zucchini in egg, then the crumbs.
3. Air-fry at 200°C (400°F) for 10–12 minutes, turning halfway, until crisp.

#### `crispy-kale-chips` · Crispy kale chips · 🥬 · Other
vibes: healthyish, lowCalorie · appliances: oven · prep 5 / cook 12 min · serves 2 · leftovers: no

- kale 100 g (torn)
- olive-oil 1 tbsp
- parmesan 10 g (finely grated)
- garlic-powder 0.5 tsp
- salt 1 pinch

1. Heat the oven to 150°C (300°F).
2. Massage the kale with the oil, garlic powder and salt and spread out on two trays.
3. Bake for 12 minutes until crisp, then sprinkle with parmesan.

#### `frozen-banana-bites` · Frozen chocolate peanut butter banana bites · 🍌 · Other
vibes: family, quickEasy · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- banana 2 piece (sliced)
- peanut-butter 2 tbsp
- dark-chocolate 50 g (melted)
- sesame-seeds 1 tsp

1. Sandwich pairs of banana slices with a little peanut butter.
2. Dip halfway in melted chocolate and lay on a lined tray.
3. Sprinkle with sesame seeds and freeze for 1 hour.

#### `chocolate-banana-pops` · Chocolate-dipped banana pops · 🍫 · Other
vibes: family · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- banana 2 piece (halved)
- dark-chocolate 60 g (melted)
- peanuts 20 g (finely chopped)

1. Push a lolly stick into each banana half.
2. Dip in the melted chocolate and roll in the peanuts.
3. Freeze on a lined tray for 2 hours.

#### `pb-chocolate-protein-balls` · Peanut butter chocolate protein balls · 🍪 · Other
vibes: highProtein, batchFriendly · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- rolled-oats 80 g
- peanut-butter 4 tbsp
- honey 2 tbsp
- chia-seeds 1 tbsp
- dark-chocolate 30 g (finely chopped)
- greek-yogurt 2 tbsp

1. Mix everything together in a bowl.
2. Roll into 12 balls.
3. Chill for 30 minutes. They keep for a week in the fridge.

#### `sweet-salty-trail-mix` · Sweet & salty trail mix · 🥜 · Other
vibes: quickEasy, batchFriendly · appliances: none · prep 5 / cook 0 min · serves 4 · leftovers: no

- peanuts 50 g
- cashews 40 g
- raisins 40 g
- dark-chocolate 30 g (chopped)
- popcorn-kernels 20 g

1. Pop the corn in a lidded pan or the microwave in a covered bowl.
2. Mix with the nuts, raisins and chocolate.
3. Split into 4 small tubs.

#### `cinnamon-sugar-popcorn` · Cinnamon sugar popcorn · 🍿 · American
vibes: family, quickEasy · appliances: stovetop · prep 2 / cook 5 min · serves 2 · leftovers: no

- popcorn-kernels 50 g
- vegetable-oil 1 tbsp
- butter 1 tbsp (melted)
- cinnamon 1 tsp
- sugar 2 tsp

1. Heat the oil in a large lidded pan with 3 kernels until they pop.
2. Add the rest of the kernels, cover and shake until the popping slows.
3. Toss with the melted butter, cinnamon and sugar.

#### `apple-nachos` · Apple nachos · 🍎 · Other
vibes: family, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- apple 2 piece (thinly sliced)
- lemon 0.5 piece
- peanut-butter 2 tbsp (warmed)
- dark-chocolate 10 g (melted)
- rolled-oats 15 g
- raisins 10 g

1. Toss the apple slices in lemon juice and spread on a plate.
2. Drizzle with the warm peanut butter and chocolate.
3. Scatter with oats and raisins.

#### `cucumber-cream-cheese-bites` · Cucumber cream cheese bites · 🥒 · British
vibes: quickEasy, lowCalorie · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- cucumber 1 piece (thickly sliced)
- cream-cheese 60 g
- sesame-seeds 1 tsp
- garlic-powder 1 pinch
- chili-flakes 1 pinch

1. Spread or pipe the cream cheese onto the cucumber slices.
2. Mix the sesame, garlic powder and chili.
3. Sprinkle over and serve cold.

#### `caprese-skewers` · Caprese skewers · 🍅 · Italian
vibes: quickEasy, family · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- cherry-tomatoes 200 g
- mozzarella 1 piece (cut into cubes)
- basil 10 g
- balsamic-vinegar 1 tbsp
- olive-oil 1 tbsp
- salt 1 pinch

1. Thread the tomatoes, mozzarella and basil onto small skewers.
2. Drizzle with the oil and balsamic.
3. Sprinkle with salt and serve.

#### `mini-pita-pizzas` · Mini pita pizzas · 🍕 · Italian
vibes: family, quickEasy · appliances: oven · prep 5 / cook 8 min · serves 4 · leftovers: no

- pita-bread 2 piece (split in half)
- passata 60 g
- dried-oregano 0.5 tsp
- mozzarella 1 piece (torn)
- olives 20 g (sliced)

1. Heat the oven to 200°C (400°F).
2. Spread the pita halves with passata and sprinkle with oregano.
3. Top with mozzarella and olives and bake for 8 minutes.

#### `rice-cake-pb-banana` · Rice cakes with peanut butter & banana · 🍘 · Other
vibes: quickEasy, family · appliances: none · prep 3 / cook 0 min · serves 2 · leftovers: no

- rice-cakes 4 piece
- peanut-butter 2 tbsp
- banana 1 piece (sliced)
- cinnamon 1 pinch
- honey 1 tsp

1. Spread the rice cakes with peanut butter.
2. Top with banana slices.
3. Finish with cinnamon and a drizzle of honey.

#### `cottage-cheese-ice-cream` · Berry cottage cheese ice cream · 🍨 · Other
vibes: highProtein, healthyish · appliances: blender · prep 5 / cook 0 min · serves 4 · leftovers: no

- cottage-cheese 450 g
- berries-frozen 150 g
- honey 3 tbsp

1. Blend the cottage cheese, berries and honey until completely smooth.
2. Tip into a freezer tub.
3. Freeze for 3 hours, stirring once, and soften for 10 minutes before scooping.

#### `mango-nice-cream` · Two-ingredient mango nice cream · 🥭 · Other
vibes: healthyish, quickEasy · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- mango 1 piece (chopped and frozen)
- banana 1 piece (sliced and frozen)
- lime 0.5 piece

1. Freeze the mango and banana pieces overnight.
2. Blend with the lime juice, scraping down often, until smooth like soft-serve.
3. Eat straight away or freeze for 30 minutes to firm up.

#### `chocolate-chia-pudding-cups` · Chocolate chia pudding cups · 🍫 · Other
vibes: healthyish, batchFriendly · appliances: none · prep 5 / cook 0 min · serves 4 · leftovers: no

- chia-seeds 4 tbsp
- soy-milk 400 ml
- dark-chocolate 30 g (melted)
- maple-syrup 2 tbsp
- berries-frozen 80 g (thawed)

1. Whisk the chia, milk, melted chocolate and maple syrup.
2. Whisk again after 5 minutes, then divide between 4 small cups.
3. Chill for 4 hours and top with berries.

#### `honey-roasted-cashews` · Honey chili roasted cashews · 🌰 · Other
vibes: quickEasy · appliances: oven · prep 2 / cook 10 min · serves 4 · leftovers: no

- cashews 120 g
- honey 1 tbsp
- chili-flakes 0.5 tsp
- salt 1 pinch

1. Heat the oven to 180°C (350°F).
2. Toss the cashews with the honey, chili and salt and spread on a lined tray.
3. Roast for 10 minutes, stirring once, then cool to crisp up.

#### `air-fryer-tortilla-chips` · Air-fryer tortilla chips & salsa · 🌮 · Mexican
vibes: family, quickEasy · appliances: airFryer · prep 5 / cook 6 min · serves 2 · leftovers: no

- corn-tortillas 4 piece (cut into triangles)
- olive-oil 1 tsp
- paprika 0.5 tsp
- lime 0.5 piece
- salsa 150 g
- salt 1 pinch

1. Toss the tortilla triangles with the oil, paprika and salt.
2. Air-fry at 180°C (350°F) for 5–6 minutes, shaking halfway, until crisp.
3. Squeeze over the lime and serve with salsa.

#### `soy-marinated-jammy-eggs` · Soy-marinated jammy eggs · 🥚 · Korean
vibes: highProtein, batchFriendly · appliances: stovetop · prep 5 / cook 7 min · serves 4 · leftovers: no

- eggs 6 piece
- soy-sauce 4 tbsp
- honey 1 tbsp
- garlic 2 clove (crushed)
- spring-onion 2 piece (sliced)
- chili-fresh 1 piece (sliced)
- sesame-seeds 1 tsp

1. Boil the eggs for 6½ minutes, then cool in iced water and peel.
2. Mix the soy sauce, honey, garlic, spring onion, chili, sesame and 4 tbsp water.
3. Marinate the eggs in a jar in the fridge for at least 4 hours.
4. Halve and spoon over some of the marinade.

#### `guacamole-veg-sticks` · Chunky guacamole with veg sticks · 🥑 · Mexican
vibes: healthyish, quickEasy · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- avocado 2 piece
- lime 1 piece
- red-onion 0.25 piece (finely diced)
- cilantro 10 g (chopped)
- salt 1 pinch
- carrot 2 piece (cut into sticks)
- bell-pepper 1 piece (cut into strips)

1. Mash the avocado roughly with the lime juice and salt.
2. Fold in the onion and cilantro.
3. Serve with the veg sticks.

#### `peanut-butter-yogurt-dip` · Peanut butter yogurt dip with apple · 🍏 · Other
vibes: highProtein, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- greek-yogurt 150 g
- peanut-butter 2 tbsp
- honey 1 tsp
- cinnamon 1 pinch
- apple 2 piece (sliced)

1. Whisk the yogurt, peanut butter, honey and cinnamon until smooth.
2. Serve with the apple slices for dipping.

#### `rice-paper-chips` · Puffed rice paper chips · ⚪ · Other
vibes: quickEasy, family · appliances: airFryer · prep 3 / cook 4 min · serves 2 · leftovers: no

- rice-paper 6 piece (cut into quarters)
- vegetable-oil 1 tsp
- sesame-seeds 1 tsp
- chili-flakes 1 pinch
- salt 1 pinch
- sweet-chili-sauce 2 tbsp

1. Brush the rice paper quarters very lightly with oil.
2. Air-fry at 200°C (400°F) for 1–2 minutes per batch until puffed.
3. Sprinkle with sesame, chili and salt and serve with sweet chili sauce.

#### `banana-oat-cookies` · Two-ingredient banana oat cookies · 🍪 · Other
vibes: family, healthyish · appliances: oven · prep 5 / cook 15 min · serves 4 · leftovers: no

- banana 2 piece (mashed)
- rolled-oats 100 g
- dark-chocolate 20 g (chopped)
- cinnamon 0.5 tsp

1. Heat the oven to 180°C (350°F).
2. Mix the banana, oats, chocolate and cinnamon and drop 12 spoonfuls onto a lined tray.
3. Bake for 15 minutes until golden, then cool on the tray.
