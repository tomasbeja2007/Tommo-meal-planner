"""Noodles, hearty bowls and sandwiches from the Tommo recipe brief."""


def build_recipes(R):
    def recipe(id, title, emoji, cuisine, vibes, appliances, prep, cook, leftovers, ingredients, steps, meal="dinner"):
        row = R(id, title, emoji, cuisine, vibes, appliances, prep, cook, 4, leftovers, ingredients, steps.split("\n"), meal=meal)
        row["tags"] = []
        return row

    return [
        recipe("bbq-roast-beef-sandwich","Barbecue roast beef sandwiches","🥪","American",["quickEasy","highProtein","comfort"],["stovetop"],12,10,False,[
            ("deli-roast-beef",420,"g"),("burger-buns",4,"piece"),("bbq-sauce",115,"g"),("cabbage",260,"g"),
            ("mayonnaise",40,"g"),("apple-cider-vinegar",1,"tbsp"),("black-pepper",0.5,"tsp"),("butter",12,"g"),
        ],"""Thinly shred the cabbage and toss it with mayonnaise, vinegar and black pepper.
Warm the barbecue sauce in a wide frying pan with a splash of water. Fold in the slices of cooked roast beef and heat through gently.
Split the buns, brush the cut sides lightly with butter and toast them in a clean dry pan.
Use tongs to pile the saucy beef into each toasted bun.
Lift the slaw out of any extra dressing and add a small handful to each sandwich.""",meal="lunch"),
        recipe("gyudon-beef-rice-bowls","Gyudon beef rice bowls","🍚","Japanese",["quickEasy","highProtein"],["stovetop"],10,22,False,[
            ("beef-steak",520,"g","very thinly sliced"),("sushi-rice",260,"g"),("onion",2,"piece"),("spring-onion",3,"piece"),
            ("vegetable-stock",300,"ml"),("soy-sauce",2.5,"tbsp"),("mirin",2,"tbsp"),("sugar",1.5,"tsp"),("pickled-red-ginger",35,"g"),
        ],"""Rinse and cook the rice according to the packet. Slice the onions into thin half-moons.
Bring the stock, soy, mirin and sugar to a simmer in a shallow pan.
Add the onions and cook until soft and translucent.
Stir in the very thin slices of beef a few at a time so they separate. Simmer gently until cooked through.
Divide the rice into bowls. Spoon the soft beef, onions and a little of the broth over each portion.
Scatter with finely sliced spring onions and add a small pinch of red pickled ginger."""),
        recipe("sticky-beef-bok-choy-noodles","Sticky beef and pak choi noodles","🍜","Chinese",["quickEasy","highProtein","fakeaway"],["stovetop"],12,16,False,[
            ("egg-noodles",300,"g"),("beef-steak",500,"g"),("bok-choy",420,"g"),("spring-onion",3,"piece"),
            ("soy-sauce",2,"tbsp"),("hoisin-sauce",2,"tbsp"),("rice-vinegar",1,"tbsp"),("cornstarch",1,"tsp"),
            ("ginger",14,"g"),("vegetable-oil",1.5,"tbsp"),("sesame-seeds",2,"tsp"),
        ],"""Boil the noodles until just firm and drain. Cut the beef across the grain into thin strips.
Slice the pak choi lengthways and finely grate the ginger. Mix soy, hoisin, vinegar, cornflour and 80 ml water.
Sear the beef in half the hot oil, working in batches so it browns. Lift it onto a clean plate.
Stir-fry the pak choi and ginger in the remaining oil until the stems soften slightly.
Add beef, noodles and sauce. Toss over high heat until the sauce turns shiny and lightly sticky.
Divide into bowls and finish with sliced spring onions and sesame seeds."""),
        recipe("black-pepper-chicken-rice","Black pepper chicken","🍗","Chinese",["quickEasy","highProtein","fakeaway"],["stovetop"],12,19,False,[
            ("chicken-thighs",580,"g","boneless"),("long-grain-rice",250,"g"),("bell-pepper",2,"piece","mixed colours"),
            ("onion",1,"piece"),("soy-sauce",2.5,"tbsp"),("black-pepper",1.5,"tsp"),("garlic",3,"clove"),("ginger",12,"g"),
            ("cornstarch",2,"tsp"),("rice-vinegar",1,"tbsp"),("sugar",1,"tsp"),("vegetable-oil",1.5,"tbsp"),
        ],"""Cook the rice according to the packet. Dice the chicken, peppers and onion into bite-size pieces.
Whisk together soy, cracked black pepper, grated garlic and ginger, cornflour, vinegar, sugar and 100 ml water.
Heat half the oil and fry the chicken until golden and 74°C (165°F) inside. Move it onto a clean plate.
Stir-fry the onion and peppers in the remaining oil. Leave them a little crisp.
Return the chicken and pour in the sauce. Let it bubble for a minute, tossing until it coats the chicken.
Serve over or beside the fluffy rice with any pan sauce spooned over."""),
        recipe("chicken-red-lentil-soup","Chicken and red lentil soup","🥣","Other",["onePan","highProtein","fiberForward","batchFriendly"],["stovetop"],13,32,True,[
            ("chicken-breast",500,"g"),("red-lentils",220,"g"),("carrot",230,"g"),("onion",1,"piece"),("chopped-tomatoes",400,"g"),
            ("chicken-stock",900,"ml"),("garlic",3,"clove"),("olive-oil",1,"tbsp"),("cumin",1,"tsp"),("parsley",14,"g"),("lemon",1,"piece"),
        ],"""Dice the onion and slice the carrots. Rinse the lentils and crush the garlic.
Warm the oil in a saucepan and soften the vegetables. Add the garlic and cumin after 5 minutes.
Add lentils, stock and tomatoes. Bring to a gentle simmer, then lower the chicken breasts into the soup.
Simmer until the chicken reaches 74°C (165°F). Lift it out, shred it and return it to the pan.
Continue simmering until the lentils are tender and the broth thickens. Add a little water if needed.
Squeeze in lemon juice and serve with roughly chopped parsley."""),
        recipe("coconut-curry-noodles-basil-beef","Coconut curry noodles with basil beef","🍜","Thai",["fakeaway","highProtein"],["stovetop"],12,18,False,[
            ("beef-steak",510,"g"),("rice-noodles",290,"g"),("coconut-milk",340,"ml"),("thai-curry-paste",1.5,"tbsp"),
            ("bell-pepper",1,"piece","red"),("ginger",12,"g"),("vegetable-oil",1.5,"tbsp"),
            ("fish-sauce",1,"tbsp"),("lime",1,"piece"),("basil",24,"g"),
        ],"""Soften the noodles following the packet and drain. Thinly slice the beef and cut the pepper into strips.
Heat half the oil and quickly sear the beef. Lift it onto a clean plate.
Add the pepper, ginger and curry paste to the pan with the remaining oil. Stir for a minute or two.
Pour in the coconut milk and fish sauce. Simmer until it thickens enough to hold on a spoon.
Turn the noodles through the sauce and return the beef until cooked through. Add lime juice.
Fold half the basil through just before serving and leave the remaining leaves on top."""),
        recipe("creamy-broccoli-rigatoni","Creamy broccoli pasta","🥦","Italian",["comfort","family","quickEasy"],["stovetop"],10,17,False,[
            ("rigatoni",340,"g"),("broccoli",580,"g"),("heavy-cream",150,"ml"),("parmesan",70,"g"),
            ("garlic",3,"clove"),("olive-oil",1,"tbsp"),("lemon",1,"piece"),("black-pepper",0.5,"tsp"),("salt",0.5,"tsp"),
        ],"""Boil the rigatoni in lightly salted water. Trim the broccoli into small florets and cut the tender stem into small dice.
Add the broccoli to the pasta pan for the last 4 minutes. Scoop out a mug of cooking water before draining.
Soften the crushed garlic in oil for 30 seconds. Add the broccoli stems, a few florets and a splash of pasta water and mash with a fork.
Add cream, lemon zest and black pepper and bring the sauce to a gentle simmer.
Stir in the pasta and remaining florets. Take off the heat and mix in most of the grated parmesan.
Loosen with a little cooking water and serve with the remaining parmesan and a squeeze of lemon."""),
        recipe("chicken-and-drop-dumplings","Chicken and drop dumplings","🥣","American",["comfort","family","onePan"],["stovetop"],18,42,False,[
            ("chicken-thighs",580,"g","boneless"),("carrot",220,"g"),("celery",130,"g"),("onion",1,"piece"),
            ("chicken-stock",850,"ml"),("flour",210,"g"),("baking-powder",2,"tsp"),("milk",135,"ml"),
            ("butter",35,"g"),("parsley",16,"g"),("salt",0.5,"tsp"),("black-pepper",0.5,"tsp"),
        ],"""Soften the chopped onion and celery and sliced carrots in a little of the butter.
Add stock, chicken, half the salt and pepper. Cover and simmer until the chicken reaches 74°C (165°F).
Lift out the chicken, shred it and return it to the simmering broth.
Rub the remaining butter into flour, baking powder and salt. Stir in chopped parsley and milk until you have a soft sticky dough.
Drop 12 spoonfuls of dough onto the broth. Cover tightly and simmer gently without lifting the lid for 14–16 minutes.
Cut open a dumpling to check it is fluffy and cooked inside. Ladle the chicken and broth into bowls and add the dumplings."""),
        recipe("hamburger-steaks-mushroom-gravy","Hamburger steaks with mushroom gravy","🥩","American",["comfort","highProtein","family"],["stovetop"],15,29,True,[
            ("ground-beef",560,"g"),("mushrooms",260,"g"),("onion",1,"piece"),("potato",680,"g"),("peas-frozen",220,"g"),
            ("vegetable-stock",350,"ml"),("flour",1.5,"tbsp"),("butter",35,"g"),("milk",85,"ml"),("worcestershire",1,"tbsp"),
            ("black-pepper",0.5,"tsp"),("salt",0.5,"tsp"),
        ],"""Peel and chop the potatoes. Boil for 15–18 minutes until soft.
Season the beef and shape it into eight thin oval patties. Fry over medium-high heat until browned and 71°C (160°F) in the centre.
Lift the patties onto a warm plate. Fry sliced mushrooms and onion in some butter in the same pan.
Stir in flour, Worcestershire sauce and stock. Simmer until thickened, then return the patties to warm through.
Mash the potatoes with the rest of the butter and milk. Boil the peas briefly and drain them.
Serve two patties per portion with plenty of mushroom gravy, mash and peas."""),
        recipe("chicken-teriyaki-udon","Chicken teriyaki udon","🍜","Japanese",["quickEasy","highProtein","fakeaway"],["stovetop"],11,16,False,[
            ("udon-noodles",600,"g"),("chicken-breast",520,"g"),("broccoli",360,"g"),("spring-onion",4,"piece"),
            ("soy-sauce",2.5,"tbsp"),("mirin",2,"tbsp"),("honey",1,"tbsp"),("ginger",12,"g"),
            ("cornstarch",1,"tsp"),("vegetable-oil",1.5,"tbsp"),
        ],"""Loosen the udon following the packet and drain. Cut the broccoli into small florets.
Dice the chicken. Mix soy, mirin, honey, ginger, cornflour and 80 ml water.
Heat half the oil in a wide pan and cook the chicken until browned and 74°C (165°F) in the centre.
Stir in broccoli with the remaining oil and a splash of water. Cover for a few minutes to tenderise it.
Add the udon and sauce and toss on high heat until the noodles are coated and glossy.
Serve with finely sliced spring onions on top."""),
        recipe("chicken-fajita-skillet-pizza","Chicken fajita skillet pizza","🍕","Other",["family","comfort","fakeaway"],["oven","stovetop"],18,27,False,[
            ("flour",290,"g"),("greek-yogurt",245,"g"),("baking-powder",2.5,"tsp"),("salt",0.5,"tsp"),
            ("chicken-breast",420,"g"),("bell-pepper",2,"piece","different colours"),("onion",1,"piece"),("cheddar",150,"g"),
            ("passata",150,"g"),("cumin",1,"tsp"),("paprika",1.5,"tsp"),("olive-oil",1.5,"tbsp"),
        ],"""Heat the oven to 220°C (425°F) with a large ovenproof skillet inside.
Mix flour, baking powder, salt and yoghurt to a soft dough. Knead briefly and roll into a circle to fit the skillet.
Cut the chicken and vegetables into pieces. Fry them in half the oil with paprika and cumin until the chicken reaches 74°C (165°F).
Brush the hot skillet with remaining oil, lay in the dough and bake for 5 minutes.
Spread passata over the base, then add the chicken, peppers, onions and grated cheddar.
Bake for 12–15 minutes until the crust is browned and the cheese bubbles. Rest briefly before cutting."""),
        recipe("lemongrass-chicken-banh-mi","Lemongrass chicken banh mi","🥖","Other",["highProtein","fakeaway"],["stovetop","oven"],17,18,False,[
            ("chicken-breast",520,"g"),("baguette",360,"g"),("lemongrass",20,"g"),("soy-sauce",2,"tbsp"),("garlic",3,"clove"),
            ("carrot",150,"g"),("daikon",150,"g"),("cucumber",0.5,"piece"),("rice-vinegar",2,"tbsp"),("sugar",1,"tsp"),
            ("cilantro",20,"g"),("mayonnaise",55,"g"),("vegetable-oil",1,"tbsp"),
        ],"""Heat the oven to 190°C (375°F). Cut the carrot and daikon into thin matchsticks and toss with vinegar and sugar to make a quick pickle.
Finely mince the tender lemongrass core and garlic. Coat thin chicken cutlets with them and the soy.
Sear the chicken in hot oil until the centre reaches 74°C (165°F), then rest and slice it.
Split the baguette into four rolls and warm them briefly in the oven until the crust crisps. Cut the cucumber into sticks.
Spread mayo inside each roll and fill with sliced chicken, drained carrot and daikon pickle, cucumber and coriander.""",meal="lunch"),
    ]
