"""Burritos, fried rice and chicken mains from the closing section of the recipe brief."""


def build_recipes(R):
    def recipe(id, title, emoji, cuisine, vibes, appliances, prep, cook, leftovers, ingredients, steps, meal="dinner"):
        row = R(id, title, emoji, cuisine, vibes, appliances, prep, cook, 4, leftovers, ingredients, steps.split("\n"), meal=meal)
        row["tags"] = []
        return row

    return [
        recipe("chicken-potato-gratin","Chicken and potato gratin","🥔","British",["comfort","family","batchFriendly"],["oven","stovetop"],16,48,True,[
            ("chicken-breast",520,"g"),("potato",780,"g"),("milk",300,"ml"),("heavy-cream",110,"ml"),
            ("cheddar",130,"g"),("butter",15,"g"),("garlic",3,"clove"),("dried-thyme",1,"tsp"),("salt",0.5,"tsp"),("black-pepper",0.5,"tsp"),
        ],"""Heat the oven to 200°C (400°F) and butter a small baking dish.
Poach the chicken until it reaches 74°C (165°F), then shred it. Thinly slice the potatoes.
Heat milk, cream, crushed garlic, thyme, salt and pepper in a wide pan. Add the sliced potatoes and simmer for 8 minutes.
Layer half the potatoes in the baking dish, followed by the chicken and half the cheddar. Cover with the remaining potatoes and their cream.
Scatter over the rest of the cheddar and bake for 25–30 minutes, until bubbling and a knife slips easily through the layers.
Rest for about 8 minutes, then slice into four squares."""),
        recipe("honey-chipotle-chicken-skewers","Honey chipotle chicken skewers","🍢","Mexican",["highProtein","fakeaway"],["stovetop"],16,17,False,[
            ("chicken-breast",580,"g"),("corn-on-cob",4,"piece"),("chipotles-in-adobo",35,"g"),("honey",2,"tbsp"),
            ("lime",3,"piece"),("garlic",3,"clove"),("vegetable-oil",1.5,"tbsp"),("paprika",1,"tsp"),("salt",0.5,"tsp"),
        ],"""Finely chop the chipotles and mix with honey, crushed garlic, paprika, salt and juice from two limes.
Cut the chicken into even pieces and coat them with the mixture. Thread the pieces onto metal skewers.
Heat an oiled griddle. Cook the corn cobs, turning occasionally until lightly charred, then set them aside.
Griddle the chicken, turning each skewer so it browns evenly. Cook until the largest piece reaches 74°C (165°F).
Let the skewers rest briefly. Cut the remaining lime into wedges.
Serve the chicken skewers alongside the charred corn with lime for squeezing."""),
        recipe("cheesy-prawn-quesadillas","Prawn and cheese quesadillas","🧀","Mexican",["highProtein","quickEasy","fakeaway"],["stovetop"],11,13,False,[
            ("shrimp",480,"g","peeled"),("tortillas",8,"piece","small"),("cheddar",150,"g"),("bell-pepper",1,"piece","red"),
            ("salsa",140,"g"),("lime",1,"piece"),("vegetable-oil",1,"tbsp"),("garlic",2,"clove"),("paprika",1,"tsp"),
        ],"""Finely dice the pepper and fry it in the oil for 3 minutes. Add crushed garlic and paprika.
Add the prawns and stir-fry until pink and opaque. Chop any large pieces and squeeze lime juice over the filling.
Spread the prawns and grated cheese across four tortillas and top with the remaining tortillas.
Toast in a clean dry pan until golden on both sides and the cheese has melted.
Rest for a minute, cut into wedges and serve with salsa.""",meal="lunch"),
        recipe("prawn-avocado-rice-burritos","Prawn and avocado rice burritos","🌯","Mexican",["highProtein","quickEasy"],["stovetop"],14,18,False,[
            ("shrimp",500,"g","peeled"),("long-grain-rice",190,"g"),("avocado",2,"piece"),("tomato",220,"g"),
            ("tortillas",4,"piece","large"),("lime",2,"piece"),("cilantro",14,"g"),("garlic",2,"clove"),
            ("olive-oil",1,"tbsp"),("paprika",1,"tsp"),("salt",0.5,"tsp"),
        ],"""Cook the rice and fluff with juice from one lime and chopped coriander.
Dice the tomato and slice the avocado. Squeeze half the remaining lime over the avocado.
Pat the prawns dry and toss with paprika and salt. Quickly fry them with the oil and crushed garlic until pink and opaque.
Turn the prawns through the juice from the last half lime. Warm the tortillas in a dry pan until flexible.
Fill each tortilla with rice, prawns, avocado and tomato, leaving the sides clear.
Fold the sides in and roll snugly. Toast in a dry pan until lightly browned, then slice across the middle."""),
        recipe("pork-pineapple-burritos","Pork and pineapple burritos","🌯","Mexican",["highProtein","fakeaway","batchFriendly"],["stovetop"],15,22,False,[
            ("pork-tenderloin",500,"g"),("pineapple-tin",220,"g","drained"),("long-grain-rice",200,"g"),
            ("red-onion",1,"piece"),("tortillas",4,"piece","large"),("chipotles-in-adobo",25,"g"),
            ("lime",1,"piece"),("vegetable-oil",1.5,"tbsp"),("cumin",1,"tsp"),("garlic",2,"clove"),
        ],"""Cook the rice. Cut the pork and pineapple into small pieces and dice the red onion.
Coat the pork with chopped chipotle, cumin, garlic and a little oil.
Sear the pork in batches until browned and at least 63°C (145°F) inside, then rest for at least 3 minutes.
Char the pineapple in the same hot pan, add the red onion briefly and squeeze over lime juice.
Lay rice, pork, pineapple and onion in a strip across each warm tortilla. Tuck in the sides and roll tightly.
Griddle seam-side down first, then turn to lightly brown both sides. Cut each burrito in half."""),
        recipe("baja-fish-burritos","Baja fish burritos","🌯","Mexican",["highProtein","fakeaway"],["stovetop"],16,20,False,[
            ("white-fish",530,"g"),("flour",100,"g"),("baking-powder",1,"tsp"),("vegetable-oil",4,"tbsp"),
            ("tortillas",4,"piece","large"),("long-grain-rice",185,"g"),("red-cabbage",280,"g"),
            ("greek-yogurt",150,"g"),("lime",2,"piece"),("paprika",1,"tsp"),("salt",0.5,"tsp"),
        ],"""Cook the rice and thinly shred the cabbage. Stir lime juice and a pinch of salt into the yoghurt.
Cut the fish into thick strips and pat dry. Mix flour, baking powder, paprika and the remaining salt.
Add enough very cold water to make a thin batter. Heat the oil in a wide frying pan.
Dip the fish in the batter and fry in batches until golden and at least 63°C (145°F) inside. Drain on a rack.
Warm the tortillas and add cabbage, rice, battered fish and lime yoghurt.
Fold in the sides and roll up. Briefly toast in a dry pan, then cut in half just before serving."""),
        recipe("cajun-prawn-rice","Cajun prawn rice","🍤","American",["onePan","highProtein","family"],["stovetop"],12,28,False,[
            ("shrimp",520,"g","peeled"),("long-grain-rice",280,"g"),("bell-pepper",1,"piece","red"),
            ("celery",150,"g"),("onion",1,"piece"),("vegetable-stock",610,"ml"),("tomato-paste",2,"tbsp"),
            ("paprika",2,"tsp"),("dried-thyme",1,"tsp"),("chili-flakes",0.5,"tsp"),
            ("vegetable-oil",1.5,"tbsp"),("spring-onion",4,"piece"),("lemon",1,"piece"),
        ],"""Rinse the rice. Finely dice the celery, pepper and onion and slice the spring onions.
Soften the celery, pepper and onion in a lidded frying pan with the oil for 5 minutes.
Stir in tomato paste, paprika, thyme and chilli flakes. Add the rice and stir to coat it.
Pour in the stock, cover and cook on low for 14–16 minutes, until most of the liquid is absorbed.
Nestle the prawns into the almost cooked rice. Cover and cook until the prawns are pink and opaque and the rice tender.
Fluff gently and finish with lemon juice and sliced spring onions."""),
        recipe("salmon-broccoli-fried-rice","Salmon and broccoli fried rice","🍚","Other",["onePan","highProtein","quickEasy"],["stovetop"],11,17,False,[
            ("salmon-fillet",450,"g"),("microwave-rice",500,"g"),("broccoli",320,"g"),("eggs",3,"piece"),
            ("spring-onion",4,"piece"),("soy-sauce",2,"tbsp"),("sesame-oil",1,"tsp"),("vegetable-oil",1.5,"tbsp"),("ginger",12,"g"),
        ],"""Pat the salmon dry, cut the broccoli into very small florets and beat the eggs.
Sear the salmon in some vegetable oil until it flakes and reaches 63°C (145°F). Move it to a clean plate.
Add the eggs to the pan and stir into soft curds. Lift them out before they dry.
Stir-fry the florets and grated ginger in the remaining oil, then add the packet rice and cook until piping hot.
Remove skin from the salmon and flake it into large pieces. Fold through the rice with the egg, soy and sesame oil.
Scatter with sliced spring onion and serve straight away."""),
        recipe("teriyaki-turkey-edamame-rice","Teriyaki turkey rice","🍚","Japanese",["highProtein","quickEasy","batchFriendly"],["stovetop"],10,19,True,[
            ("ground-turkey",500,"g"),("long-grain-rice",255,"g"),("edamame-frozen",220,"g"),("cabbage",240,"g"),
            ("soy-sauce",2,"tbsp"),("mirin",2,"tbsp"),("honey",1,"tbsp"),("ginger",12,"g"),("garlic",2,"clove"),
            ("vegetable-oil",1,"tbsp"),("spring-onion",3,"piece"),("sesame-seeds",2,"tsp"),
        ],"""Cook the rice. Briefly boil the edamame separately, then drain. Shred the cabbage and slice the spring onions.
Mix soy, mirin, honey, grated ginger and crushed garlic with a few spoonfuls of water.
Heat the oil in a wide pan and fry the mince, breaking it up until fully cooked to 74°C (165°F).
Pour in the sauce and cook until slightly sticky and glossy. Warm the cabbage through in the side of the pan.
Divide the rice into bowls. Add the glazed turkey and spoon the edamame and cabbage alongside.
Finish with sesame seeds and sliced spring onions."""),
        recipe("filipino-chicken-adobo","Filipino chicken adobo","🍗","Other",["family","comfort","batchFriendly","highProtein"],["stovetop"],10,37,True,[
            ("chicken-thighs",640,"g","boneless"),("basmati-rice",260,"g"),("soy-sauce",3,"tbsp"),("rice-vinegar",4,"tbsp"),
            ("garlic",6,"clove"),("bay-leaves",2,"piece"),("black-pepper",1,"tsp"),("sugar",1,"tsp"),("vegetable-oil",1,"tbsp"),
        ],"""Pat the chicken dry. Crush the garlic and stir soy sauce, vinegar, pepper and sugar together.
Heat the oil and brown the chicken on both sides. Scatter the garlic into the pan for 30 seconds.
Pour in the soy and vinegar mixture, add the bay leaves and enough water to come partway up the chicken.
Bring to the boil, then cover and simmer gently until the chicken reaches 74°C (165°F). Meanwhile cook the rice.
Uncover and reduce the sauce until glossy, turning the chicken so it picks up the glaze.
Leave the bay leaves in the pan and serve the chicken and sharp, savoury sauce beside the rice."""),
        recipe("chicken-pineapple-fried-rice","Chicken pineapple fried rice","🍍","Thai",["onePan","highProtein","fakeaway"],["stovetop"],13,16,False,[
            ("chicken-breast",480,"g"),("microwave-rice",500,"g"),("pineapple-tin",240,"g","drained"),("eggs",2,"piece"),
            ("cashews",60,"g"),("spring-onion",4,"piece"),("soy-sauce",2,"tbsp"),("fish-sauce",1,"tbsp"),
            ("curry-powder",1,"tsp"),("vegetable-oil",1.5,"tbsp"),
        ],"""Dice the chicken, drain the pineapple and slice the spring onions. Beat the eggs.
Toast the cashews briefly in a dry pan and set them aside. Pour a little oil into the pan and scramble the eggs, then lift them out.
Fry the chicken in the remaining oil until browned and 74°C (165°F) inside. Add spring-onion whites and pineapple until lightly coloured.
Scatter in curry powder and packet rice. Stir-fry over high heat until the rice is loose and piping hot.
Add soy and fish sauce and fold through the cooked egg.
Top with toasted cashews and spring-onion greens."""),
        recipe("thai-red-chicken-curry-rice","Thai red chicken curry with rice","🍛","Thai",["highProtein","comfort","family"],["stovetop"],10,22,True,[
            ("chicken-thighs",580,"g","boneless"),("basmati-rice",260,"g"),("coconut-milk",400,"ml"),
            ("thai-curry-paste",2,"tbsp"),("bell-pepper",2,"piece","red"),("fish-sauce",1,"tbsp"),
            ("vegetable-oil",1,"tbsp"),("basil",22,"g"),("lime",1,"piece"),("sugar",1,"tsp"),
        ],"""Rinse the rice and cook it according to the packet. Thinly slice the chicken and red peppers.
Heat the oil and fry the red curry paste for a minute. Stir in a ladle of coconut milk until smooth.
Add the chicken and turn it briefly in the sauce, then stir in the remaining coconut milk.
Simmer for 8 minutes. Add the peppers and cook until tender and the chicken reaches 74°C (165°F).
Stir in the fish sauce, sugar and a squeeze of lime. Take off the heat and fold through most of the basil.
Spoon beside the cooked rice and scatter the remaining basil on top."""),
    ]
