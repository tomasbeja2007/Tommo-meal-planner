# Codex prompt: trending recipes, batch 5 (100 recipes)

Paste everything below the line into Codex. It is self-contained: the recipes are written out in full.

---

Read `CLAUDE.md` and `BUILD_NOTES.md` (section 3d) first, and follow the project's rules.

## Task

Add the 100 recipes below (45 dinners, 20 lunches, 20 breakfasts, 15 snacks) to the bundled
library as trending recipes, the same way as `Tools/trending_recipes.py`. Add batches 1 to 4 first (in this order) if they aren't in yet.

1. Create `Tools/trending_batch5.py`. Write each recipe with `T(...)` from `trending_recipes.py` (it adds the `trending` tag),
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

#### `marry-me-chicken-rice` · Marry me chicken with rice · 💍 · Italian
vibes: comfort, family, highProtein · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: no

- chicken-thighs 600 g
- italian-herbs 2 tsp
- olive-oil 1 tbsp
- garlic 3 clove (crushed)
- roasted-peppers 120 g (sliced)
- tomato-paste 1 tbsp
- heavy-cream 100 ml
- vegetable-bouillon 1 tsp
- parmesan 30 g (grated)
- spinach 80 g
- long-grain-rice 250 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Season the chicken with the herbs and salt and brown in the oil for 5 minutes on each side, then set aside.
3. Add the garlic, peppers and tomato paste to the pan for 1 minute.
4. Stir in the cream, 150 ml water, the bouillon and parmesan and bring to a simmer.
5. Return the chicken and simmer for 8 minutes until cooked, then stir through the spinach.
6. Spoon over the rice — the sauce is the reason this went viral.

#### `marry-me-white-beans` · Marry me white beans · 💍 · Italian
vibes: quickEasy, onePan, healthyish · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- olive-oil 1 tbsp
- garlic 4 clove (sliced)
- roasted-peppers 150 g (chopped)
- tomato-paste 2 tbsp
- italian-herbs 1 tsp
- chili-flakes 0.5 tsp
- cannellini-beans 720 g (drained)
- vegetable-bouillon 1 tsp
- cream-cheese 80 g
- parmesan 30 g (grated)
- spinach-frozen 150 g
- sourdough 4 slice

1. Cook the garlic in the oil for 1 minute, then add the peppers, tomato paste, herbs and chili for 2 minutes.
2. Add the beans, 200 ml boiling water and the bouillon and simmer for 5 minutes.
3. Stir in the cream cheese and parmesan until silky and pink.
4. Add the spinach and cook until hot.
5. Season and loosen with water if needed.
6. Serve with toast for scooping.

#### `cottage-cheese-alfredo-chicken` · Cottage cheese alfredo with chicken & broccoli · 🥦 · Italian
vibes: highProtein, family, quickEasy · appliances: stovetop, blender · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 300 g
- broccoli 1 piece (cut into florets)
- chicken-thighs 500 g (diced)
- olive-oil 1 tbsp
- cottage-cheese 300 g
- milk 100 ml
- parmesan 40 g (grated)
- garlic 2 clove
- black-pepper 1 tsp
- salt 1 tsp

1. Cook the pasta in salted boiling water, adding the broccoli for the last 4 minutes, then drain.
2. Season the chicken and fry in the oil for 7 minutes until golden and cooked.
3. Blend the cottage cheese, milk, parmesan, garlic and pepper until completely smooth — it turns into alfredo.
4. Pour the sauce into the chicken pan and warm gently without boiling.
5. Toss in the pasta and broccoli.
6. Serve with extra pepper and parmesan.

#### `hidden-veg-tomato-pasta` · Hidden veg tomato pasta · 🍅 · Italian
vibes: family, healthyish, batchFriendly · appliances: stovetop, blender · prep 10 / cook 20 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (chopped)
- carrot 2 piece (chopped)
- zucchini 1 piece (chopped)
- bell-pepper 1 piece (chopped)
- garlic 2 clove
- red-lentils 60 g
- passata 500 g
- penne 350 g
- parmesan 30 g (grated)
- salt 1 tsp

1. Cook the onion, carrot, zucchini and pepper in the oil for 8 minutes until soft.
2. Add the garlic, lentils, passata and 200 ml water and simmer for 12 minutes.
3. Meanwhile, cook the pasta in salted boiling water, then drain.
4. Blend the sauce until silky — kids never spot the five vegetables.
5. Toss with the pasta.
6. Serve with parmesan. The sauce freezes well.

#### `takeout-chicken-fried-rice` · Takeout-style chicken fried rice · 🍚 · Chinese
vibes: fakeaway, quickEasy, family · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- long-grain-rice 300 g
- chicken-thighs 400 g (diced)
- vegetable-oil 2 tbsp
- eggs 3 piece (beaten)
- garlic 2 clove (crushed)
- peas-frozen 150 g
- carrot 1 piece (diced)
- soy-sauce 3 tbsp
- sesame-oil 1 tsp
- spring-onion 4 piece (sliced)

1. Cook the rice for 12 minutes, drain and spread on a tray to steam dry — this is the takeout secret.
2. Stir-fry the chicken in half the oil over a high heat for 6 minutes, then set aside.
3. Scramble the eggs in the rest of the oil and push to one side.
4. Add the garlic, carrot and peas for 2 minutes.
5. Add the rice, chicken and soy sauce and stir-fry for 4 minutes until hot and slightly crisp.
6. Finish with sesame oil and spring onions.

#### `turkey-burgers-sweet-potato-wedges` · Juicy turkey burgers with sweet potato wedges · 🍔 · American
vibes: family, highProtein, healthyish · appliances: oven, stovetop · prep 15 / cook 30 min · serves 4 · leftovers: no

- ground-turkey 500 g
- onion 0.5 piece (grated)
- garlic-powder 1 tsp
- paprika 1 tsp
- sweet-potato 3 piece (cut into wedges)
- olive-oil 1 tbsp
- burger-buns 4 piece
- lettuce 0.25 piece
- tomato 1 piece (sliced)
- greek-yogurt 100 g
- ketchup 1 tbsp
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Toss the wedges with the oil and salt and roast for 30 minutes.
2. Mix the turkey with the grated onion, garlic powder, paprika and salt — the onion keeps it juicy.
3. Shape into 4 burgers and fry for 5 minutes on each side until cooked through.
4. Mix the yogurt with the ketchup for a burger sauce.
5. Toast the buns.
6. Build with sauce, lettuce, tomato and a burger, and serve with the wedges.

#### `lemon-chicken-rice-soup` · Lemony chicken & rice soup · 🍋 · Mediterranean
vibes: comfort, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- celery 2 piece (diced)
- chicken-thighs 500 g
- vegetable-bouillon 3 tsp
- long-grain-rice 120 g
- eggs 2 piece
- lemon 2 piece
- spinach 80 g
- salt 1 tsp

1. Cook the onion, carrot and celery in the oil for 6 minutes.
2. Add the chicken, 1.5 litres boiling water and the bouillon and simmer for 12 minutes, then lift out and shred the chicken.
3. Add the rice and simmer for 12 minutes.
4. Whisk the eggs with the lemon juice, then slowly whisk in a ladle of hot broth.
5. Take the pan off the heat and stir in the egg mixture — it turns the soup silky.
6. Return the chicken with the spinach and season.

#### `pasta-primavera` · 15-minute pasta primavera · 🌱 · Italian
vibes: quickEasy, healthyish, family · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- penne 350 g
- peas-frozen 150 g
- zucchini 1 piece (diced)
- green-beans 150 g (halved)
- olive-oil 2 tbsp
- garlic 2 clove (sliced)
- lemon 1 piece
- cream-cheese 60 g
- parmesan 30 g (grated)
- salt 1 tsp

1. Cook the pasta in salted boiling water, adding the green beans and peas for the last 4 minutes. Save a mug of water and drain.
2. Fry the zucchini and garlic in the oil for 4 minutes until golden.
3. Add the pasta and veg with the cream cheese, lemon zest and juice and a splash of pasta water.
4. Toss until glossy and creamy.
5. Season well.
6. Finish with parmesan.

#### `teriyaki-turkey-meatball-bowl` · Teriyaki turkey meatball rice bowl · 🍱 · Japanese
vibes: family, highProtein, fakeaway · appliances: oven, stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- ground-turkey 500 g
- breadcrumbs 40 g
- eggs 1 piece
- garlic 2 clove (crushed)
- soy-sauce 4 tbsp
- honey 2 tbsp
- cornstarch 1 tsp
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)
- sesame-seeds 1 tsp

1. Heat the oven to 220°C (425°F).
2. Mix the turkey, breadcrumbs, egg, garlic and 1 tbsp soy sauce and roll into 20 meatballs. Roast for 15 minutes.
3. Cook the rice, adding the broccoli for the last 4 minutes, then drain.
4. Simmer the rest of the soy sauce, the honey, cornstarch and 3 tbsp water until glossy.
5. Toss the meatballs in the teriyaki.
6. Serve over rice and broccoli with sesame.

#### `chicken-caprese-traybake` · Chicken caprese traybake · 🍅 · Italian
vibes: onePan, healthyish, highProtein · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: no

- chicken-breast 4 piece
- cherry-tomatoes 300 g
- mozzarella 1 piece (sliced)
- balsamic-vinegar 2 tbsp
- olive-oil 1 tbsp
- italian-herbs 1 tsp
- garlic 2 clove (crushed)
- potato 4 piece (cubed)
- basil 10 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Roast the potatoes with the oil and salt for 10 minutes.
2. Rub the chicken with the herbs, garlic and salt and add to the tray with the tomatoes.
3. Roast for 15 minutes.
4. Lay the mozzarella over the chicken and roast for 3 minutes until melted.
5. Drizzle with the balsamic.
6. Tear over the basil and serve.

#### `pizza-chicken-bake` · Pizza chicken bake · 🍕 · Italian
vibes: family, highProtein, lowCalorie · appliances: oven, stovetop · prep 10 / cook 25 min · serves 4 · leftovers: no

- chicken-breast 4 piece
- passata 250 g
- dried-oregano 1 tsp
- garlic 1 clove (crushed)
- mozzarella 1 piece (torn)
- ham 2 slice (torn)
- bell-pepper 1 piece (sliced)
- olives 30 g (sliced)
- spaghetti 250 g
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Season the chicken and lay in a baking dish.
3. Mix the passata with the oregano, garlic and salt and spoon over the chicken.
4. Top with mozzarella, ham, pepper and olives like a pizza and bake for 25 minutes.
5. Meanwhile, cook the spaghetti and toss with the sauce from the dish.
6. Serve the pizza chicken with the spaghetti.

#### `chicken-chorizo-pasta` · Smoky chicken & chorizo pasta · 🌶️ · Spanish/Portuguese
vibes: comfort, family · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- penne 350 g
- chicken-thighs 400 g (diced)
- chorizo 80 g (diced)
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- paprika 1 tsp
- chopped-tomatoes 400 g
- cream-cheese 50 g
- spinach 60 g
- salt 1 tsp

1. Cook the pasta in salted boiling water, saving a mug of water before draining.
2. Fry the chorizo for 3 minutes until it releases its red oil, then add the chicken for 6 minutes.
3. Add the onion, garlic and paprika and cook for 4 minutes.
4. Pour in the tomatoes and simmer for 6 minutes, then stir in the cream cheese.
5. Toss in the pasta, spinach and a splash of pasta water.
6. Serve hot.

#### `sausage-lentil-stew` · Sausage & red lentil stew · 🥘 · British
vibes: comfort, batchFriendly, onePan · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- sausages 6 piece (cut into chunks)
- onion 1 piece (diced)
- carrot 2 piece (diced)
- garlic 2 clove (crushed)
- paprika 1 tsp
- red-lentils 200 g
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- spinach-frozen 100 g
- wholemeal-bread 4 slice

1. Brown the sausages in a deep pan for 5 minutes.
2. Add the onion and carrot for 5 minutes, then the garlic and paprika.
3. Stir in the lentils, tomatoes, 700 ml boiling water and the bouillon.
4. Simmer for 15 minutes until the lentils have collapsed into a thick stew.
5. Stir in the spinach until hot.
6. Serve with buttered toast.

#### `halloumi-veg-skewers-rice` · Halloumi & veg skewers with herby rice · 🍢 · Mediterranean
vibes: healthyish, family · appliances: oven, stovetop · prep 15 / cook 15 min · serves 4 · leftovers: no

- halloumi 250 g (cubed)
- zucchini 1 piece (cut into chunks)
- bell-pepper 2 piece (cut into chunks)
- red-onion 1 piece (cut into chunks)
- olive-oil 2 tbsp
- dried-oregano 1 tsp
- long-grain-rice 250 g
- parsley 15 g (chopped)
- lemon 1 piece
- greek-yogurt 150 g

1. Heat the oven grill or oven to its hottest setting, 240°C (465°F).
2. Thread the halloumi and vegetables onto skewers and brush with the oil and oregano.
3. Grill for 12–15 minutes, turning once, until charred.
4. Cook the rice in salted boiling water for 12 minutes, drain and stir in the parsley and lemon zest and juice.
5. Season the yogurt with a pinch of salt.
6. Serve the skewers over the herby rice with the yogurt.

#### `crispy-chickpea-tacos` · Crispy chickpea tacos with lime crema · 🌮 · Mexican
vibes: healthyish, quickEasy, fakeaway · appliances: stovetop · prep 10 / cook 10 min · serves 4 · leftovers: no

- chickpeas 480 g (drained and patted dry)
- olive-oil 2 tbsp
- paprika 2 tsp
- cumin 1 tsp
- chili-powder 0.5 tsp
- corn-tortillas 12 piece
- red-cabbage 200 g (shredded)
- lime 2 piece
- greek-yogurt 150 g
- cilantro 10 g
- salt 1 tsp

1. Fry the chickpeas in the oil over a medium-high heat for 8 minutes until crisp and popping.
2. Toss with the spices and salt for the last minute.
3. Toss the cabbage with the juice of 1 lime.
4. Mix the yogurt with the rest of the lime juice.
5. Warm the tortillas.
6. Fill with chickpeas, slaw, lime crema and cilantro.

#### `hoisin-pork-noodles` · Hoisin pork noodles with crunchy veg · 🍜 · Chinese
vibes: quickEasy, fakeaway, family · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- egg-noodles 250 g
- ground-pork 400 g
- vegetable-oil 1 tbsp
- garlic 2 clove (crushed)
- hoisin-sauce 4 tbsp
- soy-sauce 2 tbsp
- cabbage 200 g (shredded)
- carrot 2 piece (cut into matchsticks)
- spring-onion 3 piece (sliced)

1. Cook the noodles for 4 minutes, then drain.
2. Fry the pork in the oil over a high heat for 7 minutes until crispy.
3. Add the garlic, cabbage and carrot and stir-fry for 2 minutes so they stay crunchy.
4. Add the noodles, hoisin and soy sauce.
5. Toss for 2 minutes until glossy.
6. Scatter with spring onions.

#### `air-fryer-nuggets-veggie-fries` · Air-fryer chicken nuggets with veggie fries · 🍗 · American
vibes: family, highProtein · appliances: airFryer · prep 15 / cook 25 min · serves 4 · leftovers: no

- chicken-breast 3 piece (cut into nuggets)
- greek-yogurt 80 g
- breadcrumbs 80 g
- paprika 1 tsp
- garlic-powder 1 tsp
- carrot 3 piece (cut into fries)
- zucchini 1 piece (cut into fries)
- parmesan 20 g (grated)
- olive-oil 1 tbsp
- ketchup 3 tbsp
- salt 1 tsp

1. Toss the carrot and zucchini fries with the oil, parmesan and a pinch of salt.
2. Air-fry at 200°C (400°F) for 12 minutes, shaking halfway, then keep warm.
3. Coat the chicken in the yogurt and salt, then press into the breadcrumbs mixed with the paprika and garlic powder.
4. Air-fry at 200°C (400°F) for 10–12 minutes, turning halfway, until golden.
5. Serve the nuggets and veggie fries with ketchup.
6. Let little ones dip and dunk.

#### `sweet-potato-chickpea-buddha-bowl` · Sweet potato & chickpea buddha bowl · 🥗 · Other
vibes: healthyish, batchFriendly · appliances: oven, stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- sweet-potato 2 piece (cubed)
- chickpeas 480 g (drained)
- olive-oil 2 tbsp
- paprika 2 tsp
- quinoa 200 g
- red-cabbage 150 g (shredded)
- carrot 2 piece (grated)
- tahini 3 tbsp
- lemon 1 piece
- salt 1 tsp

1. Heat the oven to 220°C (425°F). Roast the sweet potato and chickpeas with the oil, paprika and salt for 25 minutes.
2. Simmer the quinoa in 500 ml water for 15 minutes until absorbed.
3. Whisk the tahini, lemon juice and 4 tbsp water into a dressing.
4. Arrange the quinoa, roast tray, cabbage and carrot in bowls in sections.
5. Drizzle generously with the tahini dressing.
6. Pack the leftovers for lunch.

#### `chicken-quinoa-enchilada-skillet` · Chicken & quinoa enchilada skillet · 🌶️ · Mexican
vibes: onePan, highProtein, family · appliances: stovetop · prep 5 / cook 25 min · serves 4 · leftovers: yes

- chicken-thighs 400 g (diced)
- olive-oil 1 tbsp
- onion 1 piece (diced)
- cumin 2 tsp
- chili-powder 1 tsp
- quinoa 200 g
- passata 400 g
- vegetable-bouillon 1 tsp
- black-beans 240 g (drained)
- sweetcorn-tin 165 g (drained)
- cheddar 80 g (grated)
- salt 1 tsp

1. Brown the chicken and onion in the oil in a lidded pan for 6 minutes.
2. Stir in the spices for 1 minute.
3. Add the quinoa, passata, 350 ml boiling water and the bouillon.
4. Cover and simmer for 18 minutes until the quinoa is cooked.
5. Stir in the beans and corn, scatter with cheddar and cover for 2 minutes to melt.
6. Serve straight from the pan.

#### `spicy-sausage-tomato-orzo` · Spicy sausage & tomato orzo · 🍅 · Italian
vibes: onePan, comfort, quickEasy · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- sausages 6 piece (skins removed)
- olive-oil 1 tbsp
- garlic 2 clove (crushed)
- chili-flakes 0.5 tsp
- orzo 300 g
- chopped-tomatoes 400 g
- vegetable-bouillon 1 tsp
- spinach 80 g
- parmesan 30 g (grated)

1. Fry the sausage meat in the oil, breaking it up, for 6 minutes until golden.
2. Add the garlic and chili for 1 minute.
3. Stir in the orzo, tomatoes, 600 ml boiling water and the bouillon.
4. Simmer for 10 minutes, stirring often, until the orzo is tender and creamy.
5. Stir through the spinach.
6. Finish with parmesan.

#### `greek-turkey-meatballs-orzo` · Greek lemon turkey meatballs with orzo · 🍋 · Mediterranean
vibes: highProtein, family, healthyish · appliances: stovetop · prep 15 / cook 20 min · serves 4 · leftovers: no

- ground-turkey 500 g
- feta 80 g (crumbled)
- dried-oregano 2 tsp
- garlic 2 clove (crushed)
- breadcrumbs 30 g
- olive-oil 1 tbsp
- orzo 250 g
- vegetable-bouillon 1 tsp
- lemon 1 piece
- spinach 80 g
- greek-yogurt 100 g

1. Mix the turkey, half the feta, the oregano, garlic and breadcrumbs and roll into 16 meatballs.
2. Brown them in the oil in a deep pan for 6 minutes.
3. Add the orzo, 700 ml boiling water and the bouillon and simmer for 10 minutes, stirring now and then.
4. Stir in the lemon zest and juice and the spinach.
5. Crumble over the rest of the feta.
6. Serve with a spoon of yogurt.

#### `ginger-pork-broccoli-stir-fry` · Ginger pork & broccoli stir-fry · 🫚 · Chinese
vibes: quickEasy, highProtein · appliances: stovetop · prep 5 / cook 12 min · serves 4 · leftovers: no

- ground-pork 500 g
- vegetable-oil 1 tbsp
- ginger 25 g (grated)
- garlic 3 clove (crushed)
- broccoli 1 piece (cut into small florets)
- soy-sauce 3 tbsp
- honey 1 tbsp
- long-grain-rice 250 g
- spring-onion 3 piece (sliced)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Fry the pork in the oil over a high heat for 7 minutes until crispy.
3. Add the ginger and garlic for 1 minute — lots of ginger is the point.
4. Add the broccoli with 3 tbsp water and cook for 3 minutes.
5. Stir in the soy sauce and honey.
6. Serve over rice with spring onions.

#### `creamy-mushroom-spinach-pasta` · Creamy mushroom & spinach pasta · 🍄 · Italian
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 350 g
- mushrooms 300 g (sliced)
- butter 1 tbsp
- olive-oil 1 tbsp
- garlic 3 clove (crushed)
- cream-cheese 100 g
- spinach-frozen 150 g
- parmesan 30 g (grated)
- black-pepper 1 tsp
- salt 1 tsp

1. Cook the pasta in salted boiling water, saving a mug of water before draining.
2. Fry the mushrooms in the butter and oil over a high heat for 7 minutes until golden — don't crowd the pan.
3. Add the garlic for 1 minute.
4. Stir in the cream cheese, spinach and a splash of pasta water until creamy.
5. Toss in the pasta and parmesan.
6. Finish with lots of black pepper.

#### `lentil-sweet-potato-curry` · Red lentil & sweet potato curry · 🍛 · Indian
vibes: healthyish, batchFriendly, comfort · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- vegetable-oil 1 tbsp
- onion 1 piece (diced)
- garlic 3 clove (crushed)
- ginger 15 g (grated)
- curry-powder 1 tbsp
- red-lentils 200 g
- sweet-potato 2 piece (cubed)
- chopped-tomatoes 400 g
- coconut-milk 200 ml
- spinach-frozen 100 g
- basmati-rice 250 g
- salt 1 tsp

1. Cook the onion in the oil for 5 minutes, then add the garlic, ginger and curry powder.
2. Add the lentils, sweet potato, tomatoes, coconut milk and 400 ml water.
3. Simmer for 20 minutes until the lentils are soft and the sweet potato tender.
4. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
5. Stir the spinach into the curry and season.
6. Serve over the rice.

#### `three-bean-chili` · Three-bean chili · 🌶️ · Mexican
vibes: healthyish, batchFriendly, onePan · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- bell-pepper 1 piece (diced)
- garlic 3 clove (crushed)
- chili-powder 2 tsp
- cumin 2 tsp
- paprika 1 tsp
- chopped-tomatoes 800 g
- kidney-beans 240 g (drained)
- black-beans 240 g (drained)
- chickpeas 240 g (drained)
- long-grain-rice 250 g
- greek-yogurt 100 g
- salt 1 tsp

1. Cook the onion and pepper in the oil for 6 minutes.
2. Add the garlic and spices for 1 minute.
3. Add the tomatoes and all the beans and simmer for 20 minutes until thick.
4. Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.
5. Season the chili.
6. Serve over rice with a spoon of yogurt. It freezes brilliantly.

#### `broccoli-cheddar-baked-potatoes` · Broccoli cheddar stuffed potatoes · 🥔 · American
vibes: comfort, family · appliances: microwave, stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- potato 4 piece
- broccoli 1 piece (cut into small florets)
- cheddar 120 g (grated)
- greek-yogurt 150 g
- spring-onion 2 piece (sliced)
- ham 4 slice (chopped)
- butter 1 tbsp
- salt 1 tsp

1. Prick the potatoes and microwave for 12–15 minutes, turning halfway, until soft.
2. Boil the broccoli for 4 minutes, then drain.
3. Halve the potatoes and scoop the insides into a bowl.
4. Mash with the butter, yogurt, most of the cheddar, the broccoli, ham, spring onion and salt.
5. Pile back into the skins and top with the rest of the cheese.
6. Microwave or grill for 2 minutes until melted.

#### `lemony-chickpea-spinach-pasta` · Lemony chickpea & spinach pasta · 🍋 · Mediterranean
vibes: quickEasy, healthyish · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 300 g
- olive-oil 3 tbsp
- garlic 4 clove (sliced)
- chickpeas 480 g (drained)
- chili-flakes 0.5 tsp
- spinach 100 g
- lemon 1 piece
- parmesan 40 g (grated)
- salt 1 tsp

1. Cook the pasta in salted boiling water, saving a mug of water before draining.
2. Fry the garlic and chickpeas in the oil for 6 minutes until the chickpeas are golden.
3. Add the chili for 30 seconds.
4. Toss in the pasta, spinach, lemon zest and juice and a splash of pasta water.
5. Stir until the spinach wilts and the sauce is glossy.
6. Finish with parmesan.

#### `beef-bean-nachos-traybake` · Loaded beef & bean nachos traybake · 🧀 · Mexican
vibes: fakeaway, family · appliances: oven, stovetop · prep 10 / cook 20 min · serves 4 · leftovers: no

- corn-tortillas 12 piece (cut into triangles)
- olive-oil 1 tbsp
- ground-beef 400 g
- chili-powder 2 tsp
- cumin 1 tsp
- black-beans 240 g (drained)
- passata 150 g
- cheddar 120 g (grated)
- salsa 150 g
- greek-yogurt 100 g
- salt 1 tsp

1. Heat the oven to 200°C (400°F). Toss the tortilla triangles with the oil and bake on a large tray for 8 minutes.
2. Brown the beef with the spices and salt for 7 minutes, then add the beans and passata for 3 minutes.
3. Spoon the beef over the chips and scatter with cheddar.
4. Bake for 6 minutes until the cheese bubbles.
5. Top with salsa and dollops of yogurt.
6. Put it in the middle of the table and dig in.

#### `honey-mustard-chicken-traybake` · Honey mustard chicken & potato traybake · 🍯 · British
vibes: onePan, family · appliances: oven · prep 10 / cook 35 min · serves 4 · leftovers: yes

- chicken-thighs 700 g
- potato 5 piece (cut into chunks)
- carrot 3 piece (cut into batons)
- olive-oil 1 tbsp
- dijon-mustard 2 tbsp
- honey 2 tbsp
- garlic 2 clove (crushed)
- dried-thyme 1 tsp
- green-beans 200 g
- salt 1 tsp

1. Heat the oven to 220°C (425°F).
2. Toss the potatoes and carrots with the oil and salt on a large tray and roast for 10 minutes.
3. Mix the mustard, honey, garlic and thyme and coat the chicken.
4. Add the chicken to the tray and roast for 20 minutes.
5. Add the green beans and roast for 5 minutes more.
6. Spoon the sticky juices over everything.

#### `one-pan-paprika-chicken-rice` · One-pan paprika chicken & rice · 🍗 · Spanish/Portuguese
vibes: onePan, family · appliances: stovetop · prep 10 / cook 30 min · serves 4 · leftovers: yes

- chicken-thighs 600 g
- paprika 3 tsp
- garlic-powder 1 tsp
- olive-oil 1 tbsp
- onion 1 piece (diced)
- bell-pepper 2 piece (sliced)
- long-grain-rice 250 g
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- peas-frozen 150 g
- salt 1 tsp

1. Rub the chicken with 2 tsp paprika, the garlic powder and salt and brown in the oil for 4 minutes on each side. Set aside.
2. Cook the onion and peppers in the pan for 5 minutes with the rest of the paprika.
3. Stir in the rice, tomatoes, 450 ml boiling water and the bouillon.
4. Sit the chicken on top, cover and simmer for 18 minutes.
5. Scatter with peas, cover and cook for 3 minutes.
6. Leave to stand for 5 minutes before serving.

#### `kimchi-butter-udon` · Kimchi butter udon · 🍜 · Korean
vibes: quickEasy, comfort · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- udon-noodles 2 piece
- butter 2 tbsp
- kimchi 150 g (chopped)
- gochujang 1 tsp
- soy-sauce 1 tbsp
- eggs 2 piece
- spring-onion 2 piece (sliced)
- sesame-seeds 1 tsp

1. Loosen the udon in boiling water for 2 minutes, then drain.
2. Melt the butter and fry the kimchi for 3 minutes until caramelised.
3. Stir in the gochujang and soy sauce, then toss in the noodles.
4. Push to one side and fry the eggs in the same pan.
5. Serve the noodles topped with a fried egg.
6. Scatter with spring onion and sesame.

#### `shakshuka-baked-chickpeas` · Shakshuka-style eggs with chickpeas · 🍳 · Middle Eastern
vibes: onePan, healthyish, quickEasy · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- olive-oil 1 tbsp
- onion 1 piece (diced)
- bell-pepper 1 piece (diced)
- garlic 2 clove (crushed)
- cumin 1 tsp
- paprika 1 tsp
- chopped-tomatoes 800 g
- chickpeas 480 g (drained)
- eggs 8 piece
- feta 60 g (crumbled)
- pita-bread 4 piece

1. Cook the onion and pepper in the oil in a wide pan for 6 minutes.
2. Add the garlic and spices for 1 minute.
3. Add the tomatoes and chickpeas and simmer for 8 minutes until thick.
4. Make 8 wells, crack in the eggs, cover and cook for 6 minutes until the whites set.
5. Scatter with feta.
6. Serve with warm pittas for dipping.

#### `sweet-potato-spinach-frittata` · Sweet potato & spinach frittata · 🍳 · Other
vibes: healthyish, highProtein, batchFriendly · appliances: stovetop, oven · prep 10 / cook 25 min · serves 4 · leftovers: yes

- sweet-potato 2 piece (finely diced)
- eggs 8 piece
- spinach 100 g
- red-onion 1 piece (sliced)
- feta 80 g (crumbled)
- olive-oil 1 tbsp
- lettuce 0.5 piece
- salt 1 tsp

1. Fry the sweet potato and onion in the oil in an ovenproof pan, covered, for 10 minutes until tender.
2. Add the spinach and stir until wilted.
3. Whisk the eggs with the salt and pour over.
4. Crumble over the feta and cook for 4 minutes until the edges set.
5. Grill for 4–5 minutes until puffed and golden.
6. Cut into wedges and serve with a green salad.

#### `smoky-sausage-cabbage-skillet` · Smoky sausage & cabbage skillet · 🥬 · Other
vibes: onePan, quickEasy, comfort · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- sausages 6 piece (sliced)
- olive-oil 1 tbsp
- onion 1 piece (sliced)
- cabbage 600 g (shredded)
- paprika 2 tsp
- garlic 2 clove (crushed)
- red-wine-vinegar 1 tbsp
- potato 4 piece (cubed)
- dijon-mustard 1 tbsp
- salt 1 tsp

1. Boil the potatoes for 10 minutes, then drain.
2. Brown the sausage slices in the oil for 5 minutes.
3. Add the onion, cabbage, paprika and garlic and cook for 8 minutes until the cabbage is soft and caramelised at the edges.
4. Add the potatoes and fry for 3 minutes.
5. Stir in the vinegar and mustard.
6. Season and serve.

#### `bang-bang-chicken-bowl` · Air-fryer bang bang chicken bowl · 🍗 · American
vibes: fakeaway, family, highProtein · appliances: airFryer, stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- chicken-thighs 500 g (cut into bite-size pieces)
- cornstarch 3 tbsp
- long-grain-rice 250 g
- mayonnaise 3 tbsp
- sweet-chili-sauce 3 tbsp
- sriracha 1 tsp
- cabbage 200 g (shredded)
- cucumber 1 piece (sliced)
- spring-onion 2 piece (sliced)
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Toss the chicken with the salt, then the cornstarch.
3. Air-fry at 200°C (400°F) for 14 minutes, shaking halfway, until crisp.
4. Mix the mayonnaise, sweet chili sauce and sriracha into bang bang sauce.
5. Toss the chicken in half the sauce.
6. Serve over rice with cabbage, cucumber, spring onions and the rest of the sauce.

#### `cheeseburger-quesadillas` · Cheeseburger quesadillas · 🍔 · American
vibes: fakeaway, family, quickEasy · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- ground-beef 400 g
- onion 0.5 piece (finely diced)
- ketchup 2 tbsp
- dijon-mustard 1 tsp
- tortillas 4 piece
- cheddar 120 g (grated)
- lettuce 0.25 piece (shredded)
- tomato 1 piece (diced)
- mayonnaise 2 tbsp
- salt 1 tsp

1. Brown the beef and onion with the salt for 7 minutes, then stir in the ketchup and mustard.
2. Mix the mayonnaise with a little extra ketchup for a burger sauce.
3. Scatter cheese over half of each tortilla, add the beef and more cheese, and fold.
4. Cook in a dry pan for 3 minutes on each side until crisp and melted.
5. Cut into wedges.
6. Serve with lettuce, tomato and the burger sauce for dipping.

#### `one-pot-taco-pasta` · One-pot taco pasta · 🌮 · Mexican
vibes: onePan, family, comfort · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- ground-beef 400 g
- onion 1 piece (diced)
- chili-powder 2 tsp
- cumin 1 tsp
- paprika 1 tsp
- penne 300 g
- salsa 200 g
- vegetable-bouillon 1 tsp
- black-beans 240 g (drained)
- cheddar 100 g (grated)
- spring-onion 2 piece (sliced)

1. Brown the beef and onion in a large pan for 7 minutes.
2. Stir in the spices for 1 minute.
3. Add the pasta, salsa, 700 ml boiling water and the bouillon and bring to the boil.
4. Simmer for 12 minutes, stirring often, until the pasta is tender and saucy.
5. Stir in the beans and most of the cheddar.
6. Top with the rest of the cheese and spring onions.

#### `buffalo-chicken-pasta` · Creamy buffalo chicken pasta · 🔥 · American
vibes: comfort, highProtein · appliances: stovetop · prep 5 / cook 15 min · serves 4 · leftovers: no

- penne 300 g
- chicken-thighs 500 g (diced)
- olive-oil 1 tbsp
- garlic-powder 1 tsp
- hot-sauce 4 tbsp
- cream-cheese 100 g
- milk 100 ml
- cheddar 60 g (grated)
- celery 2 piece (finely sliced)
- salt 1 tsp

1. Cook the pasta in salted boiling water, then drain.
2. Season the chicken with garlic powder and salt and fry in the oil for 7 minutes.
3. Add the hot sauce, cream cheese and milk and stir into a creamy orange sauce.
4. Stir in the cheddar until melted.
5. Toss in the pasta.
6. Top with crunchy celery for that wings-night feel.

#### `ramen-noodle-stir-fry` · Ramen noodle stir-fry with egg & veg · 🍜 · Japanese
vibes: quickEasy, fakeaway · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- egg-noodles 150 g
- vegetable-oil 1 tbsp
- mixed-veg-frozen 250 g
- garlic 2 clove (crushed)
- soy-sauce 2 tbsp
- honey 1 tsp
- sriracha 1 tsp
- eggs 2 piece
- spring-onion 2 piece (sliced)

1. Cook the noodles for 3 minutes, then drain.
2. Stir-fry the frozen veg and garlic in the oil over a high heat for 4 minutes.
3. Add the noodles, soy sauce, honey and sriracha and toss for 2 minutes.
4. Push to one side and scramble the eggs into the pan.
5. Toss everything together.
6. Top with spring onions.

#### `chicken-mushroom-stroganoff` · Chicken & mushroom stroganoff · 🍄 · Other
vibes: comfort, quickEasy, family · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- chicken-thighs 500 g (sliced)
- olive-oil 1 tbsp
- onion 1 piece (sliced)
- mushrooms 250 g (sliced)
- garlic 2 clove (crushed)
- paprika 2 tsp
- vegetable-bouillon 1 tsp
- dijon-mustard 1 tsp
- sour-cream 150 g
- long-grain-rice 250 g
- salt 1 tsp

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Brown the chicken in the oil for 6 minutes, then set aside.
3. Cook the onion and mushrooms for 6 minutes until golden, then add the garlic and paprika.
4. Add 200 ml boiling water, the bouillon and mustard and bubble for 2 minutes.
5. Return the chicken, take off the heat and stir in the sour cream.
6. Serve over the rice.

#### `air-fryer-falafel-wraps` · Air-fryer falafel wraps · 🧆 · Middle Eastern
vibes: healthyish, fakeaway · appliances: airFryer, blender · prep 15 / cook 15 min · serves 4 · leftovers: no

- chickpeas 480 g (drained and patted dry)
- onion 0.5 piece
- garlic 2 clove
- parsley 20 g
- cumin 2 tsp
- flour 2 tbsp
- olive-oil 1 tbsp
- tortillas 4 piece
- hummus 120 g
- lettuce 0.5 piece (shredded)
- tomato 2 piece (diced)
- salt 1 tsp

1. Pulse the chickpeas, onion, garlic, parsley, cumin, flour and salt in a blender until coarse.
2. Shape into 16 small patties and brush with the oil.
3. Air-fry at 200°C (400°F) for 12–15 minutes, turning halfway, until crisp.
4. Spread the tortillas with hummus.
5. Fill with lettuce, tomato and falafel.
6. Wrap tightly and cut in half.

#### `lemon-garlic-chicken-green-beans` · Lemon garlic chicken & green bean skillet · 🍋 · Other
vibes: quickEasy, highProtein, onePan · appliances: stovetop · prep 5 / cook 20 min · serves 4 · leftovers: no

- chicken-thighs 600 g
- olive-oil 1 tbsp
- green-beans 300 g
- garlic 4 clove (sliced)
- lemon 1 piece
- butter 1 tbsp
- vegetable-bouillon 1 tsp
- potato 4 piece (cubed)
- salt 1 tsp
- black-pepper 1 pinch

1. Boil the potatoes for 10 minutes, then drain.
2. Season the chicken and cook in the oil for 6 minutes on each side until golden and cooked. Set aside.
3. Add the potatoes and green beans to the pan and fry for 5 minutes.
4. Add the garlic, butter, lemon juice, bouillon and 4 tbsp water and bubble for 1 minute.
5. Return the chicken and spoon over the lemony sauce.
6. Finish with black pepper.

#### `spinach-feta-stuffed-chicken` · Spinach & feta stuffed chicken · 🥬 · Mediterranean
vibes: highProtein, healthyish · appliances: oven, stovetop · prep 15 / cook 25 min · serves 4 · leftovers: no

- chicken-breast 4 piece
- spinach-frozen 150 g (thawed and squeezed)
- feta 100 g (crumbled)
- cream-cheese 50 g
- garlic 1 clove (crushed)
- paprika 1 tsp
- olive-oil 1 tbsp
- couscous 200 g
- cherry-tomatoes 200 g (halved)
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Mix the spinach, feta, cream cheese and garlic.
3. Cut a deep pocket into each chicken breast and stuff with the filling.
4. Rub with the oil, paprika and salt and bake for 22–25 minutes until cooked through.
5. Cover the couscous with 300 ml boiling water and a pinch of salt for 5 minutes, then fluff and stir in the tomatoes.
6. Slice the chicken to show off the filling and serve on the couscous.

#### `peanut-tofu-lettuce-wraps` · Crispy peanut tofu lettuce wraps · 🥬 · Thai
vibes: healthyish, quickEasy · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: no

- tofu 600 g (crumbled)
- vegetable-oil 2 tbsp
- garlic 2 clove (crushed)
- soy-sauce 3 tbsp
- peanut-butter 3 tbsp
- lime 1 piece
- honey 1 tbsp
- lettuce 1 piece (leaves separated)
- carrot 2 piece (grated)
- long-grain-rice 200 g
- peanuts 30 g (chopped)

1. Cook the rice in salted boiling water for 12 minutes, then drain.
2. Fry the crumbled tofu in the oil over a high heat for 10 minutes until golden and crispy.
3. Whisk the peanut butter, soy sauce, lime juice, honey and 3 tbsp hot water.
4. Add the garlic to the tofu for 30 seconds, then half the sauce.
5. Spoon rice and tofu into lettuce cups with carrot.
6. Drizzle with the rest of the sauce and scatter with peanuts.

#### `sticky-honey-garlic-tofu-bowl` · Sticky honey garlic tofu bowl · 🍯 · Chinese
vibes: healthyish, fakeaway, quickEasy · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: no

- tofu 800 g (pressed and cubed)
- cornstarch 2 tbsp
- vegetable-oil 2 tbsp
- garlic 5 clove (crushed)
- honey 3 tbsp
- soy-sauce 3 tbsp
- rice-vinegar 1 tbsp
- long-grain-rice 250 g
- broccoli 1 piece (cut into florets)
- sesame-seeds 1 tsp

1. Cook the rice, adding the broccoli for the last 4 minutes, then drain.
2. Toss the tofu in the cornstarch.
3. Fry in the oil for 10 minutes, turning, until crisp all over.
4. Add the garlic for 30 seconds, then the honey, soy sauce and vinegar.
5. Toss for 1 minute until the tofu is sticky and glazed.
6. Serve over the rice and broccoli with sesame seeds.

### Lunchs (20)

#### `cottage-cheese-egg-salad` · High-protein cottage cheese egg salad · 🥚 · American
vibes: highProtein, quickEasy · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- eggs 4 piece
- cottage-cheese 120 g
- dijon-mustard 1 tsp
- spring-onion 1 piece (sliced)
- wholemeal-bread 4 slice
- lettuce 0.25 piece
- paprika 1 pinch

1. Boil the eggs for 9 minutes, then cool and peel.
2. Mash the eggs with the cottage cheese, mustard, spring onion and a pinch of salt.
3. Pile onto the bread with lettuce and a pinch of paprika.
4. Close the sandwiches and cut in half.

#### `greek-yogurt-ranch-chicken-wrap` · Greek yogurt ranch chicken wraps · 🌯 · American
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 10 min · serves 2 · leftovers: no

- chicken-breast 1 piece (sliced)
- olive-oil 1 tsp
- greek-yogurt 80 g
- garlic-powder 0.5 tsp
- dried-thyme 0.5 tsp
- tortillas 2 piece
- lettuce 0.25 piece (shredded)
- tomato 1 piece (sliced)
- cheddar 30 g (grated)

1. Cook the chicken in the oil for 7 minutes until golden.
2. Mix the yogurt with the garlic powder, thyme and a pinch of salt for a quick ranch.
3. Fill the tortillas with lettuce, tomato, chicken, cheese and ranch.
4. Roll up tightly and toast seam-side down for 1 minute.

#### `pesto-pasta-salad-jars` · Pesto pasta salad jars · 🫙 · Italian
vibes: batchFriendly, quickEasy · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: yes

- penne 250 g
- pesto 4 tbsp
- lemon 1 piece
- cherry-tomatoes 200 g (halved)
- cucumber 1 piece (diced)
- mozzarella 1 piece (diced)
- spinach 60 g

1. Cook the pasta, then rinse under cold water and drain.
2. Toss with the pesto and lemon juice.
3. Layer into 4 jars with the tomatoes, cucumber, mozzarella and spinach on top.
4. Keep for 3 days. Shake into a bowl to eat.

#### `greek-yogurt-caesar-pasta-salad` · Greek yogurt Caesar pasta salad · 🥗 · American
vibes: highProtein, batchFriendly · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: yes

- penne 250 g
- chicken-breast 2 piece
- greek-yogurt 120 g
- parmesan 40 g (grated)
- lemon 1 piece
- dijon-mustard 1 tsp
- garlic 1 clove (crushed)
- lettuce 0.5 piece (chopped)
- black-pepper 1 tsp

1. Cook the pasta, then rinse cold. Poach the chicken in simmering water for 12 minutes, then slice.
2. Whisk the yogurt, half the parmesan, lemon juice, mustard, garlic and pepper into a lighter Caesar dressing.
3. Toss the pasta and chicken in the dressing.
4. Fold in the lettuce just before eating and finish with the rest of the parmesan.

#### `hummus-pasta-salad` · Creamy hummus pasta salad · 🍝 · Mediterranean
vibes: healthyish, quickEasy · appliances: stovetop · prep 10 / cook 12 min · serves 4 · leftovers: yes

- penne 250 g
- hummus 200 g
- lemon 1 piece
- cucumber 1 piece (diced)
- cherry-tomatoes 200 g (halved)
- red-onion 0.25 piece (finely diced)
- chickpeas 240 g (drained)
- paprika 1 tsp

1. Cook the pasta, then rinse under cold water and drain.
2. Loosen the hummus with the lemon juice and 3 tbsp water into a creamy dressing.
3. Toss the pasta with the dressing, cucumber, tomatoes, onion and chickpeas.
4. Dust with paprika and pack for the week.

#### `sweet-potato-black-bean-salad` · Roasted sweet potato & black bean salad · 🍠 · Mexican
vibes: healthyish, batchFriendly · appliances: oven · prep 10 / cook 25 min · serves 4 · leftovers: yes

- sweet-potato 2 piece (cubed)
- olive-oil 2 tbsp
- chili-powder 1 tsp
- black-beans 480 g (drained)
- sweetcorn-tin 165 g (drained)
- red-onion 0.5 piece (finely diced)
- lime 2 piece
- cilantro 15 g (chopped)
- feta 60 g (crumbled)

1. Heat the oven to 220°C (425°F). Roast the sweet potato with half the oil and the chili powder for 25 minutes.
2. Whisk the lime juice with the rest of the oil and a pinch of salt.
3. Toss the warm sweet potato with the beans, sweetcorn, onion and dressing.
4. Scatter with cilantro and feta. It keeps for 3 days.

#### `avocado-egg-salad-wraps` · Avocado egg salad wraps · 🥑 · American
vibes: quickEasy, healthyish · appliances: stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- eggs 4 piece
- avocado 1 piece
- lemon 0.5 piece
- spring-onion 1 piece (sliced)
- tortillas 2 piece
- spinach 30 g
- chili-flakes 1 pinch

1. Boil the eggs for 9 minutes, then cool, peel and chop.
2. Mash the avocado with the lemon juice and a pinch of salt, then fold in the eggs and spring onion.
3. Spread over the tortillas with the spinach and chili.
4. Roll up and cut in half.

#### `carrot-ginger-soup` · Carrot & ginger soup · 🥕 · Other
vibes: healthyish, batchFriendly, lowCalorie · appliances: stovetop, blender · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 8 piece (chopped)
- ginger 25 g (grated)
- red-lentils 80 g
- vegetable-bouillon 3 tsp
- coconut-milk 100 ml
- sourdough 4 slice

1. Cook the onion in the oil for 5 minutes, then add the ginger for 1 minute.
2. Add the carrots, lentils, 1 litre boiling water and the bouillon and simmer for 20 minutes.
3. Blend with the coconut milk until velvety — the lentils make it creamy and filling.
4. Serve with toast.

#### `creamy-tomato-red-lentil-soup` · Creamy tomato & red lentil soup · 🍅 · Other
vibes: healthyish, batchFriendly, comfort · appliances: stovetop, blender · prep 5 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- paprika 1 tsp
- red-lentils 150 g
- chopped-tomatoes 800 g
- vegetable-bouillon 2 tsp
- greek-yogurt 80 g
- sourdough 4 slice

1. Cook the onion and garlic in the oil for 5 minutes, then add the paprika.
2. Add the lentils, tomatoes, 700 ml boiling water and the bouillon and simmer for 20 minutes.
3. Blend until smooth.
4. Serve with a swirl of yogurt and toast for dunking.

#### `chicken-vegetable-soup` · Hearty chicken & vegetable soup · 🍲 · British
vibes: comfort, healthyish, batchFriendly · appliances: stovetop · prep 10 / cook 25 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- carrot 2 piece (diced)
- celery 2 piece (diced)
- potato 2 piece (diced)
- chicken-thighs 400 g
- vegetable-bouillon 3 tsp
- peas-frozen 100 g
- dried-thyme 1 tsp

1. Cook the onion, carrot and celery in the oil for 6 minutes.
2. Add the potatoes, chicken, thyme, 1.2 litres boiling water and the bouillon and simmer for 18 minutes.
3. Lift out the chicken, shred it and return with the peas.
4. Season well and serve.

#### `pizza-quesadilla` · Pizza quesadilla · 🍕 · Italian
vibes: quickEasy, family · appliances: stovetop · prep 3 / cook 6 min · serves 2 · leftovers: no

- tortillas 2 piece
- passata 60 g
- dried-oregano 0.5 tsp
- mozzarella 1 piece (grated)
- ham 2 slice (torn)
- bell-pepper 0.5 piece (diced)

1. Spread half of each tortilla with passata and sprinkle with oregano.
2. Top with mozzarella, ham and pepper and fold over.
3. Cook in a dry pan for 3 minutes on each side until crisp and stretchy.
4. Cut into wedges and dip in the rest of the passata.

#### `chicken-burrito-lunch-jars` · Chicken burrito lunch jars · 🫙 · Mexican
vibes: batchFriendly, highProtein · appliances: stovetop · prep 10 / cook 15 min · serves 4 · leftovers: yes

- long-grain-rice 200 g
- chicken-thighs 400 g (diced)
- paprika 1 tsp
- cumin 1 tsp
- black-beans 240 g (drained)
- sweetcorn-tin 165 g (drained)
- salsa 200 g
- lettuce 0.5 piece (shredded)
- lime 1 piece

1. Cook the rice, drain and stir in the lime juice.
2. Fry the chicken with the spices and a pinch of salt for 8 minutes.
3. Layer 4 jars with salsa, rice, beans, sweetcorn, chicken and lettuce on top.
4. Keep for 3 days and tip into a bowl to eat, warm or cold.

#### `spicy-chickpea-pitta-pockets` · Spicy smashed chickpea pitta pockets · 🥙 · Middle Eastern
vibes: healthyish, quickEasy · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- chickpeas 240 g (drained)
- greek-yogurt 40 g
- sriracha 2 tsp
- lemon 0.5 piece
- pita-bread 2 piece
- cucumber 0.5 piece (sliced)
- lettuce 0.25 piece (shredded)

1. Smash the chickpeas with a fork, leaving some chunky.
2. Mix in the yogurt, sriracha, lemon juice and a pinch of salt.
3. Split the pittas open.
4. Fill with lettuce, cucumber and the spicy chickpeas.

#### `tuna-sweetcorn-jacket-potatoes` · Tuna sweetcorn jacket potatoes · 🥔 · British
vibes: highProtein, quickEasy · appliances: microwave · prep 5 / cook 12 min · serves 2 · leftovers: no

- potato 2 piece
- canned-tuna 145 g (drained)
- greek-yogurt 60 g
- sweetcorn-tin 80 g (drained)
- spring-onion 1 piece (sliced)
- cheddar 30 g (grated)

1. Prick the potatoes and microwave for 10–12 minutes, turning halfway, until soft.
2. Mix the tuna, yogurt, sweetcorn, spring onion and a pinch of pepper.
3. Split the potatoes and fluff the insides.
4. Pile in the tuna and top with cheddar.

#### `protein-bento-box` · Protein bento lunch box · 🍱 · Other
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 8 min · serves 2 · leftovers: no

- eggs 2 piece
- hummus 80 g
- cucumber 0.5 piece (cut into sticks)
- carrot 1 piece (cut into sticks)
- cheddar 40 g (cubed)
- ham 2 slice (rolled)
- rice-cakes 4 piece
- grapes 100 g

1. Boil the eggs for 8 minutes, then cool, peel and halve.
2. Divide the hummus between two boxes.
3. Pack the eggs, veg sticks, cheese, ham, rice cakes and grapes around it.
4. Keep chilled until lunch.

#### `peanut-chicken-crunch-wraps` · Peanut chicken crunch wraps · 🥜 · Thai
vibes: highProtein, quickEasy · appliances: stovetop · prep 10 / cook 8 min · serves 2 · leftovers: no

- chicken-thighs 250 g (sliced)
- soy-sauce 1 tbsp
- peanut-butter 2 tbsp
- lime 0.5 piece
- tortillas 2 piece
- red-cabbage 80 g (shredded)
- carrot 1 piece (grated)
- peanuts 15 g (chopped)

1. Fry the chicken with the soy sauce for 7 minutes until sticky.
2. Whisk the peanut butter with the lime juice and 2 tbsp hot water.
3. Fill the tortillas with cabbage, carrot, chicken, peanut sauce and peanuts.
4. Roll up tightly and toast seam-side down for 1 minute.

#### `mediterranean-tuna-salad` · No-mayo Mediterranean tuna salad · 🐟 · Mediterranean
vibes: highProtein, healthyish · appliances: none · prep 10 / cook 0 min · serves 2 · leftovers: no

- canned-tuna 145 g (drained)
- cannellini-beans 240 g (drained)
- cucumber 0.5 piece (diced)
- tomato 2 piece (diced)
- red-onion 0.25 piece (finely diced)
- olive-oil 2 tbsp
- lemon 1 piece
- dried-oregano 1 tsp

1. Whisk the oil, lemon juice and oregano with a pinch of salt.
2. Toss the beans, cucumber, tomato and onion in the dressing.
3. Flake over the tuna.
4. Eat straight away or pack for later.

#### `smoky-chickpea-pepper-soup` · Smoky chickpea & roasted pepper soup · 🌶️ · Spanish/Portuguese
vibes: healthyish, batchFriendly · appliances: stovetop, blender · prep 5 / cook 20 min · serves 4 · leftovers: yes

- olive-oil 1 tbsp
- onion 1 piece (diced)
- garlic 2 clove (crushed)
- paprika 2 tsp
- roasted-peppers 300 g
- chickpeas 480 g (drained)
- chopped-tomatoes 400 g
- vegetable-bouillon 2 tsp
- greek-yogurt 80 g

1. Cook the onion and garlic in the oil for 5 minutes, then add the paprika.
2. Add the peppers, chickpeas, tomatoes, 600 ml boiling water and the bouillon and simmer for 15 minutes.
3. Blend half the soup and stir it back in for a creamy but chunky texture.
4. Serve with a swirl of yogurt.

#### `black-bean-corn-quesadillas` · Black bean & corn quesadillas · 🫓 · Mexican
vibes: quickEasy, family · appliances: stovetop · prep 5 / cook 8 min · serves 2 · leftovers: no

- black-beans 240 g (drained)
- sweetcorn-tin 80 g (drained)
- cumin 1 tsp
- tortillas 2 piece
- cheddar 60 g (grated)
- salsa 80 g
- greek-yogurt 60 g

1. Mash half the beans with the cumin, then stir in the rest and the sweetcorn.
2. Spread over half of each tortilla, scatter with cheese and fold.
3. Cook in a dry pan for 3 minutes on each side until golden and melted.
4. Serve with salsa and yogurt.

#### `egg-fried-rice-lunchbox` · 10-minute egg fried rice lunchbox · 🍳 · Chinese
vibes: quickEasy, batchFriendly · appliances: stovetop, microwave · prep 2 / cook 8 min · serves 2 · leftovers: no

- microwave-rice 1 piece
- eggs 3 piece (beaten)
- vegetable-oil 1 tbsp
- peas-frozen 100 g
- soy-sauce 2 tbsp
- spring-onion 2 piece (sliced)

1. Heat the oil in a wok and scramble the eggs until just set, then push to one side.
2. Add the peas and rice and stir-fry for 4 minutes until hot.
3. Toss with the soy sauce and spring onions.
4. Eat hot, or pack and reheat for lunch.

### Breakfasts (20)

#### `brownie-baked-oats` · Chocolate brownie baked oats · 🍫 · Other
vibes: family, comfort · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 100 g
- banana 1 piece
- eggs 1 piece
- milk 150 ml
- dark-chocolate 30 g (half melted, half chopped)
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F).
2. Blend the oats, banana, egg, milk, baking powder and melted chocolate until smooth.
3. Pour into two small dishes and push in the chopped chocolate.
4. Bake for 22–25 minutes so the middle stays gooey like a brownie.

#### `apple-pie-baked-oats` · Apple pie baked oats · 🍏 · Other
vibes: family, comfort · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 100 g
- apple 1 piece (half grated, half sliced)
- eggs 1 piece
- milk 150 ml
- cinnamon 1 tsp
- maple-syrup 1 tbsp
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F).
2. Blend the oats, grated apple, egg, milk, cinnamon, maple syrup and baking powder.
3. Pour into two dishes and fan the apple slices on top with a pinch more cinnamon.
4. Bake for 25 minutes until golden and set.

#### `blended-chocolate-overnight-oats` · Blended chocolate overnight oats · 🍫 · Other
vibes: quickEasy, batchFriendly · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 80 g
- milk 250 ml
- greek-yogurt 150 g
- banana 1 piece
- dark-chocolate 20 g (melted)
- peanut-butter 1 tbsp

1. Blend the oats, milk, yogurt, banana and melted chocolate until completely smooth.
2. Pour into two jars and chill overnight — it sets like chocolate mousse.
3. Top with a swirl of peanut butter.
4. Eat cold with a spoon.

#### `cottage-cheese-overnight-oats` · High-protein cottage cheese overnight oats · 🥣 · Other
vibes: highProtein, batchFriendly · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- cottage-cheese 150 g
- milk 200 ml
- honey 1 tbsp
- cinnamon 1 tsp
- berries-frozen 100 g

1. Blend the cottage cheese with the milk, honey and cinnamon until smooth.
2. Stir in the oats.
3. Split between jars, top with the berries and chill overnight.
4. Stir and eat cold.

#### `berry-cheesecake-yogurt-bowl` · Berry cheesecake yogurt bowl · 🍓 · Other
vibes: quickEasy, highProtein · appliances: stovetop · prep 5 / cook 3 min · serves 2 · leftovers: no

- greek-yogurt 250 g
- cream-cheese 40 g
- honey 1 tbsp
- berries-frozen 150 g (thawed)
- rolled-oats 30 g
- butter 1 tsp

1. Whisk the yogurt, cream cheese and honey until smooth and thick like cheesecake filling.
2. Toast the oats in the butter for 3 minutes until golden — that's your biscuit base.
3. Spoon the cheesecake yogurt into bowls.
4. Top with the berries and crunchy oats.

#### `microwave-mug-omelette` · Fluffy microwave mug omelette · ☕ · Other
vibes: quickEasy, highProtein · appliances: microwave · prep 2 / cook 2 min · serves 2 · leftovers: no

- eggs 4 piece
- milk 2 tbsp
- cheddar 30 g (grated)
- spinach 30 g (chopped)
- ham 1 slice (chopped)
- wholemeal-bread 2 slice

1. Whisk 2 eggs with 1 tbsp milk in each large mug.
2. Stir in the spinach, ham and cheese.
3. Microwave for 1 minute, stir, then 30–45 seconds more until just set.
4. Eat with toast — breakfast in 3 minutes.

#### `banana-bread-mug-cake` · Banana bread breakfast mug cake · 🍌 · Other
vibes: quickEasy, family · appliances: microwave · prep 3 / cook 2 min · serves 2 · leftovers: no

- banana 1 piece (mashed)
- eggs 1 piece
- rolled-oats 40 g
- cinnamon 0.5 tsp
- baking-powder 0.5 tsp
- peanut-butter 1 tbsp
- greek-yogurt 80 g

1. Mix the banana, egg, oats, cinnamon, baking powder and peanut butter and split between two mugs.
2. Microwave each for about 90 seconds until risen and set.
3. Leave for 1 minute.
4. Top with yogurt.

#### `cookie-dough-overnight-oats` · Cookie dough overnight oats · 🍪 · Other
vibes: family, batchFriendly · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 200 ml
- greek-yogurt 100 g
- peanut-butter 2 tbsp
- maple-syrup 1 tbsp
- dark-chocolate 20 g (chopped)

1. Stir the oats, milk, yogurt, peanut butter and maple syrup together until thick.
2. Fold in most of the chocolate.
3. Split between jars and chill overnight.
4. Top with the rest of the chocolate — it tastes like cookie dough.

#### `lemon-cheesecake-overnight-oats` · Lemon cheesecake overnight oats · 🍋 · Other
vibes: healthyish, batchFriendly · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- rolled-oats 100 g
- milk 200 ml
- greek-yogurt 120 g
- lemon 0.5 piece
- honey 1 tbsp
- cream-cheese 40 g

1. Stir the oats, milk, yogurt, lemon zest and juice and honey together.
2. Whisk the cream cheese with a splash of milk and layer it through the oats in two jars.
3. Chill overnight.
4. Stir and eat cold.

#### `pb-banana-smoothie-bowl` · Peanut butter banana smoothie bowl · 🥜 · Other
vibes: quickEasy, family · appliances: blender, stovetop · prep 5 / cook 3 min · serves 2 · leftovers: no

- banana 3 piece (2 frozen, 1 sliced)
- peanut-butter 2 tbsp
- greek-yogurt 150 g
- milk 60 ml
- rolled-oats 30 g

1. Blend the frozen bananas, yogurt, milk and 1 tbsp peanut butter until thick like soft-serve.
2. Toast the oats in a dry pan for 3 minutes.
3. Spoon into bowls and top with the sliced banana and toasted oats.
4. Drizzle with the rest of the peanut butter.

#### `yogurt-parfait-jars` · Make-ahead yogurt parfait jars · 🫙 · Other
vibes: batchFriendly, healthyish · appliances: stovetop · prep 10 / cook 4 min · serves 4 · leftovers: no

- greek-yogurt 500 g
- rolled-oats 80 g
- honey 2 tbsp
- cinnamon 1 tsp
- berries-frozen 200 g (thawed)
- banana 2 piece (sliced)

1. Toast the oats in a dry pan with the cinnamon for 4 minutes, then stir in half the honey.
2. Layer the yogurt, fruit and crunchy oats in 4 jars.
3. Drizzle with the rest of the honey.
4. Keep for 2 days — the oats stay crunchiest on top.

#### `mango-coconut-baked-oats` · Mango coconut baked oats · 🥭 · Other
vibes: family, healthyish · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 100 g
- mango 1 piece (diced)
- eggs 1 piece
- coconut-milk 150 ml
- honey 1 tbsp
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F).
2. Blend the oats, half the mango, egg, coconut milk, honey and baking powder.
3. Pour into two dishes and top with the rest of the mango.
4. Bake for 25 minutes until golden.

#### `pbj-baked-oats` · PB & J baked oats · 🥜 · American
vibes: family, comfort · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 100 g
- banana 1 piece
- eggs 1 piece
- milk 150 ml
- peanut-butter 2 tbsp
- berries-frozen 100 g
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F).
2. Blend the oats, banana, egg, milk, peanut butter and baking powder.
3. Pour into two dishes and press the berries into the middle like jam.
4. Bake for 25 minutes.

#### `chocolate-pb-baked-oats` · Chocolate peanut butter baked oats · 🍫 · Other
vibes: family, comfort · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 100 g
- banana 1 piece
- eggs 1 piece
- milk 150 ml
- dark-chocolate 20 g (chopped)
- peanut-butter 2 tbsp
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F).
2. Blend the oats, banana, egg, milk and baking powder.
3. Pour into two dishes, swirl in the peanut butter and scatter with chocolate.
4. Bake for 25 minutes until puffed and gooey.

#### `berry-crumble-baked-oats` · Berry crumble baked oats · 🫐 · British
vibes: family, comfort · appliances: blender, oven · prep 5 / cook 25 min · serves 2 · leftovers: no

- rolled-oats 120 g
- banana 1 piece
- eggs 1 piece
- milk 150 ml
- berries-frozen 120 g
- butter 1 tbsp
- baking-powder 1 tsp

1. Heat the oven to 180°C (350°F).
2. Blend 100 g oats with the banana, egg, milk and baking powder and pour into two dishes with the berries.
3. Rub the butter into the rest of the oats with a pinch of cinnamon and scatter over as crumble.
4. Bake for 25 minutes until golden and bubbling.

#### `savory-egg-spinach-wrap` · Spinach & cheese egg wrap · 🌯 · Other
vibes: quickEasy, highProtein · appliances: stovetop · prep 2 / cook 6 min · serves 2 · leftovers: no

- eggs 4 piece (beaten)
- spinach 40 g
- cheddar 40 g (grated)
- tortillas 2 piece
- salsa 60 g

1. Pour half the egg into a hot non-stick pan, scatter with spinach and cheese and cook for 1 minute.
2. Press a tortilla on top, flip and cook for 1 minute.
3. Add salsa, fold and repeat.
4. Eat hot.

#### `peanut-butter-banana-toast` · Peanut butter banana toast with chia · 🍌 · Other
vibes: quickEasy, family · appliances: none · prep 3 / cook 2 min · serves 2 · leftovers: no

- wholemeal-bread 2 slice
- peanut-butter 2 tbsp
- banana 1 piece (sliced)
- honey 1 tsp
- cinnamon 1 pinch

1. Toast the bread.
2. Spread with peanut butter.
3. Top with banana slices.
4. Finish with honey and cinnamon.

#### `spinach-banana-smoothie` · Hulk green smoothie · 💚 · Other
vibes: quickEasy, healthyish · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- spinach 50 g
- banana 2 piece
- peanut-butter 1 tbsp
- milk 300 ml
- rolled-oats 30 g

1. Blend the spinach with the milk until no leaves are left.
2. Add the banana, peanut butter and oats.
3. Blend until thick and smooth — it tastes like banana peanut butter, not spinach.
4. Pour into two glasses.

#### `ham-cheese-breakfast-quesadilla` · Ham, egg & cheese breakfast quesadilla · 🧀 · American
vibes: quickEasy, highProtein · appliances: stovetop · prep 3 / cook 8 min · serves 2 · leftovers: no

- eggs 3 piece (beaten)
- ham 2 slice (chopped)
- cheddar 40 g (grated)
- tortillas 2 piece
- spring-onion 1 piece (sliced)

1. Softly scramble the eggs.
2. Scatter cheese, ham, eggs and spring onion over half of each tortilla and fold.
3. Toast in a dry pan for 2 minutes on each side.
4. Cut into wedges.

#### `savory-oat-pancakes` · Savory oat & spinach pancakes · 🥬 · Other
vibes: healthyish, quickEasy · appliances: blender, stovetop · prep 5 / cook 10 min · serves 2 · leftovers: no

- rolled-oats 80 g
- eggs 2 piece
- milk 100 ml
- spinach 40 g
- cheddar 30 g (grated)
- vegetable-oil 1 tsp

1. Blend the oats, eggs, milk and spinach with a pinch of salt until smooth.
2. Stir in the cheese.
3. Cook small pancakes in an oiled pan for 2 minutes on each side.
4. Serve warm with a fried egg or hot sauce if you like.

### Snacks (15)

#### `cottage-cheese-cookie-dough` · Cottage cheese cookie dough · 🍪 · Other
vibes: highProtein, quickEasy · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- cottage-cheese 150 g
- peanut-butter 2 tbsp
- maple-syrup 1 tbsp
- rolled-oats 20 g
- dark-chocolate 15 g (chopped)

1. Blend the cottage cheese, peanut butter and maple syrup until completely smooth.
2. Stir in the oats and chocolate.
3. Chill for 10 minutes and eat with a spoon.

#### `cottage-cheese-queso-dip` · Cottage cheese queso dip · 🧀 · Mexican
vibes: highProtein, quickEasy · appliances: blender, microwave · prep 5 / cook 2 min · serves 4 · leftovers: no

- cottage-cheese 250 g
- cheddar 40 g (grated)
- salsa 60 g
- chili-powder 0.5 tsp
- corn-tortillas 4 piece (cut into triangles)
- carrot 2 piece (cut into sticks)

1. Blend the cottage cheese, cheddar and chili powder until smooth.
2. Microwave for 1–2 minutes, stirring halfway, until hot and melty, then swirl in the salsa.
3. Serve with toasted tortilla chips and carrot sticks.

#### `whipped-honey-cottage-cheese` · Whipped honey cottage cheese with berries · 🍯 · Other
vibes: highProtein, quickEasy · appliances: blender · prep 5 / cook 0 min · serves 2 · leftovers: no

- cottage-cheese 200 g
- honey 1 tbsp
- berries-frozen 100 g (thawed)
- cinnamon 1 pinch

1. Blend the cottage cheese until whipped and smooth.
2. Spoon into bowls and drizzle with honey.
3. Top with berries and a pinch of cinnamon.

#### `air-fryer-potato-skins` · Air-fryer cheesy potato skins · 🥔 · American
vibes: family, comfort · appliances: microwave, airFryer · prep 5 / cook 15 min · serves 4 · leftovers: no

- potato 2 piece
- cheddar 50 g (grated)
- spring-onion 2 piece (sliced)
- greek-yogurt 60 g

1. Microwave the potatoes for 8 minutes until soft, then halve and scoop out most of the middle (save it for mash).
2. Fill the skins with cheddar and air-fry at 200°C (400°F) for 6 minutes until crisp and bubbling.
3. Top with yogurt and spring onion.

#### `ants-on-a-log` · Ants on a log · 🐜 · American
vibes: family, quickEasy · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- celery 3 piece (cut into sticks)
- peanut-butter 3 tbsp
- raisins 20 g

1. Fill the celery sticks with peanut butter.
2. Dot with raisins like ants marching along.
3. Serve straight away — kids love making these.

#### `chocolate-yogurt-pudding` · Chocolate Greek yogurt pudding · 🍫 · Other
vibes: highProtein, quickEasy · appliances: microwave · prep 5 / cook 1 min · serves 2 · leftovers: no

- greek-yogurt 200 g
- dark-chocolate 20 g (melted)
- honey 1 tbsp
- banana 1 piece (sliced)

1. Stir the melted chocolate and honey into the yogurt until smooth.
2. Chill for 10 minutes to thicken.
3. Top with banana slices.

#### `salt-vinegar-crispy-chickpeas` · Salt & vinegar crispy chickpeas · 🫘 · British
vibes: healthyish, batchFriendly · appliances: oven · prep 5 / cook 25 min · serves 4 · leftovers: no

- chickpeas 480 g (drained and patted dry)
- olive-oil 1 tbsp
- red-wine-vinegar 2 tbsp
- salt 1 tsp

1. Heat the oven to 200°C (400°F).
2. Toss the chickpeas with the oil and roast for 20 minutes until crisp.
3. Toss with the vinegar and salt and roast for 5 minutes more.

#### `ranch-roasted-chickpeas` · Ranch roasted chickpeas · 🫘 · American
vibes: healthyish, batchFriendly · appliances: airFryer · prep 5 / cook 15 min · serves 4 · leftovers: no

- chickpeas 480 g (drained and patted dry)
- olive-oil 1 tbsp
- garlic-powder 1 tsp
- onion-powder 1 tsp
- dried-thyme 1 tsp
- salt 1 tsp

1. Toss the chickpeas with the oil.
2. Air-fry at 200°C (400°F) for 12 minutes, shaking halfway.
3. Toss with the seasonings and air-fry for 3 minutes more.

#### `taco-seasoned-popcorn` · Taco-seasoned popcorn · 🍿 · Mexican
vibes: family, quickEasy · appliances: stovetop · prep 2 / cook 5 min · serves 2 · leftovers: no

- popcorn-kernels 50 g
- vegetable-oil 1 tbsp
- chili-powder 1 tsp
- cumin 0.5 tsp
- lime 0.5 piece

1. Heat the oil in a large lidded pan with 3 kernels until they pop, then add the rest and shake until the popping slows.
2. Toss with the spices and a pinch of salt.
3. Squeeze over the lime and eat warm.

#### `chocolate-oat-clusters` · Chocolate oat clusters · 🍫 · Other
vibes: family, batchFriendly · appliances: microwave · prep 10 / cook 1 min · serves 4 · leftovers: no

- rolled-oats 80 g
- dark-chocolate 60 g
- peanut-butter 1 tbsp
- raisins 30 g

1. Melt the chocolate with the peanut butter in the microwave.
2. Stir in the oats and raisins and drop spoonfuls onto a lined tray.
3. Chill for 20 minutes until set.

#### `yogurt-dipped-frozen-banana` · Frozen yogurt-dipped banana bites · 🍌 · Other
vibes: family, healthyish · appliances: none · prep 10 / cook 0 min · serves 4 · leftovers: no

- banana 2 piece (sliced)
- greek-yogurt 150 g
- honey 1 tsp
- peanuts 20 g (finely chopped)

1. Mix the yogurt with the honey.
2. Dip each banana slice in the yogurt, roll in peanuts and lay on a lined tray.
3. Freeze for 2 hours.

#### `cucumber-feta-bites` · Cucumber feta bites · 🥒 · Mediterranean
vibes: quickEasy, lowCalorie · appliances: none · prep 5 / cook 0 min · serves 2 · leftovers: no

- cucumber 1 piece (thickly sliced)
- feta 50 g (crumbled)
- greek-yogurt 30 g
- dried-oregano 0.5 tsp
- olive-oil 1 tsp

1. Mash the feta with the yogurt and oregano.
2. Spoon onto the cucumber slices.
3. Drizzle with oil and a crack of pepper.

#### `pepper-nachos` · Bell pepper nachos · 🫑 · Mexican
vibes: healthyish, quickEasy · appliances: oven · prep 5 / cook 6 min · serves 2 · leftovers: no

- bell-pepper 1 piece (cut into chip-sized pieces)
- black-beans 100 g (drained)
- cheddar 40 g (grated)
- salsa 60 g
- chili-powder 0.5 tsp

1. Heat the oven to 220°C (425°F) and spread the pepper pieces on a tray like chips.
2. Scatter with beans, cheese and chili powder and bake for 6 minutes until melted.
3. Top with salsa.

#### `edamame-guacamole` · Edamame guacamole with veg sticks · 🥑 · Mexican
vibes: healthyish, highProtein · appliances: blender, stovetop · prep 5 / cook 4 min · serves 4 · leftovers: no

- edamame-frozen 150 g
- avocado 1 piece
- lime 1 piece
- garlic 1 clove
- carrot 2 piece (cut into sticks)
- cucumber 1 piece (cut into sticks)

1. Boil the edamame for 3 minutes, then cool under cold water.
2. Blend with the avocado, lime juice, garlic and a pinch of salt until chunky-smooth.
3. Serve with the veg sticks.

#### `cinnamon-roasted-apple-slices` · Air-fryer cinnamon apple slices with yogurt · 🍏 · Other
vibes: healthyish, family · appliances: airFryer · prep 5 / cook 8 min · serves 2 · leftovers: no

- apple 2 piece (cored and sliced)
- cinnamon 1 tsp
- honey 1 tsp
- greek-yogurt 80 g

1. Toss the apple slices with the cinnamon.
2. Air-fry at 180°C (350°F) for 8 minutes until soft and caramelised at the edges.
3. Serve warm with yogurt and a drizzle of honey.
