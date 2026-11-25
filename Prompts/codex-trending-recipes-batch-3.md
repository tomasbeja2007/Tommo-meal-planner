# Codex prompt: trending recipes, batch 3 (100 recipes)

Paste everything below the line into Codex. It is self-contained: the recipes are written out in full.

---

Read `CLAUDE.md` and `BUILD_NOTES.md` (section 3d) first, and follow the project's rules.

## Task

Add the 100 recipes below (45 dinners, 20 lunches, 20 breakfasts, 15 snacks) to the bundled
library as trending recipes, the same way as `Tools/trending_recipes.py`. Add batches 1 to 2 first (in this order) if they aren't in yet.

1. Create `Tools/trending_batch3.py`. Write each recipe with `T(...)` from `trending_recipes.py` (it adds the `trending` tag),
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

#### `sticky-sesame-chicken` · Sticky sesame chicken · 🍗 · Chinese
vibes: fakeaway, family · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-thighs 600 g (cut into bite-size pieces)
- cornstarch 3 tbsp
- vegetable-oil 2 tbsp
- garlic 2 clove (crushed)
- soy-sauce 3 tbsp
- honey 3 tbsp
- rice-vinegar 1 tbsp
- sesame-oil 1 tsp
- sesame-seeds 2 tbsp
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)
- spring-onion 2 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, adding the broccoli for the last 4, then drain.
2. Toss the chicken in 2 tbsp cornstarch.
3. Fry in the oil over a medium-high heat for 8 minutes, turning, until crisp and cooked through. Set aside.
4. Whisk the soy sauce, honey, vinegar, sesame oil, garlic, the rest of the cornstarch and 3 tbsp water.
5. Pour into the pan and bubble for 1 minute until thick, then toss the chicken back in with most of the sesame seeds.
6. Serve over the rice and broccoli with spring onions and the rest of the sesame.

#### `mapo-style-tofu` · Mapo-style tofu with pork · 🌶️ · Chinese
vibes: fakeaway, comfort, quickEasy · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- tofu 600 g (cut into cubes)
- ground-pork 250 g
- vegetable-oil 1 tbsp
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- gochujang 2 tbsp
- chili-flakes 1 tsp
- soy-sauce 2 tbsp
- chicken-stock 300 ml
- cornstarch 1 tbsp
- spring-onion 3 piece (sliced)
- long-grain-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Brown the pork in the oil for 6 minutes until crisp.
3. Add the garlic, ginger, gochujang and chili flakes and fry for 1 minute.
4. Pour in the stock and soy sauce and bring to a simmer.
5. Slide in the tofu and simmer gently for 5 minutes without stirring too much.
6. Stir in the cornstarch mixed with 2 tbsp water until glossy, and serve over rice with spring onions.

#### `char-siu-style-pork-rice` · Char siu-style pork with rice & greens · 🐖 · Chinese
vibes: fakeaway, family · appliances: oven, stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- pork-tenderloin 1 piece
- hoisin-sauce 3 tbsp
- honey 2 tbsp
- soy-sauce 2 tbsp
- five-spice 1 tsp
- garlic 2 clove (crushed)
- long-grain-rice 250 g
- bok-choy 4 piece (halved)
- sesame-oil 1 tsp
- spring-onion 2 piece (sliced)

1. Heat the oven to 200°C (400°F).
2. Mix the hoisin, honey, soy sauce, five-spice and garlic and coat the pork, keeping 2 tbsp aside.
3. Roast on a lined tray for 22–25 minutes, brushing with the saved glaze halfway, until sticky and just cooked.
4. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
5. Steam or boil the bok choy for 3 minutes and toss with the sesame oil.
6. Rest the pork for 5 minutes, slice and serve over rice with the greens, spooning over the tray juices.

#### `salt-pepper-chicken` · Salt & pepper chicken · 🧂 · Chinese
vibes: fakeaway, family · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-breast 3 piece (cut into strips)
- cornstarch 3 tbsp
- vegetable-oil 3 tbsp
- five-spice 1 tsp
- salt 1 tsp
- black-pepper 1 tsp
- chili-fresh 2 piece (sliced)
- onion 1 piece (sliced)
- bell-pepper 2 piece (sliced)
- garlic 3 clove (sliced)
- long-grain-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Mix the salt, pepper and five-spice.
3. Toss the chicken in the cornstarch and half the spice mix.
4. Fry in the oil over a high heat for 7 minutes until crisp and golden, then set aside.
5. Stir-fry the onion, peppers, garlic and chili for 3 minutes.
6. Toss the chicken back in with the rest of the spice mix and serve with the rice.

#### `singapore-style-noodles` · Singapore-style noodles · 🍜 · Other
vibes: fakeaway, quickEasy · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- rice-noodles 250 g
- vegetable-oil 2 tbsp
- shrimp 200 g
- ham 4 slice (cut into strips)
- eggs 2 piece (beaten)
- curry-powder 1 tbsp
- bell-pepper 1 piece (thinly sliced)
- onion 1 piece (thinly sliced)
- bean-sprouts 150 g
- soy-sauce 3 tbsp
- spring-onion 3 piece (sliced)

1. Soak the noodles in just-boiled water for 6 minutes, then drain.
2. Scramble the eggs in half the oil, then set aside.
3. Stir-fry the shrimp, pepper and onion in the rest of the oil for 3 minutes.
4. Add the curry powder and ham for 30 seconds.
5. Toss in the noodles, soy sauce and eggs until evenly yellow.
6. Add the bean sprouts and spring onions and toss for 1 minute.

#### `hainanese-style-chicken-rice` · Hainanese-style poached chicken rice · 🍚 · Other
vibes: comfort, healthyish · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: no

- chicken-thighs 600 g
- ginger 40 g (half sliced, half grated)
- garlic 4 clove (crushed)
- spring-onion 4 piece (sliced)
- vegetable-bouillon 2 tsp
- long-grain-rice 300 g
- soy-sauce 2 tbsp
- lime 1 piece
- cucumber 1 piece (sliced)
- chili-flakes 0.5 tsp
- salt 1 tsp

1. Simmer 1.2 litres water with the bouillon, sliced ginger and half the spring onions, add the chicken and poach gently for 15 minutes.
2. Lift out the chicken and keep 650 ml of the broth.
3. Fry the rice with half the garlic in 1 tbsp oil for 1 minute, add the saved broth, cover and cook on low for 15 minutes — the broth makes the rice the star.
4. Mix the grated ginger, the rest of the garlic and spring onions with a pinch of salt and 1 tbsp hot oil for a ginger sauce.
5. Mix the soy sauce, lime juice and chili.
6. Slice the chicken and serve on the rice with cucumber, both sauces and a cup of the hot broth.

#### `pad-prik-king-pork` · Red curry pork & green bean stir-fry · 🫘 · Thai
vibes: quickEasy, fakeaway · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- ground-pork 500 g
- vegetable-oil 1 tbsp
- thai-curry-paste 2 tbsp
- green-beans 300 g (cut into short lengths)
- fish-sauce 1 tbsp
- sugar 1 tsp
- lime 1 piece
- basil 15 g
- basmati-rice 250 g
- eggs 4 piece

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Fry the curry paste in the oil for 1 minute.
3. Add the pork and cook for 6 minutes, breaking it up, until crispy.
4. Add the green beans and a splash of water and stir-fry for 4 minutes until just tender.
5. Season with the fish sauce, sugar and lime juice and stir in the basil.
6. Fry the eggs until crispy at the edges and serve on top of the rice and pork.

#### `tom-kha-style-chicken-soup` · Tom kha-style coconut chicken soup · 🥥 · Thai
vibes: comfort, healthyish · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- vegetable-bouillon 2 tsp
- coconut-milk 400 ml
- ginger 30 g (sliced)
- thai-curry-paste 1 tbsp
- chicken-breast 3 piece (thinly sliced)
- mushrooms 200 g (sliced)
- fish-sauce 2 tbsp
- lime 2 piece
- sugar 1 tsp
- rice-noodles 150 g

1. Simmer 800 ml water with the bouillon, ginger and curry paste for 5 minutes.
2. Add the coconut milk and bring back to a gentle simmer.
3. Add the chicken and mushrooms and simmer for 8 minutes until cooked.
4. Soak the noodles in just-boiled water for 8 minutes, then drain into bowls.
5. Season the soup with the fish sauce, lime juice and sugar — it should taste sour, salty and a little sweet.
6. Ladle over the noodles.

#### `vietnamese-caramel-pork` · Vietnamese-style caramel pork · 🍯 · Other
vibes: fakeaway, comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- pork-tenderloin 1 piece (thinly sliced)
- sugar 3 tbsp
- fish-sauce 3 tbsp
- soy-sauce 1 tbsp
- garlic 4 clove (crushed)
- onion 1 piece (sliced)
- black-pepper 1 tsp
- vegetable-oil 1 tbsp
- long-grain-rice 250 g
- cucumber 1 piece (sliced)
- spring-onion 3 piece (sliced)
- chili-fresh 1 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Melt the sugar in a dry deep pan over a medium heat until it turns a deep amber caramel.
3. Carefully add 4 tbsp water, the fish sauce and soy sauce and stir until smooth.
4. Add the oil, garlic, onion and pork and simmer for 15 minutes until the sauce is sticky.
5. Season with plenty of black pepper.
6. Serve over rice with cucumber, spring onions and chili.

#### `nasi-goreng` · Nasi goreng · 🍳 · Other
vibes: quickEasy, fakeaway, onePan · appliances: stovetop · prep 10 / cook 22 min · serves 2 · leftovers: no

- long-grain-rice 150 g
- vegetable-oil 1 tbsp
- chicken-thighs 250 g (diced)
- garlic 2 clove (crushed)
- onion 0.5 piece (diced)
- chili-flakes 0.5 tsp
- soy-sauce 2 tbsp
- honey 1 tbsp
- ketchup 1 tbsp
- eggs 2 piece
- cucumber 0.5 piece (sliced)

1. Cook the rice for 12 minutes, drain and spread out to steam dry.
2. Stir-fry the chicken in the oil over a high heat for 5 minutes.
3. Add the garlic, onion and chili and cook for 2 minutes.
4. Mix the soy sauce, honey and ketchup into a sweet soy sauce, add with the rice and stir-fry for 3 minutes until sticky.
5. Fry the eggs in another pan until crispy at the edges.
6. Serve the rice topped with the eggs and cucumber on the side.

#### `laksa-style-shrimp-noodles` · Laksa-style shrimp noodle soup · 🍜 · Other
vibes: comfort, fakeaway · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- vegetable-oil 1 tbsp
- thai-curry-paste 3 tbsp
- curry-powder 1 tsp
- coconut-milk 400 ml
- vegetable-bouillon 2 tsp
- fish-sauce 1 tbsp
- sugar 1 tsp
- shrimp 200 g
- rice-noodles 200 g
- bean-sprouts 150 g
- lime 1 piece
- eggs 2 piece

1. Boil the eggs for 7 minutes, cool and peel.
2. Fry the curry paste and curry powder in the oil for 1 minute.
3. Add the coconut milk, 700 ml boiling water, the bouillon, fish sauce and sugar and simmer for 5 minutes.
4. Add the shrimp and simmer for 3 minutes until pink.
5. Soak the noodles in just-boiled water for 8 minutes and drain into bowls.
6. Ladle over the soup and top with sprouts, halved eggs and lime.

#### `yaki-udon` · Yaki udon with pork & cabbage · 🍜 · Japanese
vibes: quickEasy, fakeaway · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- udon-noodles 2 piece
- ground-pork 200 g
- vegetable-oil 1 tbsp
- cabbage 200 g (shredded)
- carrot 1 piece (cut into matchsticks)
- mushrooms 100 g (sliced)
- soy-sauce 2 tbsp
- worcestershire 1 tbsp
- honey 1 tsp
- spring-onion 2 piece (sliced)
- sesame-seeds 1 tsp

1. Loosen the udon in boiling water for 2 minutes, then drain.
2. Fry the pork in the oil over a high heat for 5 minutes until browned.
3. Add the cabbage, carrot and mushrooms and stir-fry for 3 minutes.
4. Mix the soy sauce, Worcestershire and honey.
5. Add the noodles and sauce and toss for 2 minutes.
6. Serve topped with spring onion and sesame seeds.

#### `air-fryer-tonkatsu-pork` · Air-fryer tonkatsu pork with cabbage · 🐷 · Japanese
vibes: fakeaway, family · appliances: airFryer, stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- pork-tenderloin 1 piece (cut into 8 medallions and flattened)
- flour 2 tbsp
- eggs 1 piece (beaten)
- breadcrumbs 80 g
- long-grain-rice 250 g
- cabbage 300 g (very finely shredded)
- ketchup 3 tbsp
- worcestershire 2 tbsp
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Season the pork with salt, dust in flour, dip in egg, then press into the breadcrumbs.
3. Air-fry at 200°C (400°F) for 12 minutes, turning halfway, until golden and cooked through.
4. Mix the ketchup and Worcestershire into a quick tonkatsu sauce.
5. Pile the shredded cabbage onto plates — shred it as finely as you can.
6. Slice the pork and serve with the rice, cabbage and sauce.

#### `chicken-karaage-bowl` · Air-fryer chicken karaage bowl · 🍗 · Japanese
vibes: fakeaway, highProtein · appliances: airFryer, stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- chicken-thighs 600 g (cut into chunks)
- soy-sauce 3 tbsp
- ginger 15 g (grated)
- garlic 2 clove (crushed)
- cornstarch 4 tbsp
- long-grain-rice 250 g
- cabbage 200 g (shredded)
- mayonnaise 3 tbsp
- sriracha 1 tsp
- lemon 1 piece
- spring-onion 2 piece (sliced)

1. Marinate the chicken in 2 tbsp soy sauce, the ginger and garlic for 10 minutes.
2. Cook the rice in salted boiling water for 12 minutes, then drain.
3. Toss the chicken in the cornstarch until coated.
4. Air-fry at 200°C (400°F) for 14 minutes, shaking halfway, until crisp and cooked through.
5. Mix the mayonnaise with the sriracha.
6. Serve over rice with cabbage, the spicy mayo, lemon wedges and spring onions, drizzled with the rest of the soy.

#### `dakgalbi-spicy-chicken` · Cheesy dakgalbi-style spicy chicken · 🌶️ · Korean
vibes: onePan, fakeaway · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-thighs 600 g (sliced)
- gochujang 3 tbsp
- soy-sauce 2 tbsp
- honey 1 tbsp
- garlic 3 clove (crushed)
- vegetable-oil 1 tbsp
- cabbage 400 g (chopped)
- onion 1 piece (sliced)
- mozzarella 1 piece (torn)
- long-grain-rice 250 g
- sesame-seeds 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Mix the gochujang, soy sauce, honey and garlic and coat the chicken.
3. Heat the oil in a large pan and add the chicken, cabbage and onion.
4. Stir-fry for 10 minutes until the chicken is cooked and the sauce is sticky.
5. Scatter over the mozzarella, cover for 2 minutes to melt.
6. Sprinkle with sesame and serve with the rice.

#### `beef-bulgogi-rice-bowl` · Beef bulgogi rice bowl · 🥩 · Korean
vibes: highProtein, fakeaway · appliances: stovetop · prep 15 / cook 10 min · serves 4 · leftovers: no

- beef-steak 2 piece (very thinly sliced)
- soy-sauce 4 tbsp
- honey 2 tbsp
- garlic 3 clove (crushed)
- sesame-oil 1 tbsp
- onion 1 piece (sliced)
- long-grain-rice 250 g
- cucumber 1 piece (sliced)
- spring-onion 3 piece (sliced)
- sesame-seeds 1 tsp

1. Mix the soy sauce, honey and garlic and marinate the beef for 10 minutes.
2. Cook the rice in salted boiling water for 12 minutes, then drain.
3. Heat the sesame oil in a very hot pan and cook the onion for 2 minutes.
4. Add the beef in batches and sear for 2 minutes until caramelised.
5. Spoon over the rice.
6. Serve with cucumber, spring onions and sesame.

#### `kimchi-stew-pork-tofu` · Kimchi stew with pork & tofu · 🍲 · Korean
vibes: comfort, onePan · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- ground-pork 250 g
- vegetable-oil 1 tbsp
- kimchi 300 g (chopped)
- onion 1 piece (sliced)
- garlic 3 clove (crushed)
- gochujang 1 tbsp
- vegetable-bouillon 2 tsp
- soy-sauce 1 tbsp
- tofu 400 g (sliced)
- spring-onion 3 piece (sliced)
- long-grain-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Brown the pork in the oil in a deep pan for 5 minutes.
3. Add the kimchi, onion and garlic and cook for 5 minutes — frying the kimchi deepens the flavour.
4. Stir in the gochujang, then 900 ml boiling water, the bouillon and soy sauce, and simmer for 10 minutes.
5. Slide in the tofu and simmer for 5 minutes more.
6. Scatter with spring onions and serve with the rice.

#### `palak-paneer` · Palak paneer · 🥬 · Indian
vibes: healthyish, comfort · appliances: stovetop, blender · prep 10 / cook 20 min · serves 4 · leftovers: no

- spinach-frozen 500 g
- paneer 225 g (cubed)
- vegetable-oil 2 tbsp
- onion 1 piece (diced)
- garlic 4 clove (crushed)
- ginger 15 g (grated)
- cumin 1 tsp
- garam-masala 2 tsp
- tomato 1 piece (chopped)
- heavy-cream 50 ml
- basmati-rice 250 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Heat the spinach with a splash of water until hot, then blend until smooth.
3. Fry the paneer in half the oil until golden, then set aside.
4. Cook the onion in the rest of the oil for 6 minutes, then add the garlic, ginger and spices for 1 minute, and the tomato for 3 minutes.
5. Stir in the spinach, cream and salt and simmer for 3 minutes.
6. Fold in the paneer and serve with the rice.

#### `chicken-jalfrezi` · Chicken jalfrezi · 🌶️ · Indian
vibes: fakeaway, highProtein · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 3 piece (diced)
- vegetable-oil 2 tbsp
- onion 2 piece (cut into chunks)
- bell-pepper 2 piece (cut into chunks)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- chili-fresh 2 piece (sliced)
- curry-powder 1 tbsp
- garam-masala 1 tsp
- chopped-tomatoes 400 g
- basmati-rice 250 g
- cilantro 15 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Brown the chicken in half the oil for 5 minutes, then set aside.
3. Fry the onions and peppers in the rest of the oil over a high heat for 5 minutes until charred at the edges.
4. Add the garlic, ginger, chili and spices for 1 minute.
5. Add the tomatoes, chicken and salt and simmer for 8 minutes until thick.
6. Serve with the rice and cilantro.

#### `tandoori-chicken-traybake` · Tandoori-style chicken traybake · 🍗 · Indian
vibes: onePan, highProtein, family · appliances: oven, stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- greek-yogurt 150 g
- garam-masala 2 tsp
- paprika 2 tsp
- cumin 1 tsp
- turmeric 1 tsp
- garlic 3 clove (crushed)
- lemon 1 piece
- cauliflower 1 piece (cut into florets)
- red-onion 2 piece (cut into wedges)
- olive-oil 1 tbsp
- basmati-rice 250 g
- cucumber 1 piece (diced)
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix half the yogurt with the spices, garlic, lemon juice and salt and coat the chicken.
3. Toss the cauliflower and onions with the oil on a large tray and add the chicken.
4. Roast for 30 minutes until the chicken is charred and cooked through.
5. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
6. Mix the rest of the yogurt with the cucumber and serve alongside.

#### `rajma-kidney-bean-curry` · Rajma kidney bean curry · 🫘 · Indian
vibes: healthyish, batchFriendly, comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- cumin 1 tsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- garam-masala 2 tsp
- ground-coriander 1 tsp
- chili-powder 0.5 tsp
- chopped-tomatoes 400 g
- kidney-beans 720 g (drained)
- basmati-rice 250 g
- cilantro 15 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Fry the cumin in the oil for 30 seconds, then add the onion for 6 minutes.
3. Add the garlic, ginger and spices for 1 minute.
4. Add the tomatoes, beans, salt and 200 ml water.
5. Simmer for 15 minutes, crushing some of the beans to thicken.
6. Serve over the rice with cilantro.

#### `egg-curry` · Spiced egg curry · 🥚 · Indian
vibes: quickEasy, comfort · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- eggs 8 piece
- vegetable-oil 1 tbsp
- onion 2 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- curry-powder 1 tbsp
- garam-masala 1 tsp
- chopped-tomatoes 400 g
- coconut-milk 200 ml
- spinach 100 g
- basmati-rice 250 g
- cilantro 10 g
- salt 1 tsp

1. Boil the eggs for 9 minutes, then cool in cold water and peel.
2. Cook the rice in salted boiling water for 12 minutes, then drain.
3. Cook the onions in the oil for 8 minutes until golden.
4. Add the garlic, ginger and spices for 1 minute, then the tomatoes, coconut milk and salt.
5. Simmer for 8 minutes, then add the spinach and the eggs, halved.
6. Warm through and serve with the rice and cilantro.

#### `chicken-chickpea-tagine` · Chicken & chickpea tagine with couscous · 🍲 · Middle Eastern
vibes: comfort, batchFriendly · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chicken-thighs 600 g (diced)
- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- cumin 1 tsp
- cinnamon 1 tsp
- ground-coriander 1 tsp
- paprika 1 tsp
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- chickpeas 240 g (drained)
- raisins 40 g
- honey 1 tbsp
- couscous 250 g

1. Brown the chicken in the oil in a deep pan for 5 minutes.
2. Add the onion and cook for 5 minutes, then the garlic and spices for 1 minute.
3. Add the tomatoes, 300 ml water, 1 tsp bouillon, the chickpeas, raisins and honey.
4. Cover and simmer for 20 minutes until the chicken is tender.
5. Pour 350 ml boiling water with the rest of the bouillon over the couscous, cover for 5 minutes, then fluff.
6. Serve the tagine over the couscous.

#### `lebanese-chicken-rice` · Lebanese-style spiced chicken & rice · 🍚 · Middle Eastern
vibes: family, comfort · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- ground-beef 200 g
- chicken-breast 2 piece
- chicken-stock 800 ml
- butter 1 tbsp
- onion 1 piece (diced)
- cinnamon 1 tsp
- cumin 0.5 tsp
- long-grain-rice 300 g
- cashews 40 g
- greek-yogurt 150 g
- cucumber 1 piece (diced)
- parsley 15 g
- salt 1 tsp

1. Poach the chicken in the stock for 15 minutes, then lift out and shred, keeping 600 ml of stock.
2. Brown the beef and onion in the butter for 7 minutes with the cinnamon, cumin and salt.
3. Stir in the rice, then the saved stock.
4. Cover and cook on a low heat for 15 minutes until tender.
5. Toast the cashews in a dry pan until golden.
6. Pile the rice onto a plate, top with the chicken, cashews and parsley, and serve with yogurt and cucumber.

#### `greek-baked-white-beans` · Greek-style baked white beans with feta · 🫘 · Mediterranean
vibes: healthyish, comfort, batchFriendly · appliances: oven, stovetop · prep 10 / cook 35 min · serves 4 · leftovers: yes

- olive-oil 3 tbsp
- onion 1 piece (diced)
- carrot 1 piece (diced)
- garlic 3 clove (crushed)
- dried-oregano 1 tsp
- cinnamon 0.25 tsp
- chopped-tomatoes 400 g
- tomato-paste 1 tbsp
- cannellini-beans 720 g (drained)
- feta 150 g
- parsley 15 g
- baguette 1 piece

1. Heat the oven to 200°C (400°F).
2. Cook the onion and carrot in the oil for 6 minutes, then add the garlic, oregano and cinnamon.
3. Stir in the tomatoes, tomato paste, beans and 150 ml water.
4. Tip into a baking dish and crumble over the feta.
5. Bake for 25 minutes until bubbling and golden at the edges.
6. Scatter with parsley and serve with warm baguette.

#### `briam-roast-vegetables` · Briam Greek roast vegetables with feta · 🍆 · Mediterranean
vibes: healthyish, onePan, batchFriendly · appliances: oven · prep 10 / cook 35 min · serves 4 · leftovers: yes

- potato 3 piece (cut into small chunks)
- zucchini 2 piece (chopped)
- eggplant 1 piece (chopped)
- red-onion 2 piece (cut into wedges)
- bell-pepper 1 piece (chopped)
- garlic 4 clove (sliced)
- chopped-tomatoes 400 g
- dried-oregano 2 tsp
- olive-oil 4 tbsp
- feta 150 g
- baguette 1 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss all the vegetables and garlic with the oil, oregano and salt on your largest tray — small pieces and space are what make this fast.
3. Roast for 20 minutes.
4. Stir in the tomatoes and roast for 15 minutes more until soft and caramelised.
5. Crumble over the feta.
6. Serve with bread.

#### `greek-stuffed-peppers` · Greek stuffed peppers with rice & feta · 🫑 · Mediterranean
vibes: healthyish, family · appliances: oven, stovetop · prep 10 / cook 35 min · serves 4 · leftovers: yes

- bell-pepper 4 piece (halved lengthways and seeded)
- olive-oil 2 tbsp
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- long-grain-rice 150 g
- chopped-tomatoes 400 g
- vegetable-bouillon 1 tsp
- dried-oregano 1 tsp
- feta 120 g (crumbled)
- chickpeas 240 g (drained)
- salt 1 tsp

1. Heat the oven to 220°C (425°F) and roast the pepper halves for 10 minutes while you make the filling.
2. Cook the onion in the oil for 5 minutes, then add the garlic, rice and oregano.
3. Add the tomatoes, 300 ml water and the bouillon and simmer for 12 minutes until the rice is nearly tender.
4. Stir in the chickpeas and most of the feta.
5. Fill the peppers and bake for 15 minutes.
6. Crumble over the rest of the feta to serve.

#### `chicken-cacciatore` · Chicken cacciatore · 🍗 · Italian
vibes: comfort, family, batchFriendly · appliances: stovetop · prep 10 / cook 35 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- olive-oil 1 tbsp
- onion 1 piece (sliced)
- bell-pepper 2 piece (sliced)
- mushrooms 200 g (sliced)
- garlic 3 clove (crushed)
- italian-herbs 2 tsp
- chopped-tomatoes 400 g
- chicken-stock 200 ml
- olives 60 g
- penne 300 g
- parsley 10 g
- salt 1 tsp

1. Season the chicken with salt and brown in the oil in a deep pan for 6 minutes, then set aside.
2. Cook the onion, peppers and mushrooms for 6 minutes.
3. Add the garlic and herbs, then the tomatoes, stock and olives.
4. Return the chicken, cover and simmer for 25 minutes until tender.
5. Cook the pasta in salted boiling water, then drain.
6. Serve the chicken and sauce over the pasta with parsley.

#### `spaghetti-carbonara` · Spaghetti carbonara · 🍝 · Italian
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- spaghetti 350 g
- bacon 8 slice (chopped)
- eggs 3 piece
- parmesan 80 g (finely grated)
- garlic 1 clove (peeled)
- black-pepper 1 tsp
- peas-frozen 100 g

1. Cook the spaghetti in salted boiling water, adding the peas for the last 2 minutes. Save a mug of water before draining.
2. Fry the bacon with the whole garlic clove until crisp, then discard the garlic.
3. Whisk the eggs with most of the parmesan and the pepper.
4. Take the bacon pan off the heat and add the spaghetti and peas.
5. Pour in the egg mixture with a splash of pasta water and toss quickly until silky, not scrambled.
6. Serve with the rest of the parmesan and more pepper.

#### `pasta-e-fagioli` · Pasta e fagioli · 🍲 · Italian
vibes: comfort, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 2 tbsp
- onion 1 piece (diced)
- carrot 1 piece (diced)
- celery 2 piece (diced)
- garlic 3 clove (crushed)
- italian-herbs 1 tsp
- chopped-tomatoes 400 g
- cannellini-beans 480 g (drained)
- vegetable-bouillon 3 tsp
- penne 200 g
- parmesan 40 g (grated)
- baguette 1 piece

1. Cook the onion, carrot and celery in the oil for 8 minutes.
2. Add the garlic and herbs for 1 minute.
3. Add the tomatoes, beans, 1 litre boiling water and the bouillon, then mash a few beans to thicken.
4. Simmer for 5 minutes, then add the pasta and simmer for 10 minutes until tender.
5. Season and loosen with a splash of water if needed.
6. Serve with parmesan and crusty bread.

#### `gnocchi-alla-sorrentina` · Gnocchi alla sorrentina · 🍅 · Italian
vibes: comfort, family, onePan · appliances: stovetop, oven · prep 5 / cook 25 min · serves 4 · leftovers: no

- gnocchi 1000 g
- olive-oil 1 tbsp
- garlic 3 clove (crushed)
- passata 500 g
- italian-herbs 1 tsp
- basil 20 g
- mozzarella 2 piece (torn)
- parmesan 30 g (grated)
- arugula 60 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Cook the garlic in the oil in an ovenproof pan for 1 minute, then add the passata, herbs and salt and simmer for 8 minutes.
3. Cook the gnocchi in boiling water for 2 minutes until they float, then drain.
4. Stir the gnocchi and half the basil into the sauce.
5. Top with mozzarella and parmesan and bake for 12 minutes until bubbling.
6. Scatter with the rest of the basil and serve with an arugula salad.

#### `lemon-butter-chicken-spaghetti` · Lemon butter chicken with spaghetti · 🍋 · Italian
vibes: quickEasy, family · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 3 piece (halved horizontally)
- flour 2 tbsp
- olive-oil 1 tbsp
- butter 3 tbsp
- garlic 3 clove (crushed)
- chicken-stock 200 ml
- lemon 2 piece
- spaghetti 300 g
- spinach 100 g
- parsley 15 g (chopped)
- parmesan 30 g (grated)
- salt 1 tsp

1. Cook the spaghetti in salted boiling water, saving a mug of water before draining.
2. Season the chicken with salt and dust in the flour.
3. Fry in the oil and 1 tbsp butter for 4 minutes on each side until golden and cooked. Set aside.
4. Add the garlic, stock and lemon juice to the pan and bubble for 3 minutes, then stir in the rest of the butter.
5. Toss the spaghetti and spinach in half the sauce with a splash of pasta water.
6. Slice the chicken, lay on top and spoon over the rest of the sauce, parsley and parmesan.

#### `pasta-alla-norma` · Pasta alla norma · 🍆 · Italian
vibes: healthyish, family · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- eggplant 2 piece (cubed)
- olive-oil 4 tbsp
- garlic 3 clove (sliced)
- chili-flakes 0.5 tsp
- chopped-tomatoes 800 g
- penne 350 g
- basil 20 g
- parmesan 40 g (grated)
- salt 1 tsp

1. Fry the eggplant in 3 tbsp oil over a medium-high heat for 10 minutes, turning, until golden and soft.
2. Push to one side, add the rest of the oil, garlic and chili for 1 minute.
3. Add the tomatoes and salt and simmer for 12 minutes.
4. Meanwhile, cook the pasta in salted boiling water, then drain.
5. Toss the pasta with the sauce and most of the basil.
6. Serve with parmesan and the rest of the basil.

#### `vegetable-paella` · Vegetable paella · 🥘 · Spanish/Portuguese
vibes: onePan, healthyish, family · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: no

- olive-oil 2 tbsp
- onion 1 piece (diced)
- bell-pepper 2 piece (sliced)
- garlic 3 clove (crushed)
- paprika 2 tsp
- turmeric 1 tsp
- arborio-rice 300 g
- chopped-tomatoes 200 g
- vegetable-bouillon 3 tsp
- green-beans 150 g (halved)
- peas-frozen 150 g
- chickpeas 240 g (drained)
- lemon 1 piece

1. Cook the onion and peppers in the oil in a wide pan for 6 minutes.
2. Add the garlic, paprika and turmeric for 1 minute.
3. Stir in the rice, then the tomatoes, 900 ml boiling water and the bouillon.
4. Simmer without stirring for 15 minutes — not stirring is what gives paella its crispy base.
5. Scatter over the beans, peas and chickpeas, cover and cook for 8 minutes until the rice is tender.
6. Serve with lemon wedges.

#### `patatas-bravas-eggs` · Patatas bravas with fried eggs · 🥔 · Spanish/Portuguese
vibes: comfort, family · appliances: oven, stovetop · prep 10 / cook 35 min · serves 4 · leftovers: no

- potato 5 piece (cubed)
- olive-oil 3 tbsp
- paprika 2 tsp
- garlic 2 clove (crushed)
- chili-flakes 0.5 tsp
- chopped-tomatoes 400 g
- red-wine-vinegar 1 tsp
- eggs 8 piece
- mayonnaise 3 tbsp
- parsley 10 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Toss the potatoes with 2 tbsp oil and salt and roast for 35 minutes until crisp.
2. Cook the garlic, paprika and chili in the rest of the oil for 1 minute.
3. Add the tomatoes and vinegar and simmer for 10 minutes until thick.
4. Mix 1 tbsp of the sauce into the mayonnaise.
5. Fry the eggs until crisp at the edges.
6. Pile the potatoes onto plates, spoon over the bravas sauce and garlic mayo and top with the eggs and parsley.

#### `carne-asada-bowls` · Carne asada rice bowls · 🥩 · Mexican
vibes: highProtein, family · appliances: stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- beef-steak 2 piece
- lime 3 piece
- garlic 3 clove (crushed)
- cumin 1 tsp
- chili-powder 1 tsp
- olive-oil 2 tbsp
- long-grain-rice 250 g
- black-beans 240 g (drained)
- tomato 2 piece (diced)
- red-onion 0.5 piece (finely diced)
- cilantro 20 g (chopped)
- salt 1 tsp

1. Mix the juice of 2 limes, the garlic, spices, oil and salt and marinate the steak for 10 minutes.
2. Cook the rice in salted boiling water for 12 minutes, then drain and toss with half the cilantro.
3. Mix the tomato, onion, the rest of the cilantro and the juice of the last lime for a pico de gallo.
4. Sear the steak in a very hot pan for 3–4 minutes on each side.
5. Rest for 5 minutes, then slice thinly against the grain.
6. Serve over the rice with warm beans and pico de gallo.

#### `taco-soup` · One-pot taco soup · 🌮 · Mexican
vibes: onePan, family, batchFriendly · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: yes

- ground-beef 500 g
- onion 1 piece (diced)
- bell-pepper 1 piece (diced)
- chili-powder 2 tsp
- cumin 2 tsp
- paprika 1 tsp
- chopped-tomatoes 400 g
- kidney-beans 240 g (drained)
- black-beans 240 g (drained)
- sweetcorn-tin 165 g (drained)
- vegetable-bouillon 2 tsp
- cheddar 60 g (grated)
- corn-tortillas 4 piece (cut into strips)

1. Brown the beef with the onion and pepper for 8 minutes.
2. Stir in the spices for 1 minute.
3. Add the tomatoes, beans, sweetcorn, 700 ml boiling water and the bouillon and simmer for 15 minutes.
4. Toast the tortilla strips in a dry pan until crisp.
5. Taste and season with salt.
6. Serve topped with cheddar and the crispy strips.

#### `street-corn-chicken-bowl` · Street corn chicken bowl · 🌽 · Mexican
vibes: family, highProtein · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-breast 3 piece
- chili-powder 1 tsp
- paprika 1 tsp
- olive-oil 1 tbsp
- corn-frozen 400 g
- mayonnaise 2 tbsp
- greek-yogurt 100 g
- lime 2 piece
- feta 80 g (crumbled)
- long-grain-rice 250 g
- cilantro 15 g
- red-onion 0.5 piece (finely diced)
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Rub the chicken with the spices and salt and cook in the oil for 6 minutes on each side, then slice.
3. Char the corn in the hot pan for 6 minutes until blackened in spots.
4. Mix the mayonnaise, yogurt and juice of 1 lime, then toss with the corn, feta and onion.
5. Fill bowls with rice, chicken and the street corn.
6. Finish with cilantro, chili and lime wedges.

#### `chicken-biscuit-pot-pie` · Chicken pot pie skillet with biscuit topping · 🥧 · American
vibes: comfort, family · appliances: stovetop, oven · prep 15 / cook 30 min · serves 4 · leftovers: no

- chicken-breast 2 piece (diced)
- butter 4 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- celery 2 piece (diced)
- flour 180 g
- chicken-stock 500 ml
- milk 250 ml
- peas-frozen 150 g
- dried-thyme 1 tsp
- baking-powder 2 tsp
- cheddar 40 g (grated)
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Cook the onion, carrot, celery and chicken in 1 tbsp butter in an ovenproof pan for 8 minutes.
3. Stir in 2 tbsp flour and the thyme, then whisk in the stock and 150 ml milk and simmer until thick. Add the peas.
4. Rub the rest of the butter into the rest of the flour with the baking powder and salt, then stir in the cheese and the rest of the milk to a soft dough.
5. Drop spoonfuls of the dough over the filling.
6. Bake for 20 minutes until the biscuits are risen and golden.

#### `mini-turkey-meatloaves` · Mini turkey meatloaves with mash · 🦃 · American
vibes: family, highProtein, comfort · appliances: oven, stovetop · prep 15 / cook 30 min · serves 4 · leftovers: no

- ground-turkey 500 g
- onion 0.5 piece (grated)
- breadcrumbs 40 g
- eggs 1 piece
- worcestershire 1 tbsp
- garlic-powder 1 tsp
- ketchup 5 tbsp
- potato 5 piece (peeled and chopped)
- milk 100 ml
- butter 1 tbsp
- green-beans 250 g
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Mix the turkey, onion, breadcrumbs, egg, Worcestershire, garlic powder and salt and shape into 8 mini loaves on a lined tray.
3. Brush with the ketchup and bake for 25 minutes until glazed and cooked through.
4. Meanwhile, boil the potatoes for 15 minutes, then mash with the milk and butter.
5. Steam the green beans for 4 minutes.
6. Serve the meatloaves with the mash and beans.

#### `one-pot-chili-mac` · One-pot chili mac · 🌶️ · American
vibes: onePan, family, comfort · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: no

- ground-beef 500 g
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- chili-powder 2 tsp
- cumin 1 tsp
- paprika 1 tsp
- chopped-tomatoes 400 g
- kidney-beans 240 g (drained)
- vegetable-stock 700 ml
- penne 250 g
- cheddar 100 g (grated)
- spring-onion 2 piece (sliced)

1. Brown the beef and onion in a large pan for 8 minutes.
2. Add the garlic and spices for 1 minute.
3. Stir in the tomatoes, beans and stock and bring to the boil.
4. Add the pasta and simmer for 12 minutes, stirring often, until tender.
5. Stir in most of the cheddar until melted.
6. Top with the rest of the cheese and spring onions.

#### `white-chicken-chili` · White chicken chili · 🍲 · American
vibes: comfort, highProtein, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- chili-flakes 1 tsp
- cumin 2 tsp
- dried-oregano 1 tsp
- chicken-breast 3 piece
- vegetable-bouillon 2 tsp
- cannellini-beans 480 g (drained)
- corn-frozen 150 g
- cream-cheese 80 g
- lime 1 piece
- cilantro 15 g
- corn-tortillas 4 piece (cut into strips)

1. Cook the onion in the oil for 5 minutes, then add the garlic, chili and spices.
2. Add the whole chicken breasts, 800 ml boiling water and the bouillon and simmer for 15 minutes.
3. Lift out and shred the chicken.
4. Mash half the beans and add them all to the pot with the corn and chicken.
5. Stir in the cream cheese and lime juice until creamy.
6. Serve with cilantro and toasted tortilla strips.

#### `air-fryer-fish-chips` · Air-fryer fish goujons, chips & mushy peas · 🐟 · British
vibes: family, fakeaway · appliances: airFryer, stovetop · prep 15 / cook 30 min · serves 4 · leftovers: no

- potato 4 piece (cut into chips)
- olive-oil 1 tbsp
- white-fish 3 piece (cut into fingers)
- flour 2 tbsp
- eggs 1 piece (beaten)
- breadcrumbs 80 g
- paprika 1 tsp
- peas-frozen 300 g
- butter 1 tbsp
- lemon 1 piece
- mayonnaise 2 tbsp
- salt 1 tsp

1. Toss the chips with the oil and salt and air-fry at 200°C (400°F) for 20 minutes, shaking twice. Keep warm.
2. Dust the fish in flour, dip in egg, then press into the breadcrumbs mixed with the paprika.
3. Air-fry at 200°C (400°F) for 8–10 minutes until golden and flaky.
4. Meanwhile, boil the peas for 3 minutes, drain and mash with the butter and a pinch of salt.
5. Mix the mayonnaise with a squeeze of lemon.
6. Serve the fish and chips with the mushy peas, lemon mayo and lemon wedges.

#### `lamb-potato-stew` · One-pot lamb, potato & carrot stew · 🥘 · British
vibes: comfort, batchFriendly, onePan · appliances: stovetop · prep 10 / cook 35 min · serves 4 · leftovers: yes

- lamb-mince 500 g
- onion 2 piece (sliced)
- carrot 3 piece (chopped)
- flour 1 tbsp
- worcestershire 1 tbsp
- dried-thyme 1 tsp
- vegetable-bouillon 2 tsp
- potato 4 piece (cut into chunks)
- peas-frozen 150 g
- salt 1 tsp

1. Brown the lamb in a deep pan for 6 minutes until crisp, then spoon off most of the fat.
2. Add the onions and carrots and cook for 5 minutes.
3. Stir in the flour, then the Worcestershire, thyme, bouillon, salt and 600 ml boiling water.
4. Add the potatoes, cover and simmer for 25 minutes until tender and the gravy is thick.
5. Stir in the peas for the last 3 minutes.
6. Serve in bowls with plenty of gravy.

#### `huli-huli-style-chicken` · Huli huli-style chicken & rice · 🍗 · American
vibes: family, fakeaway, highProtein · appliances: oven, stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- ketchup 3 tbsp
- soy-sauce 3 tbsp
- honey 3 tbsp
- ginger 15 g (grated)
- garlic 2 clove (crushed)
- long-grain-rice 250 g
- lime 1 piece
- cabbage 200 g (shredded)
- spring-onion 2 piece (sliced)

1. Heat the oven to 220°C (425°F).
2. Whisk the ketchup, soy sauce, honey, ginger and garlic and toss the chicken in half of it.
3. Roast on a lined tray for 25–30 minutes, brushing with the rest of the sauce twice, until sticky and charred.
4. Cook the rice in salted boiling water for 12 minutes, then drain.
5. Toss the cabbage with the lime juice and a pinch of salt.
6. Serve the chicken over rice with the slaw and spring onions.

### Lunchs (20)

#### `elote-chickpea-salad` · Elote-style corn & chickpea salad · 🌽 · Mexican
vibes: healthyish, quickEasy · appliances: stovetop · prep 10 / cook 8 min · serves 2 · leftovers: no

- corn-frozen 250 g
- chickpeas 240 g (drained)
- mayonnaise 1 tbsp
- greek-yogurt 60 g
- lime 1 piece
- chili-powder 0.5 tsp
- feta 50 g (crumbled)
- red-onion 0.25 piece (finely diced)
- cilantro 10 g (chopped)
- corn-tortillas 2 piece

1. Char the corn in a dry pan over a high heat for 6 minutes until blackened in spots.
2. Mix the mayonnaise, yogurt, lime juice and chili powder.
3. Toss the corn, chickpeas and onion in the dressing.
4. Top with feta and cilantro and serve with toasted tortillas.

#### `curried-chicken-salad-sandwich` · Curried chicken salad sandwich · 🥪 · British
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- chicken-breast 1 piece
- greek-yogurt 60 g
- mayonnaise 1 tbsp
- curry-powder 1 tsp
- raisins 20 g
- celery 1 piece (finely diced)
- spring-onion 1 piece (sliced)
- wholemeal-bread 4 slice
- lettuce 0.25 piece

1. Poach the chicken in simmering water for 12 minutes, then cool and dice.
2. Mix the yogurt, mayonnaise and curry powder.
3. Fold in the chicken, raisins, celery and spring onion.
4. Fill the bread with lettuce and the curried chicken.

#### `chicken-avocado-club` · Chicken & avocado club sandwich · 🥪 · American
vibes: highProtein, family · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- chicken-breast 1 piece (halved horizontally)
- bacon 2 slice
- wholemeal-bread 6 slice
- avocado 0.5 piece (sliced)
- tomato 1 piece (sliced)
- lettuce 0.25 piece
- mayonnaise 2 tbsp
- olive-oil 1 tsp

1. Cook the chicken in the oil for 5 minutes on each side, then slice. Fry the bacon until crisp.
2. Toast the bread and spread with mayonnaise.
3. Layer toast, chicken and lettuce, then toast, bacon, avocado and tomato, then toast.
4. Hold with skewers and cut into triangles.

#### `onigirazu-sushi-sandwich` · Tuna onigirazu sushi sandwich · 🍙 · Japanese
vibes: quickEasy, highProtein · appliances: stovetop · prep 15 / cook 12 min · serves 2 · leftovers: no

- long-grain-rice 125 g
- rice-vinegar 1 tbsp
- nori 4 piece
- canned-tuna 145 g (drained)
- mayonnaise 1 tbsp
- sriracha 1 tsp
- cucumber 0.5 piece (cut into thin strips)
- lettuce 0.25 piece

1. Cook the rice for 12 minutes, drain and mix with the vinegar, then cool slightly.
2. Mix the tuna with the mayonnaise and sriracha.
3. Lay a nori sheet diamond-wise, put a square of rice in the middle, then lettuce, tuna, cucumber and more rice.
4. Fold the corners over to make a parcel, wrap tightly and cut in half.

#### `roast-cauliflower-tahini-salad` · Roast cauliflower salad with tahini · 🥗 · Middle Eastern
vibes: healthyish, batchFriendly · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: yes

- cauliflower 1 piece (cut into florets)
- chickpeas 480 g (drained)
- olive-oil 2 tbsp
- cumin 1 tsp
- paprika 1 tsp
- tahini 3 tbsp
- lemon 1 piece
- garlic 1 clove (crushed)
- arugula 60 g
- raisins 30 g
- parsley 15 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Toss the cauliflower and chickpeas with the oil, spices and salt and roast for 25 minutes.
2. Whisk the tahini, lemon juice, garlic and 4 tbsp water.
3. Toss the arugula, raisins and parsley with the warm roast tray.
4. Drizzle generously with the tahini sauce.

#### `french-onion-soup` · Quicker French onion soup with cheesy toast · 🧅 · Other
vibes: comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- onion 5 piece (thinly sliced)
- butter 2 tbsp
- sugar 1 tsp
- dried-thyme 1 tsp
- flour 1 tbsp
- vegetable-bouillon 3 tsp
- worcestershire 1 tbsp
- baguette 1 piece (sliced)
- cheddar 100 g (grated)
- salt 1 tsp

1. Cook the onions in the butter with the sugar, thyme and salt over a medium-high heat for 18 minutes, adding a splash of water whenever they catch — this speeds up the browning.
2. Stir in the flour, then 1.2 litres boiling water, the bouillon and Worcestershire, and simmer for 5 minutes.
3. Top the baguette slices with cheddar and grill until bubbling.
4. Ladle the soup into bowls and float the cheesy toasts on top.

#### `chinese-chicken-corn-soup` · Chinese-style chicken & sweetcorn soup · 🌽 · Chinese
vibes: comfort, quickEasy · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- chicken-stock 1200 ml
- ginger 10 g (grated)
- chicken-breast 2 piece (finely diced)
- corn-frozen 300 g
- soy-sauce 1 tbsp
- cornstarch 2 tbsp
- eggs 2 piece (beaten)
- sesame-oil 1 tsp
- spring-onion 3 piece (sliced)
- sourdough 4 slice

1. Simmer the stock with the ginger, chicken and corn for 10 minutes.
2. Stir in the soy sauce and the cornstarch mixed with 3 tbsp water until slightly thickened.
3. Slowly drizzle in the egg while stirring gently so it forms silky ribbons.
4. Finish with sesame oil and spring onions, with toast on the side.

#### `hot-sour-tofu-soup` · Hot & sour tofu soup · 🍲 · Chinese
vibes: healthyish, quickEasy · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- vegetable-bouillon 1 tsp
- mushrooms 150 g (sliced)
- tofu 200 g (cut into strips)
- soy-sauce 2 tbsp
- rice-vinegar 3 tbsp
- black-pepper 1 tsp
- chili-flakes 0.5 tsp
- cornstarch 1 tbsp
- eggs 1 piece (beaten)
- spring-onion 2 piece (sliced)
- rice-noodles 60 g

1. Simmer 800 ml water with the bouillon, mushrooms and noodles for 5 minutes.
2. Add the tofu, soy sauce, vinegar, pepper and chili.
3. Stir in the cornstarch mixed with 2 tbsp water until thickened.
4. Drizzle in the egg while stirring, then top with spring onions.

#### `west-african-peanut-soup` · Spicy peanut & sweet potato soup · 🥜 · Other
vibes: comfort, healthyish, batchFriendly · appliances: stovetop, blender · prep 10 / cook 25 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- chili-powder 1 tsp
- sweet-potato 2 piece (cubed)
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- peanut-butter 4 tbsp
- spinach 100 g
- peanuts 30 g (chopped)
- lime 1 piece

1. Cook the onion in the oil for 5 minutes, then add the garlic and chili.
2. Add the sweet potato, tomatoes, 900 ml boiling water and the bouillon and simmer for 18 minutes.
3. Stir in the peanut butter and blend half the soup, then stir it back in.
4. Add the spinach until wilted and serve with peanuts and lime.

#### `curried-cauliflower-soup` · Curried cauliflower soup with crispy chickpeas · 🥣 · Indian
vibes: healthyish, batchFriendly · appliances: stovetop, blender · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 2 tbsp
- onion 1 piece (diced)
- curry-powder 1 tbsp
- cauliflower 1 piece (chopped)
- potato 1 piece (diced)
- vegetable-stock 900 ml
- coconut-milk 200 ml
- chickpeas 240 g (drained and patted dry)
- paprika 1 tsp
- cilantro 10 g
- naan 2 piece

1. Cook the onion in 1 tbsp oil for 5 minutes, then add the curry powder.
2. Add the cauliflower, potato and stock and simmer for 18 minutes, then blend with the coconut milk.
3. Fry the chickpeas in the rest of the oil with the paprika for 6 minutes until crisp.
4. Serve the soup topped with crispy chickpeas and cilantro, with warm naan.

#### `loaded-hummus-spiced-beef` · Loaded hummus bowl with spiced beef · 🫓 · Middle Eastern
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- hummus 250 g
- ground-beef 400 g
- olive-oil 1 tbsp
- cumin 1 tsp
- cinnamon 0.5 tsp
- paprika 1 tsp
- garlic 2 clove (crushed)
- tomato 2 piece (diced)
- cucumber 0.5 piece (diced)
- lemon 1 piece
- pita-bread 4 piece

1. Brown the beef in the oil for 7 minutes until crisp, adding the garlic and spices for the last minute.
2. Swoosh the hummus over plates.
3. Pile on the spiced beef, tomato and cucumber and squeeze over the lemon.
4. Serve with warm pita for scooping.

#### `tuna-stuffed-avocado` · Tuna-stuffed avocados · 🥑 · Other
vibes: highProtein, quickEasy · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- avocado 2 piece (halved)
- canned-tuna 145 g (drained)
- greek-yogurt 40 g
- lemon 0.5 piece
- red-onion 0.25 piece (finely diced)
- sweetcorn-tin 60 g (drained)
- paprika 1 pinch
- rice-cakes 4 piece

1. Scoop a little flesh from each avocado half and dice it.
2. Mix with the tuna, yogurt, lemon juice, onion and sweetcorn.
3. Pile back into the avocado halves and dust with paprika.
4. Serve with rice cakes.

#### `halloumi-fries-salad` · Air-fryer halloumi fries with salad · 🧀 · Mediterranean
vibes: quickEasy, family · appliances: airFryer · prep 10 / cook 10 min · serves 4 · leftovers: no

- halloumi 250 g (cut into fries)
- cornstarch 1 tbsp
- paprika 1 tsp
- greek-yogurt 150 g
- sweet-chili-sauce 3 tbsp
- cucumber 1 piece (diced)
- tomato 3 piece (diced)
- spinach 60 g
- pita-bread 4 piece

1. Toss the halloumi in the cornstarch and paprika.
2. Air-fry at 200°C (400°F) for 8–10 minutes until golden.
3. Toss the cucumber, tomato and spinach.
4. Serve the fries with the salad, warm pita, yogurt and sweet chili sauce for dipping.

#### `pea-feta-mint-frittata` · Pea, feta & mint frittata · 🍳 · Mediterranean
vibes: highProtein, batchFriendly · appliances: stovetop, oven · prep 5 / cook 20 min · serves 4 · leftovers: yes

- eggs 8 piece
- peas-frozen 200 g
- feta 100 g (crumbled)
- mint 15 g (chopped)
- spring-onion 3 piece (sliced)
- olive-oil 1 tbsp
- arugula 60 g
- sourdough 4 slice
- salt 1 pinch

1. Heat the oven to 200°C (400°F) and soften the spring onions in the oil in an ovenproof pan for 2 minutes.
2. Whisk the eggs with the salt and stir in the peas, feta and mint.
3. Pour into the pan, cook for 3 minutes until the edges set, then bake for 15 minutes.
4. Cut into wedges and serve warm or cold with arugula and toast.

#### `spanish-tortilla` · Spanish potato tortilla · 🥔 · Spanish/Portuguese
vibes: family, batchFriendly · appliances: microwave, stovetop · prep 10 / cook 20 min · serves 4 · leftovers: yes

- potato 4 piece (thinly sliced)
- onion 1 piece (thinly sliced)
- olive-oil 4 tbsp
- eggs 6 piece
- salt 1 tsp
- lettuce 0.5 piece
- tomato 2 piece (sliced)

1. Microwave the potato slices with a splash of water, covered, for 8 minutes until just tender.
2. Fry the onion and potatoes in the oil over a medium heat for 6 minutes without browning much.
3. Beat the eggs with the salt, stir in the potatoes and onion, pour back into the pan and cook over a low heat for 5 minutes, then flip onto a plate and slide back for 3 minutes.
4. Cut into wedges and serve warm or cold with a lettuce and tomato salad.

#### `mezze-plate` · Mezze lunch plate · 🫒 · Middle Eastern
vibes: healthyish, quickEasy · appliances: stovetop · prep 10 / cook 8 min · serves 2 · leftovers: no

- hummus 120 g
- pita-bread 2 piece
- cucumber 0.5 piece (cut into sticks)
- tomato 1 piece (cut into wedges)
- feta 40 g
- eggs 2 piece
- roasted-peppers 60 g
- olive-oil 1 tsp
- paprika 1 pinch

1. Boil the eggs for 8 minutes, then cool, peel and halve.
2. Warm the pittas and cut into strips.
3. Spoon the hummus onto plates and drizzle with the oil and paprika.
4. Arrange the eggs, cucumber, tomato, feta and peppers around it.

#### `ploughmans-lunch-box` · Ploughman's lunch box · 🧀 · British
vibes: quickEasy, family · appliances: stovetop · prep 10 / cook 8 min · serves 2 · leftovers: no

- cheddar 80 g (cut into chunks)
- ham 2 slice
- apple 1 piece (sliced)
- eggs 2 piece
- baguette 0.5 piece
- celery 1 piece (cut into sticks)
- dijon-mustard 1 tsp
- grapes 80 g

1. Boil the eggs for 8 minutes, then cool, peel and halve.
2. Slice the bread.
3. Pack the cheddar, ham, apple, eggs, celery and grapes into boxes.
4. Add a dab of mustard and the bread.

#### `leek-potato-soup` · Leek & potato soup · 🥣 · British
vibes: comfort, batchFriendly · appliances: stovetop, blender · prep 10 / cook 25 min · serves 4 · leftovers: yes

- butter 1 tbsp
- leek 3 piece (sliced)
- onion 1 piece (diced)
- potato 3 piece (diced)
- vegetable-stock 1000 ml
- milk 150 ml
- cheddar 60 g (grated)
- sourdough 4 slice
- salt 1 tsp

1. Soften the leeks and onion in the butter for 8 minutes without browning.
2. Add the potatoes, stock and salt and simmer for 15 minutes.
3. Blend until smooth and stir in the milk.
4. Serve with cheddar on top and toast on the side.

#### `smoky-chorizo-bean-soup` · Smoky chorizo & bean soup · 🥘 · Spanish/Portuguese
vibes: comfort, batchFriendly · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: yes

- chorizo 100 g (diced)
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- paprika 1 tsp
- chopped-tomatoes 400 g
- cannellini-beans 480 g (drained)
- vegetable-stock 800 ml
- kale 80 g (shredded)
- baguette 1 piece

1. Fry the chorizo in a dry pan for 3 minutes until it releases its oil.
2. Add the onion for 5 minutes, then the garlic and paprika.
3. Add the tomatoes, beans and stock and simmer for 10 minutes, then stir in the kale.
4. Serve with crusty bread.

#### `cheesy-bean-tortilla-bake` · Cheesy bean & corn tortilla bake · 🫓 · Mexican
vibes: family, batchFriendly · appliances: oven · prep 10 / cook 20 min · serves 4 · leftovers: yes

- tortillas 4 piece
- black-beans 480 g (drained)
- sweetcorn-tin 165 g (drained)
- salsa 300 g
- cumin 1 tsp
- cheddar 120 g (grated)
- spinach 80 g
- sour-cream 80 g
- cilantro 10 g

1. Heat the oven to 200°C (400°F).
2. Mix the beans, sweetcorn, spinach, cumin and two-thirds of the salsa.
3. Layer tortillas, bean mix and cheese in a round dish, finishing with a tortilla, the rest of the salsa and cheese.
4. Bake for 20 minutes, then cut into wedges and serve with sour cream and cilantro.

### Breakfasts (20)

#### `croque-madame` · Pan-fried croque madame · 🥪 · Other
vibes: comfort, highProtein · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- wholemeal-bread 4 slice
- ham 2 slice
- cheddar 60 g (grated)
- butter 1 tbsp
- dijon-mustard 1 tsp
- eggs 2 piece

1. Spread two slices of bread with mustard and top with ham and most of the cheese, then close the sandwiches.
2. Butter the outsides and fry over a medium heat for 3 minutes on each side, pressing down.
3. Scatter the rest of the cheese on top in the pan and cover for 1 minute to melt.
4. Fry the eggs and sit one on each sandwich.

#### `lighter-eggs-benedict` · Lighter eggs Benedict · 🍳 · American
vibes: highProtein, comfort · appliances: stovetop · prep 10 / cook 8 min · serves 2 · leftovers: no

- eggs 4 piece
- sourdough 2 slice
- ham 2 slice
- greek-yogurt 80 g
- dijon-mustard 1 tsp
- lemon 0.5 piece
- paprika 1 pinch

1. Whisk the yogurt, mustard and lemon juice and warm gently in a small pan (don't boil) for a quick hollandaise.
2. Poach the eggs in barely simmering water for 3 minutes.
3. Toast the bread.
4. Layer the toast with ham and eggs and spoon over the sauce with a pinch of paprika.

#### `chilaquiles` · Chilaquiles with fried eggs · 🌮 · Mexican
vibes: comfort, family · appliances: oven, stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- corn-tortillas 6 piece (cut into triangles)
- olive-oil 1 tbsp
- salsa 250 g
- chili-powder 0.5 tsp
- eggs 2 piece
- feta 40 g (crumbled)
- red-onion 0.25 piece (finely sliced)

1. Toss the tortilla triangles with the oil and bake at 200°C (400°F) for 8 minutes until crisp.
2. Warm the salsa with the chili powder in a frying pan.
3. Toss the chips in the salsa until just coated, and fry the eggs in another pan.
4. Top with the eggs, feta and onion and eat straight away.

#### `sausage-potato-breakfast-hash` · Sausage & potato breakfast hash · 🥔 · British
vibes: comfort, onePan · appliances: stovetop · prep 5 / cook 20 min · serves 2 · leftovers: no

- sausages 2 piece (sliced)
- potato 2 piece (diced)
- olive-oil 1 tbsp
- onion 0.5 piece (diced)
- bell-pepper 0.5 piece (diced)
- paprika 1 tsp
- eggs 2 piece
- spring-onion 1 piece (sliced)

1. Fry the potatoes in the oil for 10 minutes until golden.
2. Add the sausage, onion, pepper and paprika and cook for 8 minutes.
3. Make 2 wells, crack in the eggs, cover and cook for 4 minutes.
4. Scatter with spring onion.

#### `full-english-traybake` · Full English-style traybake · 🍳 · British
vibes: comfort, family · appliances: oven · prep 5 / cook 25 min · serves 4 · leftovers: no

- sausages 4 piece
- tomato 2 piece (halved)
- olive-oil 1 tbsp
- eggs 4 piece
- cannellini-beans 240 g (drained)
- passata 150 g
- wholemeal-bread 4 slice

1. Heat the oven to 200°C (400°F). Toss the sausages and tomatoes with the oil on a large tray and roast for 15 minutes.
2. Mix the beans with the passata and a pinch of salt and spoon onto one corner of the tray.
3. Make 4 gaps, crack in the eggs and bake for 8–10 minutes until the whites set.
4. Serve with toast.

#### `tamago-sando` · Tamago sando egg sandwich · 🥚 · Japanese
vibes: comfort, quickEasy · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- eggs 4 piece
- mayonnaise 2 tbsp
- dijon-mustard 0.5 tsp
- sugar 0.5 tsp
- milk 1 tbsp
- wholemeal-bread 4 slice
- salt 1 pinch

1. Boil the eggs for 9 minutes, then cool in cold water and peel.
2. Mash the yolks with the mayonnaise, mustard, sugar, milk and salt until creamy, then chop and fold in the whites.
3. Spread thickly between the bread.
4. Press gently, cut off the crusts and slice in half.

#### `snickers-overnight-oats` · Snickers-style overnight oats · 🍫 · Other
vibes: family, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 240 ml
- greek-yogurt 100 g
- peanut-butter 2 tbsp
- dark-chocolate 20 g (melted)
- peanuts 20 g (chopped)

1. Stir the oats, milk, yogurt and half the peanut butter together.
2. Split between two jars and chill overnight.
3. Spread the rest of the peanut butter over the top.
4. Drizzle with melted chocolate and scatter with peanuts.

#### `banana-chocolate-crepes` · Banana chocolate crepes · 🥞 · Other
vibes: family, comfort · appliances: stovetop, blender · prep 5 / cook 12 min · serves 2 · leftovers: no

- flour 60 g
- eggs 1 piece
- milk 150 ml
- butter 1 tsp
- banana 2 piece (sliced)
- dark-chocolate 20 g (melted)

1. Blend the flour, egg and milk into a thin batter and rest for 5 minutes.
2. Wipe a non-stick pan with butter and swirl in a thin layer of batter.
3. Cook for 1 minute, flip for 30 seconds and repeat to make 4–6 crepes.
4. Fill with banana, fold and drizzle with chocolate.

#### `make-ahead-french-toast-bake` · Make-ahead berry French toast bake · 🍞 · American
vibes: family, batchFriendly · appliances: oven · prep 10 / cook 35 min · serves 4 · leftovers: yes

- wholemeal-bread 8 slice (cubed)
- eggs 4 piece
- milk 300 ml
- maple-syrup 3 tbsp
- cinnamon 1 tsp
- berries-frozen 200 g
- butter 1 tbsp

1. Butter a baking dish and add the bread and berries.
2. Whisk the eggs, milk, 2 tbsp maple syrup and cinnamon and pour over. Chill overnight.
3. Bake at 180°C (350°F) for 35 minutes until puffed and golden.
4. Drizzle with the rest of the maple syrup.

#### `maple-nut-granola` · Honey walnut granola with yogurt · 🥣 · Other
vibes: batchFriendly, family · appliances: oven · prep 5 / cook 25 min · serves 4 · leftovers: no

- rolled-oats 200 g
- walnuts 50 g (chopped)
- honey 4 tbsp
- vegetable-oil 2 tbsp
- cinnamon 1 tsp
- greek-yogurt 400 g
- berries-frozen 150 g (thawed)

1. Heat the oven to 160°C (325°F).
2. Mix the oats, walnuts, cinnamon, honey and oil and spread on a lined tray.
3. Bake for 25 minutes, stirring once, then leave to cool — it crisps as it cools.
4. Serve over yogurt with berries. Keep the rest in a jar for 2 weeks.

#### `spinach-feta-savory-muffins` · Spinach & feta savory muffins · 🧁 · Mediterranean
vibes: batchFriendly, family · appliances: oven · prep 10 / cook 22 min · serves 4 · leftovers: yes

- flour 200 g
- baking-powder 2 tsp
- eggs 2 piece
- milk 150 ml
- greek-yogurt 100 g
- olive-oil 3 tbsp
- spinach 100 g (chopped)
- feta 100 g (crumbled)
- salt 1 pinch

1. Heat the oven to 190°C (375°F) and line an 8-hole muffin tin.
2. Whisk the eggs, milk, yogurt and oil, then fold in the flour, baking powder and salt.
3. Fold in the spinach and feta and divide between the cases.
4. Bake for 20–22 minutes until risen and golden. Keep for 3 days.

#### `yogurt-dough-egg-flatbread` · Two-ingredient dough flatbread with eggs · 🫓 · Middle Eastern
vibes: highProtein, family · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- flour 120 g
- greek-yogurt 120 g
- baking-powder 1 tsp
- eggs 3 piece (beaten)
- butter 1 tsp
- spinach 30 g
- feta 40 g (crumbled)
- chili-flakes 1 pinch

1. Mix the flour, yogurt and baking powder into a soft dough, then roll into 2 thin rounds.
2. Cook each in a dry pan for 2 minutes on each side until puffed and charred.
3. Scramble the eggs in the butter with the spinach.
4. Pile onto the flatbreads with feta and chili.

#### `two-ingredient-bagels` · Two-ingredient dough bagels · 🥯 · American
vibes: family, batchFriendly · appliances: oven · prep 15 / cook 25 min · serves 4 · leftovers: no

- flour 250 g
- greek-yogurt 250 g
- baking-powder 2 tsp
- eggs 1 piece (beaten)
- sesame-seeds 1 tbsp
- cream-cheese 100 g
- cucumber 0.5 piece (sliced)
- salt 1 pinch

1. Heat the oven to 190°C (375°F). Mix the flour, yogurt, baking powder and salt into a dough and split into 4.
2. Roll each into a rope, join into a ring, brush with egg and sprinkle with sesame.
3. Bake for 25 minutes until golden. Make a batch at the weekend — they keep for 2 days.
4. Serve split with cream cheese and cucumber.

#### `healthy-banana-bread` · Healthy banana bread · 🍌 · Other
vibes: batchFriendly, family · appliances: oven · prep 10 / cook 50 min · serves 4 · leftovers: yes

- banana 3 piece (mashed)
- eggs 2 piece
- greek-yogurt 100 g
- maple-syrup 3 tbsp
- vegetable-oil 2 tbsp
- flour 150 g
- rolled-oats 50 g
- baking-powder 2 tsp
- cinnamon 1 tsp

1. Heat the oven to 180°C (350°F) and line a loaf tin.
2. Whisk the bananas, eggs, yogurt, maple syrup and oil, then fold in the flour, oats, baking powder and cinnamon.
3. Bake for 45–50 minutes until a skewer comes out clean.
4. Cool before slicing. It keeps for 4 days wrapped up.

#### `apple-oat-breakfast-bars` · Apple oat breakfast bars · 🍏 · Other
vibes: batchFriendly, family · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: yes

- rolled-oats 200 g
- apple 2 piece (grated)
- banana 1 piece (mashed)
- eggs 1 piece
- maple-syrup 3 tbsp
- cinnamon 1 tsp
- raisins 40 g
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F) and line a square tin.
2. Mix everything together.
3. Press into the tin.
4. Bake for 25 minutes until golden, then cool and cut into 8 bars.

#### `mango-coconut-rice-pudding` · Mango coconut breakfast rice pudding · 🥭 · Thai
vibes: comfort, family · appliances: stovetop · prep 5 / cook 25 min · serves 2 · leftovers: no

- long-grain-rice 80 g
- coconut-milk 200 ml
- milk 300 ml
- maple-syrup 1 tbsp
- cinnamon 0.5 tsp
- mango 1 piece (diced)
- lime 0.5 piece

1. Simmer the rice with the coconut milk, milk, maple syrup and cinnamon for 25 minutes, stirring often, until creamy.
2. Toss the mango with the lime juice.
3. Spoon the rice pudding into bowls.
4. Top with the mango.

#### `pb-banana-breakfast-quesadilla` · Peanut butter banana breakfast quesadilla · 🍌 · Other
vibes: quickEasy, family · appliances: stovetop · prep 3 / cook 5 min · serves 2 · leftovers: no

- tortillas 2 piece
- peanut-butter 2 tbsp
- banana 1 piece (sliced)
- cinnamon 1 pinch
- honey 1 tsp
- greek-yogurt 100 g

1. Spread the tortillas with peanut butter.
2. Lay the banana over half of each, sprinkle with cinnamon and fold.
3. Toast in a dry pan for 2 minutes on each side.
4. Cut into wedges and serve with yogurt and honey.

#### `savory-cheese-tomato-french-toast` · Savory cheese & tomato French toast · 🍞 · Other
vibes: comfort, highProtein · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- sourdough 2 slice
- eggs 3 piece
- milk 50 ml
- parmesan 20 g (grated)
- butter 1 tsp
- cherry-tomatoes 120 g (halved)
- black-pepper 1 pinch

1. Whisk the eggs, milk, parmesan and pepper.
2. Soak the bread in the mixture for 1 minute on each side.
3. Fry in the butter for 3 minutes on each side until golden.
4. Blister the tomatoes in the same pan and pile on top.

#### `fluffy-cottage-cheese-eggs` · Fluffy cottage cheese scrambled eggs · 🍳 · Other
vibes: highProtein, quickEasy · appliances: stovetop · prep 2 / cook 5 min · serves 2 · leftovers: no

- eggs 4 piece
- cottage-cheese 100 g
- butter 1 tsp
- spring-onion 1 piece (sliced)
- wholemeal-bread 2 slice
- black-pepper 1 pinch

1. Whisk the eggs with the cottage cheese and pepper.
2. Melt the butter in a non-stick pan over a low heat.
3. Stir the eggs slowly until softly set and fluffy.
4. Serve on toast with spring onion.

#### `breakfast-nachos` · Breakfast nachos · 🧀 · Mexican
vibes: family, comfort · appliances: oven, stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- corn-tortillas 8 piece (cut into triangles)
- olive-oil 1 tbsp
- eggs 4 piece (beaten)
- black-beans 240 g (drained)
- cheddar 80 g (grated)
- salsa 150 g
- spring-onion 2 piece (sliced)

1. Toss the tortilla triangles with the oil and bake at 200°C (400°F) for 8 minutes until crisp.
2. Softly scramble the eggs.
3. Spoon the eggs and beans over the chips, scatter with cheddar and bake for 4 minutes.
4. Top with salsa and spring onions.

### Snacks (15)

#### `cottage-cheese-crisps` · Baked cottage cheese crisps · 🧀 · Other
vibes: highProtein, quickEasy · appliances: oven · prep 3 / cook 25 min · serves 2 · leftovers: no

- cottage-cheese 200 g
- italian-herbs 0.5 tsp
- chili-flakes 1 pinch

1. Heat the oven to 200°C (400°F) and line a tray with baking paper.
2. Spread teaspoons of cottage cheese thinly on the tray and sprinkle with herbs and chili.
3. Bake for 20–25 minutes until golden and crisp, then cool on the tray.

#### `no-bake-peanut-oat-bars` · No-bake peanut oat bars · 🥜 · Other
vibes: batchFriendly, family · appliances: microwave · prep 10 / cook 1 min · serves 4 · leftovers: no

- rolled-oats 150 g
- peanut-butter 5 tbsp
- honey 3 tbsp
- dark-chocolate 40 g (melted)
- peanuts 20 g (chopped)

1. Warm the peanut butter and honey in the microwave for 30 seconds and stir into the oats.
2. Press into a small lined tin and drizzle with the chocolate and peanuts.
3. Chill for 1 hour, then cut into 8 bars.

#### `tzatziki-pita-chips` · Tzatziki with baked pita chips · 🥒 · Mediterranean
vibes: healthyish, quickEasy · appliances: oven · prep 10 / cook 8 min · serves 4 · leftovers: no

- greek-yogurt 250 g
- cucumber 1 piece (grated and squeezed)
- garlic 1 clove (crushed)
- mint 10 g (chopped)
- lemon 0.5 piece
- olive-oil 1 tbsp
- pita-bread 2 piece (cut into triangles)

1. Heat the oven to 200°C (400°F) and bake the pita triangles with half the oil for 8 minutes.
2. Mix the yogurt, cucumber, garlic, mint and lemon juice.
3. Drizzle with the rest of the oil and serve with the chips.

#### `healthier-pb-cups` · Healthier peanut butter cups · 🍫 · Other
vibes: family, batchFriendly · appliances: microwave · prep 10 / cook 1 min · serves 4 · leftovers: no

- dark-chocolate 100 g
- peanut-butter 3 tbsp
- honey 1 tsp
- greek-yogurt 2 tbsp

1. Melt the chocolate in the microwave and spoon a little into 8 mini cupcake cases.
2. Mix the peanut butter, honey and yogurt, add a spoonful to each and top with the rest of the chocolate.
3. Chill for 30 minutes until set.

#### `tomato-bruschetta` · Tomato bruschetta · 🍅 · Italian
vibes: quickEasy, family · appliances: oven · prep 10 / cook 5 min · serves 4 · leftovers: no

- baguette 1 piece (sliced)
- tomato 4 piece (diced)
- garlic 1 clove (halved)
- basil 10 g (chopped)
- olive-oil 2 tbsp
- balsamic-vinegar 1 tsp
- salt 1 pinch

1. Toast the baguette slices in a hot oven at 200°C (400°F) for 5 minutes, then rub with the cut garlic.
2. Mix the tomatoes, basil, oil, balsamic and salt.
3. Spoon onto the toasts just before eating.

#### `ham-cheese-pinwheels` · Ham & cheese pinwheels · 🌀 · British
vibes: family, quickEasy · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- tortillas 2 piece
- cream-cheese 80 g
- ham 4 slice
- spinach 30 g
- cheddar 40 g (grated)

1. Spread the tortillas with cream cheese.
2. Cover with ham, spinach and cheddar and roll up tightly.
3. Chill for 10 minutes, then slice into 1 cm pinwheels.

#### `sweet-chili-halloumi-bites` · Air-fryer sweet chili halloumi bites · 🧀 · Mediterranean
vibes: quickEasy, fakeaway · appliances: airFryer · prep 5 / cook 8 min · serves 4 · leftovers: no

- halloumi 250 g (cubed)
- cornstarch 1 tbsp
- sweet-chili-sauce 3 tbsp
- lime 0.5 piece
- sesame-seeds 1 tsp
- spring-onion 1 piece (sliced)

1. Toss the halloumi in the cornstarch.
2. Air-fry at 200°C (400°F) for 8 minutes until golden.
3. Toss with the sweet chili sauce and lime juice and finish with sesame and spring onion.

#### `microwave-potato-crisps` · Microwave potato crisps · 🥔 · British
vibes: quickEasy, family · appliances: microwave · prep 5 / cook 8 min · serves 2 · leftovers: no

- potato 1 piece (sliced paper-thin)
- olive-oil 1 tsp
- salt 1 pinch
- paprika 1 pinch

1. Pat the potato slices dry and toss with the oil.
2. Lay in a single layer on baking paper and microwave for 3–4 minutes until crisp, turning once. Repeat in batches.
3. Sprinkle with salt and paprika.

#### `cinnamon-sugar-tortilla-chips` · Air-fryer cinnamon sugar tortilla chips · 🌮 · Mexican
vibes: family, quickEasy · appliances: airFryer · prep 5 / cook 5 min · serves 2 · leftovers: no

- tortillas 2 piece (cut into triangles)
- butter 1 tbsp (melted)
- cinnamon 1 tsp
- sugar 1 tbsp
- greek-yogurt 80 g
- berries-frozen 60 g (thawed)

1. Brush the tortilla triangles with the butter and toss in the cinnamon and sugar.
2. Air-fry at 180°C (350°F) for 4–5 minutes until crisp.
3. Serve with yogurt mashed with the berries for dipping.

#### `greek-yogurt-fruit-dip` · Honey yogurt fruit dip platter · 🍎 · Other
vibes: healthyish, family · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- greek-yogurt 250 g
- honey 2 tbsp
- cinnamon 0.5 tsp
- peanut-butter 1 tbsp
- apple 2 piece (sliced)
- grapes 200 g
- banana 1 piece (sliced)

1. Whisk the yogurt, honey, cinnamon and peanut butter.
2. Arrange the fruit around the dip.
3. Dip and eat straight away.

#### `crispy-broccoli-parmesan-bites` · Air-fryer crispy broccoli parmesan bites · 🥦 · Italian
vibes: healthyish, family · appliances: airFryer · prep 5 / cook 10 min · serves 2 · leftovers: no

- broccoli 0.5 piece (cut into small florets)
- olive-oil 1 tbsp
- parmesan 20 g (grated)
- garlic-powder 0.5 tsp
- lemon 0.5 piece

1. Toss the broccoli with the oil, garlic powder and half the parmesan.
2. Air-fry at 190°C (375°F) for 8–10 minutes until crisp at the edges.
3. Toss with the rest of the parmesan and a squeeze of lemon.

#### `maple-paprika-mixed-nuts` · Maple paprika mixed nuts · 🌰 · Other
vibes: batchFriendly · appliances: oven · prep 2 / cook 12 min · serves 4 · leftovers: no

- cashews 60 g
- walnuts 60 g
- peanuts 40 g
- maple-syrup 1 tbsp
- paprika 1 tsp
- salt 1 pinch

1. Heat the oven to 170°C (340°F).
2. Toss the nuts with the maple syrup, paprika and salt and spread on a lined tray.
3. Roast for 12 minutes, stirring once, then cool to crisp up.

#### `chocolate-rice-cake-bites` · Chocolate peanut rice cake bites · 🍘 · Other
vibes: family, quickEasy · appliances: microwave · prep 5 / cook 1 min · serves 2 · leftovers: no

- rice-cakes 3 piece (broken into pieces)
- dark-chocolate 40 g
- peanut-butter 1 tbsp

1. Melt the chocolate with the peanut butter in the microwave.
2. Dip the rice cake pieces and lay on a lined tray.
3. Chill for 15 minutes until set.

#### `avocado-edamame-rice-cakes` · Smashed avocado & edamame rice cakes · 🥑 · Japanese
vibes: healthyish, quickEasy · appliances: stovetop · prep 5 / cook 4 min · serves 2 · leftovers: no

- edamame-frozen 60 g
- avocado 1 piece
- lime 0.5 piece
- soy-sauce 1 tsp
- rice-cakes 3 piece
- sesame-seeds 1 tsp
- chili-flakes 1 pinch

1. Boil the edamame for 3 minutes, then drain and cool.
2. Smash with the avocado, lime juice and soy sauce.
3. Spread over the rice cakes and finish with sesame and chili.

#### `air-fryer-banana-chips` · Air-fryer cinnamon banana chips · 🍌 · Other
vibes: healthyish, family · appliances: airFryer · prep 5 / cook 15 min · serves 2 · leftovers: no

- banana 2 piece (thinly sliced)
- lemon 0.5 piece
- cinnamon 0.5 tsp

1. Toss the banana slices in the lemon juice and cinnamon.
2. Air-fry in a single layer at 150°C (300°F) for 12–15 minutes, flipping halfway.
3. Cool for 5 minutes to crisp up.
