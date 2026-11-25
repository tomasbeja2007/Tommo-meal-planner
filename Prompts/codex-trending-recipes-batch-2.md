# Codex prompt: trending recipes, batch 2 (102 recipes)

Paste everything below the line into Codex. It is self-contained: the recipes are written out in full.

---

Read `CLAUDE.md` and `BUILD_NOTES.md` (section 3d) first, and follow the project's rules.

## Task

Add the 102 recipes below (47 dinners, 20 lunches, 20 breakfasts, 15 snacks) to the bundled
library as trending recipes, the same way as `Tools/trending_recipes.py`. Add batches 1 to 1 first (in this order) if they aren't in yet.

1. Create `Tools/trending_batch2.py`. Write each recipe with `T(...)` from `trending_recipes.py` (it adds the `trending` tag),
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

### Dinners (47)

#### `smash-burger-tacos` · Smash burger tacos · 🌮 · American
vibes: fakeaway, family, quickEasy · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- ground-beef 500 g
- tortillas 8 piece
- cheddar 100 g (grated)
- onion 0.5 piece (very finely chopped)
- lettuce 0.25 piece (shredded)
- tomato 1 piece (diced)
- mayonnaise 3 tbsp
- ketchup 1 tbsp
- dijon-mustard 1 tsp
- cucumber 0.25 piece (finely diced)
- salt 1 tsp

1. Mix the mayonnaise, ketchup, mustard and cucumber into a burger sauce.
2. Split the beef into 8 balls and season with salt.
3. Press a ball of beef thinly over one side of each tortilla, right to the edges, and scatter with a little onion.
4. Heat a large frying pan over a medium-high heat and cook 2 tacos at a time, beef-side down, for 3 minutes until crisp.
5. Flip, scatter with cheddar and cook for 1 minute until the tortilla is golden.
6. Fold and fill with lettuce, tomato and a drizzle of burger sauce.

#### `crispy-rice-paper-dumplings` · Crispy rice paper dumplings · 🥟 · Chinese
vibes: fakeaway, quickEasy · appliances: stovetop · prep 20 / cook 12 min · serves 4 · leftovers: no

- ground-pork 400 g
- cabbage 150 g (very finely shredded)
- spring-onion 3 piece (finely sliced)
- garlic 2 clove (crushed)
- ginger 10 g (grated)
- soy-sauce 3 tbsp
- sesame-oil 1 tsp
- rice-paper 16 piece
- vegetable-oil 2 tbsp
- rice-vinegar 2 tbsp
- chili-flakes 0.5 tsp
- microwave-rice 2 piece

1. Mix the pork, cabbage, spring onion, garlic, ginger, 1 tbsp soy sauce and the sesame oil.
2. Dip 2 rice paper sheets together in warm water for 5 seconds and lay them flat.
3. Put a spoonful of filling in the middle and fold into a tight square parcel. Repeat to make 8.
4. Heat the oil in a non-stick pan over a medium heat and fry the dumplings for 5 minutes on each side until crisp and cooked through.
5. Mix the rest of the soy sauce with the vinegar and chili flakes for dipping.
6. Heat the rice and serve with the dumplings and dipping sauce.

#### `greek-sheet-pan-nachos` · Greek-style sheet-pan nachos · 🫓 · Mediterranean
vibes: family, fakeaway · appliances: oven, stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- pita-bread 4 piece (cut into triangles)
- olive-oil 2 tbsp
- chicken-breast 2 piece (diced)
- dried-oregano 2 tsp
- lemon 1 piece
- greek-yogurt 150 g
- cucumber 1 piece
- garlic 1 clove (crushed)
- cherry-tomatoes 200 g (quartered)
- red-onion 0.5 piece (finely diced)
- feta 100 g (crumbled)
- olives 50 g (sliced)
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Toss the pita triangles with 1 tbsp oil and bake on a large tray for 8 minutes until crisp.
3. Toss the chicken with the oregano, juice of half the lemon and salt, then fry in the rest of the oil for 8 minutes.
4. Grate half the cucumber into the yogurt with the garlic and the rest of the lemon juice. Dice the other half.
5. Pile the chicken over the pita chips, scatter with feta and bake for 4 minutes.
6. Top with tomatoes, diced cucumber, onion and olives, and drizzle with the tzatziki.

#### `slow-cooker-shredded-beef-tacos` · Slow-cooker shredded beef tacos · 🌮 · Mexican
vibes: batchFriendly, family · appliances: slowCooker, stovetop · prep 15 / cook 420 min · serves 4 · leftovers: yes

- stewing-beef 700 g
- onion 1 piece (sliced)
- garlic 4 clove (crushed)
- chili-powder 2 tsp
- cumin 2 tsp
- dried-oregano 1 tsp
- chopped-tomatoes 400 g
- vegetable-bouillon 1 tsp
- lime 2 piece
- corn-tortillas 12 piece
- red-onion 0.5 piece (finely diced)
- cilantro 20 g (chopped)
- salt 1 tsp

1. Rub the beef with the spices and salt.
2. Put the onion and garlic in the slow cooker with the beef, tomatoes, bouillon and 150 ml water.
3. Cook on low for 7 hours until the beef falls apart — chuck is the cut that does this.
4. Shred the beef in the sauce and squeeze in the juice of 1 lime.
5. Dip each tortilla in the cooking juices and fry in a hot pan for 1 minute on each side.
6. Fill with beef and top with red onion, cilantro and lime, with a cup of the juices for dipping.

#### `hot-honey-halloumi-tacos` · Hot honey halloumi tacos · 🌮 · Mexican
vibes: quickEasy, fakeaway · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- halloumi 250 g (cut into sticks)
- honey 2 tbsp
- hot-sauce 2 tsp
- chili-flakes 0.5 tsp
- red-cabbage 150 g (shredded)
- lime 2 piece
- avocado 1 piece
- sweetcorn-tin 165 g (drained)
- greek-yogurt 100 g
- corn-tortillas 12 piece
- cilantro 15 g

1. Toss the cabbage with the juice of 1 lime.
2. Mash the avocado with the juice of the other lime and a pinch of salt.
3. Fry the halloumi in a dry pan for 2 minutes on each side until golden.
4. Warm the honey with the hot sauce and chili flakes and toss with the halloumi.
5. Char the sweetcorn in the same pan for 3 minutes, and warm the tortillas.
6. Spread the tortillas with avocado and fill with halloumi, corn, slaw, yogurt and cilantro.

#### `sheet-pan-chicken-quesadilla` · Sheet-pan chicken quesadilla · 🫓 · Mexican
vibes: family, fakeaway, onePan · appliances: oven, stovetop · prep 15 / cook 25 min · serves 4 · leftovers: no

- tortillas 6 piece
- chicken-breast 2 piece (diced)
- olive-oil 1 tbsp
- paprika 2 tsp
- cumin 1 tsp
- black-beans 240 g (drained)
- bell-pepper 1 piece (diced)
- cheddar 150 g (grated)
- salsa 150 g
- sour-cream 100 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Fry the chicken with the oil, spices and salt for 8 minutes, then stir in the beans and pepper.
3. Lay 5 tortillas over a lined tray so they overlap the edges and cover the base.
4. Spread over the chicken mixture and two-thirds of the cheese, then put the last tortilla in the middle.
5. Fold the edges in, scatter the rest of the cheese on top, put another tray on top and bake for 15 minutes.
6. Remove the top tray and bake for 5 minutes more until crisp, then cut into squares and serve with salsa and sour cream.

#### `french-onion-pasta` · French onion pasta · 🧅 · Other
vibes: comfort, family · appliances: stovetop · prep 10 / cook 35 min · serves 4 · leftovers: no

- onion 4 piece (thinly sliced)
- butter 3 tbsp
- dried-thyme 1 tsp
- garlic 2 clove (crushed)
- worcestershire 1 tbsp
- vegetable-stock 900 ml
- penne 350 g
- mozzarella 1 piece (torn)
- parmesan 30 g (grated)
- salt 1 tsp

1. Melt the butter in a large pan and cook the onions with the thyme and salt over a medium-low heat for 25 minutes until deep golden.
2. Add the garlic and Worcestershire and cook for 1 minute.
3. Pour in the stock and bring to the boil.
4. Add the pasta and simmer for 11 minutes, stirring often, until it's tender and the liquid is saucy.
5. Stir in the parmesan.
6. Top with the mozzarella, cover for 2 minutes to melt and serve.

#### `baked-herby-cream-cheese-pasta` · Baked garlic & herb cream cheese pasta · 🍝 · Italian
vibes: quickEasy, family, onePan · appliances: oven, stovetop · prep 5 / cook 30 min · serves 4 · leftovers: no

- cream-cheese 150 g
- cherry-tomatoes 500 g
- garlic 4 clove (peeled)
- italian-herbs 2 tsp
- olive-oil 2 tbsp
- chili-flakes 0.5 tsp
- spaghetti 350 g
- spinach 100 g
- basil 15 g
- black-pepper 1 pinch

1. Heat the oven to 200°C (400°F).
2. Put the tomatoes and garlic in a baking dish with the oil and chili, and sit the cream cheese in the middle.
3. Sprinkle the herbs over the cream cheese and bake for 25 minutes until the tomatoes burst.
4. Meanwhile, cook the spaghetti, saving a mug of water before draining.
5. Mash everything in the dish into a creamy sauce and stir in the spinach.
6. Toss in the spaghetti with a splash of pasta water and finish with basil and pepper.

#### `mongolian-style-beef` · Mongolian-style beef with rice · 🥩 · Chinese
vibes: fakeaway, highProtein · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- beef-steak 3 piece (thinly sliced)
- cornstarch 2 tbsp
- vegetable-oil 2 tbsp
- garlic 4 clove (crushed)
- ginger 15 g (grated)
- soy-sauce 4 tbsp
- sugar 2 tbsp
- spring-onion 4 piece (cut into lengths)
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)

1. Cook the rice in salted boiling water for 12 minutes, adding the broccoli for the last 4, then drain.
2. Toss the beef in the cornstarch.
3. Fry the beef in the oil in batches over a high heat for 2 minutes until crisp, then set aside.
4. Add the garlic and ginger to the pan for 30 seconds.
5. Stir in the soy sauce, sugar and 4 tbsp water and bubble for 2 minutes until syrupy.
6. Toss the beef and spring onions in the sauce and serve over the rice and broccoli.

#### `general-tso-style-tofu` · General Tso-style crispy tofu · 🌶️ · Chinese
vibes: fakeaway, healthyish · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- tofu 800 g (pressed and cubed)
- cornstarch 3 tbsp
- vegetable-oil 2 tbsp
- garlic 3 clove (crushed)
- ginger 10 g (grated)
- hoisin-sauce 2 tbsp
- soy-sauce 2 tbsp
- rice-vinegar 2 tbsp
- sugar 1 tbsp
- chili-flakes 1 tsp
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)
- sesame-seeds 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, adding the broccoli for the last 4, then drain.
2. Toss the tofu in 2 tbsp cornstarch.
3. Fry in the oil for 10 minutes, turning, until crisp all over, then set aside.
4. Whisk the hoisin, soy sauce, vinegar, sugar, chili flakes, the rest of the cornstarch and 100 ml water.
5. Fry the garlic and ginger for 30 seconds, then pour in the sauce and bubble until thick.
6. Toss in the tofu and serve over rice and broccoli with sesame seeds.

#### `kung-pao-chicken` · Kung pao chicken · 🥜 · Chinese
vibes: fakeaway, quickEasy, highProtein · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- chicken-thighs 500 g (diced)
- cornstarch 1 tbsp
- soy-sauce 3 tbsp
- vegetable-oil 1 tbsp
- chili-flakes 1 tsp
- garlic 3 clove (sliced)
- ginger 10 g (grated)
- bell-pepper 2 piece (diced)
- rice-vinegar 1 tbsp
- honey 1 tbsp
- peanuts 50 g
- spring-onion 3 piece (sliced)
- long-grain-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the chicken with the cornstarch and 1 tbsp soy sauce.
3. Stir-fry the chicken in the oil over a high heat for 6 minutes until cooked.
4. Add the chili, garlic, ginger and peppers and cook for 3 minutes.
5. Stir in the rest of the soy sauce, the vinegar and honey.
6. Toss through the peanuts and spring onions and serve over rice.

#### `chicken-chow-mein` · Chicken chow mein · 🍜 · Chinese
vibes: fakeaway, quickEasy, family · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- egg-noodles 250 g
- chicken-breast 2 piece (thinly sliced)
- vegetable-oil 2 tbsp
- garlic 2 clove (crushed)
- cabbage 200 g (shredded)
- carrot 2 piece (cut into matchsticks)
- bean-sprouts 150 g
- soy-sauce 4 tbsp
- hoisin-sauce 1 tbsp
- sesame-oil 1 tsp
- spring-onion 3 piece (sliced)

1. Cook the noodles for 4 minutes, then drain and toss with the sesame oil.
2. Heat the oil in a wok over a high heat and stir-fry the chicken for 5 minutes.
3. Add the garlic, cabbage and carrot and stir-fry for 3 minutes.
4. Add the noodles, soy sauce and hoisin and toss for 2 minutes.
5. Add the bean sprouts and toss for 30 seconds so they stay crunchy.
6. Serve topped with spring onions.

#### `pad-thai-style-noodles` · Pad Thai-style shrimp noodles · 🍤 · Thai
vibes: fakeaway, quickEasy · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- rice-noodles 150 g
- shrimp 120 g
- eggs 2 piece (beaten)
- vegetable-oil 1 tbsp
- garlic 2 clove (crushed)
- fish-sauce 2 tbsp
- sugar 1 tbsp
- lime 1 piece
- ketchup 1 tbsp
- bean-sprouts 100 g
- spring-onion 3 piece (cut into lengths)
- peanuts 30 g (chopped)
- chili-flakes 1 pinch

1. Soak the noodles in just-boiled water for 6 minutes, then drain.
2. Mix the fish sauce, sugar, ketchup and the juice of half the lime.
3. Stir-fry the shrimp and garlic in the oil for 2 minutes, then push to one side and scramble the eggs.
4. Add the noodles and sauce and toss for 2 minutes until coated.
5. Toss in the bean sprouts and spring onions.
6. Serve with peanuts, chili flakes and lime wedges.

#### `slow-cooker-massaman-beef` · Slow-cooker massaman-style beef curry · 🍛 · Thai
vibes: comfort, batchFriendly · appliances: slowCooker, stovetop · prep 15 / cook 360 min · serves 4 · leftovers: yes

- stewing-beef 600 g (cut into chunks)
- thai-curry-paste 3 tbsp
- cinnamon 0.5 tsp
- coconut-milk 400 ml
- potato 3 piece (cut into chunks)
- onion 1 piece (cut into wedges)
- peanut-butter 2 tbsp
- fish-sauce 1 tbsp
- lime 1 piece
- basmati-rice 250 g
- peanuts 30 g

1. Whisk the curry paste, cinnamon, peanut butter and coconut milk in the slow cooker.
2. Add the beef, potatoes and onion and stir to coat.
3. Cook on low for 6 hours until the beef is tender.
4. Cook the rice in salted boiling water for 12 minutes, then drain.
5. Season the curry with the fish sauce and lime juice.
6. Serve over the rice, scattered with peanuts.

#### `goan-style-fish-curry` · Goan-style coconut fish curry · 🐟 · Indian
vibes: healthyish, quickEasy · appliances: stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- vegetable-oil 1 tbsp
- onion 1 piece (sliced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- turmeric 1 tsp
- curry-powder 1 tbsp
- chili-powder 0.5 tsp
- chopped-tomatoes 400 g
- coconut-milk 400 ml
- white-fish 3 piece (cut into chunks)
- lime 1 piece
- basmati-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Cook the onion in the oil for 6 minutes until soft.
3. Add the garlic, ginger and spices and cook for 1 minute.
4. Pour in the tomatoes and coconut milk and simmer for 8 minutes.
5. Lower in the fish and simmer gently for 5 minutes until it flakes.
6. Squeeze in the lime and serve over rice.

#### `mild-chicken-korma` · Mild chicken korma · 🍛 · Indian
vibes: family, comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- chicken-thighs 600 g (diced)
- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- garam-masala 2 tsp
- turmeric 1 tsp
- cashews 50 g
- coconut-milk 400 ml
- greek-yogurt 100 g
- basmati-rice 250 g
- cilantro 10 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Cook the onion in the oil for 6 minutes.
3. Add the garlic, ginger and spices for 1 minute, then the chicken for 5 minutes.
4. Blend the cashews with the coconut milk until smooth and pour it in.
5. Simmer for 12 minutes until the chicken is tender.
6. Stir in the yogurt off the heat and serve with the rice and cilantro.

#### `lamb-keema-peas` · Lamb keema with peas · 🍛 · Indian
vibes: comfort, quickEasy, batchFriendly · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: yes

- lamb-mince 500 g
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- garam-masala 2 tsp
- cumin 1 tsp
- turmeric 1 tsp
- chopped-tomatoes 400 g
- peas-frozen 200 g
- naan 4 piece
- greek-yogurt 100 g
- cilantro 10 g
- salt 1 tsp

1. Brown the lamb in a dry pan for 6 minutes, then pour off most of the fat.
2. Add the onion and cook for 5 minutes.
3. Stir in the garlic, ginger and spices for 1 minute.
4. Add the tomatoes and salt and simmer for 12 minutes.
5. Stir in the peas for 3 minutes.
6. Serve with warm naan, yogurt and cilantro.

#### `aloo-gobi` · Aloo gobi with naan · 🥔 · Indian
vibes: healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- vegetable-oil 2 tbsp
- cumin 1 tsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- turmeric 1 tsp
- garam-masala 2 tsp
- potato 3 piece (cubed)
- cauliflower 1 piece (cut into florets)
- chopped-tomatoes 400 g
- peas-frozen 100 g
- naan 4 piece
- cilantro 15 g
- salt 1 tsp

1. Fry the cumin in the oil for 30 seconds, then add the onion for 5 minutes.
2. Add the garlic, ginger, turmeric and garam masala for 1 minute.
3. Add the potatoes and cauliflower and toss to coat.
4. Pour in the tomatoes, salt and 100 ml water, cover and cook for 18 minutes until tender.
5. Stir in the peas for 2 minutes.
6. Serve with warm naan and cilantro.

#### `one-pot-chicken-biryani` · One-pot chicken biryani-style rice · 🍚 · Indian
vibes: onePan, family, batchFriendly · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chicken-thighs 500 g (diced)
- greek-yogurt 100 g
- garam-masala 2 tsp
- turmeric 1 tsp
- chili-powder 0.5 tsp
- vegetable-oil 1 tbsp
- onion 2 piece (thinly sliced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- basmati-rice 300 g (rinsed)
- chicken-stock 550 ml
- raisins 30 g
- cashews 30 g
- cilantro 15 g
- salt 1 tsp

1. Mix the chicken with the yogurt, spices and salt.
2. Fry the onions in the oil for 10 minutes until golden, and keep a handful aside.
3. Add the garlic, ginger and chicken and cook for 5 minutes.
4. Stir in the rice, then the stock and raisins, and bring to the boil.
5. Cover tightly and cook on the lowest heat for 15 minutes, then leave to steam for 5 minutes.
6. Fluff with a fork and top with the crispy onions, cashews and cilantro.

#### `japanese-chicken-curry` · Japanese-style chicken curry · 🍛 · Japanese
vibes: comfort, family, batchFriendly · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chicken-thighs 500 g (diced)
- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (chopped)
- potato 2 piece (chopped)
- butter 2 tbsp
- flour 2 tbsp
- curry-powder 2 tbsp
- vegetable-bouillon 2 tsp
- honey 1 tbsp
- soy-sauce 1 tbsp
- long-grain-rice 250 g

1. Cook the chicken, onion, carrot and potato in the oil in a deep pan for 6 minutes.
2. Add 700 ml boiling water and the bouillon and simmer for 15 minutes until the vegetables are tender.
3. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
4. In a small pan, melt the butter, stir in the flour and curry powder and cook for 2 minutes into a paste.
5. Whisk the paste into the curry with the honey and soy sauce and simmer for 5 minutes until thick and glossy.
6. Serve the curry over the rice.

#### `air-fryer-chicken-katsu-bowl` · Air-fryer chicken katsu bowl · 🍱 · Japanese
vibes: fakeaway, family, highProtein · appliances: airFryer, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 3 piece (flattened)
- flour 2 tbsp
- eggs 1 piece (beaten)
- breadcrumbs 80 g
- long-grain-rice 250 g
- curry-powder 1 tbsp
- butter 1 tbsp
- vegetable-bouillon 1 tsp
- honey 1 tsp
- soy-sauce 1 tbsp
- cabbage 200 g (finely shredded)
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Dust the chicken in half the flour, dip in egg, then press into the breadcrumbs.
3. Air-fry at 200°C (400°F) for 14 minutes, turning halfway, until golden and cooked through.
4. Melt the butter, stir in the rest of the flour and the curry powder, then whisk in 300 ml water, the bouillon, honey and soy sauce and simmer until thick.
5. Toss the cabbage with a pinch of salt.
6. Slice the katsu and serve over rice with the curry sauce and cabbage.

#### `okonomiyaki-cabbage-pancakes` · Okonomiyaki-style cabbage pancakes · 🥞 · Japanese
vibes: fakeaway, family · appliances: stovetop · prep 10 / cook 15 min · serves 2 · leftovers: no

- cabbage 300 g (finely shredded)
- flour 100 g
- eggs 3 piece
- vegetable-stock 100 ml
- spring-onion 3 piece (sliced)
- bacon 4 slice
- vegetable-oil 1 tbsp
- mayonnaise 2 tbsp
- hoisin-sauce 1 tbsp
- worcestershire 1 tsp
- nori 1 piece (crumbled)
- sesame-seeds 1 tsp

1. Whisk the flour, eggs and stock into a batter.
2. Fold in the cabbage and most of the spring onion.
3. Heat the oil in a frying pan and pour in half the batter, shaping a thick round pancake.
4. Lay 2 slices of bacon on top and cook for 5 minutes, then flip and cook for 5 minutes until the bacon is crisp. Repeat.
5. Mix the hoisin with the Worcestershire.
6. Brush over the pancakes, zigzag with mayonnaise and finish with nori, sesame and spring onion.

#### `oyakodon` · Oyakodon chicken & egg rice bowl · 🍳 · Japanese
vibes: comfort, quickEasy · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- long-grain-rice 150 g
- chicken-thighs 250 g (sliced)
- onion 1 piece (thinly sliced)
- chicken-stock 150 ml
- soy-sauce 2 tbsp
- honey 1 tbsp
- eggs 3 piece (lightly beaten)
- spring-onion 2 piece (sliced)
- nori 1 piece (cut into strips)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Simmer the stock, soy sauce and honey in a small frying pan.
3. Add the onion and chicken and simmer for 7 minutes until cooked through.
4. Pour the egg over in a slow circle, cover and cook for 1 minute until just set but still soft.
5. Slide over the bowls of rice.
6. Top with spring onion and nori.

#### `bibimbap-bowl` · Beef bibimbap bowl · 🍚 · Korean
vibes: healthyish, highProtein · appliances: stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- long-grain-rice 250 g
- ground-beef 400 g
- soy-sauce 3 tbsp
- garlic 2 clove (crushed)
- sesame-oil 2 tbsp
- spinach 200 g
- carrot 2 piece (cut into matchsticks)
- eggs 4 piece
- gochujang 2 tbsp
- sesame-seeds 2 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Brown the beef with the garlic and 2 tbsp soy sauce for 7 minutes.
3. Quickly fry the carrot, then the spinach, in a little sesame oil, seasoning with the rest of the soy sauce.
4. Fry the eggs in the rest of the sesame oil until the whites are crisp.
5. Arrange the beef and vegetables over the rice and top with an egg.
6. Loosen the gochujang with 1 tbsp water, drizzle over and scatter with sesame. Mix it all up to eat.

#### `korean-fried-cauliflower` · Air-fryer Korean-style fried cauliflower · 🌶️ · Korean
vibes: fakeaway, healthyish · appliances: airFryer, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- cauliflower 1 piece (cut into florets)
- flour 60 g
- cornstarch 2 tbsp
- milk 120 ml
- gochujang 2 tbsp
- honey 2 tbsp
- soy-sauce 1 tbsp
- garlic 2 clove (crushed)
- sesame-seeds 2 tsp
- spring-onion 2 piece (sliced)
- long-grain-rice 250 g

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Whisk the flour, cornstarch and milk into a batter and toss the cauliflower in it.
3. Air-fry at 200°C (400°F) for 18 minutes, shaking halfway, until crisp.
4. Simmer the gochujang, honey, soy sauce and garlic in a pan for 1 minute.
5. Toss the cauliflower in the sticky sauce.
6. Serve over rice with sesame seeds and spring onions.

#### `bulgogi-pork-lettuce-wraps` · Bulgogi-style pork lettuce wraps · 🥬 · Korean
vibes: quickEasy, highProtein · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- ground-pork 500 g
- soy-sauce 3 tbsp
- honey 2 tbsp
- garlic 3 clove (crushed)
- vegetable-oil 1 tbsp
- gochujang 1 tbsp
- lettuce 1 piece (leaves separated)
- cucumber 1 piece (cut into matchsticks)
- kimchi 150 g
- long-grain-rice 200 g
- sesame-seeds 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Mix the soy sauce, honey, garlic and gochujang.
3. Brown the pork in the oil for 7 minutes until crispy.
4. Pour in the sauce and cook for 2 minutes until sticky.
5. Put out the lettuce cups, cucumber and kimchi.
6. Fill each lettuce leaf with rice, pork and toppings and scatter with sesame.

#### `spanish-garlic-shrimp` · Spanish garlic shrimp & white beans · 🍤 · Spanish/Portuguese
vibes: quickEasy, onePan · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- shrimp 200 g
- olive-oil 5 tbsp
- garlic 8 clove (sliced)
- chili-flakes 0.5 tsp
- paprika 1 tsp
- cannellini-beans 480 g (drained)
- lemon 1 piece
- parsley 10 g (chopped)
- baguette 1 piece
- salt 1 pinch

1. Warm the oil in a wide pan over a low heat with the garlic and chili for 3 minutes until the garlic is pale golden.
2. Add the beans and paprika and simmer for 4 minutes, crushing a few so they soak up the garlic oil.
3. Turn up the heat, push the beans aside and add the shrimp with the salt.
4. Cook for 2 minutes on each side until pink.
5. Squeeze over the lemon and scatter with parsley.
6. Serve from the pan with torn bread for mopping up.

#### `piri-piri-chicken-rice` · Portuguese-style piri-piri chicken & rice · 🔥 · Spanish/Portuguese
vibes: family, fakeaway, highProtein · appliances: oven, stovetop · prep 10 / cook 35 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- paprika 2 tsp
- chili-flakes 1 tsp
- garlic 4 clove (crushed)
- lemon 1 piece
- red-wine-vinegar 1 tbsp
- olive-oil 2 tbsp
- dried-oregano 1 tsp
- long-grain-rice 250 g
- turmeric 0.5 tsp
- peas-frozen 150 g
- lettuce 0.5 piece (shredded)
- tomato 2 piece (sliced)
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the paprika, chili, garlic, lemon juice, vinegar, oil, oregano and salt and rub all over the chicken.
3. Roast on a tray for 30–35 minutes until charred and cooked through, basting once.
4. Cook the rice with the turmeric in salted boiling water for 12 minutes, adding the peas for the last 3, then drain.
5. Spoon the tray juices over the rice.
6. Serve the chicken with the rice and a lettuce and tomato salad.

#### `greek-green-bean-potato-stew` · Greek green bean & potato stew with feta · 🫘 · Mediterranean
vibes: onePan, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- olive-oil 3 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- potato 4 piece (cut into chunks)
- green-beans 500 g (halved)
- chopped-tomatoes 400 g
- dried-oregano 1 tsp
- feta 120 g
- baguette 1 piece
- salt 1 tsp

1. Cook the onion in the oil in a deep lidded pan for 5 minutes, then add the garlic.
2. Add the potatoes, beans, tomatoes, oregano, salt and 200 ml water.
3. Cover and simmer for 25 minutes until everything is soft and the sauce is rich.
4. Taste and add more salt and a drizzle of oil.
5. Crumble over the feta.
6. Serve with bread to mop up the sauce.

#### `shrimp-saganaki-orzo` · Shrimp saganaki-style orzo · 🍤 · Mediterranean
vibes: onePan, quickEasy · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- olive-oil 2 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- chili-flakes 0.5 tsp
- dried-oregano 1 tsp
- orzo 300 g
- chopped-tomatoes 400 g
- vegetable-bouillon 1 tsp
- shrimp 300 g
- feta 150 g
- lemon 1 piece

1. Cook the onion in the oil in a deep pan for 5 minutes.
2. Add the garlic, chili and oregano for 1 minute.
3. Stir in the orzo, tomatoes, 600 ml boiling water and the bouillon and simmer for 10 minutes, stirring often.
4. Nestle in the shrimp and crumble over the feta.
5. Cover and cook for 4 minutes until the shrimp are pink and the feta is soft.
6. Serve with lemon wedges.

#### `moussaka-skillet` · Moussaka-style lamb & eggplant skillet · 🍆 · Mediterranean
vibes: comfort, onePan · appliances: stovetop, oven · prep 10 / cook 30 min · serves 4 · leftovers: no

- eggplant 2 piece (cubed)
- olive-oil 3 tbsp
- lamb-mince 500 g
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- cinnamon 1 tsp
- dried-oregano 1 tsp
- chopped-tomatoes 400 g
- greek-yogurt 200 g
- eggs 1 piece
- parmesan 30 g (grated)
- salt 1 tsp

1. Fry the eggplant in the oil in an ovenproof pan for 8 minutes until golden, then set aside.
2. Brown the lamb and onion in the same pan for 8 minutes, then add the garlic, cinnamon and oregano.
3. Stir in the tomatoes, salt and eggplant and simmer for 8 minutes.
4. Whisk the yogurt, egg and half the parmesan and spread over the top.
5. Scatter with the rest of the parmesan.
6. Grill or bake at 220°C (425°F) for 6 minutes until golden and set.

#### `turkey-zucchini-boats` · Turkey stuffed zucchini boats · 🥒 · Italian
vibes: healthyish, highProtein, lowCalorie · appliances: oven, stovetop · prep 15 / cook 25 min · serves 4 · leftovers: no

- zucchini 4 piece (halved lengthways)
- ground-turkey 500 g
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- italian-herbs 2 tsp
- passata 300 g
- mozzarella 1 piece (torn)
- parmesan 20 g (grated)
- basil 10 g
- baguette 1 piece
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Scoop the middle out of the zucchini halves and chop it.
3. Brown the turkey, onion and chopped zucchini for 8 minutes, then add the garlic and herbs.
4. Stir in the passata and salt and simmer for 5 minutes.
5. Fill the zucchini boats, top with mozzarella and parmesan and bake for 20 minutes.
6. Scatter with basil and serve with warm baguette.

#### `easy-eggplant-parmesan` · Easy eggplant parmesan bake · 🍆 · Italian
vibes: comfort, family · appliances: oven, stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- eggplant 2 piece (thinly sliced)
- olive-oil 3 tbsp
- garlic 2 clove (crushed)
- passata 500 g
- italian-herbs 1 tsp
- mozzarella 2 piece (sliced)
- parmesan 40 g (grated)
- basil 15 g
- spaghetti 250 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Brush the eggplant slices with 2 tbsp oil and roast for 15 minutes — thin slices cook fast.
2. Simmer the passata with the garlic, herbs, salt and the rest of the oil for 10 minutes.
3. Layer sauce, eggplant, mozzarella and parmesan in a baking dish, finishing with cheese.
4. Bake for 15 minutes until bubbling.
5. Meanwhile, cook the spaghetti and toss with a little of the sauce.
6. Scatter with basil and serve.

#### `sausage-kale-chili-penne` · Sausage, kale & chili penne · 🌭 · Italian
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 350 g
- sausages 6 piece (skins removed)
- olive-oil 1 tbsp
- garlic 3 clove (sliced)
- chili-flakes 1 tsp
- kale 150 g (shredded)
- lemon 0.5 piece
- parmesan 40 g (grated)

1. Cook the pasta in salted boiling water, saving a mug of water before draining.
2. Fry the sausage meat in the oil, breaking it up, for 8 minutes until golden and crisp.
3. Add the garlic and chili for 1 minute.
4. Add the kale with a splash of pasta water and cook for 3 minutes until wilted.
5. Toss in the pasta, parmesan, lemon juice and more pasta water until glossy.
6. Serve with extra parmesan.

#### `aglio-olio-broccoli-beans` · Aglio e olio with broccoli & white beans · 🍝 · Italian
vibes: quickEasy, healthyish · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- spaghetti 350 g
- broccoli 1 piece (cut into small florets)
- olive-oil 4 tbsp
- garlic 5 clove (thinly sliced)
- chili-flakes 1 tsp
- cannellini-beans 240 g (drained)
- lemon 1 piece
- parsley 15 g (chopped)
- breadcrumbs 30 g

1. Cook the spaghetti in salted boiling water, adding the broccoli for the last 4 minutes. Save a mug of water and drain.
2. Toast the breadcrumbs in 1 tbsp oil until golden, then set aside.
3. Warm the rest of the oil with the garlic and chili over a low heat for 3 minutes until the garlic is pale gold.
4. Add the beans and warm through.
5. Toss in the spaghetti, broccoli, lemon juice and a splash of pasta water.
6. Finish with parsley and the crispy breadcrumbs.

#### `skillet-lasagne` · One-pan skillet lasagne · 🍝 · Italian
vibes: comfort, family, onePan · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- ground-beef 400 g
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- italian-herbs 2 tsp
- passata 700 g
- lasagne-sheets 8 piece (broken into pieces)
- spinach-frozen 150 g
- cottage-cheese 250 g
- mozzarella 1 piece (torn)
- parmesan 20 g (grated)
- salt 1 tsp

1. Brown the beef and onion in a large lidded pan for 8 minutes, then add the garlic and herbs.
2. Stir in the passata, salt and 300 ml water and bring to a simmer.
3. Push the broken lasagne sheets into the sauce and add the spinach.
4. Cover and simmer for 12 minutes, stirring once, until the pasta is tender.
5. Dollop over the cottage cheese, scatter with mozzarella and parmesan, cover for 3 minutes to melt.
6. Serve straight from the pan.

#### `one-pan-mexican-quinoa` · One-pan Mexican quinoa · 🫘 · Mexican
vibes: onePan, healthyish, batchFriendly · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- bell-pepper 1 piece (diced)
- cumin 2 tsp
- chili-powder 1 tsp
- quinoa 250 g
- chopped-tomatoes 400 g
- vegetable-bouillon 1 tsp
- black-beans 480 g (drained)
- sweetcorn-tin 165 g (drained)
- lime 1 piece
- cilantro 15 g

1. Cook the onion and pepper in the oil for 5 minutes.
2. Add the garlic and spices for 1 minute.
3. Stir in the quinoa, tomatoes, 400 ml boiling water and the bouillon.
4. Cover and simmer for 18 minutes until the quinoa is cooked.
5. Stir in the beans and sweetcorn and warm through.
6. Finish with lime juice and cilantro.

#### `chicken-tinga-tostadas` · Chicken tinga tostadas · 🌮 · Mexican
vibes: family, highProtein · appliances: oven, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- chicken-breast 3 piece
- olive-oil 1 tbsp
- onion 1 piece (sliced)
- garlic 2 clove (crushed)
- paprika 2 tsp
- chili-powder 1 tsp
- dried-oregano 1 tsp
- passata 300 g
- corn-tortillas 12 piece
- black-beans 240 g (drained)
- lettuce 0.5 piece (shredded)
- sour-cream 100 g
- feta 60 g (crumbled)
- salt 1 tsp

1. Heat the oven to 200°C (400°F). Poach the chicken in simmering water for 14 minutes, then shred.
2. Brush the tortillas with a little oil and bake on trays for 8 minutes until crisp.
3. Cook the onion in the rest of the oil for 5 minutes, then add the garlic and spices.
4. Add the passata, salt and shredded chicken and simmer for 5 minutes.
5. Warm and mash the beans with a splash of water.
6. Spread the tostadas with beans, pile on the chicken and top with lettuce, sour cream and feta.

#### `chicken-shrimp-jambalaya` · Chicken & shrimp jambalaya · 🍤 · American
vibes: onePan, family, comfort · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- chicken-thighs 400 g (diced)
- chorizo 80 g (sliced)
- onion 1 piece (diced)
- celery 2 piece (diced)
- bell-pepper 1 piece (diced)
- garlic 2 clove (crushed)
- paprika 2 tsp
- dried-thyme 1 tsp
- long-grain-rice 250 g
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- shrimp 200 g

1. Brown the chicken and chorizo in the oil for 5 minutes.
2. Add the onion, celery and pepper and cook for 5 minutes.
3. Stir in the garlic, paprika, thyme and rice.
4. Add the tomatoes, 600 ml boiling water and the bouillon, cover and simmer for 15 minutes.
5. Stir in the shrimp, cover and cook for 4 minutes until pink and the rice is tender.
6. Leave to stand for 2 minutes before serving.

#### `philly-cheesesteak-sandwiches` · Philly cheesesteak-style sandwiches · 🥖 · American
vibes: fakeaway, family, highProtein · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- beef-steak 2 piece (very thinly sliced)
- vegetable-oil 1 tbsp
- onion 2 piece (thinly sliced)
- bell-pepper 1 piece (thinly sliced)
- worcestershire 1 tbsp
- mozzarella 1 piece (sliced)
- baguette 2 piece (halved)
- salt 1 tsp
- black-pepper 1 pinch

1. Cook the onions and pepper in half the oil for 10 minutes until soft and golden, then set aside.
2. Sear the steak in the rest of the oil over a very high heat for 2 minutes with the salt, pepper and Worcestershire.
3. Return the onions and peppers and toss together.
4. Split into 4 piles in the pan and lay the mozzarella on top.
5. Cover for 1 minute to melt.
6. Split and toast the baguettes and scoop in the cheesy steak.

#### `turkey-sloppy-joes` · Turkey sloppy joes · 🍔 · American
vibes: family, comfort, quickEasy · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- ground-turkey 500 g
- olive-oil 1 tbsp
- onion 1 piece (diced)
- bell-pepper 1 piece (diced)
- garlic 2 clove (crushed)
- tomato-paste 2 tbsp
- passata 250 g
- worcestershire 1 tbsp
- honey 1 tbsp
- burger-buns 4 piece
- salt 1 tsp

1. Brown the turkey, onion and pepper in the oil for 8 minutes.
2. Add the garlic and tomato paste for 1 minute.
3. Stir in the passata, Worcestershire, honey and salt.
4. Simmer for 10 minutes until thick and saucy.
5. Toast the buns.
6. Pile in the turkey and eat with plenty of napkins.

#### `bbq-chicken-stuffed-sweet-potatoes` · BBQ chicken stuffed sweet potatoes · 🍠 · American
vibes: healthyish, family, highProtein · appliances: microwave, stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- sweet-potato 4 piece
- chicken-breast 2 piece
- bbq-sauce 5 tbsp
- red-cabbage 150 g (shredded)
- lime 1 piece
- greek-yogurt 100 g
- sweetcorn-tin 165 g (drained)
- cheddar 60 g (grated)
- spring-onion 2 piece (sliced)

1. Prick the sweet potatoes and microwave for 10–12 minutes, turning halfway, until soft.
2. Meanwhile, poach the chicken in simmering water for 12 minutes, then shred and toss with the BBQ sauce.
3. Toss the cabbage with the lime juice.
4. Split the potatoes and fill with BBQ chicken, sweetcorn and cheddar.
5. Microwave for 1 minute to melt the cheese.
6. Top with the slaw, yogurt and spring onions.

#### `sweet-potato-cottage-pie` · Cottage pie with sweet potato mash · 🥧 · British
vibes: comfort, family, batchFriendly · appliances: stovetop, oven · prep 15 / cook 30 min · serves 4 · leftovers: yes

- ground-beef 500 g
- onion 1 piece (diced)
- carrot 2 piece (diced)
- tomato-paste 2 tbsp
- worcestershire 1 tbsp
- dried-thyme 1 tsp
- vegetable-bouillon 1 tsp
- peas-frozen 150 g
- sweet-potato 4 piece (peeled and chopped)
- butter 1 tbsp
- cheddar 50 g (grated)
- salt 1 tsp

1. Boil the sweet potatoes for 12 minutes until soft, then mash with the butter and a pinch of salt.
2. At the same time, brown the beef with the onion and carrot for 10 minutes.
3. Stir in the tomato paste, Worcestershire, thyme, bouillon and 300 ml water and simmer for 8 minutes, then add the peas.
4. Tip into a baking dish and spread over the mash.
5. Scatter with cheddar.
6. Grill or bake at 220°C (425°F) for 10 minutes until golden at the edges.

#### `chicken-leek-mash-pie` · Creamy chicken & leek pie with mash · 🥧 · British
vibes: comfort, family · appliances: stovetop, oven · prep 10 / cook 35 min · serves 4 · leftovers: yes

- potato 5 piece (peeled and chopped)
- butter 2 tbsp
- milk 400 ml
- chicken-thighs 500 g (diced)
- leek 2 piece (sliced)
- flour 2 tbsp
- dijon-mustard 1 tsp
- peas-frozen 150 g
- cheddar 50 g (grated)
- salt 1 tsp

1. Boil the potatoes for 15 minutes, then mash with half the butter and a splash of the milk.
2. Meanwhile, brown the chicken in the rest of the butter for 5 minutes, then add the leeks for 5 minutes.
3. Stir in the flour, then gradually the rest of the milk, and simmer for 3 minutes until thick. Add the mustard, peas and salt.
4. Tip into a baking dish and spread over the mash.
5. Scatter with cheddar.
6. Grill or bake at 220°C (425°F) for 10 minutes until golden.

#### `toad-in-the-hole` · Toad in the hole with onion gravy · 🌭 · British
vibes: comfort, family · appliances: oven, stovetop · prep 10 / cook 35 min · serves 4 · leftovers: no

- sausages 8 piece
- vegetable-oil 2 tbsp
- flour 120 g
- eggs 3 piece
- milk 250 ml
- onion 2 piece (sliced)
- butter 1 tbsp
- vegetable-stock 400 ml
- cornstarch 1 tbsp
- green-beans 250 g
- salt 1 pinch

1. Heat the oven to 220°C (425°F). Roast the sausages in the oil in a roasting tin for 10 minutes.
2. Whisk the flour, eggs, milk and salt into a smooth batter.
3. Pour the batter around the sausages in the hot tin and bake for 25 minutes without opening the door, until puffed and golden.
4. Meanwhile, cook the onions in the butter for 12 minutes until golden.
5. Add the stock and the cornstarch mixed with a splash of water and simmer until thick.
6. Steam the green beans and serve with the toad in the hole and gravy.

#### `chicken-leek-mustard-one-pot` · Creamy chicken, leek & mustard one-pot · 🍗 · British
vibes: onePan, comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- chicken-thighs 600 g
- olive-oil 1 tbsp
- leek 2 piece (sliced)
- garlic 2 clove (crushed)
- potato 4 piece (cubed)
- chicken-stock 400 ml
- dijon-mustard 2 tbsp
- heavy-cream 80 ml
- peas-frozen 150 g
- parsley 10 g (chopped)
- salt 1 tsp

1. Brown the chicken in the oil in a deep pan for 6 minutes, then set aside.
2. Soften the leeks and garlic in the same pan for 5 minutes.
3. Add the potatoes, stock and chicken, cover and simmer for 15 minutes.
4. Stir in the mustard, cream and peas and simmer for 3 minutes.
5. Season with salt.
6. Scatter with parsley and serve.

#### `crispy-chili-beef-bowl` · Crispy chili beef rice bowl · 🌶️ · Chinese
vibes: fakeaway, family · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- beef-steak 2 piece (cut into thin strips)
- cornstarch 3 tbsp
- vegetable-oil 3 tbsp
- bell-pepper 1 piece (sliced)
- onion 1 piece (sliced)
- garlic 2 clove (crushed)
- sweet-chili-sauce 4 tbsp
- soy-sauce 2 tbsp
- rice-vinegar 1 tbsp
- long-grain-rice 250 g
- spring-onion 2 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the beef in the cornstarch until coated.
3. Fry in the oil over a high heat in batches for 3 minutes until very crisp, then drain on paper.
4. Pour off most of the oil and stir-fry the pepper, onion and garlic for 3 minutes.
5. Add the sweet chili sauce, soy sauce and vinegar and bubble for 1 minute.
6. Toss the beef back in and serve over rice with spring onions.

### Lunchs (20)

#### `cowboy-caviar` · Cowboy caviar with tortilla chips · 🫘 · Mexican
vibes: healthyish, batchFriendly · appliances: oven · prep 15 / cook 8 min · serves 4 · leftovers: yes

- black-beans 480 g (drained)
- sweetcorn-tin 165 g (drained)
- bell-pepper 1 piece (diced)
- cherry-tomatoes 200 g (quartered)
- red-onion 0.5 piece (finely diced)
- cilantro 20 g (chopped)
- lime 2 piece
- olive-oil 2 tbsp
- chili-powder 0.5 tsp
- corn-tortillas 8 piece (cut into triangles)
- salt 1 tsp

1. Heat the oven to 200°C (400°F) and bake the tortilla triangles for 8 minutes until crisp.
2. Whisk the lime juice, oil, chili powder and salt.
3. Toss the beans, sweetcorn, pepper, tomatoes, onion and cilantro in the dressing.
4. Scoop up with the chips. It keeps for 3 days in the fridge.

#### `crispy-rice-salad` · Crispy rice salad · 🍚 · Thai
vibes: healthyish, fakeaway · appliances: stovetop · prep 15 / cook 10 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- vegetable-oil 2 tbsp
- thai-curry-paste 1 tsp
- cucumber 0.5 piece (diced)
- red-onion 0.25 piece (finely sliced)
- cilantro 15 g
- peanuts 30 g (chopped)
- lime 1 piece
- fish-sauce 1 tbsp
- sugar 1 tsp

1. Mix the rice with the curry paste and press into a thin layer in a non-stick pan with the oil.
2. Fry over a medium-high heat for 8 minutes without stirring until crisp underneath, then break into chunks.
3. Whisk the lime juice, fish sauce and sugar.
4. Toss the crispy rice with the cucumber, onion, cilantro and peanuts in the dressing.

#### `chicken-grape-walnut-salad-cups` · Chicken, grape & walnut salad cups · 🍇 · American
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- chicken-breast 1 piece
- grapes 120 g (halved)
- celery 1 piece (finely diced)
- walnuts 30 g (chopped)
- greek-yogurt 80 g
- dijon-mustard 1 tsp
- lemon 0.5 piece
- lettuce 0.5 piece (leaves separated)

1. Poach the chicken in simmering water for 12 minutes, then cool and dice.
2. Mix the yogurt, mustard and lemon juice with a pinch of salt.
3. Fold in the chicken, grapes, celery and walnuts.
4. Spoon into lettuce cups.

#### `tuna-nicoise-salad` · Tuna niçoise salad · 🥗 · Other
vibes: highProtein, healthyish · appliances: stovetop · prep 10 / cook 15 min · serves 2 · leftovers: no

- potato 2 piece (halved)
- green-beans 120 g
- eggs 2 piece
- canned-tuna 145 g (drained)
- tomato 1 piece (cut into wedges)
- lettuce 0.5 piece
- olive-oil 2 tbsp
- red-wine-vinegar 1 tbsp
- dijon-mustard 1 tsp

1. Boil the potatoes for 12 minutes, adding the eggs for the last 8 and the beans for the last 3, then cool in cold water.
2. Peel and halve the eggs and slice the potatoes.
3. Whisk the oil, vinegar and mustard.
4. Arrange the lettuce, potatoes, beans, tomato, tuna and eggs and drizzle with the dressing.

#### `panzanella` · Panzanella bread salad · 🍅 · Italian
vibes: quickEasy, family · appliances: oven · prep 15 / cook 10 min · serves 2 · leftovers: no

- sourdough 3 slice (torn into chunks)
- olive-oil 3 tbsp
- tomato 3 piece (chopped)
- cucumber 0.5 piece (chopped)
- red-onion 0.25 piece (finely sliced)
- basil 10 g
- red-wine-vinegar 1 tbsp
- mozzarella 0.5 piece (torn)
- salt 1 pinch

1. Heat the oven to 200°C (400°F). Toss the bread with 1 tbsp oil and bake for 10 minutes until crisp.
2. Toss the tomatoes with the salt and leave for 5 minutes to release their juices — that's the dressing.
3. Add the cucumber, onion, the rest of the oil and the vinegar.
4. Toss in the bread and basil, leave for 5 minutes to soak, then top with the mozzarella.

#### `fattoush-salad-chickpeas` · Fattoush salad with crispy chickpeas · 🥗 · Middle Eastern
vibes: healthyish, quickEasy · appliances: oven · prep 15 / cook 15 min · serves 2 · leftovers: no

- pita-bread 1 piece (torn)
- chickpeas 240 g (drained)
- olive-oil 3 tbsp
- paprika 1 tsp
- lettuce 0.5 piece (chopped)
- cucumber 0.5 piece (diced)
- tomato 2 piece (diced)
- spring-onion 2 piece (sliced)
- parsley 15 g
- lemon 1 piece
- salt 1 pinch

1. Heat the oven to 200°C (400°F). Toss the pita and chickpeas with 1 tbsp oil and the paprika and bake for 15 minutes until crisp.
2. Whisk the lemon juice, the rest of the oil and the salt.
3. Toss the lettuce, cucumber, tomato, spring onion and parsley in the dressing.
4. Top with the crispy pita and chickpeas.

#### `diy-chicken-noodle-jars` · Make-ahead chicken noodle soup jars · 🫙 · Chinese
vibes: batchFriendly, quickEasy · appliances: none · prep 15 / cook 0 min · serves 2 · leftovers: no

- rice-noodles 80 g
- chicken-breast 1 piece (poached and shredded)
- vegetable-bouillon 2 tsp
- miso-paste 1 tbsp
- soy-sauce 1 tbsp
- ginger 5 g (grated)
- spinach 40 g
- carrot 1 piece (grated)
- spring-onion 2 piece (sliced)
- chili-flakes 1 pinch

1. Split the bouillon, miso, soy sauce and ginger between two large jars.
2. Layer in the dry noodles, chicken, carrot, spinach and spring onion.
3. Seal and keep in the fridge for up to 3 days.
4. At lunch, fill the jar with boiling water, close the lid for 5 minutes, then stir.

#### `spinach-feta-quesadilla` · Spinach & feta quesadilla · 🫓 · Mediterranean
vibes: quickEasy · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- tortillas 2 piece
- spinach 80 g
- feta 60 g (crumbled)
- mozzarella 0.5 piece (grated)
- roasted-peppers 50 g (sliced)
- dried-oregano 0.5 tsp
- greek-yogurt 60 g

1. Wilt the spinach in a dry pan, then squeeze out the water.
2. Scatter the spinach, feta, mozzarella, peppers and oregano over half of each tortilla.
3. Fold and cook in the dry pan for 3 minutes on each side until golden and melted.
4. Cut into wedges and serve with yogurt.

#### `blt-pasta-salad` · BLT pasta salad · 🥓 · American
vibes: family, batchFriendly · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: yes

- penne 250 g
- bacon 6 slice
- cherry-tomatoes 250 g (halved)
- lettuce 0.5 piece (shredded)
- greek-yogurt 100 g
- mayonnaise 2 tbsp
- lemon 0.5 piece
- garlic-powder 0.5 tsp
- black-pepper 1 pinch

1. Cook the pasta in salted boiling water, then rinse under cold water and drain.
2. Fry the bacon until crisp, then chop.
3. Mix the yogurt, mayonnaise, lemon juice, garlic powder and pepper.
4. Toss the pasta with the tomatoes and dressing, then fold in the lettuce and bacon just before eating.

#### `japanese-egg-rice-bowl` · Soy butter egg rice bowl · 🍚 · Japanese
vibes: quickEasy, comfort · appliances: stovetop · prep 2 / cook 15 min · serves 2 · leftovers: no

- long-grain-rice 150 g
- eggs 4 piece
- butter 1 tbsp
- soy-sauce 2 tbsp
- spring-onion 2 piece (sliced)
- nori 1 piece (crumbled)
- sesame-seeds 1 tsp
- avocado 1 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Melt the butter in a pan and fry the eggs until crispy at the edges with runny yolks.
3. Spoon the rice into bowls and drizzle with the soy sauce.
4. Top with the eggs, avocado, spring onion, nori and sesame.

#### `gazpacho-with-croutons` · Gazpacho with garlic croutons · 🍅 · Spanish/Portuguese
vibes: healthyish, quickEasy · appliances: blender, stovetop · prep 15 / cook 5 min · serves 4 · leftovers: no

- tomato 6 piece (chopped)
- cucumber 1 piece (chopped)
- bell-pepper 1 piece (chopped)
- red-onion 0.25 piece
- garlic 1 clove
- red-wine-vinegar 2 tbsp
- olive-oil 4 tbsp
- sourdough 4 slice (cubed)
- cannellini-beans 240 g (drained)
- salt 1 tsp

1. Blend the tomatoes, cucumber, pepper, onion, garlic, beans, vinegar, 3 tbsp oil and salt until very smooth.
2. Chill for at least 30 minutes.
3. Fry the bread cubes in the rest of the oil for 4 minutes until golden.
4. Serve the cold soup topped with croutons and a drizzle of oil.

#### `minestrone` · Quick minestrone · 🍲 · Italian
vibes: healthyish, batchFriendly, comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- celery 2 piece (diced)
- garlic 2 clove (crushed)
- italian-herbs 2 tsp
- chopped-tomatoes 400 g
- vegetable-bouillon 3 tsp
- cannellini-beans 240 g (drained)
- penne 100 g
- zucchini 1 piece (diced)
- parmesan 30 g (grated)

1. Cook the onion, carrot and celery in the oil for 6 minutes.
2. Add the garlic and herbs, then the tomatoes, 1.2 litres boiling water, the bouillon and the beans, and simmer for 10 minutes.
3. Add the pasta and zucchini and simmer for 10 minutes until the pasta is tender.
4. Serve with parmesan.

#### `sweetcorn-chowder` · Sweetcorn & potato chowder · 🌽 · American
vibes: comfort, family · appliances: stovetop, blender · prep 10 / cook 20 min · serves 4 · leftovers: yes

- butter 1 tbsp
- bacon 3 slice (chopped)
- onion 1 piece (diced)
- potato 2 piece (diced)
- corn-frozen 400 g
- vegetable-stock 700 ml
- milk 200 ml
- paprika 1 tsp
- spring-onion 2 piece (sliced)
- sourdough 4 slice

1. Fry the bacon in the butter until crisp, then lift out half for the top.
2. Add the onion and cook for 5 minutes, then the potatoes, corn, paprika and stock and simmer for 15 minutes.
3. Blend a third of the soup and stir it back in with the milk.
4. Serve topped with the crispy bacon and spring onions, with toast.

#### `pea-ham-soup` · Pea & ham soup · 🟢 · British
vibes: comfort, quickEasy · appliances: stovetop, blender · prep 5 / cook 15 min · serves 4 · leftovers: no

- butter 1 tbsp
- onion 1 piece (diced)
- potato 1 piece (diced)
- peas-frozen 500 g
- vegetable-stock 900 ml
- ham 6 slice (shredded)
- mint 10 g
- greek-yogurt 80 g
- sourdough 4 slice

1. Cook the onion in the butter for 5 minutes.
2. Add the potato and stock and simmer for 10 minutes, then add the peas for 3 minutes.
3. Blend with the mint until smooth.
4. Serve topped with the shredded ham and a swirl of yogurt, with toast.

#### `chicken-mulligatawny` · Chicken mulligatawny soup · 🍲 · Indian
vibes: comfort, batchFriendly · appliances: stovetop, blender · prep 10 / cook 25 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- apple 1 piece (diced)
- garlic 2 clove (crushed)
- curry-powder 1 tbsp
- red-lentils 100 g
- vegetable-bouillon 3 tsp
- chicken-breast 2 piece
- coconut-milk 200 ml
- lemon 1 piece

1. Cook the onion, carrot and apple in the oil for 6 minutes.
2. Add the garlic and curry powder for 1 minute, then the lentils, 1.2 litres boiling water, the bouillon and the whole chicken breasts, and simmer for 18 minutes.
3. Lift out the chicken and shred it, then blend the soup with the coconut milk.
4. Return the chicken and add the lemon juice.

#### `roast-veg-hummus-flatbread` · Roast veg & hummus pittas · 🫓 · Middle Eastern
vibes: healthyish, family · appliances: oven · prep 10 / cook 25 min · serves 2 · leftovers: no

- zucchini 1 piece (sliced)
- bell-pepper 1 piece (sliced)
- red-onion 1 piece (cut into wedges)
- olive-oil 1 tbsp
- cumin 1 tsp
- pita-bread 2 piece
- hummus 120 g
- feta 30 g (crumbled)
- lemon 0.5 piece

1. Heat the oven to 220°C (425°F). Toss the vegetables with the oil and cumin and roast for 20 minutes.
2. Warm the pittas in the oven for the last 3 minutes.
3. Spread the pittas with hummus and pile on the roast vegetables.
4. Top with feta and a squeeze of lemon.

#### `pizza-pasta-salad` · Pizza pasta salad · 🍕 · Italian
vibes: family, batchFriendly · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: yes

- penne 250 g
- ham 4 slice (chopped)
- mozzarella 1 piece (diced)
- cherry-tomatoes 200 g (halved)
- bell-pepper 1 piece (diced)
- olives 50 g (sliced)
- olive-oil 3 tbsp
- red-wine-vinegar 1 tbsp
- dried-oregano 1 tsp
- tomato-paste 1 tbsp
- basil 10 g

1. Cook the pasta in salted boiling water, then rinse under cold water and drain.
2. Whisk the oil, vinegar, tomato paste and oregano into a pizza-flavoured dressing.
3. Toss the pasta with the ham, mozzarella, tomatoes, pepper and olives.
4. Pour over the dressing and finish with basil.

#### `tuna-mayo-rice-bowl` · Korean-style tuna mayo rice bowl · 🍙 · Korean
vibes: quickEasy, highProtein · appliances: microwave · prep 5 / cook 3 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- canned-tuna 145 g (drained)
- mayonnaise 2 tbsp
- soy-sauce 1 tbsp
- gochujang 1 tsp
- kimchi 80 g
- cucumber 0.5 piece (sliced)
- nori 2 piece (cut into squares)
- sesame-seeds 1 tsp

1. Heat the rice following the pack.
2. Mix the tuna with the mayonnaise, soy sauce and gochujang.
3. Spoon the rice into bowls and top with the tuna, kimchi and cucumber.
4. Scatter with sesame and scoop up bites with the nori squares.

#### `banh-mi-tofu-sandwich` · Banh mi-style tofu sandwich · 🥖 · Other
vibes: healthyish, fakeaway · appliances: stovetop · prep 15 / cook 10 min · serves 2 · leftovers: no

- tofu 200 g (sliced)
- soy-sauce 1 tbsp
- vegetable-oil 1 tsp
- carrot 1 piece (cut into matchsticks)
- cucumber 0.5 piece (sliced)
- rice-vinegar 2 tbsp
- sugar 1 tsp
- baguette 1 piece (halved)
- mayonnaise 1 tbsp
- sriracha 1 tsp

1. Toss the carrot and cucumber with the vinegar, sugar and a pinch of salt for a quick pickle.
2. Fry the tofu in the oil for 6 minutes until golden, then add the soy sauce to glaze.
3. Mix the mayonnaise with the sriracha and spread inside the split baguettes.
4. Fill with the tofu and pickles.

#### `halloumi-pepper-sandwich` · Halloumi & roasted pepper baguette · 🥖 · Mediterranean
vibes: quickEasy · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- halloumi 125 g (sliced)
- baguette 0.75 piece (halved)
- roasted-peppers 80 g
- hummus 60 g
- spinach 30 g
- honey 1 tsp
- chili-flakes 1 pinch

1. Fry the halloumi in a dry pan for 2 minutes on each side until golden.
2. Drizzle with the honey and sprinkle with chili.
3. Split the baguette and spread with hummus.
4. Fill with the peppers, halloumi and spinach.

### Breakfasts (20)

#### `dutch-baby-pancake` · Dutch baby pancake with berries · 🥞 · American
vibes: family, comfort · appliances: oven, blender · prep 5 / cook 20 min · serves 2 · leftovers: no

- eggs 3 piece
- flour 60 g
- milk 120 ml
- butter 2 tbsp
- cinnamon 0.5 tsp
- berries-frozen 150 g (thawed)
- greek-yogurt 100 g

1. Heat the oven to 220°C (425°F) with the butter in an ovenproof frying pan.
2. Blend the eggs, flour, milk and cinnamon until smooth.
3. Pour into the sizzling butter and bake for 18–20 minutes without opening the door, until puffed and golden.
4. Top with berries and yogurt and eat straight away.

#### `potato-egg-breakfast-tacos` · Crispy potato & egg breakfast tacos · 🌮 · Mexican
vibes: comfort, family · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- potato 1 piece (finely diced)
- olive-oil 1 tbsp
- paprika 1 tsp
- eggs 4 piece (beaten)
- corn-tortillas 6 piece
- cheddar 30 g (grated)
- salsa 80 g
- salt 1 pinch

1. Fry the potato in the oil with the paprika and salt for 12 minutes until crisp.
2. Pour in the eggs and scramble gently until just set.
3. Warm the tortillas in a dry pan.
4. Fill with the potato and eggs and top with cheddar and salsa.

#### `huevos-rancheros` · Huevos rancheros · 🍳 · Mexican
vibes: comfort, highProtein · appliances: stovetop · prep 5 / cook 15 min · serves 2 · leftovers: no

- olive-oil 1 tbsp
- onion 0.5 piece (diced)
- garlic 1 clove (crushed)
- cumin 0.5 tsp
- chili-powder 0.5 tsp
- chopped-tomatoes 400 g
- black-beans 120 g (drained)
- eggs 4 piece
- corn-tortillas 4 piece

1. Cook the onion in the oil for 4 minutes, then add the garlic and spices.
2. Add the tomatoes and beans and simmer for 6 minutes.
3. Make 4 wells, crack in the eggs, cover and cook for 5 minutes until the whites set.
4. Serve over warm tortillas.

#### `menemen` · Turkish-style menemen · 🍳 · Middle Eastern
vibes: quickEasy, onePan · appliances: stovetop · prep 5 / cook 12 min · serves 2 · leftovers: no

- olive-oil 1 tbsp
- bell-pepper 1 piece (sliced)
- onion 0.5 piece (diced)
- chopped-tomatoes 400 g
- chili-flakes 0.5 tsp
- eggs 4 piece (beaten)
- wholemeal-bread 2 slice

1. Cook the pepper and onion in the oil for 5 minutes.
2. Add the tomatoes and chili and cook for 5 minutes until jammy.
3. Pour in the eggs and stir gently until just set and still soft.
4. Serve straight from the pan with toast.

#### `masala-omelette` · Masala omelette · 🍳 · Indian
vibes: highProtein, quickEasy · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- eggs 5 piece
- red-onion 0.5 piece (finely diced)
- tomato 1 piece (finely diced)
- cilantro 10 g (chopped)
- turmeric 0.25 tsp
- garam-masala 0.5 tsp
- chili-flakes 0.5 tsp
- butter 1 tbsp
- wholemeal-bread 2 slice
- salt 1 pinch

1. Beat the eggs with the onion, tomato, cilantro, spices and salt.
2. Melt half the butter in a frying pan and pour in half the egg.
3. Cook for 2 minutes, flip and cook for 1 minute. Repeat with the rest.
4. Serve with toast.

#### `savory-congee-jammy-egg` · Savory rice congee with jammy egg · 🥣 · Chinese
vibes: comfort · appliances: stovetop · prep 5 / cook 25 min · serves 2 · leftovers: no

- long-grain-rice 80 g
- vegetable-bouillon 2 tsp
- ginger 15 g (cut into matchsticks)
- eggs 2 piece
- soy-sauce 1 tbsp
- spring-onion 2 piece (sliced)
- chili-flakes 1 pinch
- peanuts 20 g (chopped)

1. Simmer the rice with 900 ml water, the bouillon and ginger for 25 minutes, stirring often, until thick and creamy.
2. Meanwhile, boil the eggs for 6½ minutes, then cool and peel.
3. Season the congee with the soy sauce.
4. Top with halved eggs, spring onion, chili and peanuts.

#### `bacon-egg-cheese-toastie` · Bacon, egg & cheese toastie · 🥪 · British
vibes: comfort, highProtein · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- bacon 2 slice
- eggs 2 piece
- wholemeal-bread 4 slice
- cheddar 40 g (grated)
- butter 1 tsp
- ketchup 1 tbsp

1. Fry the bacon until crisp, then fry the eggs in the same pan with broken yolks until set.
2. Layer the cheese, bacon and egg between the bread.
3. Butter the outsides and press in the pan for 3 minutes on each side until golden and melted.
4. Cut in half and serve with ketchup.

#### `zucchini-fritters-yogurt` · Zucchini fritters with yogurt · 🥒 · Mediterranean
vibes: healthyish, family · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- zucchini 2 piece (grated and squeezed dry)
- eggs 2 piece
- flour 50 g
- feta 50 g (crumbled)
- spring-onion 2 piece (sliced)
- olive-oil 2 tbsp
- greek-yogurt 120 g

1. Mix the zucchini, eggs, flour, feta and spring onion — squeezing the zucchini dry keeps them crisp.
2. Fry spoonfuls in the oil for 3 minutes on each side until golden.
3. Season the yogurt with a pinch of salt.
4. Serve the fritters with the yogurt.

#### `cinnamon-roll-baked-oats` · Cinnamon roll baked oats · 🌀 · Other
vibes: family, comfort · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 100 g
- banana 1 piece
- eggs 1 piece
- milk 150 ml
- baking-powder 1 tsp
- cinnamon 2 tsp
- maple-syrup 2 tbsp
- cream-cheese 40 g

1. Heat the oven to 180°C (350°F).
2. Blend the oats, banana, egg, milk, baking powder, half the cinnamon and half the maple syrup until smooth.
3. Pour into two small dishes, swirl in the rest of the cinnamon and maple syrup, and bake for 25 minutes.
4. Loosen the cream cheese with a splash of milk and spread over the warm oats like icing.

#### `banana-oat-muffins` · Banana oat breakfast muffins · 🧁 · Other
vibes: batchFriendly, family · appliances: oven, blender · prep 10 / cook 22 min · serves 4 · leftovers: yes

- rolled-oats 150 g
- banana 3 piece
- eggs 2 piece
- greek-yogurt 150 g
- maple-syrup 3 tbsp
- baking-powder 2 tsp
- cinnamon 1 tsp
- dark-chocolate 30 g (chopped)

1. Heat the oven to 180°C (350°F) and line a 12-hole muffin tin.
2. Blend the oats, bananas, eggs, yogurt, maple syrup, baking powder and cinnamon.
3. Stir in the chocolate and divide between the cases.
4. Bake for 20–22 minutes until risen and golden. Keep for 4 days in a tin.

#### `savory-cottage-cheese-bowl` · Savory cottage cheese breakfast bowl · 🥣 · Other
vibes: highProtein, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- cottage-cheese 250 g
- cucumber 0.5 piece (diced)
- tomato 1 piece (diced)
- olive-oil 1 tbsp
- sesame-seeds 1 tsp
- garlic-powder 1 pinch
- chili-flakes 1 pinch
- rice-cakes 2 piece

1. Spoon the cottage cheese into bowls.
2. Top with the cucumber and tomato.
3. Mix the sesame seeds, garlic powder and chili and sprinkle over with the oil.
4. Scoop up with the rice cakes.

#### `kimchi-cheese-omelette` · Kimchi cheese omelette · 🍳 · Korean
vibes: quickEasy, highProtein · appliances: stovetop · prep 3 / cook 6 min · serves 2 · leftovers: no

- eggs 5 piece (beaten)
- kimchi 100 g (chopped)
- cheddar 40 g (grated)
- spring-onion 2 piece (sliced)
- butter 1 tbsp
- wholemeal-bread 2 slice

1. Fry the kimchi in half the butter for 2 minutes, then set aside.
2. Melt the rest of the butter and pour in half the egg, swirling to cover the pan.
3. When almost set, add half the kimchi and cheese, fold and slide out. Repeat.
4. Scatter with spring onion and serve with toast.

#### `apple-cinnamon-pancakes` · Apple cinnamon pancakes · 🍎 · American
vibes: family, comfort · appliances: stovetop · prep 10 / cook 12 min · serves 2 · leftovers: no

- flour 100 g
- baking-powder 1 tsp
- cinnamon 1 tsp
- eggs 1 piece
- milk 150 ml
- apple 1 piece (grated)
- butter 1 tbsp
- greek-yogurt 100 g

1. Whisk the flour, baking powder, cinnamon, egg and milk into a thick batter, then stir in the apple.
2. Melt a little butter in a non-stick pan over a medium heat.
3. Cook spoonfuls for 2 minutes until bubbles appear, then flip for 1 minute.
4. Stack with yogurt and a dusting of cinnamon.

#### `green-spinach-pancakes` · Green spinach banana pancakes · 🥬 · Other
vibes: healthyish, family · appliances: blender, stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- spinach 50 g
- banana 1 piece
- eggs 2 piece
- rolled-oats 80 g
- milk 100 ml
- baking-powder 1 tsp
- vegetable-oil 1 tsp
- greek-yogurt 100 g

1. Blend the spinach, banana, eggs, oats, milk and baking powder until bright green and smooth.
2. Wipe a non-stick pan with a little oil.
3. Cook small pancakes for 2 minutes on each side.
4. Serve with yogurt.

#### `berry-crumble-yogurt-bowl` · Warm berry crumble yogurt bowl · 🫐 · British
vibes: comfort, healthyish · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- berries-frozen 200 g
- maple-syrup 1 tbsp
- rolled-oats 40 g
- butter 1 tbsp
- cinnamon 0.5 tsp
- greek-yogurt 250 g

1. Simmer the berries with half the maple syrup for 5 minutes until jammy.
2. In another pan, toast the oats in the butter with the cinnamon and the rest of the maple syrup until golden.
3. Spoon the yogurt into bowls.
4. Top with the warm berries and the crumble.

#### `baked-avocado-egg-boats` · Baked avocado egg boats · 🥑 · Other
vibes: highProtein, healthyish · appliances: oven · prep 5 / cook 15 min · serves 2 · leftovers: no

- avocado 2 piece (halved and stoned)
- eggs 4 piece
- cheddar 20 g (grated)
- chili-flakes 1 pinch
- wholemeal-bread 2 slice
- salt 1 pinch

1. Heat the oven to 200°C (400°F).
2. Scoop out a little avocado to widen each hole and sit the halves in a small dish.
3. Crack an egg into each, top with cheddar, chili and salt and bake for 15 minutes until the whites set.
4. Serve with toast.

#### `pbj-overnight-oats` · PB & J overnight oats · 🥜 · American
vibes: quickEasy, batchFriendly · appliances: stovetop · prep 5 / cook 5 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 240 ml
- greek-yogurt 100 g
- peanut-butter 2 tbsp
- berries-frozen 150 g
- maple-syrup 1 tsp

1. Simmer the berries with the maple syrup for 5 minutes, mashing into a quick jam.
2. Stir the oats, milk, yogurt and peanut butter together.
3. Layer the oats and jam in two jars and chill overnight.
4. Top with an extra swirl of peanut butter.

#### `tortilla-breakfast-pizza` · Tortilla breakfast pizza · 🍕 · American
vibes: family, highProtein · appliances: oven · prep 5 / cook 10 min · serves 2 · leftovers: no

- tortillas 2 piece
- passata 60 g
- mozzarella 0.5 piece (torn)
- eggs 2 piece
- spinach 30 g
- ham 2 slice (torn)
- chili-flakes 1 pinch

1. Heat the oven to 220°C (425°F) and put the tortillas on a lined tray.
2. Spread with passata and scatter with spinach, ham and mozzarella, leaving a gap in the middle.
3. Crack an egg into the middle of each.
4. Bake for 8–10 minutes until the egg white is set, then sprinkle with chili.

#### `breakfast-pita-pockets` · Breakfast pita pockets with eggs & hummus · 🥙 · Middle Eastern
vibes: quickEasy, highProtein · appliances: stovetop · prep 5 / cook 6 min · serves 2 · leftovers: no

- pita-bread 2 piece
- eggs 4 piece (beaten)
- butter 1 tsp
- hummus 60 g
- cucumber 0.25 piece (diced)
- tomato 1 piece (diced)
- paprika 1 pinch

1. Scramble the eggs in the butter until just set.
2. Warm the pittas and split them open.
3. Spread the inside with hummus.
4. Fill with eggs, cucumber, tomato and a pinch of paprika.

#### `tropical-overnight-oats` · Tropical mango coconut overnight oats · 🥭 · Other
vibes: quickEasy, healthyish · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- coconut-milk 150 ml
- milk 100 ml
- greek-yogurt 100 g
- mango 1 piece (diced)
- lime 0.5 piece

1. Stir the oats, coconut milk, milk and yogurt together.
2. Fold in half the mango and the lime zest.
3. Split between jars and chill overnight.
4. Top with the rest of the mango and a squeeze of lime.

### Snacks (15)

#### `frozen-yogurt-peanut-bites` · Frozen yogurt peanut caramel bites · 🍫 · Other
vibes: highProtein, family · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- greek-yogurt 200 g
- peanut-butter 2 tbsp
- honey 1 tbsp
- peanuts 30 g (chopped)
- dark-chocolate 50 g (melted)

1. Mix the yogurt with the honey and spoon into 12 mini cupcake cases.
2. Top each with a little peanut butter and some peanuts.
3. Freeze for 2 hours, dip the tops in melted chocolate and freeze for 10 minutes more.

#### `baked-cinnamon-apples` · Baked cinnamon apples with oat crumble · 🍎 · British
vibes: comfort, family · appliances: oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- apple 2 piece (halved and cored)
- rolled-oats 20 g
- butter 1 tbsp
- cinnamon 1 tsp
- maple-syrup 1 tbsp
- greek-yogurt 80 g

1. Heat the oven to 180°C (350°F).
2. Rub the oats, butter, cinnamon and maple syrup together and pile into the apple halves.
3. Bake for 25 minutes until soft, and serve with yogurt.

#### `banana-chocolate-mug-cake` · Banana chocolate mug cake · ☕ · Other
vibes: quickEasy, comfort · appliances: microwave · prep 3 / cook 2 min · serves 2 · leftovers: no

- banana 1 piece (mashed)
- eggs 1 piece
- flour 2 tbsp
- dark-chocolate 20 g (chopped)
- baking-powder 0.5 tsp
- peanut-butter 1 tbsp

1. Mix the banana, egg, flour, baking powder and peanut butter in a large mug.
2. Stir in most of the chocolate and press the rest on top.
3. Microwave for 90 seconds to 2 minutes until just set. Share between two.

#### `cottage-cheese-pepper-boats` · Cottage cheese pepper boats · 🫑 · Other
vibes: highProtein, lowCalorie · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- bell-pepper 1 piece (cut into 4 boats)
- cottage-cheese 150 g
- garlic-powder 0.5 tsp
- chili-flakes 1 pinch
- sesame-seeds 1 tsp

1. Mix the cottage cheese with the garlic powder.
2. Spoon into the pepper boats.
3. Sprinkle with chili and sesame.

#### `air-fryer-mozzarella-bites` · Air-fryer mozzarella bites · 🧀 · Italian
vibes: family, fakeaway · appliances: airFryer · prep 10 / cook 6 min · serves 4 · leftovers: no

- mozzarella 1 piece (cut into cubes and frozen for 20 minutes)
- eggs 1 piece (beaten)
- breadcrumbs 40 g
- italian-herbs 1 tsp
- passata 80 g

1. Mix the breadcrumbs with the herbs.
2. Dip the frozen mozzarella in egg, then crumbs, then egg and crumbs again.
3. Air-fry at 200°C (400°F) for 5–6 minutes until golden, and serve with warm passata for dipping.

#### `pizza-rice-cakes` · Air-fryer pizza rice cakes · 🍕 · Italian
vibes: quickEasy, family · appliances: airFryer · prep 3 / cook 4 min · serves 2 · leftovers: no

- rice-cakes 4 piece
- passata 60 g
- mozzarella 0.5 piece (torn)
- dried-oregano 0.5 tsp
- olives 20 g (sliced)

1. Spread the rice cakes with passata and top with mozzarella, olives and oregano.
2. Air-fry at 180°C (350°F) for 3–4 minutes until the cheese melts.
3. Eat straight away while crisp.

#### `everything-seasoning-eggs` · Everything-seasoning boiled eggs · 🥚 · American
vibes: highProtein, quickEasy · appliances: stovetop · prep 2 / cook 8 min · serves 2 · leftovers: no

- eggs 4 piece
- sesame-seeds 1 tsp
- garlic-powder 0.5 tsp
- onion-powder 0.5 tsp
- salt 1 pinch
- chili-flakes 1 pinch

1. Boil the eggs for 8 minutes, then cool in cold water and peel.
2. Mix the sesame, garlic powder, onion powder, chili and salt.
3. Halve the eggs and dip the cut sides in the seasoning.

#### `quick-cucumber-kimchi` · Quick cucumber kimchi · 🥒 · Korean
vibes: healthyish, lowCalorie · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- cucumber 2 piece (cut into chunks)
- salt 1 tsp
- gochujang 1 tbsp
- garlic 1 clove (crushed)
- fish-sauce 1 tsp
- sugar 1 tsp
- spring-onion 1 piece (sliced)
- sesame-seeds 1 tsp
- rice-cakes 2 piece

1. Toss the cucumber with the salt and leave for 10 minutes, then drain.
2. Mix the gochujang, garlic, fish sauce and sugar and toss with the cucumber.
3. Scatter with spring onion and sesame and eat with rice cakes, or chill for up to 2 days.

#### `marinated-feta-olives` · Marinated feta & olives · 🫒 · Mediterranean
vibes: quickEasy · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- feta 120 g (cubed)
- olives 80 g
- olive-oil 3 tbsp
- lemon 0.5 piece (zest only)
- dried-oregano 1 tsp
- chili-flakes 0.5 tsp
- garlic 1 clove (sliced)
- cucumber 1 piece (cut into sticks)

1. Toss the feta and olives with the oil, lemon zest, oregano, chili and garlic in a jar.
2. Leave for at least 30 minutes, or up to 3 days in the fridge.
3. Serve with cucumber sticks.

#### `grape-cheddar-skewers` · Grape & cheddar skewers · 🍇 · British
vibes: quickEasy, family · appliances: none · prep 5 / cook 0 min · serves 4 · leftovers: no

- grapes 250 g
- cheddar 120 g (cubed)
- walnuts 30 g

1. Thread the grapes and cheddar cubes onto small skewers.
2. Serve with a few walnuts on the side.

#### `parmesan-crisps` · Crunchy parmesan crisps · 🧀 · Italian
vibes: quickEasy, highProtein · appliances: oven · prep 3 / cook 7 min · serves 2 · leftovers: no

- parmesan 50 g (finely grated)
- italian-herbs 0.5 tsp
- chili-flakes 1 pinch

1. Heat the oven to 200°C (400°F) and line a tray.
2. Make 8 small piles of parmesan, flatten slightly and sprinkle with herbs and chili.
3. Bake for 6–7 minutes until golden and lacy, then cool to crisp up.

#### `sweet-potato-rounds-dip` · Air-fryer sweet potato rounds with yogurt dip · 🍠 · Other
vibes: healthyish, family · appliances: airFryer · prep 5 / cook 15 min · serves 2 · leftovers: no

- sweet-potato 1 piece (sliced into thin rounds)
- olive-oil 1 tsp
- paprika 0.5 tsp
- salt 1 pinch
- greek-yogurt 80 g
- lime 0.5 piece

1. Toss the sweet potato with the oil, paprika and salt.
2. Air-fry at 190°C (375°F) for 12–15 minutes, shaking twice, until crisp at the edges.
3. Mix the yogurt with the lime juice and serve for dipping.

#### `chocolate-frozen-grapes` · Chocolate-dipped frozen grapes · 🍇 · Other
vibes: family, healthyish · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- grapes 200 g
- dark-chocolate 30 g (melted)
- sesame-seeds 1 tsp

1. Dip each grape halfway into the melted chocolate.
2. Sprinkle with sesame and lay on a lined tray.
3. Freeze for 1 hour until icy.

#### `hummus-cucumber-cups` · Hummus cucumber cups · 🥒 · Middle Eastern
vibes: healthyish, lowCalorie · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- cucumber 1 piece (cut into thick rounds)
- hummus 100 g
- paprika 1 pinch
- olive-oil 1 tsp

1. Scoop a little out of each cucumber round with a teaspoon to make cups.
2. Fill with hummus.
3. Finish with a drizzle of oil and a pinch of paprika.

#### `spicy-sesame-cucumber-snack` · Spicy sesame cucumber salad · 🥒 · Chinese
vibes: healthyish, quickEasy · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- cucumber 2 piece (very thinly sliced)
- soy-sauce 1 tbsp
- rice-vinegar 1 tbsp
- sesame-oil 2 tsp
- garlic 1 clove (crushed)
- chili-flakes 0.5 tsp
- sugar 1 tsp
- sesame-seeds 2 tsp

1. Slice the cucumber as thinly as you can into a lidded container.
2. Add the soy sauce, vinegar, sesame oil, garlic, chili and sugar.
3. Close the lid, shake hard and top with sesame seeds.
