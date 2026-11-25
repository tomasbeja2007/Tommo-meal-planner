"""Comfort-food recipes from the Tommo recipe brief."""


def build_recipes(R):
    recipes = [
        R("ham-mac-and-cheese", "Mac and cheese with ham", "🧀", "American", ["comfort", "family"],
          ["stovetop", "oven"], 10, 27, 4, True, [
              ("macaroni", 300, "g"), ("ham", 180, "g"), ("cheddar", 180, "g"), ("milk", 500, "ml"),
              ("butter", 35, "g"), ("flour", 35, "g"), ("dijon-mustard", 1, "tsp"),
              ("black-pepper", 0.5, "tsp"), ("salt", 0.5, "tsp"),
          ], [
              "Heat the oven to 200°C (400°F). Dice the ham and grate the cheddar.",
              "Cook the macaroni for 2 minutes less than the packet suggests. Drain well.",
              "Melt the butter in a saucepan, stir in the flour and cook for a minute until it smells lightly toasted.",
              "Add the milk gradually, whisking between additions. Simmer until thick, then take off the heat and stir in the mustard, seasoning and most of the cheese.",
              "Fold the macaroni and diced ham through the sauce. Transfer to a baking dish and scatter the remaining cheese over it.",
              "Bake for 12–15 minutes until bubbling with golden patches. Rest for 3 minutes before serving.",
          ]),
        R("crab-mac-and-cheese", "Crab mac and cheese", "🦀", "American", ["comfort", "highProtein"],
          ["stovetop", "oven"], 12, 24, 4, False, [
              ("macaroni", 280, "g"), ("white-crabmeat", 300, "g"), ("cheddar", 150, "g", "mature white"),
              ("milk", 470, "ml"), ("butter", 35, "g"), ("flour", 30, "g"),
              ("breadcrumbs", 35, "g"), ("lemon", 1, "piece"), ("parsley", 12, "g"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Heat the oven to 210°C (410°F). Cook the macaroni for a minute less than the packet suggests.",
              "Pick through the crab for pieces of shell and tear any large lumps into bite-size pieces.",
              "Melt the butter, stir in the flour and cook for a minute. Gradually whisk in the milk and simmer until it coats a spoon.",
              "Take off the heat and stir in grated cheddar, pepper and a little lemon zest. Fold in the drained macaroni and crab, leaving some crab pieces intact.",
              "Spoon into a baking dish and sprinkle with breadcrumbs. Bake for 10–12 minutes, until the edges bubble and the crumbs are lightly browned.",
              "Scatter over chopped parsley and finish with a squeeze of lemon just before serving.",
          ]),
        R("buffalo-chicken-mac-cheese", "Buffalo chicken mac and cheese", "🌶️", "American",
          ["comfort", "highProtein", "fakeaway"], ["stovetop"], 12, 22, 4, True, [
              ("macaroni", 300, "g"), ("chicken-breast", 450, "g"), ("cheddar", 150, "g"),
              ("milk", 420, "ml"), ("butter", 30, "g"), ("flour", 30, "g"), ("hot-sauce", 3, "tbsp"),
              ("garlic-powder", 0.5, "tsp"), ("spring-onion", 2, "piece"),
          ], [
              "Put the macaroni on to boil. In a second pan, cover the chicken with water and bring it to a gentle simmer.",
              "Poach the chicken for 12–16 minutes until the thickest part reaches 74°C (165°F). Drain it and pull it into small shreds with forks.",
              "Melt the butter in a saucepan and stir in the flour and garlic powder for 1 minute.",
              "Gradually whisk in the milk. Simmer until smooth and thick, then take off the heat and stir in the grated cheddar and hot sauce.",
              "Drain the macaroni and fold it into the sauce with the shredded chicken. Loosen with a splash of the pasta water if needed.",
              "Divide into bowls and scatter with thinly sliced spring onions.",
          ]),
        R("classic-glazed-beef-meatloaf", "Classic glazed beef meatloaf", "🍽️", "American",
          ["family", "comfort", "batchFriendly"], ["oven", "stovetop"], 15, 60, 4, True, [
              ("ground-beef", 600, "g"), ("breadcrumbs", 65, "g"), ("onion", 1, "piece"),
              ("eggs", 1, "piece"), ("milk", 100, "ml"), ("worcestershire", 1, "tbsp"),
              ("ketchup", 85, "g"), ("dijon-mustard", 1, "tsp"), ("potato", 680, "g"),
              ("butter", 25, "g"), ("peas-frozen", 250, "g"), ("salt", 1, "tsp"),
          ], [
              "Heat the oven to 190°C (375°F). Grate the onion and soak the breadcrumbs in half the milk.",
              "Mix the beef, breadcrumbs, onion, egg, Worcestershire sauce and half the salt with a fork or your hands. Stop once combined.",
              "Shape into a low loaf on a lined baking tray. Mix the ketchup and mustard and spread half over the loaf.",
              "Bake for 40–50 minutes until the centre reaches 71°C (160°F). Brush with the remaining glaze for the final 12 minutes.",
              "Meanwhile, boil the peeled and chopped potatoes until soft. Drain and mash with butter, the rest of the milk and salt. Boil the peas for 3 minutes.",
              "Rest the meatloaf for 10 minutes, then cut it into thick slices and serve beside the mash and peas.",
          ]),
        R("steamed-pork-dumpling-lasagne", "Steamed pork dumpling lasagne", "🥟", "Chinese",
          ["comfort", "highProtein", "fakeaway"], ["stovetop"], 20, 25, 4, False, [
              ("wonton-wrappers", 200, "g", "use thin wheat-based wrappers"), ("ground-pork", 470, "g"),
              ("cabbage", 240, "g"), ("spring-onion", 4, "piece"), ("ginger", 15, "g"),
              ("soy-sauce", 2, "tbsp"), ("sesame-oil", 2, "tsp"), ("vegetable-oil", 1, "tbsp"),
              ("chili-flakes", 1, "tsp"), ("salt", 0.5, "tsp"),
          ], [
              "Very finely shred the cabbage, toss with salt and leave for 5 minutes. Squeeze it dry.",
              "Mix the cabbage with minced pork, ginger, soy sauce, sesame oil and the sliced spring-onion whites.",
              "Set four small heatproof dishes out. Cover the bases with wrappers, spread a thin layer of filling on top, then repeat and finish with wrappers.",
              "Put the dishes in a covered steamer set over gently boiling water. Steam for 18–23 minutes until the centres reach 71°C (160°F).",
              "Heat the vegetable oil in a small pan and pour it over the chilli flakes in a heatproof bowl. Let them sizzle and settle.",
              "Run a knife around the edge of each dumpling stack and slide it onto a plate with a spatula. Scatter over the spring-onion greens and spoon on a little chilli oil.",
          ]),
        R("spaghetti-alfredo", "Spaghetti Alfredo", "🍝", "Italian", ["quickEasy", "comfort", "family"],
          ["stovetop"], 5, 15, 4, False, [
              ("spaghetti", 360, "g"), ("heavy-cream", 200, "ml"), ("butter", 35, "g"),
              ("parmesan", 100, "g"), ("black-pepper", 1, "tsp"), ("salt", 1, "tsp"),
          ], [
              "Bring a pan of water to the boil, add salt and cook the spaghetti until just firm in the centre.",
              "Grate the parmesan finely while the spaghetti cooks. Scoop out a mug of the pasta water before draining.",
              "Warm the butter and cream in a wide pan over low heat until the butter melts. Avoid a hard boil.",
              "Add the spaghetti and a splash of pasta water. Turn it through the warm cream with tongs.",
              "Take the pan off the heat. Toss in most of the parmesan a little at a time until the sauce clings to the strands.",
              "Add a final splash of pasta water if the sauce feels tight. Twist the spaghetti into bowls and finish with the remaining parmesan and cracked black pepper.",
          ]),
        R("french-onion-chicken-orzo", "French onion chicken orzo", "🍗", "Other",
          ["comfort", "highProtein", "batchFriendly"], ["stovetop", "oven"], 12, 47, 4, True, [
              ("chicken-thighs", 600, "g", "boneless"), ("onion", 450, "g"), ("orzo", 280, "g"),
              ("chicken-stock", 750, "ml"), ("mozzarella", 125, "g"), ("butter", 20, "g"),
              ("olive-oil", 1, "tbsp"), ("worcestershire", 1, "tbsp"), ("dried-thyme", 1, "tsp"),
              ("black-pepper", 0.5, "tsp"), ("salt", 0.5, "tsp"),
          ], [
              "Thinly slice the onions. Heat the oven to 210°C (410°F) and season the chicken with salt and pepper.",
              "Heat the oil in a wide ovenproof pan. Brown the thighs on both sides, then lift them onto a plate.",
              "Melt the butter in the same pan and cook the onions on medium-low for about 20 minutes. Scrape the pan and add a splash of water when the onions catch.",
              "Add the thyme, Worcestershire sauce, orzo and stock. Stir well and nestle the chicken and its juices into the orzo.",
              "Bake for 14 minutes, then scatter torn mozzarella over the pan and bake until the orzo is tender and the chicken reaches 74°C (165°F).",
              "Rest for 3 minutes, then serve each piece of chicken over orzo with the caramelised onions scooped on top.",
          ]),
        R("creamy-italian-sausage-pasta", "Creamy Italian sausage pasta", "🍝", "Italian",
          ["comfort", "family", "batchFriendly"], ["stovetop"], 10, 23, 4, True, [
              ("rigatoni", 320, "g"), ("sausages", 350, "g", "skins removed"), ("onion", 1, "piece"),
              ("garlic", 3, "clove"), ("passata", 400, "g"), ("heavy-cream", 100, "ml"),
              ("italian-herbs", 1, "tsp"), ("olive-oil", 1, "tsp"), ("basil", 15, "g"),
          ], [
              "Chop the onion and crush the garlic. Set the rigatoni cooking in a separate pan.",
              "Heat the oil and pinch the sausage meat into small lumps. Leave them to brown before stirring.",
              "Add the onion and cook until soft, then add the garlic and herbs for another minute.",
              "Stir in the passata and simmer for 8–10 minutes until the sausage is cooked and the tomato tastes mellow.",
              "Stir in the cream. Drain the rigatoni, keeping a cup of the cooking water, and fold the pasta through the sauce.",
              "Loosen with pasta water as needed and serve with torn basil.",
          ]),
        R("caramelised-cabbage-spaghetti", "Caramelised cabbage pasta", "🥬", "Other",
          ["comfort", "fiberForward"], ["stovetop"], 12, 24, 4, True, [
              ("spaghetti", 360, "g"), ("cabbage", 650, "g"), ("onion", 1, "piece"), ("garlic", 3, "clove"),
              ("butter", 45, "g"), ("olive-oil", 1, "tbsp"), ("lemon", 1, "piece"),
              ("parsley", 10, "g"), ("salt", 0.5, "tsp"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Halve the cabbage and cut it into thin ribbons. Thinly slice the onion and crush the garlic.",
              "Heat the oil and half of the butter in a wide pan. Fry the onion for 5 minutes over medium heat.",
              "Add the cabbage and salt in two batches. Let it brown against the pan before tossing, then continue for about 12 minutes until tender.",
              "Cook the spaghetti until just firm and reserve a mug of the cooking water. Stir the garlic into the cabbage.",
              "Add the drained spaghetti, remaining butter and a splash of pasta water. Toss until the cabbage is distributed between the strands.",
              "Squeeze over lemon, divide into bowls and finish with parsley and cracked pepper.",
          ]),
        R("chicken-mushroom-tetrazzini", "Chicken tetrazzini", "🍝", "American",
          ["family", "comfort", "batchFriendly"], ["oven", "stovetop"], 15, 43, 4, True, [
              ("chicken-breast", 450, "g"), ("spaghetti", 290, "g"), ("mushrooms", 250, "g"),
              ("onion", 1, "piece"), ("milk", 300, "ml"), ("chicken-stock", 260, "ml"),
              ("butter", 35, "g"), ("flour", 35, "g"), ("parmesan", 60, "g"),
              ("breadcrumbs", 35, "g"), ("dried-thyme", 1, "tsp"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Heat the oven to 200°C (400°F). Simmer the chicken in water until the thickest part reaches 74°C (165°F), then shred it.",
              "Cook the spaghetti for 2 minutes less than the packet suggests. Drain and set it aside.",
              "Slice the mushrooms and onion. Fry them in half the butter until the water from the mushrooms evaporates.",
              "Stir in the remaining butter, flour and thyme. Slowly whisk in the milk and stock. Simmer until the sauce thickens.",
              "Add the pepper, spaghetti, chicken and half the parmesan. Tip into a baking dish and top with breadcrumbs and the remaining parmesan.",
              "Bake for 15–18 minutes until bubbling at the sides and golden. Let it settle briefly before serving.",
          ]),
        R("meatball-stuffed-pasta-shells", "Meatball-stuffed pasta shells", "🍝", "Italian",
          ["comfort", "family", "batchFriendly"], ["oven", "stovetop"], 23, 35, 4, True, [
              ("jumbo-pasta-shells", 300, "g"), ("ground-beef", 450, "g"), ("breadcrumbs", 30, "g"),
              ("eggs", 1, "piece"), ("garlic", 3, "clove"), ("italian-herbs", 2, "tsp"),
              ("passata", 650, "g"), ("mozzarella", 150, "g"), ("olive-oil", 1, "tsp"),
              ("salt", 0.5, "tsp"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Heat the oven to 210°C (410°F). Lightly oil a baking tray and set a pan of water on to boil.",
              "Mix the beef with breadcrumbs, egg, half the crushed garlic, half the herbs, salt and pepper. Roll into small meatballs.",
              "Bake the meatballs for 12–15 minutes until brown and cooked to 71°C (160°F). Meanwhile, boil the shells for 2 minutes less than the packet says.",
              "Stir the remaining garlic and herbs into the passata. Spread half of the sauce in a baking dish.",
              "Set the shells in the dish, open side up, and tuck a small meatball into each. Spoon over the remaining sauce and scatter with torn mozzarella.",
              "Bake for about 15 minutes until the sauce bubbles and the mozzarella turns golden in patches.",
          ]),
        R("sausage-kale-zuppa-toscana", "Sausage and kale zuppa toscana", "🥣", "Italian",
          ["onePan", "comfort", "batchFriendly"], ["stovetop"], 12, 28, 4, True, [
              ("sausages", 350, "g", "skins removed"), ("potato", 650, "g"), ("kale", 160, "g"),
              ("onion", 1, "piece"), ("garlic", 3, "clove"), ("chicken-stock", 800, "ml"),
              ("heavy-cream", 120, "ml"), ("olive-oil", 1, "tsp"), ("black-pepper", 0.5, "tsp"),
          ], [
              "Slice the potatoes into thin half-moons. Chop the onion and garlic and tear the kale from its stems.",
              "Heat the oil in a deep pan. Crumble the sausage meat into it and cook until browned, breaking up large pieces.",
              "Stir in the onion for 5 minutes, then add the garlic for 30 seconds.",
              "Pour in the stock and add the sliced potatoes. Simmer for 12–15 minutes until the potatoes are tender and the sausage is cooked.",
              "Stir in the torn kale and simmer for 3 minutes, then add the cream and warm it gently.",
              "Taste, finish with pepper and ladle into bowls with an even share of sausage, potatoes and greens.",
          ]),
    ]
    for recipe in recipes:
        recipe["tags"] = []
    return recipes
