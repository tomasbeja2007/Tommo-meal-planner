"""Roasts, egg dishes and other meals from the Tommo recipe brief."""


def build_recipes(R):
    recipes = [
        R("teriyaki-minced-beef-bowls", "Teriyaki beef rice bowls", "🍚", "Japanese",
          ["quickEasy", "highProtein", "batchFriendly"], ["stovetop"], 10, 20, 4, True, [
              ("ground-beef", 450, "g"), ("long-grain-rice", 260, "g"), ("broccoli", 350, "g"),
              ("soy-sauce", 2, "tbsp"), ("honey", 1.5, "tbsp"), ("rice-vinegar", 1, "tbsp"),
              ("ginger", 12, "g"), ("garlic", 2, "clove"), ("cornstarch", 1, "tsp"),
              ("vegetable-oil", 1, "tbsp"), ("sesame-seeds", 2, "tsp"), ("spring-onion", 2, "piece"),
          ], [
              "Rinse the rice and cook it following the packet. Cut the broccoli into small florets.",
              "Grate the ginger and garlic. Mix them with the soy, honey, vinegar and 80 ml water.",
              "Heat the oil in a frying pan and brown the beef, breaking it up as it cooks.",
              "Add the broccoli and a spoonful of water, cover and cook for 3 minutes.",
              "Whisk the cornflour into the sauce, pour it into the pan and toss until the beef is sizzling and glossy.",
              "Spoon the beef and broccoli beside the rice and finish with sesame seeds and finely sliced spring onions.",
          ]),
        R("roast-turkey-breast-gravy", "Roast turkey breast with gravy", "🍗", "British",
          ["highProtein", "comfort", "family"], ["oven", "stovetop"], 18, 65, 4, True, [
              ("turkey-breast", 800, "g"), ("potato", 640, "g"), ("carrot", 400, "g"),
              ("butter", 40, "g"), ("milk", 80, "ml"), ("garlic", 2, "clove"),
              ("dried-thyme", 1, "tsp"), ("olive-oil", 1, "tbsp"), ("flour", 2, "tbsp"),
              ("chicken-stock", 450, "ml"), ("black-pepper", 0.5, "tsp"), ("salt", 1, "tsp"),
          ], [
              "Heat the oven to 190°C (375°F). Mash half the butter with garlic, thyme, pepper and half the salt. Spread it over the turkey.",
              "Place the breast in a small roasting tin and roast for 45–60 minutes, until the centre registers 74°C (165°F).",
              "Cut the carrots into batons, toss with oil and roast on a separate tray for the last 30 minutes.",
              "Peel and cut the potatoes into large chunks. Boil for 15–18 minutes, drain and mash with the milk and remaining butter and salt.",
              "Move the cooked turkey to a warm plate to rest. Whisk the flour into the cooking juices in a small saucepan over medium heat.",
              "Gradually whisk in the stock and simmer until the gravy coats a spoon.",
              "Carve the turkey across the grain. Serve with mash, carrots and a little gravy over each portion.",
          ]),
        R("garlic-butter-roast-chicken", "Garlic butter roast chicken", "🍗", "British",
          ["family", "comfort", "batchFriendly"], ["oven", "stovetop"], 15, 85, 4, True, [
              ("whole-chicken", 1, "piece", "choose a bird weighing around 1.4 kg bone-in"),
              ("butter", 40, "g"), ("garlic", 5, "clove"), ("lemon", 1, "piece"),
              ("potato", 650, "g"), ("green-beans", 300, "g"), ("dried-thyme", 2, "tsp"),
              ("olive-oil", 1, "tbsp"), ("salt", 1, "tsp"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Heat the oven to 200°C (400°F) and pat the chicken skin dry with kitchen paper.",
              "Mash the butter with crushed garlic, lemon zest, thyme, salt and pepper. Rub it over the chicken and put the lemon halves inside.",
              "Set the chicken in a roasting tin. Halve any large potatoes, toss them with the oil and spread them around the bird.",
              "Roast for 70–85 minutes, turning the potatoes halfway through. The thickest parts of the breast and thigh should reach 74°C (165°F), away from bone.",
              "Rest the chicken for 15 minutes. Boil the green beans for 4 minutes, drain and toss with a little of the cooking juices.",
              "Put the rested chicken on a platter with the roast potatoes and green beans, then carve at the table.",
          ]),
        R("thai-red-pumpkin-curry", "Thai red pumpkin curry", "🎃", "Thai",
          ["family", "healthyish", "batchFriendly"], ["stovetop"], 12, 25, 4, True, [
              ("pumpkin", 750, "g", "seeded, choose kabocha if leaving the skin on"), ("green-beans", 250, "g"),
              ("basmati-rice", 260, "g"), ("coconut-milk", 400, "ml"), ("onion", 1, "piece"),
              ("thai-curry-paste", 1.5, "tbsp"), ("vegetable-stock", 200, "ml"),
              ("vegetable-oil", 1, "tbsp"), ("lime", 1, "piece"), ("basil", 10, "g"), ("chili-fresh", 0.5, "piece"),
          ], [
              "Cut the pumpkin into 3 cm chunks. Thinly slice the onion trim the green beans and slice the chilli.",
              "Heat the oil in a wide pan and soften the onion for 5 minutes. Add the curry paste and cook for a minute.",
              "Stir in a little coconut milk to loosen the paste. Add the pumpkin, remaining coconut milk and stock.",
              "Simmer for about 14 minutes while you cook the rice in a separate pan following the packet.",
              "Add the beans and chilli and simmer until the vegetables are tender. Squeeze in lime juice and stir in torn basil.",
              "Spoon the curry into wide bowls and serve next to the rice.",
          ]),
        R("ham-broccoli-egg-bake", "Ham and broccoli egg bake", "🥚", "British",
          ["highProtein", "family", "batchFriendly"], ["oven", "stovetop"], 12, 26, 4, True, [
              ("eggs", 8, "piece"), ("ham", 150, "g"), ("broccoli", 300, "g"), ("milk", 90, "ml"),
              ("cheddar", 110, "g"), ("butter", 10, "g"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Heat the oven to 190°C (375°F) and butter a small square baking dish.",
              "Cut the broccoli into florets, blanch for 2 minutes in boiling water and drain thoroughly. Dice the ham.",
              "Beat the eggs, milk and pepper with a fork. Grate the cheddar.",
              "Spread the ham and broccoli in the dish and pour over the eggs. Sprinkle the top with cheddar.",
              "Bake for 22–26 minutes until the middle is set and the cheese is golden. Rest for 5 minutes before cutting into four squares.",
          ], meal="breakfast"),
        R("bacon-asparagus-frittata", "Bacon and asparagus frittata", "🍳", "Italian",
          ["highProtein", "quickEasy", "onePan"], ["stovetop", "oven"], 10, 15, 2, False, [
              ("eggs", 5, "piece"), ("asparagus", 150, "g"), ("bacon", 70, "g"), ("cheddar", 30, "g"),
              ("black-pepper", 0.5, "tsp"), ("olive-oil", 1, "tsp"),
          ], [
              "Heat the oven to 200°C (400°F). Snap the woody ends from the asparagus and cut the spears into short pieces.",
              "Slice the bacon and fry it in a small ovenproof pan until lightly crisp. Add a little oil if the pan is dry.",
              "Add the asparagus and cook for 3 minutes. Beat the eggs with pepper and the grated cheddar.",
              "Pour the eggs over the bacon and asparagus. Let the edges set without stirring, then transfer the pan to the oven.",
              "Bake for 6–8 minutes until the centre is just set. Let it settle for 2 minutes before cutting into wedges.",
          ], meal="breakfast"),
        R("crustless-spinach-tomato-quiche", "Crustless spinach and tomato quiche", "🍅", "Other",
          ["highProtein", "family", "batchFriendly"], ["oven", "stovetop"], 12, 30, 4, True, [
              ("eggs", 7, "piece"), ("spinach", 220, "g"), ("cherry-tomatoes", 200, "g"),
              ("cottage-cheese", 280, "g"), ("cheddar", 70, "g"), ("olive-oil", 1, "tbsp"),
              ("garlic", 2, "clove"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Heat the oven to 190°C (375°F). Brush a shallow round dish with a little of the oil.",
              "Warm the remaining oil in a pan. Stir in crushed garlic for 20 seconds, then wilt the spinach and squeeze out the excess liquid.",
              "Beat the eggs with cottage cheese and pepper. Fold in the spinach and half the cheddar.",
              "Pour into the dish and top with halved tomatoes, cut-side up, and the remaining cheddar.",
              "Bake for 25–30 minutes until the middle is set. Rest for 5 minutes so you can lift out clean wedges.",
          ], meal="breakfast"),
        R("korean-steamed-eggs-prawns", "Korean steamed eggs with prawns", "🥚", "Korean",
          ["highProtein", "quickEasy"], ["stovetop"], 8, 14, 2, False, [
              ("eggs", 5, "piece"), ("shrimp", 160, "g", "peeled"), ("chicken-stock", 180, "ml"),
              ("soy-sauce", 1, "tsp"), ("spring-onion", 2, "piece"), ("sesame-oil", 2, "tsp"),
          ], [
              "Thinly slice the spring onions, keeping the green tops separate. Pat the prawns dry.",
              "Whisk the eggs with the stock, soy sauce and spring-onion whites until evenly mixed.",
              "Pour into a heatproof bowl. Set the bowl above gently simmering water in a covered pan, keeping the water below the bowl.",
              "Steam for 8 minutes until the edges begin to set. Nestle the prawns on top and cover again.",
              "Steam for another 4–6 minutes until the prawns are pink and opaque and the eggs are set. Finish with spring-onion greens and sesame oil.",
          ], meal="breakfast"),
        R("denver-scrambled-eggs-toast", "Denver scrambled eggs on toast", "🍳", "American",
          ["quickEasy", "highProtein"], ["stovetop"], 8, 10, 2, False, [
              ("eggs", 5, "piece"), ("ham", 75, "g"), ("bell-pepper", 0.5, "piece", "green"),
              ("onion", 0.5, "piece"), ("cheddar", 45, "g"), ("sourdough", 2, "slice"),
              ("butter", 15, "g"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Finely dice the ham, green pepper and onion. Beat the eggs with pepper and grate the cheddar.",
              "Toast the sourdough in a dry pan. Spread it with a little of the butter and keep it warm.",
              "Melt the rest of the butter in a frying pan. Soften the onion and green pepper for 4 minutes, then add the ham for a minute.",
              "Turn the heat to low, pour in the eggs and draw a spatula slowly across the pan to make soft curds.",
              "Add the cheddar just before the eggs finish setting. Serve the scramble beside the toast.",
          ], meal="breakfast"),
        R("loaded-breakfast-burritos", "Loaded breakfast burritos", "🌯", "Mexican",
          ["family", "comfort", "batchFriendly"], ["stovetop"], 12, 20, 4, True, [
              ("tortillas", 4, "piece"), ("sausages", 250, "g", "skins removed"), ("eggs", 5, "piece"),
              ("potato", 320, "g"), ("tomato", 1, "piece"), ("cheddar", 75, "g"),
              ("vegetable-oil", 1, "tbsp"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Dice the potato into small cubes. Boil for 6 minutes, then drain well.",
              "Heat half the oil in a frying pan and cook the potato until crisp and tender. Move it to a clean plate.",
              "Fry the sausage in the same pan until fully cooked, breaking it into small pieces. Move it to the plate with the potato.",
              "Beat the eggs with pepper and make soft scrambled eggs over low heat in the remaining oil.",
              "Warm the tortillas and fill each with potato, sausage, eggs, grated cheddar and finely diced tomato.",
              "Tuck the sides in, roll tightly and toast seam-side down in the dry pan. Cut in half before serving.",
          ], meal="breakfast"),
        R("chicken-philly-cheesesteak", "Chicken Philly cheesesteak", "🥖", "American",
          ["highProtein", "comfort", "fakeaway"], ["stovetop", "oven"], 12, 18, 4, False, [
              ("chicken-breast", 500, "g"), ("baguette", 320, "g"),
              ("bell-pepper", 2, "piece", "green"), ("onion", 1, "piece"), ("mozzarella", 160, "g"),
              ("olive-oil", 1, "tbsp"), ("garlic-powder", 1, "tsp"), ("black-pepper", 0.5, "tsp"), ("salt", 0.5, "tsp"),
          ], [
              "Heat the oven to 210°C (410°F). Cut the baguette into four pieces and split each piece lengthways.",
              "Thinly slice the chicken, peppers and onion. Toss the chicken with garlic powder, pepper and salt.",
              "In a wide frying pan, soften the peppers and onion in half the oil for 6 minutes, then move them onto a plate.",
              "Use the remaining oil to fry the chicken until it reaches 74°C (165°F). Stir the peppers and onion back in.",
              "Pile the filling into the rolls and lay thin slices of mozzarella on top. Heat in the oven until the cheese has melted and the bread is crisp.",
          ], meal="lunch"),
        R("chicken-butternut-squash-stew", "Chicken and butternut squash stew", "🥣", "British",
          ["onePan", "highProtein", "batchFriendly"], ["stovetop"], 15, 35, 4, True, [
              ("chicken-thighs", 550, "g", "boneless, skinless"), ("butternut-squash", 600, "g", "peeled and seeded"),
              ("cannellini-beans", 260, "g", "drained"), ("onion", 1, "piece"), ("garlic", 3, "clove"),
              ("chicken-stock", 550, "ml"), ("dried-thyme", 2, "tsp"), ("olive-oil", 1, "tbsp"),
              ("flour", 1, "tbsp"), ("lemon", 1, "piece"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Cut the chicken and squash into bite-size chunks. Dice the onion and crush the garlic.",
              "Heat the oil in a heavy pan and brown the chicken. Lift it out onto a clean plate.",
              "Soften the onion in the same pan for 5 minutes. Add the garlic, thyme and flour and stir for a minute.",
              "Gradually stir in the stock. Return the chicken with the squash and cook at a gentle simmer for about 20 minutes.",
              "Add the drained beans and simmer until the squash is tender and the chicken reaches 74°C (165°F).",
              "Squeeze in lemon juice and add black pepper to taste. Spoon into bowls with plenty of the broth.",
          ]),
    ]
    for recipe in recipes:
        recipe["tags"] = []
    return recipes
