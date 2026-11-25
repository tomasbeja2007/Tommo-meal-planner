"""Skillet dinners, toasted sandwiches, salads and tacos from the recipe brief."""


def build_recipes(R):
    recipes = [
        R("unstuffed-beef-pepper-skillet", "Unstuffed pepper skillet", "🫑", "American",
          ["onePan", "family", "batchFriendly"], ["stovetop"], 12, 30, 4, True, [
              ("ground-beef", 450, "g"), ("bell-pepper", 3, "piece", "red and green"), ("onion", 1, "piece"),
              ("garlic", 3, "clove"), ("long-grain-rice", 230, "g"), ("chopped-tomatoes", 400, "g"),
              ("vegetable-stock", 450, "ml"), ("dried-oregano", 1, "tsp"),
              ("olive-oil", 1, "tbsp"), ("cheddar", 90, "g"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Dice the red and green peppers and onion. Rinse and drain the rice.",
              "Heat the oil in a deep lidded frying pan. Brown the beef, breaking it up as it cooks.",
              "Add the peppers and onions and cook for 5 minutes, then stir in the garlic, oregano and pepper.",
              "Stir in the rice, tomatoes and stock. Bring to a simmer, cover and cook over low heat for 17–20 minutes.",
              "Check that the rice is tender and stir gently. Add a little water and cook a few minutes longer if needed.",
              "Sprinkle with cheddar and cover off the heat for 2 minutes to melt the cheese.",
          ]),
        R("ginger-brothy-beef-bowls", "Brothy ginger beef bowls", "🥣", "Other",
          ["quickEasy", "highProtein"], ["stovetop"], 12, 20, 4, False, [
              ("beef-steak", 480, "g"), ("basmati-rice", 260, "g"), ("bok-choy", 300, "g"),
              ("vegetable-stock", 900, "ml"), ("ginger", 25, "g"), ("garlic", 2, "clove"),
              ("spring-onion", 4, "piece"), ("soy-sauce", 2, "tbsp"), ("rice-vinegar", 1, "tbsp"),
              ("vegetable-oil", 1, "tbsp"),
          ], [
              "Rinse the rice and cook it following the packet. Slice the ginger, garlic and spring onions.",
              "Put the stock, ginger, garlic and spring-onion whites in a saucepan. Simmer gently for 10 minutes.",
              "Pat the steak dry and sear it in the hot oil on both sides. For medium, take it off at 63°C (145°F) and rest it for at least 3 minutes.",
              "Strain the broth if you prefer it clear. Stir in the soy and vinegar, and simmer the quartered pak choi for 3 minutes.",
              "Slice the beef thinly across the grain while the greens cook.",
              "Spoon rice into deep bowls, add the sliced steak and pak choi, then ladle over the broth and finish with spring-onion greens.",
          ]),
        R("cheesy-chicken-crescent-rolls", "Cheesy chicken crescent rolls", "🥐", "American",
          ["family", "comfort"], ["oven", "stovetop"], 12, 30, 4, False, [
              ("crescent-dough", 240, "g"), ("chicken-breast", 360, "g"), ("cheddar", 100, "g"),
              ("cream-cheese", 55, "g"), ("spring-onion", 3, "piece"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Heat the oven to 200°C (400°F) and line a baking tray.",
              "Gently simmer the chicken in water until it reaches 74°C (165°F). Drain, shred and let it cool briefly.",
              "Mix the shredded chicken with cream cheese, grated cheddar, pepper and most of the finely sliced spring onions.",
              "Separate the chilled dough into eight triangles. Put filling on the wide end of each triangle and roll it up.",
              "Set seam-side down on the tray and bake for 13–17 minutes, until puffed and deeply golden.",
              "Rest for 3 minutes. Cut one roll open for serving and scatter on the remaining spring onions.",
          ]),
        R("garlic-parmesan-cheeseburger-bombs", "Garlic parmesan cheeseburger bombs", "🧄", "American",
          ["comfort", "family", "fakeaway"], ["oven", "stovetop"], 22, 25, 4, False, [
              ("flour", 280, "g"), ("greek-yogurt", 245, "g"), ("baking-powder", 2, "tsp"),
              ("ground-beef", 350, "g"), ("cheddar", 90, "g"), ("onion", 0.5, "piece"),
              ("parmesan", 30, "g"), ("garlic", 2, "clove"), ("butter", 30, "g"),
              ("parsley", 8, "g"), ("salt", 0.5, "tsp"),
          ], [
              "Heat the oven to 210°C (410°F) and line a baking tray. Dice the onion finely.",
              "Dry-fry the beef and onion until the beef is cooked. Break up the mince, drain any excess fat and spread it on a plate to cool.",
              "Mix flour, baking powder, salt and yoghurt into a soft dough. Knead briefly and divide into eight balls.",
              "Flatten each ball and fill with beef and a cube of cheddar. Pinch tightly shut and put seam-side down on the tray.",
              "Bake for 15–18 minutes until golden and cooked through.",
              "Melt the butter with crushed garlic. Brush it over the bread, then scatter with finely grated parmesan and parsley.",
          ]),
        R("crispy-rice-paper-beef-burgers", "Crispy rice paper beef burgers", "🍔", "Other",
          ["fakeaway", "highProtein"], ["stovetop"], 15, 20, 4, False, [
              ("rice-paper", 12, "piece"), ("ground-beef", 500, "g"), ("cabbage", 190, "g"),
              ("spring-onion", 3, "piece"), ("soy-sauce", 1, "tbsp"), ("vegetable-oil", 2, "tbsp"),
              ("ketchup", 70, "g"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Shred the cabbage finely and slice the spring onions. Mix the beef with soy and pepper and shape into four thin patties.",
              "Fry the patties in half the oil until browned and cooked to 71°C (160°F). Transfer to a clean plate.",
              "Briefly dip rice-paper sheets in water, one at a time. Layer three sheets for each burger on a damp board.",
              "Put a patty, cabbage and spring onion in the centre. Tuck in the sides and fold tightly to enclose it.",
              "Fry the parcels in the remaining oil for 2–3 minutes on each side until crisp. Work in batches so they do not touch.",
              "Set the parcels on a rack for a minute, then halve and serve with ketchup for dipping.",
          ]),
        R("hot-honey-crispy-chicken-burgers", "Hot honey crispy chicken burgers", "🍔", "American",
          ["fakeaway", "highProtein", "comfort"], ["stovetop"], 15, 22, 4, False, [
              ("chicken-breast", 520, "g"), ("burger-buns", 4, "piece"), ("cabbage", 180, "g"),
              ("cucumber", 0.5, "piece"), ("eggs", 1, "piece"), ("breadcrumbs", 90, "g"),
              ("flour", 40, "g"), ("vegetable-oil", 4, "tbsp"), ("honey", 3, "tbsp"),
              ("hot-sauce", 2, "tbsp"), ("rice-vinegar", 1, "tbsp"), ("salt", 0.5, "tsp"),
          ], [
              "Slice the chicken into four even cutlets. Shred the cabbage finely and thinly slice the cucumber.",
              "Toss the cabbage and cucumber with vinegar and salt and let them stand while you cook the chicken.",
              "Coat the chicken with flour, beaten egg and then breadcrumbs, pressing the crumbs on.",
              "Heat the oil in a wide frying pan and cook the cutlets in batches until crisp on both sides and 74°C (165°F) in the centre.",
              "Warm the honey and hot sauce together in a small pan. Drain the cutlets on a rack, then brush them with the glaze.",
              "Toast the buns, drain the cabbage and cucumber, and build each burger with the vegetables and a glazed chicken cutlet.",
          ]),
        R("bbq-cheeseburger-sliders", "BBQ cheeseburger sliders", "🍔", "American",
          ["family", "fakeaway", "comfort"], ["stovetop"], 12, 24, 4, False, [
              ("burger-buns", 4, "piece", "small buns"), ("ground-beef", 440, "g"), ("onion", 2, "piece"),
              ("cheddar", 100, "g"), ("bbq-sauce", 100, "g"), ("butter", 15, "g"),
              ("vegetable-oil", 1, "tsp"), ("salt", 0.5, "tsp"),
          ], [
              "Thinly slice the onions. Melt butter with the oil in a pan and cook the onions gently until brown and soft.",
              "Shape the meat into four small flat patties and season the outside with salt.",
              "Open the buns and toast their cut sides in a clean hot pan.",
              "Cook the patties in the hot pan until browned, turning once. Cook to 71°C (160°F) in the centre.",
              "Top with sliced cheddar and cover the pan for a minute to melt it.",
              "Spread barbecue sauce on the buns, then add the cheeseburger patties and a spoon of the caramelised onions.",
          ]),
        R("chicken-parmesan-sliders", "Chicken parmesan sliders", "🍔", "Italian",
          ["family", "comfort", "highProtein"], ["oven", "stovetop"], 15, 24, 4, False, [
              ("burger-buns", 4, "piece", "small buns"), ("chicken-breast", 440, "g"),
              ("eggs", 1, "piece"), ("breadcrumbs", 90, "g"), ("parmesan", 35, "g"),
              ("passata", 220, "g"), ("mozzarella", 125, "g"), ("basil", 12, "g"),
              ("garlic", 2, "clove"), ("olive-oil", 1.5, "tbsp"),
          ], [
              "Heat the oven to 220°C (425°F). Cut the chicken into even pieces that will fit the buns.",
              "Dip the chicken in beaten egg, then press it into breadcrumbs mixed with the grated parmesan.",
              "Brush a tray and the chicken lightly with oil. Bake for 12–16 minutes, turning once, until golden and 74°C (165°F) in the centre.",
              "Meanwhile, gently simmer the passata with crushed garlic for 8 minutes until thick enough to spoon.",
              "Split the buns and top with the chicken, tomato sauce and torn mozzarella. Return to the oven until the cheese melts.",
              "Tuck in basil leaves and close the buns just before serving.",
          ]),
        R("ham-cheddar-sliders", "Ham and cheese sliders", "🥪", "American",
          ["quickEasy", "comfort", "family"], ["oven"], 10, 16, 4, False, [
              ("burger-buns", 4, "piece", "small buns"), ("ham", 250, "g"), ("cheddar", 140, "g"),
              ("butter", 35, "g"), ("dijon-mustard", 1, "tbsp"), ("onion-powder", 0.5, "tsp"),
          ], [
              "Heat the oven to 190°C (375°F) and line a small baking dish.",
              "Split the buns and arrange their bottom halves in the dish. Fold the ham onto them and top with slices of cheddar.",
              "Set the tops in place. Melt the butter and stir in the mustard and onion powder. Brush the mixture over the buns.",
              "Cover loosely and bake for 10 minutes, then uncover for 5–6 minutes, until the tops are golden and the cheese has melted.",
          ], meal="lunch"),
        R("chicken-bacon-ranch-salad", "Chicken bacon ranch salad", "🥗", "American",
          ["highProtein", "quickEasy"], ["stovetop"], 15, 15, 4, False, [
              ("chicken-breast", 520, "g"), ("bacon", 150, "g"), ("lettuce", 450, "g"),
              ("tomato", 300, "g"), ("greek-yogurt", 180, "g"), ("mayonnaise", 50, "g"),
              ("dried-thyme", 0.5, "tsp"), ("garlic-powder", 0.5, "tsp"), ("onion-powder", 0.5, "tsp"),
              ("lemon", 1, "piece"), ("parsley", 10, "g"), ("olive-oil", 1, "tbsp"),
          ], [
              "Cook the bacon in a frying pan until crisp, then move it to kitchen paper to drain.",
              "Slice the chicken into thin cutlets. Fry in the olive oil until golden and 74°C (165°F) in the centre, then set aside to rest.",
              "For the ranch dressing, whisk the yoghurt, mayonnaise, thyme, garlic powder, onion powder, chopped parsley and lemon juice.",
              "Chop the lettuce and cut the tomatoes into small wedges. Slice the rested chicken and crumble the cooked bacon.",
              "Divide the lettuce and tomato into bowls. Add the chicken and bacon and drizzle with the ranch just before serving.",
          ], meal="lunch"),
        R("parmesan-crusted-chicken", "Parmesan-crusted chicken", "🍗", "Italian",
          ["family", "highProtein"], ["oven", "stovetop"], 15, 35, 4, False, [
              ("chicken-breast", 520, "g"), ("potato", 680, "g"), ("broccoli", 370, "g"),
              ("eggs", 1, "piece"), ("flour", 40, "g"), ("breadcrumbs", 90, "g"),
              ("parmesan", 65, "g"), ("lemon", 1, "piece"), ("olive-oil", 3, "tbsp"), ("salt", 0.5, "tsp"),
          ], [
              "Heat the oven to 220°C (425°F). Cut the potato into small chunks and toss with half the oil and salt.",
              "Roast the potatoes for 20 minutes. Cut the broccoli into florets, toss lightly with oil and add it to the tray for another 12–15 minutes.",
              "Slice the chicken into four even cutlets. Set out flour, beaten egg and breadcrumbs mixed with grated parmesan.",
              "Coat each piece with flour, egg and the parmesan crumbs. Press the crumbs in gently so they stick.",
              "Fry the cutlets in the remaining oil in batches until golden and 74°C (165°F) in the centre.",
              "Serve the chicken beside the browned potatoes and broccoli, with lemon wedges for squeezing.",
          ]),
        R("yucatan-steak-tacos", "Yucatán steak tacos", "🌮", "Mexican",
          ["quickEasy", "highProtein", "fakeaway"], ["stovetop"], 15, 12, 4, False, [
              ("beef-steak", 520, "g"), ("corn-tortillas", 12, "piece"), ("orange", 1, "piece"),
              ("lime", 3, "piece"), ("red-onion", 1, "piece"), ("garlic", 3, "clove"),
              ("paprika", 1, "tsp"), ("dried-oregano", 1, "tsp"), ("cumin", 0.5, "tsp"),
              ("cilantro", 15, "g"), ("vegetable-oil", 1, "tbsp"), ("salt", 0.5, "tsp"),
          ], [
              "Mix orange juice, juice from one lime, crushed garlic, paprika, oregano, cumin and half the salt in a shallow dish.",
              "Coat the steak with the citrus mixture. Finely slice the red onion and toss with juice from the second lime and the remaining salt.",
              "Heat the oil in a heavy frying pan. Lift the steak out of the marinade, blot it lightly and sear on both sides.",
              "For medium, cook to at least 63°C (145°F). Transfer to a board and rest for at least 3 minutes.",
              "Warm the tortillas one at a time in a dry pan. Keep them stacked under a clean cloth.",
              "Slice the steak thinly across the grain and divide among the tortillas. Top with red onion and chopped coriander and serve with the last lime cut into wedges.",
          ]),
    ]
    for recipe in recipes:
        recipe["tags"] = []
    return recipes
