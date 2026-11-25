"""Distinct plant-based, breakfast and baked dishes revisited during deduplication."""


def build_recipes(R):
    def recipe(id, title, emoji, cuisine, vibes, appliances, prep, cook, servings, leftovers, ingredients, steps, meal="dinner"):
        row = R(id, title, emoji, cuisine, vibes, appliances, prep, cook, servings, leftovers, ingredients, steps.split("\n"), meal=meal)
        row["tags"] = []
        return row

    return [
        recipe("green-lentil-roast-veg-rice-bowls","Green lentil and vegetable rice bowls","🥕","Other",["fiberForward","healthyish","batchFriendly"],["oven","stovetop"],12,25,4,True,[
            ("green-lentils-tin",480,"g","drained"),("basmati-rice",230,"g"),("carrot",360,"g"),("zucchini",400,"g"),
            ("lemon",1,"piece"),("olive-oil",2,"tbsp"),("parsley",18,"g"),("cumin",1,"tsp"),("salt",0.5,"tsp"),
        ],"""Heat the oven to 220°C (425°F). Cut the carrots and courgettes into bite-size pieces.
Toss the vegetables in half the oil with cumin and salt. Roast in one layer for 20–25 minutes, turning once.
Cook the rice according to the packet. Rinse and drain the lentils.
Warm the lentils in a small pan with the rest of the oil and a splash of water. Add lemon juice to taste.
Finely chop the parsley and mix some through the warm lentils. Fluff the rice with a fork.
Divide rice, lentils and the roasted vegetables between bowls. Finish with the remaining parsley and lemon wedges."""),
        recipe("cinnamon-fruit-nut-mix","Cinnamon-spiced fruit and nut mix","🥜","Other",["quickEasy","batchFriendly"],["oven"],6,13,4,False,[
            ("walnuts",70,"g"),("cashews",70,"g"),("raisins",45,"g"),("dried-apple",45,"g"),
            ("cinnamon",1,"tsp"),("maple-syrup",1,"tbsp"),("vegetable-oil",1,"tsp"),("salt",1,"pinch"),
        ],"""Heat the oven to 170°C (340°F). Toss walnuts and cashews with maple syrup, oil, cinnamon and salt.
Spread in a thin layer and bake for 10–13 minutes until the nuts smell toasted, stirring halfway.
Let the nuts cool completely on the tray. Chop the dried apple and add it with the raisins.
Stir and divide into four small snack portions.""",meal="snack"),
        recipe("split-pea-spinach-curry","Split pea and spinach curry","🍛","Indian",["fiberForward","batchFriendly","healthyish"],["stovetop"],10,55,4,True,[
            ("yellow-split-peas",260,"g"),("basmati-rice",230,"g"),("spinach",180,"g"),("onion",1,"piece"),("garlic",3,"clove"),
            ("ginger",14,"g"),("vegetable-stock",800,"ml"),("cumin",1,"tsp"),("turmeric",0.5,"tsp"),
            ("garam-masala",1,"tsp"),("vegetable-oil",1.5,"tbsp"),("lemon",1,"piece"),("cilantro",12,"g"),
        ],"""Rinse the split peas and pick out any discoloured pieces. Finely dice the onion and grate the garlic and ginger.
Heat the oil in a deep pan and soften the onion. Add garlic, ginger, cumin and turmeric for a minute.
Add split peas and stock. Simmer gently until very tender, 40–50 minutes, adding water if the pan starts looking dry.
Cook the rice according to the packet while the peas finish. Wash and chop the spinach.
Stir spinach and garam masala into the cooked peas. Rest for a few minutes and add a squeeze of lemon.
Serve beside fluffy rice and top with chopped coriander."""),
        recipe("japanese-bbq-minced-chicken-rice","Japanese BBQ minced chicken rice bowls","🍚","Japanese",["quickEasy","highProtein","batchFriendly"],["stovetop"],12,19,4,True,[
            ("chicken-breast",520,"g","minced or finely chopped"),("sushi-rice",250,"g"),("carrot",200,"g"),
            ("spring-onion",4,"piece"),("miso-paste",1.5,"tbsp"),("soy-sauce",1.5,"tbsp"),("mirin",2,"tbsp"),
            ("sesame-oil",1,"tsp"),("sesame-seeds",2,"tsp"),("vegetable-oil",1,"tbsp"),("ginger",10,"g"),
        ],"""Cook the sushi rice. Cut the carrot into thin matchsticks and slice the spring onions.
Whisk the miso, soy, mirin, sesame oil and grated ginger together with a few spoonfuls of water.
Heat vegetable oil in a frying pan. Add the chicken and break it into small chunks, cooking through to 74°C (165°F).
Add carrot for a couple of minutes and pour in the sauce. Toss until it thickens enough to cling.
Spoon the rice and miso-glazed chicken into bowls.
Scatter with spring onions and sesame seeds. If packing ahead, chill the rice and chicken promptly in shallow containers."""),
        recipe("strawberry-almond-baked-oats","Strawberry and almond baked oats","🍓","Other",["family","fiberForward","batchFriendly"],["oven"],8,28,4,True,[
            ("rolled-oats",200,"g"),("strawberries",300,"g"),("almonds",50,"g"),("milk",350,"ml"),("eggs",2,"piece"),
            ("maple-syrup",2,"tbsp"),("baking-powder",1,"tsp"),("cinnamon",0.5,"tsp"),("butter",8,"g"),
        ],"""Heat the oven to 190°C (375°F). Butter a shallow baking dish and halve the strawberries.
Whisk the milk, eggs and maple syrup. Stir in oats, baking powder, cinnamon and half the flaked almonds.
Fold in most of the strawberries and tip into the dish. Place the remaining berries on top and scatter with the rest of the almonds.
Bake for 24–28 minutes until the middle sets and the almond flakes turn golden. Let it settle for 5 minutes before serving.""",meal="breakfast"),
        recipe("herb-prosciutto-frittata","Herb and prosciutto frittata","🍳","Italian",["quickEasy","highProtein","onePan"],["stovetop","oven"],8,12,2,False,[
            ("eggs",5,"piece"),("prosciutto",60,"g"),("chives",12,"g"),("parsley",12,"g"),
            ("parmesan",35,"g"),("olive-oil",1,"tsp"),("black-pepper",0.5,"tsp"),
        ],"""Heat the oven to 200°C (400°F). Tear the prosciutto into ribbons and roughly chop the herbs.
Beat the eggs with most of the herbs, grated parmesan and pepper. Warm oil in a small ovenproof frying pan.
Add the egg mixture and lay the prosciutto ribbons on top. Cook gently until the sides start to set.
Bake for 6–8 minutes until the centre is set. Scatter with the reserved herbs and cut into wedges.""",meal="breakfast"),
        recipe("meat-lovers-breakfast-skillet","Meat lovers' breakfast skillet","🍳","American",["comfort","highProtein","family"],["stovetop"],12,25,4,False,[
            ("potato",540,"g"),("sausages",170,"g","skins removed"),("bacon",85,"g"),("ham",110,"g"),
            ("eggs",8,"piece"),("onion",1,"piece"),("vegetable-oil",1,"tbsp"),("paprika",1,"tsp"),("black-pepper",0.5,"tsp"),
        ],"""Cut the potatoes into small cubes and boil for 6 minutes. Drain well. Dice the onion and cut the bacon and ham into pieces.
Fry the sausage, breaking it into crumbles. Add the bacon and cook until the sausage is cooked through and the bacon crisps. Lift onto a clean plate.
Heat a little oil in the same pan, toss in the potatoes and onion and fry until browned. Stir in paprika, pepper, diced ham and the cooked meats.
Reduce the heat and make wells in the hash. Crack in the eggs, working in two batches if necessary, and cook until the whites set.
Serve each portion with two fried eggs over the crisp potato and meat mixture.""",meal="breakfast"),
        recipe("roasted-red-pepper-egg-bites","Roasted red pepper egg bites","🫑","Other",["highProtein","family","batchFriendly"],["oven"],9,21,4,True,[
            ("eggs",8,"piece"),("roasted-peppers",180,"g","drained"),("feta",125,"g"),
            ("greek-yogurt",80,"g"),("olive-oil",1,"tbsp"),("black-pepper",0.5,"tsp"),
        ],"""Heat the oven to 180°C (350°F). Brush a 12-hole muffin tin with oil.
Drain the peppers thoroughly and dice them. Beat the eggs and yoghurt with black pepper until just combined.
Divide pepper and crumbled feta among the holes and pour the egg mixture in, leaving space at the top.
Bake for 17–21 minutes until the bites puff and the middle sets. Cool for 5 minutes before lifting out.""",meal="breakfast"),
        recipe("ham-cheddar-quiche-cups","Ham and cheese quiche cups","🥚","British",["family","comfort","batchFriendly"],["oven"],14,23,4,True,[
            ("shortcrust-pastry",300,"g"),("eggs",5,"piece"),("ham",140,"g"),("cheddar",95,"g"),
            ("milk",120,"ml"),("black-pepper",0.5,"tsp"),("dijon-mustard",1,"tsp"),
        ],"""Heat the oven to 190°C (375°F). Unroll the pastry and cut 12 circles to fit a muffin tin.
Press the pastry circles into the holes. Prick the bottoms with a fork and bake for 6 minutes.
Dice the ham, grate the cheddar and beat milk, eggs, pepper and mustard together.
Put ham and cheese in the pastry cups and pour in the egg mixture. Bake for another 14–17 minutes, until the centres set.
Cool for a few minutes before lifting the quiche cups from the tin.""",meal="breakfast"),
    ]
