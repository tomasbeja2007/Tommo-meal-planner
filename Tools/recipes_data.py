# Starter recipe library (40 original recipes) used to bootstrap recipes.json.
# Diet, allergens and macros are NOT stored: ForkcastCore computes them from ingredients.

def R(id, title, emoji, cuisine, vibes, appliances, prep, cook, servings, leftovers, ingredients, steps):
    return {
        "id": id, "title": title, "emoji": emoji, "cuisine": cuisine, "vibes": vibes,
        "appliances": appliances, "prepMinutes": prep, "cookMinutes": cook,
        "baseServings": servings,
        "ingredients": [dict({"ingredientId": i[0], "amount": i[1], "unit": i[2]}, **({"note": i[3]} if len(i) > 3 else {})) for i in ingredients],
        "steps": steps, "imageName": None, "isLeftoverFriendly": leftovers,
    }

RECIPES = [
# ===================== VEGAN =====================
R("chickpea-spinach-curry","Chickpea & spinach coconut curry","🍛","Indian",["quickEasy","onePan","healthyish","batchFriendly"],["stovetop"],10,20,4,True,[
  ("basmati-rice",300,"g"),("vegetable-oil",1,"tbsp"),("onion",1,"piece","diced"),("garlic",3,"clove","crushed"),("ginger",15,"g","grated"),
  ("curry-powder",2,"tbsp"),("chopped-tomatoes",400,"g"),("coconut-milk",400,"ml"),("chickpeas",480,"g","drained"),("spinach",200,"g"),("salt",1,"tsp")],[
  "Rinse the rice and cook it in a pan of salted boiling water for 12 minutes, then drain and keep covered.",
  "Meanwhile, heat the oil in a large deep pan over a medium heat.",
  "Add the onion and cook for 5 minutes until soft and just golden.",
  "Stir in the garlic, ginger and curry powder and cook for 1 minute until fragrant.",
  "Pour in the chopped tomatoes and coconut milk, then add the chickpeas.",
  "Simmer for 10 minutes, stirring now and then, until slightly thickened.",
  "Stir through the spinach a handful at a time until wilted. Season with the salt.",
  "Serve the curry spooned over the rice."]),

R("slow-cooker-red-lentil-dahl","Slow-cooker red lentil dahl","🍲","Indian",["healthyish","batchFriendly","comfort"],["slowCooker","stovetop"],10,240,4,True,[
  ("red-lentils",300,"g","rinsed"),("onion",1,"piece","finely chopped"),("garlic",4,"clove","crushed"),("ginger",15,"g","grated"),
  ("turmeric",1,"tsp"),("cumin",2,"tsp"),("garam-masala",2,"tsp"),("chopped-tomatoes",400,"g"),("coconut-milk",400,"ml"),
  ("vegetable-stock",800,"ml"),("lemon",1,"piece"),("cilantro",25,"g","chopped"),("basmati-rice",250,"g"),("salt",1,"tsp")],[
  "Put the lentils, onion, garlic, ginger and all the spices into the slow cooker.",
  "Add the chopped tomatoes, coconut milk and stock, and stir well.",
  "Cover and cook on low for 4 hours (or high for 2½ hours), until the lentils have collapsed.",
  "About 20 minutes before serving, cook the rice in salted boiling water for 12 minutes, then drain.",
  "Stir the dahl well. If it's too thick, loosen it with a splash of hot water.",
  "Squeeze in the lemon juice and season with salt.",
  "Scatter with cilantro and serve with the rice."]),

R("black-bean-tacos","Smoky black bean tacos with lime slaw","🌮","Mexican",["quickEasy","fakeaway","family","healthyish"],["stovetop"],10,10,4,False,[
  ("olive-oil",1,"tbsp"),("red-onion",1,"piece","finely sliced"),("black-beans",480,"g","drained"),("paprika",1,"tsp"),("cumin",1,"tsp"),
  ("chili-powder",1,"tsp"),("cabbage",200,"g","finely shredded"),("lime",2,"piece"),("cilantro",25,"g","chopped"),
  ("corn-tortillas",12,"piece"),("avocado",1,"piece","sliced"),("salsa",200,"g"),("salt",1,"pinch")],[
  "Toss the cabbage with the juice of 1 lime, half the cilantro and a pinch of salt. Set aside.",
  "Heat the oil in a frying pan over a medium heat and cook half the red onion for 4 minutes.",
  "Add the black beans, paprika, cumin and chili powder with a splash of water.",
  "Cook for 5 minutes, roughly mashing about a third of the beans with a fork.",
  "Warm the tortillas in a dry pan for 30 seconds on each side and keep them wrapped in a clean tea towel.",
  "Fill each tortilla with beans, slaw, avocado and a spoonful of salsa.",
  "Finish with the remaining onion, cilantro and lime wedges for squeezing."]),

R("peanut-noodle-stir-fry","Peanut noodle stir-fry","🍜","Thai",["quickEasy","onePan","fakeaway"],["stovetop"],10,10,2,False,[
  ("rice-noodles",150,"g"),("peanut-butter",2,"tbsp"),("soy-sauce",2,"tbsp"),("lime",1,"piece"),("sriracha",1,"tsp"),("sugar",1,"tsp"),
  ("vegetable-oil",1,"tbsp"),("garlic",2,"clove","sliced"),("mixed-veg-frozen",300,"g"),("spring-onion",2,"piece","sliced"),("peanuts",30,"g","roughly chopped")],[
  "Soak the rice noodles in just-boiled water for 8 minutes, then drain.",
  "Whisk the peanut butter, soy sauce, juice of half the lime, sriracha, sugar and 4 tbsp hot water into a smooth sauce.",
  "Heat the oil in a wok or large frying pan over a high heat.",
  "Fry the garlic for 30 seconds, then add the frozen vegetables and stir-fry for 4 minutes.",
  "Add the noodles and sauce and toss for 2 minutes until glossy and hot.",
  "Serve topped with spring onions, peanuts and the remaining lime cut into wedges."]),

R("roast-veg-chickpea-couscous","Roast veg & chickpea couscous","🥗","Mediterranean",["healthyish","batchFriendly","onePan"],["oven","stovetop"],15,30,4,True,[
  ("zucchini",1,"piece","chopped"),("bell-pepper",2,"piece","chopped"),("red-onion",1,"piece","cut into wedges"),("chickpeas",240,"g","drained"),
  ("olive-oil",3,"tbsp"),("cumin",1,"tsp"),("paprika",1,"tsp"),("couscous",250,"g"),("vegetable-stock",300,"ml","hot"),
  ("lemon",1,"piece"),("parsley",25,"g","chopped"),("salt",1,"tsp")],[
  "Heat the oven to 200°C (400°F).",
  "Toss the zucchini, peppers, onion and chickpeas with 2 tbsp oil, the cumin, paprika and salt on a large tray.",
  "Roast for 30 minutes, turning halfway, until the veg is soft and charred at the edges.",
  "With 10 minutes to go, put the couscous in a bowl and pour over the hot stock.",
  "Cover and leave for 5 minutes, then fluff with a fork.",
  "Stir the remaining oil and the lemon juice through the couscous.",
  "Fold in the roast veg and chickpeas and scatter with parsley."]),

R("sticky-sesame-cauliflower","Sticky sesame cauliflower with rice","🥦","Chinese",["fakeaway","healthyish"],["airFryer","stovetop"],10,20,2,False,[
  ("long-grain-rice",150,"g"),("cauliflower",500,"g","cut into florets"),("cornstarch",3,"tbsp"),("vegetable-oil",1,"tbsp"),
  ("soy-sauce",3,"tbsp"),("sugar",1,"tbsp"),("rice-vinegar",1,"tbsp"),("garlic",2,"clove","grated"),("ginger",10,"g","grated"),
  ("sesame-seeds",1,"tsp"),("spring-onion",2,"piece","sliced")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Toss the cauliflower with the oil, then with 2 tbsp of the cornstarch until coated.",
  "Air fry at 200°C (400°F) for 15 minutes, shaking the basket halfway, until crisp.",
  "Meanwhile, mix the soy sauce, sugar, vinegar, garlic, ginger, the last 1 tbsp cornstarch and 4 tbsp water.",
  "Bubble the sauce in a small pan for 2 minutes until thick and glossy.",
  "Toss the crispy cauliflower in the sauce.",
  "Serve over the rice with sesame seeds and spring onions."]),

R("lentil-ragu-spaghetti","Lentil ragù spaghetti","🍝","Italian",["family","healthyish","batchFriendly","comfort"],["stovetop"],10,30,4,True,[
  ("olive-oil",2,"tbsp"),("onion",1,"piece","finely chopped"),("carrot",1,"piece","finely chopped"),("celery",1,"piece","finely chopped"),
  ("garlic",2,"clove","crushed"),("tomato-paste",2,"tbsp"),("red-lentils",200,"g","rinsed"),("chopped-tomatoes",800,"g"),
  ("vegetable-stock",400,"ml"),("dried-oregano",1,"tsp"),("spaghetti",400,"g"),("salt",1,"tsp"),("black-pepper",0.5,"tsp")],[
  "Heat the oil in a large pan and gently cook the onion, carrot and celery for 8 minutes until soft.",
  "Stir in the garlic and tomato paste and cook for 1 minute.",
  "Add the lentils, chopped tomatoes, stock and oregano.",
  "Simmer for 20 minutes, stirring often, until the lentils are tender and the sauce is thick.",
  "Meanwhile, cook the spaghetti in salted boiling water for 10 minutes, or according to the pack.",
  "Season the ragù with salt and pepper, adding a splash of pasta water if it's too thick.",
  "Toss the spaghetti through the sauce and serve."]),

R("sweet-potato-peanut-curry","Sweet potato & peanut curry","🥘","Thai",["comfort","healthyish","batchFriendly"],["stovetop"],10,25,4,True,[
  ("basmati-rice",250,"g"),("vegetable-oil",1,"tbsp"),("onion",1,"piece","diced"),("garlic",3,"clove","crushed"),("ginger",15,"g","grated"),
  ("curry-powder",1,"tbsp"),("sweet-potato",600,"g","peeled and cubed"),("chopped-tomatoes",400,"g"),("coconut-milk",400,"ml"),
  ("peanut-butter",3,"tbsp"),("spinach",100,"g"),("lime",1,"piece"),("cilantro",25,"g","chopped"),("salt",1,"tsp")],[
  "Heat the oil in a large pan and cook the onion for 5 minutes until soft.",
  "Add the garlic, ginger and curry powder and cook for 1 minute.",
  "Add the sweet potato, chopped tomatoes, coconut milk and peanut butter. Stir until the peanut butter melts in.",
  "Cover and simmer for 20 minutes until the sweet potato is tender.",
  "Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.",
  "Stir the spinach into the curry until wilted, then add the lime juice and salt.",
  "Serve over rice, scattered with cilantro."]),

R("microwave-chickpea-curry-bowl","Microwave chickpea curry rice bowls","🍛","Indian",["quickEasy","healthyish"],["microwave"],5,6,2,False,[
  ("chickpeas",240,"g","drained"),("passata",150,"g"),("curry-powder",2,"tsp"),("garlic-powder",0.5,"tsp"),("spinach",80,"g"),
  ("microwave-rice",250,"g"),("lemon",0.5,"piece"),("coconut-yogurt",60,"g"),("salt",1,"pinch")],[
  "Mix the chickpeas, passata, curry powder, garlic powder and a pinch of salt in a large microwave-safe bowl.",
  "Cover and microwave on high for 3 minutes.",
  "Stir in the spinach, cover again and microwave for 1 minute until wilted.",
  "Heat the rice pouch in the microwave according to the pack, about 2 minutes.",
  "Squeeze the lemon juice into the curry and stir.",
  "Divide the rice between two bowls, top with the curry and finish with a spoonful of coconut yogurt."]),

# ===================== VEGETARIAN =====================
R("air-fryer-halloumi-wraps","Air-fryer halloumi & pepper wraps","🌯","Mediterranean",["quickEasy","family","fakeaway"],["airFryer"],10,12,2,False,[
  ("halloumi",225,"g","sliced"),("bell-pepper",2,"piece","sliced"),("red-onion",1,"piece","sliced"),("olive-oil",1,"tbsp"),
  ("paprika",1,"tsp"),("greek-yogurt",100,"g"),("lemon",0.5,"piece"),("cucumber",150,"g","finely chopped"),
  ("tortillas",4,"piece"),("arugula",40,"g")],[
  "Toss the peppers and onion with the oil and paprika.",
  "Air fry at 200°C (400°F) for 6 minutes.",
  "Add the halloumi slices to the basket and air fry for another 6 minutes, turning once, until golden.",
  "Meanwhile, stir the cucumber and lemon juice into the yogurt with a pinch of salt.",
  "Warm the tortillas in the air fryer for 1 minute.",
  "Spread each tortilla with the yogurt, then add arugula, veg and halloumi.",
  "Roll up tightly and cut in half to serve."]),

R("shakshuka","Shakshuka with crusty bread","🍳","Middle Eastern",["onePan","healthyish","comfort","quickEasy"],["stovetop"],5,20,2,False,[
  ("olive-oil",1,"tbsp"),("onion",1,"piece","sliced"),("bell-pepper",1,"piece","sliced"),("garlic",2,"clove","sliced"),
  ("cumin",1,"tsp"),("paprika",1,"tsp"),("chili-flakes",0.5,"tsp"),("chopped-tomatoes",400,"g"),("eggs",4,"piece"),
  ("feta",60,"g","crumbled"),("parsley",10,"g","chopped"),("baguette",0.5,"piece")],[
  "Heat the oil in a deep frying pan with a lid over a medium heat.",
  "Cook the onion and pepper for 6 minutes until soft.",
  "Add the garlic, cumin, paprika and chili flakes and cook for 1 minute.",
  "Pour in the tomatoes and simmer for 5 minutes until slightly thickened. Season.",
  "Make 4 dips in the sauce and crack an egg into each.",
  "Cover and cook for 6 to 8 minutes until the whites are set but the yolks are still soft.",
  "Scatter over the feta and parsley and serve straight from the pan with the bread."]),

R("creamy-tomato-gnocchi-bake","Creamy tomato & spinach gnocchi bake","🍝","Italian",["comfort","family","onePan"],["oven","stovetop"],5,25,4,False,[
  ("olive-oil",1,"tbsp"),("garlic",2,"clove","crushed"),("passata",500,"g"),("dried-oregano",1,"tsp"),("cream-cheese",100,"g"),
  ("spinach",100,"g"),("gnocchi",1000,"g"),("mozzarella",125,"g","torn"),("basil",10,"g")],[
  "Heat the oven to 200°C (400°F).",
  "Heat the oil in an ovenproof pan and fry the garlic for 1 minute.",
  "Add the passata and oregano and simmer for 5 minutes.",
  "Stir in the cream cheese until melted, then add the spinach until wilted.",
  "Stir in the gnocchi straight from the pack so every piece is coated.",
  "Top with the mozzarella and bake for 15 minutes until bubbling and golden.",
  "Scatter with basil leaves and serve."]),

R("mushroom-pea-risotto","Mushroom & pea risotto","🍄","Italian",["comfort"],["stovetop"],10,30,4,False,[
  ("olive-oil",1,"tbsp"),("butter",30,"g"),("onion",1,"piece","finely chopped"),("garlic",2,"clove","crushed"),
  ("mushrooms",250,"g","sliced"),("arborio-rice",300,"g"),("vegetable-stock",1200,"ml","hot"),("peas-frozen",150,"g"),
  ("parmesan",50,"g","grated"),("lemon",0.5,"piece"),("black-pepper",0.5,"tsp")],[
  "Heat the oil and half the butter in a wide pan and cook the onion for 5 minutes.",
  "Add the mushrooms and garlic and cook for 5 minutes until golden.",
  "Stir in the rice for 1 minute until the grains turn glossy.",
  "Add the hot stock a ladle at a time, stirring, letting each addition absorb before adding the next. This takes about 18 minutes.",
  "Stir in the peas with the last ladle of stock and cook for 2 more minutes.",
  "Take off the heat and beat in the remaining butter, the parmesan and the lemon juice.",
  "Season with pepper, cover and rest for 2 minutes before serving."]),

R("two-minute-burrito-bowls","2-minute burrito bowls","🥙","Mexican",["quickEasy","family"],["microwave"],5,4,2,False,[
  ("microwave-rice",250,"g"),("black-beans",240,"g","drained"),("corn-frozen",100,"g"),("salsa",150,"g"),
  ("cheddar",50,"g","grated"),("sour-cream",60,"g"),("avocado",1,"piece","diced"),("lime",0.5,"piece")],[
  "Put the black beans and frozen corn in a microwave-safe bowl with 2 tbsp of the salsa.",
  "Cover and microwave on high for 2 minutes, then stir.",
  "Heat the rice pouch in the microwave according to the pack, about 2 minutes.",
  "Divide the rice between two bowls and top with the beans and corn.",
  "Add the remaining salsa, cheddar, avocado and a spoonful of sour cream.",
  "Squeeze over the lime juice and serve."]),

R("veggie-egg-fried-rice","Veggie egg fried rice","🍳","Chinese",["quickEasy","fakeaway","onePan","family"],["stovetop"],5,12,2,False,[
  ("vegetable-oil",1,"tbsp"),("garlic",2,"clove","finely chopped"),("carrot",1,"piece","finely diced"),("peas-frozen",100,"g"),
  ("corn-frozen",100,"g"),("microwave-rice",500,"g"),("eggs",3,"piece","beaten"),("soy-sauce",2,"tbsp"),
  ("sesame-oil",1,"tsp"),("spring-onion",3,"piece","sliced")],[
  "Heat the oil in a wok or large frying pan over a high heat.",
  "Stir-fry the garlic and carrot for 2 minutes.",
  "Add the peas and corn and cook for 2 minutes.",
  "Squeeze the rice pouches to break up the grains, add to the pan and stir-fry for 4 minutes until hot.",
  "Push the rice to one side, pour the eggs into the gap and scramble for 1 minute before mixing through.",
  "Add the soy sauce and sesame oil and toss well.",
  "Serve scattered with spring onions."]),

R("paneer-tikka-traybake","Paneer tikka traybake with naan","🍢","Indian",["highProtein","onePan"],["oven"],15,25,2,False,[
  ("paneer",225,"g","cubed"),("greek-yogurt",100,"g"),("curry-paste",2,"tbsp"),("lemon",0.5,"piece"),
  ("bell-pepper",2,"piece","chopped"),("red-onion",1,"piece","cut into wedges"),("olive-oil",1,"tbsp"),
  ("naan",2,"piece"),("cilantro",10,"g","chopped")],[
  "Heat the oven to 220°C (425°F).",
  "Mix half the yogurt with the curry paste and lemon juice, then stir in the paneer to coat.",
  "Toss the peppers and onion with the oil on a large tray and roast for 10 minutes.",
  "Add the paneer to the tray and roast for 15 minutes more until charred at the edges.",
  "Warm the naans in the oven for the last 3 minutes.",
  "Season the remaining yogurt with a pinch of salt.",
  "Pile the paneer and veg onto the naans, drizzle with yogurt and scatter with cilantro."]),

# ===================== PESCATARIAN =====================
R("air-fryer-honey-soy-salmon","Air-fryer honey-soy salmon with greens","🐟","Japanese",["highProtein","quickEasy","healthyish"],["airFryer","stovetop"],5,15,2,False,[
  ("long-grain-rice",150,"g"),("salmon-fillet",240,"g"),("honey",1,"tbsp"),("soy-sauce",2,"tbsp"),("garlic",1,"clove","grated"),
  ("ginger",5,"g","grated"),("green-beans",200,"g","trimmed"),("sesame-seeds",1,"tsp"),("spring-onion",2,"piece","sliced")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Mix the honey, soy sauce, garlic and ginger in a small bowl.",
  "Brush half the glaze over the salmon fillets.",
  "Air fry the salmon at 200°C (400°F) for 8 minutes, brushing with the remaining glaze halfway.",
  "Meanwhile, steam or boil the green beans for 4 minutes.",
  "Serve the salmon on the rice with the beans, scattered with sesame seeds and spring onions."]),

R("thai-red-prawn-curry","Thai red prawn curry","🍤","Thai",["fakeaway","quickEasy"],["stovetop"],10,15,4,False,[
  ("basmati-rice",250,"g"),("vegetable-oil",1,"tbsp"),("thai-curry-paste",3,"tbsp"),("coconut-milk",400,"ml"),
  ("bell-pepper",1,"piece","sliced"),("green-beans",150,"g","halved"),("shrimp",300,"g"),("fish-sauce",1,"tbsp"),
  ("sugar",1,"tsp"),("lime",1,"piece"),("basil",10,"g")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Meanwhile, heat the oil in a wok or deep pan and fry the curry paste for 1 minute.",
  "Pour in the coconut milk and bring to a gentle simmer.",
  "Add the pepper and green beans and simmer for 5 minutes.",
  "Add the shrimp and cook for 3 to 4 minutes until pink all the way through.",
  "Season with the fish sauce, sugar and lime juice.",
  "Scatter with basil and serve with the rice."]),

R("tuna-sweetcorn-pasta-bake","Tuna & sweetcorn pasta bake","🧀","British",["family","comfort"],["oven","stovetop"],10,25,4,True,[
  ("penne",350,"g"),("butter",30,"g"),("flour",30,"g"),("milk",400,"ml"),("dijon-mustard",1,"tsp"),
  ("cheddar",120,"g","grated"),("canned-tuna",290,"g","drained"),("corn-frozen",150,"g"),("spring-onion",3,"piece","sliced"),
  ("black-pepper",0.5,"tsp")],[
  "Heat the oven to 200°C (400°F).",
  "Cook the penne in salted boiling water for 2 minutes less than the pack says, then drain.",
  "Meanwhile, melt the butter in a pan, stir in the flour and cook for 1 minute.",
  "Gradually whisk in the milk and simmer for 3 minutes until thick and smooth.",
  "Take off the heat and stir in the mustard and two-thirds of the cheddar.",
  "Mix the pasta, tuna, corn and spring onions into the sauce and season with pepper.",
  "Tip into a baking dish, scatter over the rest of the cheese and bake for 15 minutes until golden."]),

R("lemon-cod-traybake","Lemon cod with crushed potatoes & beans","🐟","Mediterranean",["healthyish","lowCalorie","onePan"],["oven"],10,30,2,False,[
  ("potato",500,"g","cut into chunks"),("olive-oil",2,"tbsp"),("garlic",2,"clove","sliced"),("green-beans",150,"g"),
  ("cherry-tomatoes",200,"g"),("white-fish",280,"g"),("lemon",1,"piece"),("parsley",10,"g","chopped"),("salt",1,"tsp")],[
  "Heat the oven to 200°C (400°F).",
  "Toss the potatoes with 1 tbsp oil and the salt on a tray and roast for 15 minutes.",
  "Lightly crush the potatoes with a fork, then add the garlic, green beans and tomatoes.",
  "Lay the cod on top, drizzle with the remaining oil and add a few lemon slices.",
  "Roast for 12 to 15 minutes until the fish flakes easily.",
  "Squeeze over the rest of the lemon, scatter with parsley and serve."]),

R("garlic-prawn-spaghetti","Garlic prawn spaghetti","🍝","Italian",["quickEasy"],["stovetop"],5,15,2,False,[
  ("spaghetti",200,"g"),("olive-oil",2,"tbsp"),("garlic",4,"clove","sliced"),("chili-flakes",0.5,"tsp"),
  ("cherry-tomatoes",200,"g","halved"),("shrimp",200,"g"),("lemon",0.5,"piece"),("parsley",10,"g","chopped"),("arugula",40,"g")],[
  "Cook the spaghetti in salted boiling water for 10 minutes, or according to the pack. Save a mugful of pasta water.",
  "Meanwhile, heat the oil in a large frying pan over a medium heat.",
  "Fry the garlic and chili flakes for 1 minute without letting the garlic brown.",
  "Add the tomatoes and cook for 3 minutes until they start to burst.",
  "Add the shrimp and cook for 3 minutes until pink.",
  "Toss in the spaghetti with a splash of pasta water, the lemon juice and parsley.",
  "Serve topped with arugula."]),

# ===================== MEAT =====================
R("air-fryer-lemon-chicken-potatoes","Air-fryer lemon chicken thighs & potatoes","🍗","Mediterranean",["highProtein","family","onePan"],["airFryer","stovetop"],10,25,2,False,[
  ("chicken-thighs",400,"g"),("potato",400,"g","cut into chunks"),("olive-oil",1,"tbsp"),("lemon",1,"piece"),
  ("garlic",2,"clove","crushed"),("dried-oregano",1,"tsp"),("paprika",1,"tsp"),("broccoli",200,"g","cut into florets"),("salt",1,"tsp")],[
  "Toss the potatoes with half the oil and half the salt.",
  "Air fry the potatoes at 200°C (400°F) for 10 minutes.",
  "Meanwhile, mix the chicken with the remaining oil, the garlic, oregano, paprika, lemon zest and remaining salt.",
  "Shake the basket, add the chicken on top of the potatoes and air fry for 15 minutes more.",
  "Check the chicken is cooked through, with no pink juices.",
  "While it cooks, boil or steam the broccoli for 4 minutes.",
  "Squeeze the lemon juice over everything and serve."]),

R("slow-cooker-beef-chili","Slow-cooker beef & bean chili","🌶️","American",["batchFriendly","comfort","highProtein"],["slowCooker","stovetop"],15,360,4,True,[
  ("ground-beef",500,"g"),("onion",1,"piece","diced"),("bell-pepper",1,"piece","diced"),("garlic",3,"clove","crushed"),
  ("chili-powder",2,"tsp"),("cumin",2,"tsp"),("paprika",1,"tsp"),("tomato-paste",2,"tbsp"),("chopped-tomatoes",800,"g"),
  ("kidney-beans",240,"g","drained"),("long-grain-rice",300,"g"),("sour-cream",100,"g"),("salt",1,"tsp")],[
  "Brown the beef in a dry frying pan over a high heat for 5 minutes, breaking it up with a spoon.",
  "Tip the beef into the slow cooker with the onion, pepper, garlic and spices.",
  "Stir in the tomato paste, chopped tomatoes and kidney beans.",
  "Cover and cook on low for 6 hours (or high for 3 hours).",
  "About 20 minutes before serving, cook the rice in salted boiling water for 12 minutes, then drain.",
  "Season the chili with salt.",
  "Serve over rice with a spoonful of sour cream."]),

R("slow-cooker-bbq-pulled-chicken","Slow-cooker BBQ pulled chicken buns","🍔","American",["family","fakeaway","batchFriendly"],["slowCooker"],10,240,4,True,[
  ("chicken-thighs",800,"g"),("bbq-sauce",250,"g"),("onion",1,"piece","sliced"),("paprika",2,"tsp"),("garlic-powder",1,"tsp"),
  ("cabbage",200,"g","finely shredded"),("carrot",1,"piece","grated"),("mayonnaise",2,"tbsp"),("lemon",0.5,"piece"),
  ("burger-buns",4,"piece")],[
  "Put the onion in the slow cooker and lay the chicken thighs on top.",
  "Mix the barbecue sauce with the paprika and garlic powder and pour over the chicken.",
  "Cover and cook on low for 4 hours, until the chicken pulls apart easily.",
  "Shred the chicken with two forks and stir it through the sauce.",
  "Mix the cabbage and carrot with the mayonnaise and lemon juice for a quick slaw.",
  "Toast the buns, then fill with the pulled chicken and slaw."]),

R("sheet-pan-chicken-fajitas","Sheet-pan chicken fajitas","🌯","Mexican",["family","onePan","fakeaway","highProtein"],["oven"],10,20,4,False,[
  ("chicken-breast",500,"g","sliced into strips"),("bell-pepper",3,"piece","sliced"),("red-onion",1,"piece","sliced"),
  ("olive-oil",2,"tbsp"),("paprika",2,"tsp"),("cumin",1,"tsp"),("chili-powder",1,"tsp"),("lime",1,"piece"),
  ("tortillas",8,"piece"),("sour-cream",100,"g"),("salt",1,"tsp")],[
  "Heat the oven to 220°C (425°F).",
  "Toss the chicken, peppers and onion with the oil, spices and salt on a large tray.",
  "Spread everything out in a single layer and roast for 20 minutes, until the chicken is cooked through.",
  "Warm the tortillas in the oven for the last 3 minutes.",
  "Squeeze the lime juice over the tray.",
  "Fill the tortillas with chicken and veg and top with sour cream."]),

R("honey-garlic-chicken-stir-fry","Honey-garlic chicken stir-fry","🥢","Chinese",["quickEasy","highProtein","fakeaway"],["stovetop"],10,12,2,False,[
  ("long-grain-rice",150,"g"),("chicken-breast",300,"g","cut into bite-size pieces"),("cornstarch",1,"tbsp"),("vegetable-oil",1,"tbsp"),
  ("broccoli",200,"g","cut into small florets"),("bell-pepper",1,"piece","sliced"),("garlic",3,"clove","crushed"),("ginger",10,"g","grated"),
  ("honey",1,"tbsp"),("soy-sauce",3,"tbsp"),("sesame-seeds",1,"tsp")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Toss the chicken in the cornstarch.",
  "Heat the oil in a wok over a high heat and stir-fry the chicken for 5 minutes until golden.",
  "Add the broccoli, pepper and a splash of water and stir-fry for 3 minutes.",
  "Add the garlic and ginger and cook for 30 seconds.",
  "Stir in the honey and soy sauce and bubble for 1 minute until sticky.",
  "Serve over the rice, sprinkled with sesame seeds."]),

R("chicken-tikka-masala","Chicken tikka masala","🍛","Indian",["fakeaway","comfort","family"],["stovetop"],10,25,4,True,[
  ("basmati-rice",300,"g"),("vegetable-oil",1,"tbsp"),("chicken-breast",600,"g","cut into chunks"),("onion",1,"piece","diced"),
  ("garlic",3,"clove","crushed"),("ginger",15,"g","grated"),("curry-paste",4,"tbsp"),("chopped-tomatoes",400,"g"),
  ("heavy-cream",150,"ml"),("greek-yogurt",100,"g"),("cilantro",25,"g","chopped")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Heat the oil in a large pan and brown the chicken for 4 minutes. Lift out onto a plate.",
  "Add the onion to the pan and cook for 5 minutes until soft.",
  "Stir in the garlic, ginger and curry paste and cook for 1 minute.",
  "Add the tomatoes and simmer for 5 minutes.",
  "Return the chicken, stir in the cream and simmer for 8 minutes until the chicken is cooked through.",
  "Take off the heat and stir in the yogurt. Scatter with cilantro and serve with rice."]),

R("air-fryer-turkey-meatballs","Air-fryer turkey meatballs & spaghetti","🍝","Italian",["highProtein","family"],["airFryer","stovetop"],15,20,4,True,[
  ("ground-turkey",500,"g"),("breadcrumbs",50,"g"),("eggs",1,"piece"),("parmesan",30,"g","grated"),("garlic",2,"clove","crushed"),
  ("dried-oregano",1,"tsp"),("olive-oil",1,"tbsp"),("passata",500,"g"),("spaghetti",350,"g"),("basil",10,"g"),("salt",1,"tsp")],[
  "Mix the turkey, breadcrumbs, egg, parmesan, half the garlic, the oregano and salt. Roll into 20 meatballs.",
  "Air fry at 190°C (375°F) for 12 minutes, shaking halfway, until browned and cooked through.",
  "Meanwhile, cook the spaghetti in salted boiling water for 10 minutes, or according to the pack.",
  "Heat the oil in a pan and fry the remaining garlic for 30 seconds.",
  "Add the passata and simmer for 8 minutes.",
  "Add the meatballs to the sauce and turn to coat.",
  "Serve over the spaghetti, torn basil on top."]),

R("turkey-taco-lettuce-cups","Turkey taco lettuce cups","🥬","Mexican",["lowCalorie","highProtein","quickEasy"],["stovetop"],10,10,2,False,[
  ("olive-oil",1,"tbsp"),("red-onion",0.5,"piece","finely chopped"),("ground-turkey",400,"g"),("chili-powder",1,"tsp"),
  ("cumin",1,"tsp"),("paprika",1,"tsp"),("salsa",100,"g"),("lettuce",1,"piece","leaves separated"),
  ("cherry-tomatoes",150,"g","chopped"),("avocado",1,"piece","diced"),("lime",1,"piece")],[
  "Heat the oil in a frying pan over a medium-high heat and cook the onion for 3 minutes.",
  "Add the turkey and cook for 6 minutes, breaking it up, until browned.",
  "Stir in the spices and cook for 1 minute.",
  "Add the salsa and a splash of water and bubble for 2 minutes.",
  "Mix the tomatoes and avocado with half the lime juice.",
  "Spoon the turkey into lettuce leaves and top with the tomato and avocado.",
  "Serve with the remaining lime in wedges."]),

R("weeknight-spaghetti-bolognese","Weeknight spaghetti bolognese","🍝","Italian",["family","comfort","batchFriendly"],["stovetop"],10,30,4,True,[
  ("olive-oil",1,"tbsp"),("onion",1,"piece","finely chopped"),("carrot",1,"piece","finely chopped"),("celery",1,"piece","finely chopped"),
  ("garlic",2,"clove","crushed"),("ground-beef",500,"g"),("tomato-paste",2,"tbsp"),("chopped-tomatoes",800,"g"),
  ("dried-oregano",1,"tsp"),("spaghetti",400,"g"),("parmesan",40,"g","grated"),("salt",1,"tsp")],[
  "Heat the oil in a large pan and cook the onion, carrot and celery for 8 minutes until soft.",
  "Add the garlic and beef and cook for 5 minutes, breaking up the meat, until browned.",
  "Stir in the tomato paste, then the chopped tomatoes and oregano.",
  "Simmer for 20 minutes, stirring now and then.",
  "Meanwhile, cook the spaghetti in salted boiling water for 10 minutes, or according to the pack.",
  "Season the sauce with salt and loosen with a splash of pasta water.",
  "Serve the sauce over the spaghetti with grated parmesan."]),

R("beef-broccoli-rice","Beef & broccoli with rice","🥦","Chinese",["fakeaway","highProtein","quickEasy"],["stovetop"],10,12,2,False,[
  ("long-grain-rice",150,"g"),("beef-steak",300,"g","thinly sliced"),("cornstarch",1,"tbsp"),("soy-sauce",3,"tbsp"),
  ("sugar",1,"tbsp"),("vegetable-oil",1,"tbsp"),("broccoli",250,"g","cut into small florets"),("garlic",2,"clove","crushed"),
  ("ginger",10,"g","grated"),("sesame-oil",1,"tsp")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Toss the beef with the cornstarch and 1 tbsp of the soy sauce.",
  "Mix the remaining soy sauce with the sugar and 4 tbsp water.",
  "Heat the oil in a wok over a high heat and sear the beef for 2 minutes. Lift out.",
  "Stir-fry the broccoli with a splash of water for 3 minutes, then add the garlic and ginger for 30 seconds.",
  "Return the beef, pour in the sauce and toss for 1 minute until glossy.",
  "Drizzle with sesame oil and serve with the rice."]),

R("korean-beef-rice-bowls","Korean beef rice bowls","🍚","Korean",["quickEasy","fakeaway","family","highProtein"],["stovetop"],5,15,4,False,[
  ("long-grain-rice",300,"g"),("ground-beef",500,"g"),("garlic",3,"clove","crushed"),("ginger",10,"g","grated"),
  ("gochujang",2,"tbsp"),("soy-sauce",3,"tbsp"),("sugar",1,"tbsp"),("sesame-oil",1,"tbsp"),("cucumber",1,"piece","sliced"),
  ("kimchi",150,"g"),("spring-onion",3,"piece","sliced"),("sesame-seeds",1,"tsp")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Meanwhile, brown the beef in a large frying pan over a high heat for 6 minutes.",
  "Add the garlic and ginger and cook for 1 minute.",
  "Mix the gochujang, soy sauce, sugar and sesame oil, pour over the beef and bubble for 2 minutes.",
  "Divide the rice between bowls and top with the beef.",
  "Add the cucumber and kimchi on the side.",
  "Finish with spring onions and sesame seeds."]),

R("chicken-chorizo-rice","One-pan chicken & chorizo rice","🥘","Spanish/Portuguese",["onePan","family","comfort"],["stovetop"],10,30,4,True,[
  ("olive-oil",1,"tbsp"),("chicken-thighs",400,"g","cut into chunks"),("chorizo",100,"g","sliced"),("onion",1,"piece","diced"),
  ("bell-pepper",1,"piece","diced"),("garlic",2,"clove","crushed"),("paprika",2,"tsp"),("turmeric",0.5,"tsp"),
  ("long-grain-rice",300,"g"),("chopped-tomatoes",400,"g"),("chicken-stock",800,"ml"),("peas-frozen",100,"g"),("lemon",1,"piece")],[
  "Heat the oil in a large deep frying pan and brown the chicken for 5 minutes. Lift out.",
  "Fry the chorizo for 2 minutes until it releases its oil.",
  "Add the onion and pepper and cook for 5 minutes until soft.",
  "Stir in the garlic, paprika, turmeric and rice for 1 minute.",
  "Add the tomatoes and stock, return the chicken and bring to a simmer.",
  "Cover and cook for 15 minutes, without stirring, until the rice is tender.",
  "Scatter over the peas, cover for 3 minutes more, then serve with lemon wedges."]),

R("sausage-white-bean-casserole","Sausage & white bean casserole","🌭","British",["comfort","family","onePan","batchFriendly"],["stovetop"],10,30,4,True,[
  ("vegetable-oil",1,"tbsp"),("sausages",450,"g"),("onion",1,"piece","sliced"),("carrot",1,"piece","diced"),
  ("garlic",2,"clove","crushed"),("paprika",1,"tsp"),("dried-thyme",1,"tsp"),("chopped-tomatoes",400,"g"),
  ("cannellini-beans",480,"g","drained"),("chicken-stock",200,"ml"),("baguette",1,"piece")],[
  "Heat the oil in a large casserole pan and brown the sausages for 6 minutes. Lift out and cut each into 3.",
  "Add the onion and carrot to the pan and cook for 6 minutes.",
  "Stir in the garlic, paprika and thyme for 1 minute.",
  "Add the tomatoes, beans and stock and return the sausages.",
  "Simmer for 15 minutes until thick and the sausages are cooked through.",
  "Warm the baguette in a low oven for 5 minutes.",
  "Serve the casserole in bowls with chunks of bread."]),

R("miso-pork-sesame-greens","Miso-glazed pork with sesame greens","🥢","Japanese",["highProtein","healthyish"],["oven","stovetop"],10,25,2,False,[
  ("long-grain-rice",150,"g"),("pork-tenderloin",400,"g"),("miso-paste",2,"tbsp"),("honey",1,"tbsp"),("soy-sauce",1,"tbsp"),
  ("vegetable-oil",1,"tbsp"),("bok-choy",250,"g","halved"),("garlic",1,"clove","sliced"),("sesame-seeds",1,"tsp")],[
  "Heat the oven to 200°C (400°F).",
  "Mix the miso, honey and soy sauce and brush over the pork.",
  "Roast the pork on a lined tray for 20 minutes, then rest for 5 minutes.",
  "Meanwhile, cook the rice in salted boiling water for 12 minutes, then drain.",
  "Heat the oil in a frying pan and stir-fry the bok choy and garlic for 3 minutes.",
  "Slice the pork and serve with the rice and greens, sprinkled with sesame seeds."]),

R("bangers-mash-onion-gravy","Bangers & mash with onion gravy","🌭","British",["comfort","family"],["stovetop","oven"],10,25,4,False,[
  ("sausages",450,"g"),("potato",1000,"g","peeled and chunked"),("butter",40,"g"),("milk",100,"ml"),
  ("vegetable-oil",1,"tbsp"),("onion",2,"piece","sliced"),("flour",1,"tbsp"),("chicken-stock",400,"ml"),
  ("dijon-mustard",1,"tsp"),("peas-frozen",200,"g"),("salt",1,"tsp")],[
  "Heat the oven to 200°C (400°F) and roast the sausages on a tray for 25 minutes, turning once.",
  "Boil the potatoes in salted water for 15 minutes until tender.",
  "Meanwhile, heat the oil in a pan and cook the onions slowly for 12 minutes until soft and golden.",
  "Stir the flour into the onions, then gradually add the stock and simmer for 5 minutes until thick. Stir in the mustard.",
  "Cook the peas in boiling water for 3 minutes.",
  "Drain the potatoes and mash with the butter and milk. Season.",
  "Serve the sausages on the mash with peas, and pour over the gravy."]),

R("chicken-caesar-salad","Chicken Caesar-style salad","🥗","American",["lowCalorie","highProtein"],["stovetop"],10,12,2,False,[
  ("chicken-breast",300,"g"),("olive-oil",1,"tbsp"),("baguette",100,"g","cut into cubes"),("greek-yogurt",60,"g"),
  ("mayonnaise",1,"tbsp"),("lemon",0.5,"piece"),("dijon-mustard",1,"tsp"),("garlic",1,"clove","grated"),
  ("worcestershire",1,"tsp"),("parmesan",30,"g","grated"),("lettuce",1,"piece","chopped")],[
  "Rub the chicken with half the oil and season.",
  "Cook the chicken in a frying pan over a medium-high heat for 5 to 6 minutes on each side until cooked through. Rest, then slice.",
  "Toss the bread cubes with the remaining oil and toast in the same pan for 4 minutes until crisp.",
  "Whisk the yogurt, mayonnaise, lemon juice, mustard, garlic, Worcestershire sauce and half the parmesan.",
  "Toss the lettuce with the dressing.",
  "Top with the chicken, croutons and the remaining parmesan."]),

R("pesto-chicken-pasta","Pesto chicken pasta","🍝","Italian",["quickEasy","family","highProtein"],["stovetop"],5,15,4,False,[
  ("penne",400,"g"),("olive-oil",1,"tbsp"),("chicken-breast",400,"g","cut into bite-size pieces"),
  ("cherry-tomatoes",250,"g","halved"),("spinach",100,"g"),("pesto",190,"g"),("parmesan",30,"g","grated")],[
  "Cook the penne in salted boiling water for 10 minutes, or according to the pack. Save a mugful of pasta water.",
  "Meanwhile, heat the oil in a large frying pan and cook the chicken for 7 minutes until golden and cooked through.",
  "Add the tomatoes and cook for 2 minutes.",
  "Stir in the spinach until wilted.",
  "Drain the pasta, add it to the pan with the pesto and a splash of pasta water and toss.",
  "Serve topped with parmesan."]),

R("thai-basil-chicken","Thai basil chicken with fried egg","🌶️","Thai",["quickEasy","highProtein","fakeaway"],["stovetop"],5,10,2,False,[
  ("long-grain-rice",150,"g"),("vegetable-oil",1,"tbsp"),("garlic",4,"clove","chopped"),("chili-fresh",2,"piece","chopped"),
  ("chicken-breast",300,"g","finely chopped"),("green-beans",100,"g","cut short"),("soy-sauce",1,"tbsp"),("fish-sauce",1,"tbsp"),
  ("sugar",1,"tsp"),("basil",20,"g"),("eggs",2,"piece")],[
  "Cook the rice in salted boiling water for 12 minutes, then drain.",
  "Heat half the oil in a wok over a high heat and fry the garlic and chili for 30 seconds.",
  "Add the chicken and stir-fry for 4 minutes until cooked through.",
  "Add the green beans, soy sauce, fish sauce and sugar and stir-fry for 2 minutes.",
  "Toss through the basil until just wilted.",
  "In a separate pan, fry the eggs in the remaining oil for 2 to 3 minutes until crispy at the edges.",
  "Serve the chicken over rice with a fried egg on top."]),

R("beef-kofta-pittas","Beef kofta pittas with garlic yogurt","🥙","Middle Eastern",["family","highProtein"],["oven"],15,15,4,False,[
  ("ground-beef",500,"g"),("onion",0.5,"piece","grated"),("garlic",2,"clove","crushed"),("cumin",1,"tsp"),("cinnamon",0.5,"tsp"),
  ("parsley",15,"g","chopped"),("greek-yogurt",150,"g"),("cucumber",0.5,"piece","diced"),("tomato",2,"piece","diced"),
  ("lemon",0.5,"piece"),("pita-bread",4,"piece"),("salt",1,"tsp")],[
  "Heat the oven to 220°C (425°F).",
  "Mix the beef, onion, half the garlic, the cumin, cinnamon, half the parsley and the salt.",
  "Shape into 8 sausage shapes and place on a lined tray.",
  "Bake for 15 minutes until browned and cooked through.",
  "Meanwhile, mix the yogurt with the remaining garlic and a pinch of salt.",
  "Toss the cucumber and tomato with the lemon juice and remaining parsley.",
  "Warm the pitas, then fill with koftas, salad and garlic yogurt."]),
]
