"""Roasted, braised and crisp mains from the Tommo recipe brief."""


def build_recipes(R):
    def recipe(id, title, emoji, cuisine, vibes, appliances, prep, cook, leftovers, ingredients, steps, meal="dinner"):
        row = R(id, title, emoji, cuisine, vibes, appliances, prep, cook, 4, leftovers, ingredients, steps.split("\n"), meal=meal)
        row["tags"] = []
        return row

    return [
        recipe("dijon-chicken-smashed-potatoes","Dijon chicken and smashed potatoes","🍗","Other",["highProtein","family"],["stovetop","oven"],12,40,False,[
            ("chicken-thighs",620,"g","boneless"),("potato",800,"g","small"),("dijon-mustard",2,"tbsp"),
            ("chicken-stock",220,"ml"),("greek-yogurt",130,"g"),("garlic",3,"clove"),
            ("olive-oil",2,"tbsp"),("parsley",16,"g"),("salt",0.5,"tsp"),("black-pepper",0.5,"tsp"),
        ],"""Heat the oven to 230°C (450°F) and boil the small potatoes until just tender.
Drain the potatoes and press them flat on a tray. Drizzle with half the oil and sprinkle with some salt.
Roast for 20–24 minutes until the rough edges brown. Season the chicken with the remaining salt and pepper.
Brown the thighs in a frying pan in the remaining oil. Add the garlic, mustard and stock and simmer until the chicken reaches 74°C (165°F).
Take off the heat and stir in the yoghurt gradually. Return briefly to very low heat if needed.
Spoon the Dijon sauce over the chicken. Serve with the crisp potatoes and chopped parsley."""),
        recipe("smothered-chicken-mushroom-gravy","Smothered chicken with mushroom gravy","🍗","American",["comfort","highProtein","batchFriendly"],["stovetop"],12,30,True,[
            ("chicken-thighs",620,"g","boneless"),("long-grain-rice",260,"g"),("mushrooms",320,"g"),("onion",1,"piece"),
            ("chicken-stock",390,"ml"),("flour",2,"tbsp"),("butter",25,"g"),("olive-oil",1,"tbsp"),
            ("paprika",1,"tsp"),("dried-thyme",1,"tsp"),("black-pepper",0.5,"tsp"),("salt",0.5,"tsp"),
        ],"""Cook the rice following the packet. Slice the onion and mushrooms.
Season the chicken with paprika, salt and pepper. Brown both sides in the oil and lift onto a plate.
Melt butter in the same pan. Fry the onion and mushrooms until the juices evaporate and the edges brown.
Stir in flour and thyme for a minute. Pour in the stock gradually, scraping up the browned bits.
Return the chicken and simmer gently until the gravy thickens and the chicken reaches 74°C (165°F).
Serve each thigh beside rice with a generous spoonful of mushroom and onion gravy."""),
        recipe("baked-miso-salmon-soba","Baked miso salmon with soba noodles","🐟","Japanese",["quickEasy","highProtein"],["oven","stovetop"],10,15,False,[
            ("salmon-fillet",520,"g"),("soba-noodles",280,"g"),("spinach",200,"g"),("miso-paste",2,"tbsp"),
            ("honey",1,"tbsp"),("soy-sauce",1,"tbsp"),("rice-vinegar",1.5,"tbsp"),("sesame-oil",1,"tsp"),
            ("spring-onion",4,"piece"),("ginger",12,"g"),("sesame-seeds",2,"tsp"),
        ],"""Heat the oven to 210°C (410°F). Stir miso, honey, soy and grated ginger together.
Lay the salmon on a lined tray and brush the glaze over the top.
Bake for 10–14 minutes until the fish flakes easily and reaches 63°C (145°F).
Meanwhile, cook the soba. Add spinach for the last 30 seconds, then drain.
Toss the soba and greens with rice vinegar and sesame oil. Slice the spring onions on a long diagonal.
Pile noodles into bowls and set a salmon fillet on each. Scatter the spring onions and sesame over the fish and noodles."""),
        recipe("bistec-ranchero-potatoes","Bistec ranchero with potatoes","🥩","Mexican",["comfort","highProtein","onePan"],["stovetop"],15,28,True,[
            ("beef-steak",520,"g"),("potato",620,"g"),("tomato",500,"g"),("onion",1,"piece"),("chili-fresh",1,"piece","green"),
            ("garlic",3,"clove"),("vegetable-stock",130,"ml"),("vegetable-oil",1.5,"tbsp"),("cumin",0.5,"tsp"),
            ("cilantro",12,"g"),("salt",0.5,"tsp"),
        ],"""Cut the potatoes into small cubes. Slice the beef thinly, slice the onion and chilli, and chop the tomatoes.
Heat half the oil in a wide pan and cook the potato cubes until golden on several sides. Lift them out.
Add the remaining oil and sear the beef briefly in batches. Lift it onto a separate plate.
Soften the onions and green chilli, then add garlic, cumin, salt, tomatoes and stock. Simmer until the tomatoes break down.
Return the potatoes and cover until tender. Add the meat and juices and simmer until the meat is cooked and the sauce thickens.
Serve the steak and potatoes with the red tomato sauce and chopped coriander."""),
        recipe("lemon-salmon-prawns-asparagus","Lemon salmon and prawns","🍤","Mediterranean",["highProtein","quickEasy"],["oven","stovetop"],10,15,False,[
            ("salmon-fillet",500,"g"),("shrimp",350,"g","peeled"),("asparagus",430,"g"),("lemon",2,"piece"),
            ("olive-oil",2,"tbsp"),("butter",25,"g"),("garlic",3,"clove"),("parsley",12,"g"),("salt",0.5,"tsp"),
        ],"""Heat the oven to 220°C (425°F). Snap off the woody asparagus ends, toss the spears with oil and roast for 9–12 minutes.
Pat the salmon dry and season it. Thinly slice one lemon and juice the other.
Heat the remaining oil in a pan. Sear the salmon on both sides, working in batches if necessary, to 63°C (145°F).
Move the salmon to a plate. Add butter, garlic and prawns to the pan, then cook until the prawns turn pink and opaque.
Add lemon juice and chopped parsley to the pan, and warm the lemon slices in the sauce.
Serve the salmon and prawns beside roasted asparagus. Spoon over the lemon butter and add lemon rounds."""),
        recipe("minced-beef-potato-hash","Minced beef and potato hash","🥔","Other",["comfort","family","onePan"],["stovetop"],13,26,False,[
            ("ground-beef",460,"g"),("potato",740,"g"),("bell-pepper",1,"piece","red"),("onion",1,"piece"),
            ("garlic",3,"clove"),("vegetable-oil",2,"tbsp"),("paprika",1.5,"tsp"),
            ("black-pepper",0.5,"tsp"),("salt",0.5,"tsp"),("parsley",14,"g"),
        ],"""Cut the potatoes into small even cubes. Put them into boiling water for 5 minutes, then drain well.
Dice the red pepper and onion and crush the garlic.
Heat most of the oil in a large pan. Fry the potato cubes without stirring for a few minutes until they brown on the bottom.
Turn the cubes until crisp on several sides and set aside. Add the remaining oil, minced beef and onion to the same pan.
Cook through, breaking up the mince, then add pepper, garlic, paprika, salt and black pepper.
Return the potatoes and let them crisp again briefly. Scatter with chopped parsley and bring the skillet to the table."""),
        recipe("sticky-beef-coconut-rice","Sticky beef bowls with coconut rice","🍚","Other",["comfort","highProtein"],["stovetop"],12,22,False,[
            ("beef-steak",530,"g"),("basmati-rice",270,"g"),("coconut-milk",240,"ml"),("cucumber",1,"piece"),
            ("soy-sauce",2.5,"tbsp"),("honey",1.5,"tbsp"),("ginger",14,"g"),
            ("garlic",3,"clove"),("rice-vinegar",1.5,"tbsp"),("vegetable-oil",1,"tbsp"),("sesame-seeds",2,"tsp"),("spring-onion",3,"piece"),
        ],"""Rinse the rice. Add coconut milk and enough water to match the packet's liquid measure, then cover and cook.
Slice the steak thinly across the grain. Whisk the soy, honey, ginger, garlic and half the vinegar together.
Thinly slice the cucumber and lightly dress it with the remaining vinegar.
Heat the oil until shimmering. Quickly brown the steak in batches, then return it all to the pan.
Pour the sauce over the steak and toss until it bubbles and coats the beef. Fluff the coconut rice.
Spoon the sticky strips over the rice, with cucumber slices, sesame seeds and sliced spring onions."""),
        recipe("crispy-beef-bean-tortilla-pizzas","Crispy beef and bean tortilla pizzas","🍕","Mexican",["fakeaway","fiberForward","family"],["oven","stovetop"],12,22,False,[
            ("tortillas",4,"piece"),("ground-beef",380,"g"),("black-beans",240,"g","drained"),("sweetcorn-tin",100,"g","drained"),
            ("cheddar",140,"g"),("passata",160,"g"),("cumin",1,"tsp"),("paprika",1,"tsp"),
            ("olive-oil",1,"tsp"),("cilantro",12,"g"),
        ],"""Heat the oven to 220°C (425°F). Put the tortillas on trays and brush their edges with a little oil.
Bake for 4–5 minutes until just beginning to crisp.
Brown the beef in a pan, breaking it up and cooking it through. Add cumin, paprika and passata and simmer until thick.
Rinse and drain the beans and sweetcorn. Spoon the cooked beef onto each tortilla and scatter over the beans and corn.
Cover with grated cheddar and bake for 7–8 minutes until the cheese melts and the edges brown.
Scatter chopped coriander over the pizzas and cut into wedges."""),
        recipe("steak-onion-gravy","Steak with onion gravy","🥩","British",["comfort","highProtein"],["oven","stovetop"],12,35,False,[
            ("beef-steak",560,"g"),("potato",650,"g"),("carrot",420,"g"),("onion",2,"piece"),
            ("vegetable-stock",400,"ml"),("butter",25,"g"),("flour",1.5,"tbsp"),("olive-oil",1.5,"tbsp"),
            ("worcestershire",1,"tbsp"),("dried-thyme",1,"tsp"),("salt",0.5,"tsp"),("black-pepper",0.5,"tsp"),
        ],"""Heat the oven to 220°C (425°F). Toss chopped potatoes and carrots with most of the oil and roast until browned and tender.
Slice the onions. Melt butter in a pan and cook them on medium-low until soft and golden.
Stir in the flour, thyme and Worcestershire sauce. Add stock a little at a time, then simmer until thick.
Season the steaks and sear them in the remaining oil to at least 63°C (145°F).
Rest the steaks for 3 minutes or longer. Pour the resting juices into the onion gravy.
Slice the steak and spoon on the onion gravy. Serve the roast carrots and potatoes alongside."""),
        recipe("dill-pickle-ranch-chicken-salad","Dill pickle ranch chicken salad","🥗","American",["highProtein","quickEasy"],["stovetop"],14,14,False,[
            ("chicken-breast",500,"g"),("dill-pickles",150,"g","drained"),("lettuce",240,"g"),
            ("greek-yogurt",170,"g"),("mayonnaise",45,"g"),("fresh-dill",14,"g"),("sourdough",4,"slice"),
            ("garlic-powder",0.5,"tsp"),("onion-powder",0.5,"tsp"),("lemon",1,"piece"),("black-pepper",0.5,"tsp"),
        ],"""Poach the chicken gently until the centre reaches 74°C (165°F), then let it cool and dice it.
Slice the pickles, chop the romaine and finely chop the dill.
Whisk yoghurt, mayo, garlic and onion powder, lemon juice and pepper. Stir in most of the dill and a spoonful of pickle brine if needed.
Toast the thick sourdough slices in a dry pan. Toss the chicken and pickles in the dressing.
Top the toast with lettuce and the chicken salad. Finish with the remaining dill.""",meal="lunch"),
        recipe("creamy-chipotle-beef-corn-pasta","Creamy chipotle beef and corn pasta","🍝","Other",["comfort","highProtein","batchFriendly"],["stovetop"],10,22,True,[
            ("rigatoni",310,"g"),("ground-beef",440,"g"),("sweetcorn-tin",180,"g","drained"),("chipotles-in-adobo",30,"g"),
            ("onion",1,"piece"),("passata",280,"g"),("heavy-cream",130,"ml"),("spring-onion",3,"piece"),("vegetable-oil",1,"tsp"),
        ],"""Cook the rigatoni until just firm, then drain and keep a cup of pasta water.
Dice the onion and finely chop the chipotles. Heat oil in a wide pan and brown the mince.
Add onion for 4 minutes, then add passata and chipotles. Simmer until the beef is cooked through.
Stir in the cream and drained sweetcorn. Bring the sauce back to a gentle simmer.
Fold through the rigatoni and a splash of cooking water until the sauce coats the pasta.
Serve with finely sliced spring onions on top."""),
        recipe("baked-coconut-chicken-strips","Baked coconut chicken","🥥","Other",["family","highProtein"],["oven","stovetop"],17,21,False,[
            ("chicken-breast",560,"g"),("desiccated-coconut",75,"g"),("breadcrumbs",55,"g"),("eggs",2,"piece"),("flour",40,"g"),
            ("cabbage",200,"g"),("red-cabbage",100,"g"),("carrot",100,"g"),("pineapple-tin",180,"g","drained"),("sweet-chili-sauce",45,"g"),
            ("lime",2,"piece"),("vegetable-oil",1.5,"tbsp"),("salt",0.5,"tsp"),
        ],"""Heat the oven to 210°C (410°F). Cut chicken into even strips and season with salt.
Dip in flour and beaten egg, then press into a mix of coconut and breadcrumbs.
Set the strips on a lined tray, brush lightly with oil and bake for 15–19 minutes, turning once, until golden and 74°C (165°F) inside.
Chop the pineapple very finely and simmer it with sweet chilli sauce and half the lime juice until it makes a spoonable dip.
Thinly shred both cabbages, grate the carrot and toss them with the remaining lime juice.
Serve the coconut chicken with the fresh slaw and a small dish of pineapple dip."""),
    ]
