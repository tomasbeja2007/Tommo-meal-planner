"""More mains, wraps and toast from the recipe brief."""


def build_recipes(R):
    def recipe(id, title, emoji, cuisine, vibes, appliances, prep, cook, leftovers, ingredients, steps, meal="dinner"):
        row = R(id, title, emoji, cuisine, vibes, appliances, prep, cook, 4, leftovers, ingredients, steps.split("\n"), meal=meal)
        row["tags"] = []
        return row

    return [
        recipe("sheet-pan-beef-kebabs", "Sheet-pan beef kebabs", "🍢", "Middle Eastern", ["highProtein","quickEasy"], ["oven"], 18, 15, False, [
            ("beef-steak",520,"g"),("bell-pepper",2,"piece"),("red-onion",2,"piece"),("couscous",240,"g"),
            ("olive-oil",1.5,"tbsp"),("lemon",1,"piece"),("garlic",3,"clove"),("paprika",1,"tsp"),
            ("cumin",1,"tsp"),("parsley",18,"g"),("salt",0.5,"tsp"),
        ], """Heat the oven to 230°C (450°F) and line a tray. Cut the steak and peppers into even chunks and the onions into wedges.
Toss the beef and vegetables with oil, crushed garlic, paprika, cumin, lemon zest and salt.
Thread the beef, pepper and onion onto metal skewers and arrange on the tray.
Roast for about 10–13 minutes, turning once, until browned and the beef reaches at least 63°C (145°F). Rest for 3 minutes.
Meanwhile, cover the couscous with boiling water according to the packet. Fluff it with a fork and add chopped parsley and lemon juice.
Serve the skewers beside a mound of couscous."""),
        recipe("creamy-curry-chicken-pasta", "Creamy curry chicken pasta", "🍝", "British", ["comfort","family","highProtein"], ["stovetop"], 10, 21, True, [
            ("penne",310,"g"),("chicken-breast",470,"g"),("peas-frozen",180,"g"),("onion",1,"piece"),
            ("curry-powder",1,"tbsp"),("heavy-cream",150,"ml"),("chicken-stock",200,"ml"),
            ("vegetable-oil",1,"tbsp"),("garlic",2,"clove"),("cilantro",10,"g"),("lemon",1,"piece"),
        ], """Cook the penne until firm at the centre, keeping a cup of the cooking water when you drain it.
Thinly slice the chicken and chop the onion. Fry the chicken in the hot oil until coloured on both sides.
Add the onion and crushed garlic and cook until soft. Stir through the curry powder for 30 seconds.
Pour in the stock and cream. Simmer until the chicken reaches 74°C (165°F) and the sauce thickens.
Add the peas and penne and cook for a few minutes, adding a splash of pasta water to loosen the sauce.
Finish with lemon juice and chopped coriander."""),
        recipe("turkey-cheeseburgers", "Turkey cheeseburgers", "🍔", "American", ["family","highProtein","fakeaway"], ["stovetop"], 12, 16, False, [
            ("ground-turkey",520,"g"),("burger-buns",4,"piece"),("cheddar",95,"g"),("tomato",2,"piece"),
            ("lettuce",120,"g"),("mayonnaise",55,"g"),("dijon-mustard",1,"tbsp"),
            ("vegetable-oil",1,"tbsp"),("garlic-powder",0.5,"tsp"),("salt",0.5,"tsp"),("black-pepper",0.5,"tsp"),
        ], """Mix the turkey with garlic powder, salt and pepper, and shape it into four patties without packing it tightly.
Tear the lettuce leaves, thickly slice the tomatoes and cut the cheese into thin slices.
Heat the oil in a frying pan and fry the patties on each side until brown and 74°C (165°F) in the middle.
Lay cheese on each patty, cover the pan for a minute and let it melt.
Toast the split buns and stir the mustard into the mayonnaise.
Spread sauce on each bun and build with lettuce, tomato and a turkey cheeseburger patty."""),
        recipe("crispy-lemon-chicken-cutlets", "Crispy lemon chicken cutlets", "🍋", "Other", ["quickEasy","highProtein"], ["stovetop"], 12, 17, False, [
            ("chicken-breast",560,"g"),("green-beans",480,"g"),("lemon",2,"piece"),("flour",45,"g"),
            ("eggs",1,"piece"),("breadcrumbs",85,"g"),("olive-oil",3,"tbsp"),
            ("butter",20,"g"),("garlic",2,"clove"),("salt",0.5,"tsp"),("black-pepper",0.5,"tsp"),
        ], """Split the chicken breasts horizontally and pound the pieces lightly so they are an even thickness. Trim the beans.
Mix flour with salt and pepper on a plate. Beat the egg in a bowl, then mix lemon zest through the breadcrumbs on another plate.
Coat each cutlet with flour, egg and breadcrumbs. Fry in hot oil until crisp and the centre reaches 74°C (165°F).
Cook the beans in boiling water for a few minutes and drain. Toss with butter and crushed garlic in the warm pan.
Drain the chicken on a rack so the crust stays crisp. Cut the remaining lemon into thin rounds.
Serve the cutlets beside the green beans with the lemon rounds for squeezing."""),
        recipe("turkey-carrot-almond-pilaf", "Turkey and carrot pilaf", "🍚", "Middle Eastern", ["highProtein","batchFriendly","onePan"], ["stovetop"], 12, 28, True, [
            ("turkey-breast",480,"g"),("basmati-rice",260,"g"),("carrot",260,"g"),("onion",1,"piece"),
            ("almonds",45,"g"),("chicken-stock",580,"ml"),("olive-oil",1.5,"tbsp"),("cumin",1,"tsp"),
            ("turmeric",0.5,"tsp"),("parsley",14,"g"),("lemon",1,"piece"),
        ], """Toast the flaked almonds in a dry lidded pan, then set them aside. Rinse the rice and grate the carrots coarsely.
Dice the turkey and onion. Heat the oil and brown the turkey, then add the onion for 4 minutes.
Add the cumin, turmeric, carrot and rice. Stir until the rice is coated with oil and spices.
Pour in the stock and bring to a simmer. Cover and cook on low for 15 minutes, until the rice is tender and the turkey reaches 74°C (165°F).
Rest covered for 4 minutes, then fluff the grains gently with a fork.
Fold in chopped parsley and lemon juice. Scatter the toasted almonds over each bowl."""),
        recipe("korean-beef-kebab-tortillas", "Korean-style beef kebab tortillas", "🌮", "Other", ["highProtein","fakeaway"], ["stovetop"], 18, 12, False, [
            ("beef-steak",530,"g"),("tortillas",8,"piece","small"),("cabbage",240,"g"),("cucumber",0.5,"piece"),
            ("soy-sauce",2,"tbsp"),("gochujang",1,"tbsp"),("honey",1,"tbsp"),("ginger",12,"g"),
            ("garlic",3,"clove"),("sesame-oil",1,"tsp"),("sesame-seeds",2,"tsp"),("rice-vinegar",1,"tbsp"),
            ("vegetable-oil",1,"tbsp"),
        ], """Slice the beef into bite-size pieces. Mix soy, gochujang, honey, crushed garlic and grated ginger, then coat the meat.
Shred the cabbage and cut the cucumber into sticks. Dress with vinegar and sesame oil.
Thread the beef onto metal skewers. Heat a griddle pan and brush it lightly with vegetable oil.
Griddle on all sides, until browned and at least 63°C (145°F) in the centre. Rest for 3 minutes.
Warm the tortillas in a dry pan. Slide the beef off the skewers.
Fill each tortilla with beef, cabbage and cucumber, and finish with sesame seeds."""),
        recipe("spicy-peanut-chicken-noodles", "Spicy peanut chicken noodles", "🥜", "Other", ["highProtein","quickEasy"], ["stovetop"], 12, 15, False, [
            ("egg-noodles",300,"g"),("chicken-breast",490,"g"),("carrot",140,"g"),("bell-pepper",1,"piece","red"),
            ("peanut-butter",85,"g"),("sriracha",1.5,"tbsp"),("soy-sauce",2,"tbsp"),("lime",1,"piece"),
            ("vegetable-oil",1,"tbsp"),("peanuts",30,"g"),("spring-onion",3,"piece"),
        ], """Cook the noodles according to the packet. Scoop out a mug of cooking water before draining.
Whisk the peanut butter, sriracha, soy and lime juice with about 100 ml of the hot noodle water.
Slice the chicken into even cutlets. Slice the pepper and cut the carrot into matchsticks.
Sear the chicken cutlets until the centre reaches 74°C (165°F) and lift onto a clean board. Add the pepper and carrot and stir-fry for 3 minutes.
Add the noodles and peanut sauce and toss briefly, loosening with more cooking water if needed.
Slice the cooked chicken and lay it over the sauced noodles. Top with chopped peanuts and finely sliced spring onions."""),
        recipe("bbq-chicken-pineapple-toast", "Barbecue chicken and pineapple toast", "🍍", "American", ["quickEasy","highProtein","family"], ["oven","stovetop"], 10, 20, False, [
            ("sourdough",8,"slice"),("chicken-breast",440,"g"),("bbq-sauce",100,"g"),
            ("pineapple-tin",180,"g","drained"),("cheddar",110,"g"),("spring-onion",3,"piece"),("olive-oil",1,"tsp"),
        ], """Heat the oven to 220°C (425°F). Poach the chicken until the centre reaches 74°C (165°F).
Lift the chicken onto a clean plate and pull it into shreds. Toss it with barbecue sauce.
Brush the bread lightly with oil and toast for a few minutes. Drain the pineapple thoroughly and cut into smaller pieces.
Top the toast with the barbecue chicken, pineapple and grated cheddar. Return to the oven for 5–7 minutes until bubbling.
Scatter over sliced spring onions and serve the open toasts immediately.""",meal="lunch"),
        recipe("chipotle-chicken-corn-wraps", "Chipotle chicken wraps", "🌯", "Mexican", ["quickEasy","highProtein"], ["stovetop"], 12, 13, False, [
            ("chicken-breast",520,"g"),("tortillas",4,"piece","large"),("lettuce",240,"g"),
            ("sweetcorn-tin",180,"g","drained"),("greek-yogurt",130,"g"),("chipotles-in-adobo",28,"g"),
            ("lime",1,"piece"),("olive-oil",1,"tbsp"),("cumin",1,"tsp"),("salt",0.5,"tsp"),
        ], """Finely chop the chipotles. Stir half into the yoghurt with a squeeze of lime.
Cut the chicken into strips and toss with the remaining chipotle, cumin, salt and oil.
Sear in a hot skillet until browned and the centre reaches 74°C (165°F). Squeeze the rest of the lime over it.
Warm the tortillas. Chop the lettuce and drain the corn thoroughly.
Spread the yoghurt on the wraps and add lettuce, corn and chicken. Roll firmly, toast the filled wraps briefly in a dry pan and cut them in half on the diagonal.""",meal="lunch"),
        recipe("beef-sweet-potato-herby-bowls", "Beef and sweet potato bowls with herby yoghurt", "🍠", "Other", ["highProtein","healthyish","batchFriendly"], ["oven","stovetop"], 12, 28, False, [
            ("ground-beef",470,"g"),("sweet-potato",750,"g"),("cucumber",1,"piece"),
            ("greek-yogurt",220,"g"),("parsley",16,"g"),("mint",12,"g"),("lemon",1,"piece"),
            ("olive-oil",1.5,"tbsp"),("paprika",1.5,"tsp"),("cumin",1,"tsp"),("salt",0.5,"tsp"),
        ], """Heat the oven to 220°C (425°F) and cut the sweet potato into small cubes.
Toss the cubes with most of the oil, half the paprika and some salt. Roast for 22–26 minutes, turning once.
Heat the remaining oil in a frying pan and break up the beef as it browns.
Season with the remaining paprika, cumin and salt and cook through. Cut the cucumber into small cubes.
Whisk the yoghurt with chopped mint, parsley and lemon juice.
Pile the sweet potato, beef and cucumber into bowls, and spoon over the herby yoghurt."""),
        recipe("malaysian-curry-leaf-chicken", "Malaysian creamy curry leaf chicken", "🍗", "Other", ["highProtein","fakeaway"], ["stovetop"], 14, 22, False, [
            ("chicken-thighs",600,"g","boneless"),("basmati-rice",250,"g"),("cornstarch",55,"g"),
            ("evaporated-milk",270,"ml"),("butter",28,"g"),("vegetable-oil",2,"tbsp"),
            ("curry-leaves",12,"g"),("chili-fresh",1,"piece"),("garlic",3,"clove"),("sugar",1,"tsp"),("salt",0.5,"tsp"),
        ], """Rinse the rice and set it on to cook. Dice the chicken, slice the chilli and crush the garlic.
Toss the chicken in cornflour and salt. Shallow-fry in a hot pan in batches until golden and 74°C (165°F).
Drain the chicken on a rack. Melt the butter in a clean frying pan and add the garlic, curry leaves and sliced chilli.
When the leaves sizzle, stir in the evaporated milk and sugar. Simmer gently until the sauce thickens enough to lightly coat a spoon.
Tip in the crispy chicken and turn it through the sauce just before serving.
Spoon alongside rice and make sure each serving gets a few curry leaves."""),
        recipe("spinach-artichoke-chicken-skillet", "Spinach and artichoke chicken", "🍗", "Other", ["comfort","highProtein","onePan"], ["stovetop"], 11, 22, False, [
            ("chicken-breast",550,"g"),("artichoke-hearts",260,"g","drained"),("spinach",190,"g"),
            ("cream-cheese",125,"g"),("chicken-stock",250,"ml"),("parmesan",45,"g"),
            ("baguette",250,"g"),("garlic",3,"clove"),("olive-oil",1,"tbsp"),
            ("lemon",1,"piece"),("black-pepper",0.5,"tsp"),
        ], """Slice the chicken into four even cutlets. Drain and quarter the artichokes and crush the garlic.
Heat the oil in a skillet and brown the chicken on both sides. Lift it onto a clean plate.
Stir the garlic into the pan briefly and pour in the stock. Scrape up the browned bits, then stir in cream cheese.
Return the chicken along with the artichokes and simmer until the chicken reaches 74°C (165°F).
Fold in spinach and grated parmesan. Let the spinach wilt, then add lemon juice and cracked pepper.
Serve the chicken with plenty of the spinach and artichoke sauce and slices of lightly toasted baguette to mop it up."""),
    ]
