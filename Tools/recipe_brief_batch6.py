"""Stir-fries, rice bowls and skillet favourites from the Tommo recipe brief."""


def build_recipes(R):
    def dinner(id, title, emoji, cuisine, vibes, tools, prep, cook, leftovers, ingredients, method):
        recipe = R(id, title, emoji, cuisine, vibes, tools, prep, cook, 4, leftovers, ingredients, method.split("\n"))
        recipe["tags"] = []
        return recipe

    return [
        dinner("chinese-pepper-steak", "Chinese pepper steak", "🥩", "Chinese", ["highProtein", "quickEasy"],
               ["stovetop"], 12, 18, False, [
            ("beef-steak", 500, "g"), ("bell-pepper", 2, "piece", "red and green"),
            ("onion", 1, "piece"), ("long-grain-rice", 240, "g"), ("soy-sauce", 2, "tbsp"),
            ("ginger", 12, "g"), ("garlic", 3, "clove"), ("cornstarch", 2, "tsp"), ("vegetable-oil", 1.5, "tbsp"),
            ("black-pepper", 1, "tsp"), ("sugar", 1, "tsp"), ("rice-vinegar", 1, "tbsp"),
        ], """Cook the rice following the packet. Slice the beef into thin strips across the grain.
Cut the peppers and onion into thick strips. Stir the soy, ginger, garlic, cornflour, pepper, sugar and vinegar into 100 ml water.
Heat half the oil in a wide frying pan and brown the beef quickly in batches. Transfer to a clean plate.
Add the rest of the oil and stir-fry the peppers and onion until browned at the edges.
Return the beef to the pan. Stir up the sauce, pour it in and cook until it thickens and the beef is cooked to your liking.
Divide the plain rice between bowls and spoon the steak and peppers beside it."""),
        dinner("honey-garlic-prawn-stir-fry", "Honey garlic prawn stir-fry", "🍤", "Chinese",
               ["quickEasy", "highProtein"], ["stovetop"], 12, 17, False, [
            ("shrimp", 520, "g", "peeled"), ("broccoli", 320, "g"), ("peas-frozen", 130, "g"),
            ("bell-pepper", 1, "piece", "red"), ("basmati-rice", 260, "g"),
            ("garlic", 4, "clove"), ("honey", 2, "tbsp"), ("soy-sauce", 2, "tbsp"),
            ("rice-vinegar", 1, "tbsp"), ("vegetable-oil", 1.5, "tbsp"), ("cornstarch", 1, "tsp"),
        ], """Rinse the rice and cook it following the packet. Cut the broccoli and pepper into bite-size pieces.
Whisk the honey, soy, vinegar, cornflour and crushed garlic with 60 ml water.
Pat the prawns dry. Heat half the oil in a pan and cook the prawns until pink and opaque. Lift them onto a clean plate.
Add the remaining oil and stir-fry the broccoli and pepper for a few minutes. Add the peas and a splash of water.
Pour in the sauce and bubble until it coats the vegetables. Return the prawns and toss until glossy and hot.
Spoon the stir-fry and its sauce over the rice."""),
        dinner("korean-bbq-meatball-rice", "Korean BBQ meatball rice bowls", "🍚", "Korean",
               ["highProtein", "batchFriendly", "family"], ["oven", "stovetop"], 18, 22, True, [
            ("ground-beef", 480, "g"), ("eggs", 1, "piece"), ("breadcrumbs", 40, "g"), ("long-grain-rice", 250, "g"),
            ("cucumber", 1, "piece"), ("garlic", 3, "clove"), ("ginger", 14, "g"), ("gochujang", 1.5, "tbsp"),
            ("soy-sauce", 2, "tbsp"), ("honey", 1.5, "tbsp"), ("rice-vinegar", 2, "tbsp"),
            ("sesame-oil", 1, "tsp"), ("sesame-seeds", 2, "tsp"),
        ], """Heat the oven to 210°C (410°F). Set the rice cooking following the packet.
Mix the beef, egg, breadcrumbs, crushed garlic, grated ginger and half the soy. Form 16 small meatballs.
Spread on a lined tray and roast for 14–17 minutes, until cooked to 71°C (160°F).
Slice the cucumber and toss with half the vinegar. Heat the gochujang, honey, sesame oil, remaining soy and vinegar in a pan.
Bubble until lightly syrupy, then roll the roasted meatballs in the glaze.
Serve the glazed meatballs over rice with cucumber slices and a sprinkling of sesame seeds."""),
        dinner("spicy-mayo-steak-rice-bowls", "Steak rice bowls with spicy mayo", "🥩", "Other",
               ["highProtein", "quickEasy"], ["stovetop"], 10, 18, False, [
            ("beef-steak", 500, "g"), ("basmati-rice", 250, "g"), ("carrot", 220, "g"),
            ("spring-onion", 3, "piece"), ("mayonnaise", 60, "g"), ("sriracha", 1.5, "tbsp"),
            ("lime", 1, "piece"), ("vegetable-oil", 1, "tbsp"), ("soy-sauce", 1, "tbsp"), ("salt", 0.5, "tsp"),
        ], """Cook and fluff the rice. Cut the carrots into fine matchsticks and slice the spring onions.
Toss the carrots in half the lime juice. Stir the other half into the mayo with sriracha.
Pat the steak dry, season it with salt and heat the oil in a heavy frying pan.
Sear the steak on both sides to at least 63°C (145°F), then rest for at least 3 minutes.
Slice across the grain and toss the meat with its juices and the soy sauce.
Divide the rice, steak and carrots into bowls. Drizzle over the spicy mayo and add spring onions."""),
        dinner("crispy-chicken-rice-paper-bites", "Chicken rice paper bites", "🥟", "Other",
               ["highProtein", "fakeaway"], ["stovetop"], 21, 19, False, [
            ("chicken-breast", 540, "g"), ("rice-paper", 16, "piece"), ("cabbage", 300, "g"),
            ("ginger", 16, "g"), ("spring-onion", 4, "piece"), ("soy-sauce", 2, "tbsp"),
            ("rice-vinegar", 2, "tbsp"), ("sesame-oil", 1, "tsp"), ("vegetable-oil", 2, "tbsp"),
        ], """Dice the chicken finely, shred the cabbage and grate the ginger. Slice the spring onions.
Fry the chicken in a little vegetable oil until it reaches 74°C (165°F). Stir in cabbage, ginger, onions and half the soy and cook until dry enough to mound.
Let the filling cool on a clean plate. Dip a sheet of rice paper into water briefly and lay it flat.
Put two spoonfuls of filling in the middle. Fold each side over, then fold the ends tight to form a parcel. Repeat.
Heat the remaining oil and fry the parcels in batches, leaving space between them, until golden on both sides.
Mix the remaining soy with vinegar and sesame oil. Serve alongside the bites for dipping."""),
        dinner("bang-bang-crispy-chicken-bowls", "Bang bang chicken bowls", "🍚", "American",
               ["fakeaway", "highProtein"], ["oven", "stovetop"], 15, 22, False, [
            ("chicken-breast", 510, "g"), ("basmati-rice", 240, "g"), ("eggs", 1, "piece"),
            ("breadcrumbs", 80, "g"), ("vegetable-oil", 1.5, "tbsp"), ("cabbage", 230, "g"), ("cucumber", 1, "piece"),
            ("mayonnaise", 60, "g"), ("sweet-chili-sauce", 45, "g"), ("sriracha", 1, "tsp"), ("spring-onion", 3, "piece"),
        ], """Heat the oven to 220°C (425°F). Rinse the rice and put it on to cook.
Cut the chicken into bite-size pieces and coat in beaten egg, then breadcrumbs.
Spread the chicken on a lined tray and brush lightly with oil. Bake for 14–18 minutes, turning once, until crisp and 74°C (165°F).
Mix the mayo, sweet chilli sauce and sriracha until pale pink. Shred the cabbage and slice the cucumber and spring onions.
Toss the hot crispy chicken with just enough sauce to lightly coat each bite.
Pile the chicken over rice with the cabbage and cucumber. Add spring onions and serve with the remaining sauce."""),
        dinner("sweet-sour-pork-pineapple", "Sweet and sour pork with pineapple", "🥢", "Chinese",
               ["family", "fakeaway", "highProtein"], ["stovetop"], 16, 22, False, [
            ("pork-tenderloin", 500, "g"), ("bell-pepper", 2, "piece", "red and green"), ("pineapple-tin", 230, "g", "drained"),
            ("long-grain-rice", 240, "g"), ("cornstarch", 70, "g"), ("vegetable-oil", 3, "tbsp"),
            ("ketchup", 55, "g"), ("rice-vinegar", 2, "tbsp"), ("soy-sauce", 1, "tbsp"), ("sugar", 1, "tbsp"),
        ], """Rinse and cook the rice. Cube the pork and slice the peppers into squares.
Whisk ketchup, vinegar, soy, sugar, a teaspoon of cornflour and 100 ml water into a sauce.
Toss the pork in the remaining cornflour. Fry in hot oil until browned all over and 63°C (145°F) inside.
Move the pork to a clean plate to rest for at least 3 minutes. Stir-fry the peppers for 3 minutes.
Add the drained pineapple and the sauce. Bubble until thick enough to coat the back of a spoon.
Return the pork to the pan, toss to coat and serve over the rice."""),
        dinner("cajun-prawn-alfredo", "Cajun prawn Alfredo", "🍤", "American",
               ["comfort", "highProtein"], ["stovetop"], 10, 18, False, [
            ("fettuccine", 320, "g"), ("shrimp", 490, "g", "peeled"), ("heavy-cream", 190, "ml"),
            ("parmesan", 65, "g"), ("butter", 25, "g"), ("garlic", 3, "clove"), ("paprika", 2, "tsp"),
            ("dried-oregano", 1, "tsp"), ("chili-flakes", 0.5, "tsp"), ("black-pepper", 0.5, "tsp"),
            ("parsley", 10, "g"), ("lemon", 1, "piece"),
        ], """Boil the fettuccine until just firm, then drain it, keeping a cup of the cooking water.
Pat the prawns dry and toss with paprika, oregano, chilli and pepper.
Heat half the butter and fry the prawns until pink and opaque. Lift them onto a clean plate.
Melt the rest of the butter in the same pan and cook the garlic for 30 seconds. Add the cream and stir up the browned seasoning.
Toss in the pasta with some cooking water and grated parmesan. Return the prawns and warm through.
Finish with lemon juice and chopped parsley."""),
        dinner("beef-meatballs-parmesan-orzo", "Beef meatballs with creamy parmesan orzo", "🍝", "Italian",
               ["comfort", "highProtein", "batchFriendly"], ["oven", "stovetop"], 16, 25, True, [
            ("ground-beef", 480, "g"), ("eggs", 1, "piece"), ("breadcrumbs", 40, "g"), ("garlic", 3, "clove"),
            ("orzo", 290, "g"), ("chicken-stock", 750, "ml"), ("parmesan", 85, "g"), ("butter", 22, "g"),
            ("italian-herbs", 2, "tsp"), ("parsley", 12, "g"), ("black-pepper", 0.5, "tsp"), ("salt", 0.5, "tsp"),
        ], """Heat the oven to 210°C (410°F). Mix beef, beaten egg, breadcrumbs, herbs, half the garlic and salt.
Roll into 16 meatballs and bake on a lined tray until browned and 71°C (160°F) at the centre.
Melt the butter in a saucepan and stir in the remaining garlic. Add the orzo and toast briefly.
Pour in the stock and simmer, stirring every few minutes until the orzo is tender and creamy.
Stir in most of the grated parmesan off the heat. Loosen with a splash of hot water if needed.
Spoon the orzo into bowls, add the browned meatballs and finish with the remaining parmesan, cracked pepper and parsley."""),
        dinner("prawn-vegetable-yakisoba", "Prawn and vegetable yakisoba", "🍜", "Japanese",
               ["quickEasy", "highProtein", "fakeaway"], ["stovetop"], 12, 15, False, [
            ("egg-noodles", 300, "g"), ("shrimp", 480, "g", "peeled"), ("cabbage", 270, "g"), ("carrot", 150, "g"),
            ("spring-onion", 4, "piece"), ("soy-sauce", 2, "tbsp"), ("worcestershire", 2, "tbsp"),
            ("ketchup", 35, "g"), ("sugar", 1, "tsp"), ("vegetable-oil", 1.5, "tbsp"), ("ginger", 10, "g"),
        ], """Cook the noodles a minute short of the packet timing and drain well. Slice the cabbage and carrot thinly.
Mix soy, Worcestershire sauce, ketchup and sugar. Finely grate the ginger.
Fry the prawns in half the oil until pink and opaque. Lift them onto a clean plate.
Add the remaining oil, ginger, cabbage and carrot. Stir-fry until the vegetables soften slightly.
Add noodles and sauce. Let the noodles sit for a minute to develop browned edges, then toss with the prawns.
Serve immediately with plenty of finely sliced spring onions."""),
        dinner("new-orleans-bbq-prawns", "New Orleans BBQ prawns with bread", "🍤", "American",
               ["quickEasy", "highProtein", "comfort"], ["stovetop"], 10, 12, False, [
            ("shrimp", 600, "g", "peeled"), ("baguette", 320, "g"), ("butter", 75, "g"),
            ("garlic", 5, "clove"), ("worcestershire", 2, "tbsp"), ("lemon", 1, "piece"), ("chicken-stock", 120, "ml"),
            ("paprika", 1, "tsp"), ("black-pepper", 1, "tsp"), ("hot-sauce", 1, "tsp"), ("parsley", 12, "g"),
        ], """Slice the bread into generous pieces. Pat the prawns dry and mince the garlic.
Melt a little of the butter in a wide pan. Stir in garlic, paprika and pepper until fragrant.
Add the stock, Worcestershire sauce, hot sauce and lemon juice. Bubble until reduced a little.
Add the prawns and simmer gently, turning once, until pink and opaque.
Take the pan off the heat and whisk in the remaining cold butter a piece at a time. Stir in chopped parsley.
Divide the prawns and peppery sauce into bowls with slices of bread for dipping."""),
        dinner("chicken-fried-chicken-milk-gravy", "Chicken-fried chicken with milk gravy", "🍗", "American",
               ["comfort", "family", "highProtein"], ["stovetop"], 18, 26, False, [
            ("chicken-breast", 550, "g"), ("flour", 120, "g"), ("eggs", 2, "piece"), ("milk", 420, "ml"),
            ("vegetable-oil", 4, "tbsp"), ("potato", 620, "g"), ("peas-frozen", 230, "g"), ("butter", 32, "g"),
            ("black-pepper", 1, "tsp"), ("garlic-powder", 1, "tsp"), ("salt", 0.75, "tsp"),
        ], """Peel and cube the potatoes. Boil until soft and add the peas to a separate pan for their last few minutes.
Slice the chicken into four even cutlets. Reserve 2 tablespoons of flour for the gravy and mix the rest with garlic powder, half the salt and half the pepper.
Beat the eggs with a little of the milk. Coat the cutlets in the flour, then egg and then flour again to make a craggy coating.
Fry in hot oil until golden and 74°C (165°F) in the centre. Rest on a rack and carefully pour off most of the oil.
Whisk the reserved flour into the drippings, then slowly add most of the remaining milk. Simmer until it coats a spoon and add the remaining pepper.
Mash the potatoes with butter, salt and the last splash of milk. Put the chicken beside the mash and peas and spoon its gravy over one end."""),
    ]
