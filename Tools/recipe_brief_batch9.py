"""Casseroles, stir-fries and noodle bowls from the Tommo recipe brief."""


def build_recipes(R):
    def recipe(id, title, emoji, cuisine, vibes, appliances, prep, cook, leftovers, ingredients, steps, meal="dinner"):
        row = R(id, title, emoji, cuisine, vibes, appliances, prep, cook, 4, leftovers, ingredients, steps.split("\n"), meal=meal)
        row["tags"] = []
        return row

    return [
        recipe("sloppy-joe-potato-tot-casserole","Sloppy Joe potato tot casserole","🥔","American",["family","comfort","batchFriendly"],["stovetop","oven"],12,38,True,[
            ("ground-beef",480,"g"),("potato-tots",650,"g"),("cheddar",115,"g"),("onion",1,"piece"),
            ("bell-pepper",1,"piece"),("passata",350,"g"),("ketchup",50,"g"),("worcestershire",1,"tbsp"),
            ("garlic",2,"clove"),("paprika",1,"tsp"),
        ],"""Heat the oven to 220°C (425°F). Dice the onion and pepper and crush the garlic.
Brown the mince in a dry pan, breaking it up until it is cooked through.
Add the onion and pepper and soften for 5 minutes. Stir in garlic and paprika.
Add passata, ketchup and Worcestershire sauce. Simmer until the beef mixture is thick enough to mound.
Spread the beef into a baking dish. Scatter over half the grated cheese and arrange the frozen potato tots in a single layer.
Bake for 22–26 minutes until the tots are crisp and the sauce is bubbling. Sprinkle the rest of the cheese on top for the final 3 minutes. Rest for a few minutes before serving."""),
        recipe("sweet-paprika-chicken-cutlets","Sweet paprika chicken cutlets","🍗","Other",["quickEasy","family","highProtein"],["stovetop","oven"],10,20,False,[
            ("chicken-breast",520,"g"),("basmati-rice",240,"g"),("green-beans",380,"g"),("paprika",2,"tsp"),
            ("olive-oil",2,"tbsp"),("butter",20,"g"),("lemon",1,"piece"),("garlic-powder",0.5,"tsp"),
            ("salt",0.5,"tsp"),("black-pepper",0.5,"tsp"),
        ],"""Heat the oven to 220°C (425°F). Cook the rice following the packet.
Trim the beans, toss with half the oil and roast for 12–15 minutes, until browned at the tips.
Slice the chicken horizontally into thin cutlets. Rub them with paprika, garlic powder, salt, pepper and the rest of the oil.
Heat a frying pan until hot and sear the cutlets on both sides until browned and 74°C (165°F) inside.
Fluff the cooked rice and fold through the butter. Squeeze lemon juice over the cooked chicken.
Serve the cutlets with the loose buttered rice and roasted beans."""),
        recipe("red-curry-chicken-ramen","Red curry chicken ramen with carrots","🍜","Thai",["highProtein","comfort","onePan"],["stovetop"],12,23,False,[
            ("chicken-thighs",550,"g","boneless"),("ramen-noodles",250,"g"),("carrot",230,"g"),("coconut-milk",300,"ml"),
            ("chicken-stock",850,"ml"),("thai-curry-paste",2,"tbsp"),("spring-onion",4,"piece"),("vegetable-oil",1,"tbsp"),
            ("lime",1,"piece"),("ginger",12,"g"),
        ],"""Chop the chicken into bite-size pieces and slice the carrot into thin sticks. Slice the spring onions, keeping the green tops separate.
Heat the oil in a deep pan. Fry the curry paste, spring-onion whites and ginger for a minute.
Add the chicken and turn it through the paste, then pour in the coconut milk and stock.
Bring to a lively simmer. Add the carrots and cook until the chicken reaches 74°C (165°F).
Drop in the ramen and cook just until the noodles are tender. Take off the heat and stir in lime juice.
Ladle into bowls and scatter over the reserved spring-onion greens."""),
        recipe("baked-turkey-herb-meatballs","Baked turkey and herb meatballs","🍚","Other",["highProtein","family","batchFriendly"],["oven","stovetop"],16,22,True,[
            ("ground-turkey",520,"g"),("basmati-rice",250,"g"),("eggs",1,"piece"),("breadcrumbs",45,"g"),
            ("parsley",20,"g"),("dried-oregano",1,"tsp"),("garlic",2,"clove"),("greek-yogurt",170,"g"),
            ("lemon",1,"piece"),("vegetable-oil",1,"tbsp"),("salt",0.5,"tsp"),
        ],"""Heat the oven to 210°C (410°F). Rinse the rice and set it on to cook.
Mix turkey, beaten egg, breadcrumbs, crushed garlic, oregano, most of the chopped parsley and salt.
Shape into 16 small meatballs. Set on an oiled roasting tray and turn to coat lightly.
Roast for 15–19 minutes until golden and the centres reach 74°C (165°F).
Stir lemon zest, juice and a little water into the yoghurt to make a light dressing.
Serve the browned meatballs over rice with the dressing and the remaining parsley."""),
        recipe("crispy-chicken-tenders-wedges","Crispy chicken tenders with wedges","🍗","American",["family","fakeaway","highProtein"],["oven"],16,35,False,[
            ("chicken-breast",550,"g"),("potato",750,"g"),("breadcrumbs",90,"g"),("flour",45,"g"),
            ("eggs",2,"piece"),("vegetable-oil",2.5,"tbsp"),("paprika",1,"tsp"),
            ("garlic-powder",1,"tsp"),("salt",0.5,"tsp"),("ketchup",75,"g"),
        ],"""Heat the oven to 220°C (425°F). Cut the potatoes into wedges, toss with half the oil and roast for 15 minutes.
Cut the chicken into thick strips. Put flour in one bowl, beaten eggs in another and breadcrumbs mixed with paprika, garlic powder and salt in a third.
Dip the chicken first in flour, then egg and then breadcrumbs. Press the crumbs against the chicken.
Set the strips on a second lined tray and brush lightly with the remaining oil.
Turn the wedges and add the chicken tray. Bake both for 14–17 minutes, turning the chicken once, until crisp and 74°C (165°F) inside.
Serve the tenders with the wedges and ketchup for dipping."""),
        recipe("honey-garlic-chicken-chilli-crisp-noodles","Honey garlic chicken and chilli crisp noodles","🍜","Other",["fakeaway","quickEasy","highProtein"],["stovetop"],12,17,False,[
            ("egg-noodles",300,"g"),("chicken-breast",490,"g"),("broccoli",260,"g"),("spring-onion",4,"piece"),
            ("garlic",4,"clove"),("honey",2,"tbsp"),("soy-sauce",2,"tbsp"),("rice-vinegar",1,"tbsp"),
            ("chili-crisp",35,"g"),("vegetable-oil",1,"tbsp"),
        ],"""Cook the noodles until just tender, keeping a mug of their cooking water. Dice the chicken and cut the broccoli small.
Mix honey with crushed garlic, soy and vinegar. Thinly slice the spring onions.
Heat the oil in a frying pan and fry the chicken until golden and fully cooked to 74°C (165°F).
Stir in the broccoli and a splash of noodle water for 3 minutes.
Add the noodles and honey-garlic mixture. Toss over high heat until the sauce is glossy.
Fold through most of the chilli crisp. Spoon the rest over the bowls with sliced spring onions."""),
        recipe("nepali-style-chicken-curry","Nepali-style chicken curry", "🍛","Other",["highProtein","comfort","batchFriendly"],["stovetop"],13,32,True,[
            ("chicken-thighs",620,"g","boneless"),("basmati-rice",250,"g"),("onion",1,"piece"),("tomato",350,"g"),
            ("garlic",4,"clove"),("ginger",15,"g"),("fenugreek-seeds",0.5,"tsp"),("turmeric",0.5,"tsp"),
            ("cumin",1,"tsp"),("ground-coriander",1,"tsp"),("vegetable-oil",1.5,"tbsp"),
            ("salt",0.5,"tsp"),("cilantro",12,"g"),
        ],"""Chop the onion and tomatoes and grate the garlic and ginger. Cut the chicken into pieces.
Heat the oil in a wide pan. Add fenugreek seeds and stir just until they darken slightly.
Add the onion and cook until golden. Stir in the chicken, garlic, ginger, turmeric, coriander, cumin and salt.
Brown the chicken for a few minutes. Add the tomatoes and a splash of water, cover and simmer.
Cook until the chicken reaches 74°C (165°F) and the tomatoes form a loose gravy. Meanwhile, cook the rice following the packet.
Serve the curry with rice and chopped fresh coriander."""),
        recipe("beef-pepperoni-pizza","Beef and pepperoni pizza","🍕","American",["family","comfort","fakeaway"],["oven","stovetop"],20,22,False,[
            ("flour",300,"g"),("greek-yogurt",250,"g"),("baking-powder",2.5,"tsp"),("salt",0.5,"tsp"),
            ("ground-beef",240,"g"),("pepperoni",65,"g"),("passata",150,"g"),("mozzarella",160,"g"),
            ("dried-oregano",1,"tsp"),("olive-oil",1,"tbsp"),
        ],"""Heat the oven to 230°C (450°F) with a baking tray inside.
Mix flour, baking powder, salt and yoghurt into a soft dough. Knead briefly and roll into a large thin round.
Brown the beef in a frying pan until cooked through, then drain off excess fat.
Put the base on baking paper and slide onto the hot tray. Bake for 5 minutes to set the surface.
Brush with oil and spread with passata. Add oregano, torn mozzarella, cooked beef and pepperoni slices.
Bake for a further 10–14 minutes until the crust is crisp and the cheese is bubbling. Rest briefly before slicing."""),
        recipe("lemongrass-beef-vermicelli","Lemongrass beef vermicelli bowls","🥢","Other",["highProtein","healthyish"],["stovetop"],17,12,False,[
            ("beef-steak",510,"g"),("rice-noodles",280,"g","thin vermicelli"),("lemongrass",20,"g"),("garlic",3,"clove"),
            ("cucumber",1,"piece"),("carrot",180,"g"),("cilantro",18,"g"),("peanuts",45,"g"),
            ("lime",2,"piece"),("fish-sauce",2,"tbsp"),("sugar",1,"tbsp"),("vegetable-oil",1,"tbsp"),
        ],"""Prepare the vermicelli following the packet and drain well. Slice the cucumber and cut the carrot into matchsticks.
Finely chop the tender lemongrass core and the garlic. Mix with half the fish sauce and rub onto the steak.
Heat the oil in a heavy pan and sear the steak on both sides to at least 63°C (145°F). Rest for at least 3 minutes.
Whisk the lime juice, sugar and remaining fish sauce with a splash of water.
Slice the steak across the grain. Divide the noodles into bowls and add the cucumber, carrots and sliced beef.
Spoon over the dressing and scatter with coriander and crushed peanuts."""),
        recipe("chilli-lime-chicken-corn-salad","Chilli-lime chicken and corn salad","🌽","Mexican",["healthyish","quickEasy","highProtein"],["stovetop"],14,15,False,[
            ("chicken-breast",560,"g"),("sweetcorn-tin",320,"g","drained"),("lettuce",280,"g"),("tomato",280,"g"),
            ("red-onion",1,"piece"),("lime",3,"piece"),("olive-oil",2.5,"tbsp"),
            ("chili-powder",1,"tsp"),("cumin",1,"tsp"),("salt",0.5,"tsp"),
        ],"""Rub thin chicken cutlets with lime zest, chilli powder, cumin, a little oil and half the salt.
Sear the chicken to 74°C (165°F) in the centre. Set it aside to rest, then slice.
Dry the corn and char it in the same pan. Chop the lettuce and tomatoes and dice the onion.
Whisk juice from two limes with the remaining oil and salt.
Toss the vegetables with the dressing and top with sliced chicken. Serve with wedges of the final lime.""",meal="lunch"),
        recipe("japanese-tomato-egg-rice","Japanese-style tomato and egg rice bowl","🍳","Japanese",["quickEasy","family"],["stovetop"],8,18,False,[
            ("eggs",8,"piece"),("sushi-rice",260,"g"),("tomato",500,"g"),("spring-onion",4,"piece"),
            ("soy-sauce",1.5,"tbsp"),("rice-vinegar",1,"tbsp"),("sugar",1,"tsp"),("vegetable-oil",1.5,"tbsp"),
        ],"""Rinse the rice and cook it following the packet. Cut the tomatoes into chunky wedges.
Whisk the eggs and slice the spring onions, keeping the green tops separate.
Heat the oil in a frying pan. Fry the spring-onion whites for a moment, then add the tomatoes.
Add soy sauce, vinegar and sugar. Cook just until the tomatoes start to soften.
Turn the heat low, pour the eggs over the tomatoes and fold slowly until broad soft curds form. Cook until set, then take off the heat.
Spoon the tomato-egg scramble next to the rice and finish with sliced spring-onion greens."""),
        recipe("toasted-chicken-queso-tortillas","Chicken queso tortillas","🌮","Mexican",["family","comfort","quickEasy"],["stovetop"],12,21,False,[
            ("tortillas",8,"piece","small"),("chicken-breast",460,"g"),("cheddar",145,"g"),("cream-cheese",70,"g"),
            ("paprika",1,"tsp"),("cumin",0.5,"tsp"),("spring-onion",2,"piece"),("salsa",140,"g"),
        ],"""Gently simmer the chicken in water until the centre reaches 74°C (165°F). Let it cool slightly and shred it.
Mix grated cheddar, cream cheese, paprika, cumin and finely sliced spring onions.
Spread the queso on four tortillas, add the shredded chicken and cover with the remaining tortillas.
Toast in a dry skillet, flipping carefully once the bottom is golden. Cook until both sides are toasted and the filling is melted.
Rest for a minute, then cut each tortilla stack into wedges and serve with salsa.""",meal="lunch"),
    ]
