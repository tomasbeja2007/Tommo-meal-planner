"""Tacos, rolled tortillas and takeout-inspired mains from the recipe brief."""


def build_recipes(R):
    def dinner(id, title, emoji, cuisine, vibes, tools, prep, cook, leftovers, ingredients, method):
        recipe = R(id, title, emoji, cuisine, vibes, tools, prep, cook, 4, leftovers, ingredients, method.split("\n"))
        recipe["tags"] = []
        return recipe

    return [
        dinner("salmon-sushi-tacos", "Salmon sushi tacos", "🌮", "Japanese", ["highProtein", "fakeaway"],
               ["oven", "stovetop"], 18, 22, False, [
            ("corn-tortillas", 8, "piece"), ("nori", 4, "piece"), ("sushi-rice", 230, "g"),
            ("salmon-fillet", 400, "g"), ("avocado", 1, "piece"), ("cucumber", 0.5, "piece"),
            ("rice-vinegar", 2, "tbsp"), ("soy-sauce", 1, "tbsp"), ("sesame-seeds", 2, "tsp"),
            ("vegetable-oil", 1, "tbsp"), ("sugar", 0.5, "tsp"),
        ], """Heat the oven to 210°C (410°F). Rinse the sushi rice and cook it following the packet.
Brush the tortillas lightly with oil and drape them over an ovenproof rack to make taco shells. Bake for 6–8 minutes until firm and lightly golden.
Brush the salmon with soy sauce and bake on a separate tray until it flakes easily and reaches 63°C (145°F).
Mix vinegar and sugar. Fold them through the hot rice and spread the rice out for a few minutes to cool.
Slice the avocado, cut the cucumber into thin sticks and flake the cooked salmon into chunks.
Cut the nori into half sheets and press one into each shell. Fill with the rice, salmon, avocado and cucumber, then sprinkle with sesame."""),
        dinner("crispy-chipotle-beef-tacos", "Cheesy chipotle beef tacos", "🌮", "Mexican", ["fakeaway", "highProtein"],
               ["stovetop"], 12, 22, False, [
            ("ground-beef", 460, "g"), ("corn-tortillas", 12, "piece"), ("cheddar", 140, "g"),
            ("onion", 1, "piece"), ("chipotles-in-adobo", 30, "g"), ("passata", 160, "g"),
            ("cumin", 1, "tsp"), ("vegetable-oil", 1, "tbsp"), ("spring-onion", 3, "piece"), ("lime", 1, "piece"),
        ], """Dice the onion and finely chop the chipotles. Grate the cheese and slice the spring onions.
Fry the onion in half the oil for 4 minutes. Brown the mince in the same pan, breaking it into small pieces.
Stir in the chipotles, cumin and passata. Simmer until the mince is cooked and the sauce thick enough to sit on a spoon.
Warm the tortillas in a clean dry pan until flexible. Put a little grated cheese and some beef on one half of each.
Fold the tortillas over. Brush lightly with the remaining oil and fry on both sides until browned and crisp at the edges.
Scatter over the spring onions and serve with lime wedges."""),
        dinner("chicken-rice-burritos", "Chicken and rice burritos", "🌯", "Mexican", ["highProtein", "family", "batchFriendly"],
               ["stovetop"], 12, 20, True, [
            ("chicken-breast", 500, "g"), ("long-grain-rice", 210, "g"), ("black-beans", 240, "g", "drained"),
            ("tortillas", 4, "piece", "large"), ("salsa", 130, "g"), ("lime", 1, "piece"),
            ("vegetable-oil", 1, "tbsp"), ("paprika", 1, "tsp"), ("cumin", 1, "tsp"), ("salt", 0.5, "tsp"),
        ], """Rinse the rice and cook it following the packet. Drain the beans, rinse them and warm them with a spoonful of water.
Cut the chicken into bite-size pieces and toss with lime zest, paprika, cumin and salt.
Heat the oil in a frying pan and cook the chicken until golden and 74°C (165°F) in the centre.
Squeeze the lime over the chicken and toss. Warm the tortillas briefly in a clean pan.
Lay out the rice in a strip down the middle of each tortilla. Top with the black beans, chicken and salsa.
Fold in both sides and roll up snugly. Toast in a dry pan until lightly marked on both sides, then slice across the middle."""),
        dinner("crispy-beef-bean-burritos", "Crispy beef burritos", "🌯", "Mexican", ["comfort", "fakeaway", "batchFriendly"],
               ["stovetop"], 12, 23, True, [
            ("ground-beef", 420, "g"), ("kidney-beans", 240, "g", "tinned, drained"), ("tortillas", 4, "piece", "large"),
            ("cheddar", 120, "g"), ("roasted-peppers", 150, "g", "drained"), ("onion", 1, "piece"),
            ("tomato-paste", 2, "tbsp"), ("paprika", 1, "tsp"), ("cumin", 1, "tsp"), ("vegetable-oil", 1, "tbsp"),
        ], """Dice the onion and roast peppers. Grate the cheddar and rinse the kidney beans.
Heat a little oil in a skillet and brown the beef, using a spoon to break it up.
Add the onion, paprika, cumin and tomato paste. Cook until the onion softens and the beef is fully cooked.
Fold in the beans and sliced peppers. Simmer briefly until the filling is thick and almost dry.
Put a quarter of the filling and cheese on each tortilla. Fold in the sides and roll tightly.
Brush the skillet with the remaining oil and griddle the burritos seam-side down first. Turn until crisp, then halve to serve."""),
        dinner("oven-crisp-chicken-chimichangas", "Oven-crisp chicken chimichangas", "🌯", "Mexican", ["family", "fakeaway", "highProtein"],
               ["stovetop", "oven"], 15, 28, False, [
            ("chicken-breast", 520, "g"), ("tortillas", 4, "piece", "large"), ("bell-pepper", 2, "piece"),
            ("onion", 1, "piece"), ("vegetable-oil", 2, "tbsp"), ("salsa", 120, "g"),
            ("paprika", 1, "tsp"), ("cumin", 1, "tsp"), ("sour-cream", 100, "g"),
        ], """Heat the oven to 220°C (425°F) and line a baking tray.
Poach the chicken in gently simmering water until it reaches 74°C (165°F). Let it cool slightly before shredding.
Slice the peppers and onion. Fry them in half the oil for about 6 minutes until soft and browned at the edges.
Stir the shredded chicken, salsa, paprika and cumin into the peppers. Cook until the filling is thick rather than wet.
Fill the tortillas, tuck in the sides and roll tightly. Brush with the remaining oil and bake seam-side down for 12–15 minutes.
Cut each chimichanga in half on the diagonal and serve with sour cream alongside."""),
        dinner("honey-lime-chicken-enchiladas", "Honey lime chicken enchiladas", "🌮", "Mexican", ["family", "highProtein", "batchFriendly"],
               ["stovetop", "oven"], 17, 36, True, [
            ("chicken-thighs", 530, "g", "boneless"), ("corn-tortillas", 8, "piece"), ("passata", 450, "g"),
            ("cheddar", 120, "g"), ("honey", 1.5, "tbsp"), ("lime", 2, "piece"), ("garlic", 3, "clove"),
            ("paprika", 1, "tsp"), ("cumin", 1, "tsp"), ("olive-oil", 1, "tbsp"), ("cilantro", 12, "g"),
        ], """Heat the oven to 200°C (400°F). In a saucepan, bring enough water to cover the chicken to a gentle simmer.
Poach the thighs until they reach 74°C (165°F). Drain and shred them, then toss with honey and juice from one lime.
Fry the crushed garlic in the oil for 30 seconds. Add the passata, paprika and cumin and simmer for 5 minutes.
Warm the tortillas to make them flexible. Spoon a little tomato sauce into a baking dish and roll a portion of chicken into each tortilla.
Set the rolls seam-side down. Spoon the remaining red sauce over them and scatter over the cheese. Bake for 15–18 minutes until bubbling.
Finish with chopped coriander and serve with wedges of the remaining lime."""),
        dinner("white-cheese-chicken-enchiladas", "White chicken and cheese enchiladas", "🧀", "Mexican", ["comfort", "family", "highProtein"],
               ["stovetop", "oven"], 15, 40,  True, [
            ("chicken-breast", 480, "g"), ("tortillas", 8, "piece", "small"), ("mozzarella", 170, "g"),
            ("chicken-stock", 450, "ml"), ("sour-cream", 130, "g"), ("butter", 30, "g"),
            ("flour", 30, "g"), ("spring-onion", 3, "piece"), ("cumin", 0.5, "tsp"), ("black-pepper", 0.5, "tsp"),
        ], """Heat the oven to 200°C (400°F). Poach the chicken in gently simmering water until it reaches 74°C (165°F).
Shred the chicken and toss it with the cumin, pepper and half the chopped spring onions.
Melt the butter in a saucepan. Stir in the flour for a minute, then slowly whisk in the stock until the sauce thickens.
Take off the heat and stir in the sour cream. Spread a little of the white sauce in a baking dish.
Fill each tortilla with chicken, roll it up and set it in the dish. Cover with the remaining sauce and scatter on the torn mozzarella.
Bake for 15–20 minutes, until bubbling and lightly browned. Finish with the remaining spring onions."""),
        dinner("fideo-loco-beef-bean-soup", "Beef and bean fideo loco", "🥣", "Mexican", ["comfort", "onePan", "fiberForward"],
               ["stovetop"], 12, 25, True, [
            ("spaghetti", 180, "g"), ("ground-beef", 370, "g"), ("pinto-beans", 260, "g", "tinned, drained"),
            ("passata", 400, "g"), ("vegetable-stock", 850, "ml"), ("onion", 1, "piece"),
            ("garlic", 3, "clove"), ("cumin", 1, "tsp"), ("vegetable-oil", 1, "tbsp"), ("cilantro", 12, "g"),
        ], """Snap the spaghetti into short lengths. Heat half the oil in a deep pan and toast the pasta until lightly golden. Scoop it out.
Add the remaining oil and brown the beef, breaking it up with a spoon.
Dice the onion and stir it into the beef for 5 minutes. Add crushed garlic and cumin and stir until fragrant.
Pour in the passata and stock and return the toasted pasta to the pan.
Simmer until the pasta is soft, then stir in the rinsed pinto beans and warm them through.
Serve in bowls with plenty of red broth and a small handful of chopped coriander."""),
        dinner("beef-taco-salad", "Beef taco salad", "🥗", "Mexican", ["highProtein", "quickEasy"],
               ["oven", "stovetop"], 15, 15, False, [
            ("ground-beef", 440, "g"), ("lettuce", 380, "g"), ("tomato", 260, "g"), ("sweetcorn-tin", 150, "g", "drained"),
            ("cheddar", 70, "g"), ("corn-tortillas", 4, "piece"), ("lime", 2, "piece"),
            ("vegetable-oil", 1, "tbsp"), ("cumin", 1, "tsp"), ("paprika", 1, "tsp"), ("salsa", 80, "g"),
        ], """Heat the oven to 200°C (400°F). Slice the tortillas into thin strips and toss with half the oil.
Bake the strips in a single layer for 8–10 minutes, turning once, until crisp.
Fry the beef in the remaining oil. Add cumin and paprika, breaking up the mince until it is cooked through.
Chop the lettuce and tomatoes. Drain the sweetcorn, grate the cheddar and mix the salsa with juice from one lime.
Heap the lettuce and tomatoes into bowls, top with beef and sweetcorn and spoon over the dressing.
Scatter the cheddar and tortilla strips on top. Serve with the remaining lime cut into wedges."""),
        dinner("korean-fried-chicken", "Korean fried chicken", "🍗", "Korean", ["fakeaway", "highProtein"],
               ["stovetop"], 15, 23, False, [
            ("chicken-thighs", 650, "g", "boneless"), ("cornstarch", 95, "g"), ("eggs", 1, "piece"),
            ("gochujang", 2, "tbsp"), ("honey", 2, "tbsp"), ("soy-sauce", 1, "tbsp"),
            ("rice-vinegar", 1, "tbsp"), ("vegetable-oil", 5, "tbsp"), ("sesame-seeds", 2, "tsp"),
            ("spring-onion", 3, "piece"), ("ginger", 10, "g"),
        ], """Cut the chicken into even bites and pat them dry. Whisk the egg in a bowl and spread the cornflour on a plate.
Dip the chicken pieces in egg and coat all over in cornflour. Shake off loose flour.
Heat most of the oil in a frying pan. Fry in small batches until cooked to 74°C (165°F), then transfer to a rack.
Heat the rest of the oil and briefly fry the cooked chicken again until the coating turns extra crisp.
In a small pan, stir together the gochujang, honey, soy, vinegar and grated ginger. Bubble for a minute.
Toss the chicken in the glaze just before serving and scatter over sesame and sliced spring onions."""),
        dinner("orange-glazed-crispy-chicken", "Orange chicken", "🍊", "Chinese", ["fakeaway", "highProtein", "family"],
               ["stovetop"], 15, 23, False, [
            ("chicken-breast", 520, "g"), ("long-grain-rice", 260, "g"), ("orange", 2, "piece"),
            ("cornstarch", 80, "g"), ("eggs", 1, "piece"), ("soy-sauce", 1.5, "tbsp"),
            ("rice-vinegar", 1, "tbsp"), ("sugar", 1.5, "tbsp"), ("vegetable-oil", 4, "tbsp"),
            ("ginger", 10, "g"), ("garlic", 2, "clove"),
        ], """Rinse the rice and cook following the packet. Finely cut a few strips of orange zest and juice both oranges.
Mix the juice with soy sauce, vinegar, sugar, ginger, garlic and a teaspoon of cornflour.
Dice the chicken, toss it in beaten egg and coat in the remaining cornflour.
Fry the chicken in the hot oil in batches until crisp and 74°C (165°F) at the centre. Transfer to a rack.
Tip off the excess oil. Add the juice mixture and orange zest to the pan and bring to a bubble until it turns glossy.
Toss the chicken in the thick glaze and immediately serve alongside the rice."""),
        dinner("chicken-pad-see-ew", "Chicken pad see ew", "🍜", "Thai", ["highProtein", "quickEasy", "fakeaway"],
               ["stovetop"], 13, 14, False, [
            ("rice-noodles", 300, "g", "choose wide, flat noodles"), ("chicken-breast", 440, "g"),
            ("broccoli", 320, "g"), ("eggs", 2, "piece"), ("soy-sauce", 3, "tbsp"),
            ("fish-sauce", 1, "tbsp"), ("sugar", 2, "tsp"), ("rice-vinegar", 1, "tbsp"),
            ("garlic", 3, "clove"), ("vegetable-oil", 2, "tbsp"),
        ], """Soften the wide noodles according to the packet, then drain them very well. Thinly slice the chicken and cut the broccoli into small florets.
Mix the soy, fish sauce, sugar and vinegar. Crush the garlic.
Heat half the oil in a wide pan and fry the chicken until fully cooked, then briefly stir-fry the broccoli and garlic.
Push the chicken and broccoli aside. Add the beaten eggs to the empty space and stir into loose curds.
Add the remaining oil, sauce and noodles. Let the underside of the noodles catch against the hot pan for a minute before tossing.
Toss until the noodles are dark and glossy and the egg and chicken are evenly mixed through. Serve hot."""),
    ]
