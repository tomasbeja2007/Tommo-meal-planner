"""Chicken, turkey and beef dishes from the recipe brief."""


def build_recipes(R):
    def recipe(id, title, emoji, cuisine, vibes, appliances, prep, cook, leftovers, ingredients, steps, meal="dinner"):
        row = R(id, title, emoji, cuisine, vibes, appliances, prep, cook, 4, leftovers, ingredients, steps.split("\n"), meal=meal)
        row["tags"] = []
        return row

    return [
        recipe("minced-beef-gravy-mash", "Minced beef and gravy with mash", "🥔", "British", ["comfort","family","batchFriendly"],
               ["stovetop"], 12, 27, True, [
            ("ground-beef",500,"g"),("potato",750,"g"),("onion",1,"piece"),("peas-frozen",240,"g"),
            ("flour",1.5,"tbsp"),("vegetable-stock",420,"ml"),("worcestershire",1,"tbsp"),
            ("butter",35,"g"),("milk",90,"ml"),("black-pepper",0.5,"tsp"),("salt",0.5,"tsp"),
        ], """Peel the potatoes and cut into chunks. Boil for about 15 minutes until soft.
While they cook, brown the mince in a wide pan, breaking it up. Add thinly sliced onion and cook until softened.
Sprinkle in the flour and stir for a minute. Pour in the stock gradually and add the Worcestershire sauce and pepper.
Simmer for 8–10 minutes until the gravy is thick and the mince is cooked through.
Drain the potatoes and mash with milk, butter and salt. Boil the peas in a small pan and drain.
Heap the mince and onion gravy over the mash and serve the peas alongside."""),
        recipe("chicken-caesar-pasta-salad", "Chicken Caesar pasta salad", "🥗", "American", ["highProtein","quickEasy"],
               ["stovetop"], 15, 17, False, [
            ("rigatoni",280,"g"),("chicken-breast",470,"g"),("lettuce",280,"g"),("sourdough",2,"slice"),
            ("parmesan",65,"g"),("greek-yogurt",120,"g"),("mayonnaise",40,"g"),("lemon",1,"piece"),
            ("worcestershire",1,"tsp"),("dijon-mustard",1,"tsp"),("olive-oil",1,"tbsp"),("black-pepper",0.5,"tsp"),
        ], """Cook the rigatoni, drain and rinse briefly under cold water. Shake it dry.
Slice the chicken into cutlets. Fry in half the oil until golden and 74°C (165°F) inside, then let it cool before slicing.
Cube the sourdough and toast it in the remaining oil. Chop the lettuce and shave the parmesan.
Whisk the yoghurt, mayonnaise, mustard, Worcestershire, lemon juice and pepper into a thick dressing.
Toss the pasta, chicken and lettuce with the dressing. Add the parmesan and croutons just before serving.""", meal="lunch"),
        recipe("creamy-green-chile-chicken-pasta-bake", "Creamy chicken and green chile pasta bake", "🍝", "Other",
               ["comfort","family","batchFriendly"], ["oven","stovetop"], 15, 37, True, [
            ("penne",300,"g"),("chicken-breast",490,"g"),("poblano-pepper",210,"g"),("cream-cheese",140,"g"),
            ("milk",250,"ml"),("cheddar",125,"g"),("spring-onion",4,"piece"),("garlic",3,"clove"),
            ("olive-oil",1,"tbsp"),("cumin",0.5,"tsp"),("salt",0.5,"tsp"),
        ], """Heat the oven to 200°C (400°F). Halve and deseed the poblanos and roast cut-side down for 15 minutes.
Cook the penne until just underdone. Slice the poblanos and dice the chicken.
Heat the oil in a frying pan and cook the chicken to 74°C (165°F). Add crushed garlic, cumin and salt.
Stir in the cream cheese and milk over low heat. Fold through the drained pasta, sliced poblanos and half the grated cheddar.
Spoon into a baking dish and scatter with the rest of the cheese. Bake for 15 minutes until bubbling and golden.
Scatter thinly sliced spring onions over the bake and rest for 3 minutes before serving."""),
        recipe("buffalo-chicken-sliders", "Buffalo chicken sliders", "🍔", "American", ["fakeaway","highProtein","comfort"],
               ["stovetop"], 13, 19, False, [
            ("chicken-breast",540,"g"),("burger-buns",4,"piece","small"),("hot-sauce",3,"tbsp"),
            ("butter",28,"g"),("cabbage",220,"g"),("mayonnaise",45,"g"),("rice-vinegar",1,"tbsp"),
            ("honey",1,"tsp"),("salt",0.5,"tsp"),
        ], """Gently simmer the chicken in water until the middle reaches 74°C (165°F).
Finely shred the cabbage and toss it with mayonnaise, vinegar and half the salt.
Warm the butter, hot sauce, honey and the rest of the salt in a saucepan until combined.
Drain the chicken and shred it with two forks. Toss it in the warm Buffalo sauce.
Split and toast the buns in a dry frying pan.
Load the buns with the saucy shredded chicken and a small heap of the dressed cabbage."""),
        recipe("gochujang-coconut-chicken-rice", "Gochujang coconut chicken with rice", "🍚", "Other", ["highProtein","batchFriendly"],
               ["stovetop"], 12, 23, True, [
            ("chicken-thighs",620,"g","boneless"),("basmati-rice",250,"g"),("coconut-milk",320,"ml"),("gochujang",2,"tbsp"),
            ("onion",1,"piece"),("garlic",3,"clove"),("ginger",15,"g"),("vegetable-oil",1,"tbsp"),
            ("lime",1,"piece"),("spring-onion",3,"piece"),("sesame-seeds",2,"tsp"),
        ], """Rinse the rice and set it cooking. Dice the onion and cut the chicken into bite-size pieces.
Brown the chicken in the hot oil, then stir in the onion for 4 minutes.
Add the grated garlic, ginger and gochujang and cook briefly while stirring.
Pour in coconut milk. Simmer until the chicken reaches 74°C (165°F) and the sauce lightly coats a spoon.
Squeeze in lime juice and fluff the cooked rice.
Spoon the coconut chicken beside the rice and finish with spring onions and sesame seeds."""),
        recipe("soy-lime-turkey-mango-salad", "Turkey and mango salad with soy and lime", "🥭", "Other", ["quickEasy","highProtein","healthyish"],
               ["stovetop"], 15, 10, False, [
            ("turkey-breast",460,"g"),("mango",450,"g"),("cucumber",1,"piece"),("red-cabbage",320,"g"),
            ("lime",2,"piece"),("soy-sauce",2,"tbsp"),("vegetable-oil",1,"tbsp"),("sesame-oil",1,"tsp"),
            ("honey",1,"tsp"),("ginger",8,"g"),("spring-onion",2,"piece"),
        ], """Thinly slice the turkey. Toss with half the soy sauce and the grated ginger.
Heat the vegetable oil in a hot pan. Sear the turkey strips until browned and 74°C (165°F) at the centre.
Cut the mango into chunks, slice the cucumber, finely shred the red cabbage and slice the spring onions.
Whisk the remaining soy with juice from one lime, sesame oil and honey.
Toss the salad in the dressing. Add the warm or cooled turkey and spring onions, then serve with wedges of the second lime.""",meal="lunch"),
        recipe("chicken-cracker-topped-casserole", "Creamy chicken casserole with cracker topping", "🍗", "American", ["comfort","family","batchFriendly"],
               ["oven","stovetop"], 12, 40, True, [
            ("chicken-breast",550,"g"),("peas-frozen",250,"g"),("milk",360,"ml"),("chicken-stock",200,"ml"),
            ("butter",45,"g"),("flour",35,"g"),("cream-cheese",110,"g"),("saltine-crackers",100,"g"),
            ("dried-thyme",1,"tsp"),("black-pepper",0.5,"tsp"),
        ], """Heat the oven to 200°C (400°F). Poach the chicken in gently simmering water until it reaches 74°C (165°F), then shred it.
Melt most of the butter in a saucepan and stir in the flour and thyme. Cook for a minute.
Gradually whisk in the milk and stock. Simmer until smooth and thick, then stir in the cream cheese and pepper.
Fold the chicken and frozen peas into the sauce. Pour into a shallow baking dish.
Crush the crackers roughly and toss with the rest of the melted butter. Scatter across the casserole.
Bake for 18–20 minutes until it is hot at the centre and the cracker crumbs turn golden."""),
        recipe("sticky-five-spice-chicken", "Sticky five-spice chicken", "🍗", "Chinese", ["highProtein","fakeaway","family"],
               ["stovetop"], 12, 24, True, [
            ("chicken-thighs",600,"g","boneless"),("basmati-rice",250,"g"),("bok-choy",380,"g"),
            ("soy-sauce",2,"tbsp"),("honey",1.5,"tbsp"),("five-spice",1.5,"tsp"),
            ("ginger",12,"g"),("garlic",3,"clove"),("rice-vinegar",1,"tbsp"),
            ("vegetable-oil",1,"tbsp"),("spring-onion",3,"piece"),
        ], """Cook the rice following the packet. Pat the chicken thighs dry, leaving them whole.
Mix soy, honey, five-spice, garlic, ginger and vinegar with 50 ml water.
Heat the oil in a wide frying pan and brown the chicken on both sides.
Add the sauce and cover to cook the chicken through. Remove the lid and simmer until the glaze thickens and the meat reaches 74°C (165°F).
Quarter the pak choi and steam over boiling water for 3 minutes, until just tender.
Serve the chicken, pak choi and rice together. Spoon over the glaze and add sliced spring onions."""),
        recipe("vietnamese-chicken-cabbage-salad", "Vietnamese chicken and cabbage salad", "🥗", "Other", ["highProtein","healthyish","quickEasy"],
               ["stovetop"], 17, 14, False, [
            ("chicken-breast",560,"g"),("cabbage",320,"g"),("red-cabbage",100,"g"),("carrot",180,"g"),("mint",20,"g"),
            ("peanuts",60,"g"),("lime",3,"piece"),("fish-sauce",2,"tbsp"),("sugar",1,"tbsp"),
            ("garlic",2,"clove"),("rice-vinegar",1,"tbsp"),
        ], """Poach the chicken gently until the middle reaches 74°C (165°F). Let it cool slightly and pull it into shreds.
Finely shred both kinds of cabbage and cut the carrot into thin matchsticks. Tear the mint leaves.
Toast the peanuts in a dry frying pan and crush them roughly.
Whisk juice from two limes with fish sauce, vinegar, sugar and crushed garlic.
Toss the shredded chicken and vegetables with the dressing and mint. Scatter with peanuts and serve with the remaining lime in wedges.""",meal="lunch"),
        recipe("chicken-salami-pepperoncini-salad", "Chicken, salami and pepperoncini salad", "🥗", "Italian", ["quickEasy","highProtein"],
               ["stovetop"], 15, 12, False, [
            ("chicken-breast",460,"g"),("salami",110,"g"),("pepperoncini",100,"g","drained"),
            ("lettuce",300,"g"),("cherry-tomatoes",300,"g"),("olive-oil",2.5,"tbsp"),
            ("red-wine-vinegar",1.5,"tbsp"),("dried-oregano",1,"tsp"),("dijon-mustard",1,"tsp"),("black-pepper",0.5,"tsp"),
        ], """Slice the chicken into cutlets and fry in a little of the olive oil until golden and 74°C (165°F) at the centre.
Chop the lettuce and halve the tomatoes. Dice the salami and thinly slice the drained peppers.
Whisk the rest of the oil with vinegar, mustard, oregano and pepper.
Let the cooked chicken rest for a few minutes, then cut it into bite-size pieces.
Toss the vegetables, chicken, salami and peppers with enough dressing to lightly coat each bite.""",meal="lunch"),
        recipe("salmon-stuffed-cucumber-boats", "Salmon-stuffed cucumber boats", "🥒", "Other", ["quickEasy","highProtein"],
               ["oven"], 14, 14, False, [
            ("salmon-fillet",550,"g"),("cucumber",4,"piece"),("greek-yogurt",150,"g"),
            ("mayonnaise",35,"g"),("spring-onion",4,"piece"),("lemon",1,"piece"),
            ("dijon-mustard",1,"tsp"),("black-pepper",0.5,"tsp"),("olive-oil",1,"tsp"),
        ], """Heat the oven to 200°C (400°F). Rub the salmon with oil and roast until it flakes and reaches 63°C (145°F).
Cool the salmon, remove any skin and flake it into a bowl. Slice the spring onions thinly.
Mix the yoghurt, mayo, mustard, lemon juice and half the spring onions. Fold through the salmon without breaking every piece.
Halve the cucumbers lengthwise and scoop out the soft seeds with a spoon to make boats.
Mound the salmon filling into the cucumbers and finish with black pepper and the remaining spring onions.""",meal="lunch"),
        recipe("chicken-summer-rolls-sriracha", "Chicken summer rolls with sriracha dip", "🥬", "Other", ["highProtein","healthyish"],
               ["stovetop"], 25, 14, False, [
            ("chicken-breast",480,"g"),("rice-paper",12,"piece"),("red-cabbage",260,"g"),
            ("carrot",200,"g"),("mint",18,"g"),("greek-yogurt",110,"g"),("mayonnaise",35,"g"),
            ("sriracha",2,"tbsp"),("lime",1,"piece"),
        ], """Gently poach the chicken in water until it reaches 74°C (165°F). Let it cool, then shred it.
Very finely slice the red cabbage, cut the carrots into matchsticks and pick the mint leaves.
Mix the yoghurt, mayo, sriracha and lime juice into a smooth dip.
Dip a rice paper sheet briefly in water. Put the chicken, cabbage, carrot and two mint leaves in the middle.
Fold in both sides and roll snugly. Repeat and cut each roll in half on the diagonal. Serve with the dip.""",meal="lunch"),
    ]
