# Breakfasts, lunches and snacks (Nov 2026): 12 + 12 + 8 original recipes.
# Same rules as the dinners: every ingredient comes from ingredients_data.py, macros are computed,
# oven steps give °C and °F. No-cook recipes have no appliances (they pass every kitchen filter).
# Limits per meal type live in MealType (ForkcastCore): kcal per serving and step counts.
from recipes_data import R

B, L, S = "breakfast", "lunch", "snack"

BREAKFASTS = [
R("berry-overnight-oats","Berry overnight oats","🫐","Other",["quickEasy","healthyish","batchFriendly"],[],5,0,2,True,[
  ("rolled-oats",100,"g"),("chia-seeds",1,"tbsp"),("milk",240,"ml"),("greek-yogurt",100,"g"),("honey",1,"tbsp"),("berries-frozen",150,"g")],[
  "Stir the oats, chia seeds, milk and yogurt together in a bowl, or split between two jars.",
  "Stir in the honey and half the berries.",
  "Cover and chill overnight, or for at least 4 hours.",
  "In the morning, loosen with a splash of milk and top with the rest of the berries."], meal=B),

R("peanut-banana-porridge","Peanut butter & banana porridge","🥣","Other",["quickEasy","comfort","family"],["stovetop"],2,8,2,False,[
  ("rolled-oats",100,"g"),("milk",500,"ml"),("cinnamon",0.5,"tsp"),("banana",1,"piece","sliced"),("peanut-butter",2,"tbsp")],[
  "Put the oats, milk and cinnamon in a small pan over a medium heat.",
  "Bring to a gentle simmer and cook for 5 minutes, stirring often, until thick and creamy.",
  "Loosen with a splash of water if it gets too thick.",
  "Spoon into bowls and top with the banana slices.",
  "Finish each bowl with a spoonful of peanut butter."], meal=B),

R("spinach-tomato-scrambled-eggs","Spinach & tomato scrambled eggs on toast","🍳","British",["quickEasy","highProtein"],["stovetop"],3,7,2,False,[
  ("eggs",4,"piece"),("butter",1,"tbsp"),("cherry-tomatoes",100,"g","halved"),("spinach",60,"g"),
  ("wholemeal-bread",2,"slice"),("salt",1,"pinch"),("black-pepper",1,"pinch")],[
  "Beat the eggs with the salt and pepper.",
  "Melt half the butter in a non-stick pan over a medium heat and soften the tomatoes for 2 minutes.",
  "Add the spinach and stir until just wilted, then push everything to one side.",
  "Toast the bread.",
  "Melt the rest of the butter in the pan, pour in the eggs and stir slowly until softly set.",
  "Pile the eggs and vegetables onto the toast and serve straight away."], meal=B),

R("bean-egg-breakfast-burritos","Bean & egg breakfast burritos","🌯","Mexican",["highProtein","family"],["stovetop"],5,8,2,False,[
  ("black-beans",120,"g","drained"),("eggs",3,"piece"),("spring-onion",1,"piece","sliced"),("cheddar",30,"g","grated"),
  ("tortillas",2,"piece"),("salsa",4,"tbsp"),("salt",1,"pinch")],[
  "Warm the black beans in a small pan with a splash of water, lightly crushing them.",
  "Beat the eggs with the salt and half the spring onion.",
  "Scramble the eggs in a non-stick pan over a medium heat until just set.",
  "Warm the tortillas in a dry pan for 20 seconds on each side.",
  "Fill each tortilla with beans, eggs, cheese and salsa, then scatter over the rest of the spring onion.",
  "Fold in the ends, roll up tightly and cut in half."], meal=B),

R("avocado-toast-fried-egg","Smashed avocado toast with a fried egg","🥑","Other",["quickEasy","healthyish"],["stovetop"],5,5,2,False,[
  ("avocado",1,"piece"),("lime",0.5,"piece"),("salt",1,"pinch"),("chili-flakes",1,"pinch"),
  ("wholemeal-bread",2,"slice"),("olive-oil",1,"tsp"),("eggs",2,"piece")],[
  "Mash the avocado with the lime juice and salt.",
  "Toast the bread.",
  "Heat the oil in a frying pan over a medium heat and fry the eggs for 3 minutes until the whites are set.",
  "Spread the avocado over the toast.",
  "Top each slice with an egg and a pinch of chilli flakes."], meal=B),

R("greek-yogurt-berry-bowl","Greek yogurt berry bowl","🍓","Mediterranean",["quickEasy","healthyish","highProtein"],[],5,0,2,False,[
  ("berries-frozen",150,"g","thawed"),("greek-yogurt",300,"g"),("honey",1,"tbsp"),("walnuts",30,"g","roughly chopped"),("chia-seeds",1,"tbsp")],[
  "Leave the berries to thaw in a bowl for 10 minutes, or overnight in the fridge.",
  "Spoon the yogurt into two bowls.",
  "Top with the berries and their juice.",
  "Drizzle with honey and scatter over the walnuts and chia seeds."], meal=B),

R("berry-chia-pudding","Berry chia pudding","🫐","Other",["healthyish","batchFriendly"],[],5,0,2,True,[
  ("chia-seeds",60,"g"),("soy-milk",400,"ml"),("maple-syrup",1,"tbsp"),("berries-frozen",150,"g")],[
  "Whisk the chia seeds, soy milk and maple syrup together in a bowl.",
  "Leave for 10 minutes, then whisk again so the seeds don't clump.",
  "Cover and chill overnight, or for at least 3 hours, until thick.",
  "Spoon into two bowls and top with the berries."], meal=B),

R("berry-banana-smoothie","Berry & banana smoothie","🥤","Other",["quickEasy","healthyish"],["blender"],5,0,2,False,[
  ("banana",2,"piece"),("berries-frozen",200,"g"),("soy-milk",400,"ml"),("chia-seeds",1,"tbsp")],[
  "Peel the bananas and break them into the blender.",
  "Add the frozen berries, soy milk and chia seeds.",
  "Blend for 1 minute until completely smooth.",
  "Pour into two glasses and drink straight away."], meal=B),

R("sweet-potato-breakfast-hash","Sweet potato & pepper breakfast hash","🍠","American",["onePan","healthyish"],["stovetop"],10,15,2,False,[
  ("olive-oil",1,"tbsp"),("sweet-potato",1,"piece","peeled and diced"),("red-onion",0.5,"piece","diced"),
  ("bell-pepper",1,"piece","diced"),("paprika",1,"tsp"),("black-beans",120,"g","drained"),("salt",1,"pinch")],[
  "Heat the oil in a large frying pan over a medium-high heat.",
  "Add the sweet potato and cook for 8 minutes, stirring now and then, until starting to soften.",
  "Add the onion and pepper and cook for 5 minutes more.",
  "Stir in the paprika and black beans and cook for 2 minutes until hot.",
  "Season with salt and serve."], meal=B),

R("cinnamon-french-toast","Cinnamon French toast with berries","🍞","American",["comfort","family"],["stovetop"],5,8,2,False,[
  ("eggs",2,"piece"),("milk",100,"ml"),("cinnamon",0.5,"tsp"),("wholemeal-bread",4,"slice"),
  ("butter",1,"tbsp"),("berries-frozen",100,"g","thawed"),("maple-syrup",1,"tbsp")],[
  "Whisk the eggs, milk and cinnamon in a shallow dish.",
  "Melt half the butter in a frying pan over a medium heat.",
  "Dip two slices of bread in the egg mixture for a few seconds on each side.",
  "Fry for 2 minutes on each side until golden. Repeat with the rest of the butter and bread.",
  "Serve topped with the berries and a drizzle of maple syrup."], meal=B),

R("turmeric-tofu-scramble","Turmeric tofu scramble","🍳","Other",["quickEasy","highProtein","healthyish"],["stovetop"],5,8,2,False,[
  ("olive-oil",1,"tbsp"),("spring-onion",2,"piece","sliced"),("cherry-tomatoes",100,"g","halved"),
  ("tofu",300,"g","drained"),("turmeric",0.5,"tsp"),("spinach",60,"g"),("salt",1,"pinch")],[
  "Heat the oil in a frying pan over a medium heat and cook the spring onions and tomatoes for 2 minutes.",
  "Crumble the tofu into the pan with your fingers.",
  "Stir in the turmeric and salt and cook for 4 minutes until hot and golden.",
  "Add the spinach and stir until just wilted.",
  "Serve straight away."], meal=B),

R("ham-cheese-omelette","Ham & cheese omelette","🍳","British",["quickEasy","highProtein"],["stovetop"],3,5,2,False,[
  ("eggs",4,"piece"),("spring-onion",1,"piece","sliced"),("butter",1,"tsp"),("ham",2,"slice","chopped"),("cheddar",30,"g","grated")],[
  "Beat the eggs with half the spring onion.",
  "Melt the butter in a non-stick frying pan over a medium heat.",
  "Pour in the eggs and cook for 2 minutes, drawing the edges into the middle.",
  "Scatter the ham and cheese over one half and cook for 1 minute more.",
  "Fold the omelette over, cut in half and serve with the rest of the spring onion."], meal=B),
]

LUNCHES = [
R("chicken-hummus-wraps","Chicken, hummus & spinach wraps","🌯","Middle Eastern",["quickEasy","highProtein"],["stovetop"],5,12,2,False,[
  ("chicken-breast",1,"piece"),("paprika",1,"tsp"),("olive-oil",1,"tsp"),("tortillas",2,"piece"),
  ("hummus",4,"tbsp"),("spinach",40,"g"),("cucumber",0.5,"piece","sliced")],[
  "Slice the chicken into thin strips and toss with the paprika and oil.",
  "Fry in a pan over a medium-high heat for 6–8 minutes until cooked through.",
  "Warm the tortillas in a dry pan for 20 seconds on each side.",
  "Spread each tortilla with hummus.",
  "Add the spinach, cucumber and chicken, then roll up tightly and cut in half."], meal=L),

R("tuna-sweetcorn-sandwiches","Tuna & sweetcorn sandwiches","🥪","British",["quickEasy","family"],[],8,0,2,False,[
  ("canned-tuna",145,"g","drained"),("sweetcorn-tin",80,"g","drained"),("mayonnaise",2,"tbsp"),
  ("black-pepper",1,"pinch"),("wholemeal-bread",4,"slice"),("cucumber",0.25,"piece","sliced")],[
  "Flake the tuna into a bowl.",
  "Stir in the sweetcorn, mayonnaise and pepper.",
  "Spread over two slices of bread and top with the cucumber.",
  "Close the sandwiches and cut in half."], meal=L),

R("greek-chickpea-salad","Greek salad with feta & chickpeas","🥗","Mediterranean",["quickEasy","healthyish"],[],10,0,2,False,[
  ("cucumber",0.5,"piece","diced"),("cherry-tomatoes",150,"g","halved"),("red-onion",0.5,"piece","thinly sliced"),
  ("chickpeas",240,"g","drained"),("olives",40,"g"),("olive-oil",1,"tbsp"),("red-wine-vinegar",1,"tsp"),
  ("dried-oregano",0.5,"tsp"),("feta",100,"g")],[
  "Put the cucumber, tomatoes, onion, chickpeas and olives in a large bowl.",
  "Whisk the oil, vinegar and oregano together.",
  "Pour the dressing over the salad and toss well.",
  "Crumble the feta over the top and serve."], meal=L),

R("black-bean-quinoa-bowl","Quinoa, black bean & avocado bowl","🥗","Mexican",["healthyish","batchFriendly"],["stovetop"],10,15,2,True,[
  ("quinoa",120,"g","rinsed"),("black-beans",240,"g","drained"),("cherry-tomatoes",100,"g","quartered"),
  ("lime",1,"piece"),("salt",1,"pinch"),("avocado",1,"piece","sliced"),("cilantro",10,"g","chopped")],[
  "Cook the quinoa in a pan of boiling water for 15 minutes, then drain well.",
  "Meanwhile, warm the black beans in a small pan with a splash of water.",
  "Toss the quinoa with the tomatoes, the juice of the lime and the salt.",
  "Divide between two bowls and top with the beans and avocado.",
  "Scatter over the cilantro and serve warm or cold."], meal=L),

R("red-lentil-carrot-soup","Red lentil & carrot soup","🥣","Middle Eastern",["healthyish","batchFriendly","comfort"],["stovetop","blender"],10,25,4,True,[
  ("olive-oil",2,"tbsp"),("onion",1,"piece","chopped"),("carrot",3,"piece","chopped"),("cumin",1,"tsp"),
  ("red-lentils",250,"g","rinsed"),("vegetable-stock",1000,"ml"),("salt",1,"pinch")],[
  "Heat the oil in a large pan over a medium heat and soften the onion and carrots for 6 minutes.",
  "Stir in the cumin and cook for 1 minute.",
  "Add the lentils and stock and bring to the boil.",
  "Simmer for 20 minutes until the lentils have collapsed.",
  "Blend until smooth, loosening with a little water if needed.",
  "Season with salt and serve."], meal=L),

R("lemon-couscous-halloumi","Lemon couscous with halloumi","🧀","Mediterranean",["quickEasy","healthyish"],["stovetop"],10,8,2,False,[
  ("couscous",150,"g"),("vegetable-stock",200,"ml","hot"),("lemon",1,"piece"),("olive-oil",1,"tbsp"),
  ("cherry-tomatoes",100,"g","halved"),("cucumber",0.5,"piece","diced"),("mint",10,"g","chopped"),("halloumi",200,"g","sliced")],[
  "Pour the hot stock over the couscous, cover and leave for 5 minutes.",
  "Fluff with a fork and stir in the juice of the lemon and the oil.",
  "Fold in the tomatoes, cucumber and mint.",
  "Fry the halloumi in a dry non-stick pan over a medium-high heat for 2 minutes on each side until golden.",
  "Serve the couscous topped with the halloumi."], meal=L),

R("chicken-noodle-soup","Ginger chicken noodle soup","🍜","Chinese",["comfort","healthyish"],["stovetop"],10,15,2,False,[
  ("chicken-stock",1000,"ml"),("ginger",10,"g","sliced"),("carrot",1,"piece","thinly sliced"),
  ("chicken-breast",1,"piece"),("egg-noodles",100,"g"),("soy-sauce",1,"tbsp"),("spring-onion",2,"piece","sliced")],[
  "Bring the stock, ginger and carrot to a simmer in a large pan.",
  "Add the whole chicken breast and poach gently for 12 minutes until cooked through.",
  "Lift out the chicken and shred it with two forks.",
  "Add the noodles to the pan and cook for 4 minutes.",
  "Return the chicken, stir in the soy sauce and ladle into bowls.",
  "Scatter over the spring onions."], meal=L),

R("caprese-pesto-toastie","Tomato, mozzarella & pesto toastie","🥪","Italian",["quickEasy","comfort"],["stovetop"],5,6,2,False,[
  ("wholemeal-bread",4,"slice"),("butter",1,"tbsp","softened"),("pesto",2,"tbsp"),("mozzarella",1,"piece","sliced"),("tomato",1,"piece","sliced")],[
  "Butter one side of each slice of bread.",
  "Spread pesto on the other side of two slices, then layer on the mozzarella and tomato.",
  "Top with the remaining slices, buttered side out.",
  "Cook in a frying pan over a medium heat for 3 minutes on each side until golden and melting."], meal=L),

R("smashed-chickpea-sandwiches","Smashed chickpea salad sandwiches","🥪","Other",["quickEasy","healthyish"],[],10,0,2,False,[
  ("chickpeas",240,"g","drained"),("hummus",2,"tbsp"),("lemon",0.5,"piece"),("dijon-mustard",1,"tsp"),
  ("celery",1,"piece","finely chopped"),("red-onion",0.25,"piece","finely chopped"),("wholemeal-bread",4,"slice")],[
  "Roughly mash the chickpeas with a fork, leaving some whole.",
  "Stir in the hummus, lemon juice and mustard.",
  "Fold in the celery and onion.",
  "Spread over two slices of bread, top with the rest and cut in half."], meal=L),

R("cheesy-bean-jacket-potatoes","Microwave jacket potatoes with cheesy beans","🥔","British",["comfort","family"],["microwave"],5,12,2,False,[
  ("potato",2,"piece"),("cannellini-beans",240,"g","drained"),("passata",100,"g"),("paprika",0.5,"tsp"),
  ("butter",1,"tsp"),("cheddar",60,"g","grated")],[
  "Prick the potatoes all over with a fork.",
  "Microwave on high for 8–10 minutes, turning halfway, until soft all the way through.",
  "Meanwhile, mix the beans, passata and paprika in a bowl and microwave for 2 minutes until hot.",
  "Split the potatoes and add a little butter to each.",
  "Spoon over the beans and top with the cheese."], meal=L),

R("tuna-white-bean-salad","Tuna & white bean salad","🐟","Italian",["quickEasy","healthyish","highProtein"],[],10,0,2,False,[
  ("cannellini-beans",240,"g","drained"),("red-onion",0.5,"piece","thinly sliced"),("cherry-tomatoes",150,"g","halved"),
  ("lemon",1,"piece"),("olive-oil",1,"tbsp"),("arugula",40,"g"),("canned-tuna",145,"g","drained"),("parsley",10,"g","chopped")],[
  "Put the beans, onion and tomatoes in a bowl.",
  "Dress with the juice of the lemon and the oil.",
  "Fold through the arugula.",
  "Flake the tuna over the top and scatter with parsley."], meal=L),

R("sweet-potato-bean-quesadillas","Sweet potato & black bean quesadillas","🌮","Mexican",["family","fakeaway"],["stovetop"],10,12,2,False,[
  ("sweet-potato",1,"piece","peeled and grated"),("cumin",1,"tsp"),("black-beans",240,"g","drained"),
  ("tortillas",4,"piece"),("cheddar",60,"g","grated"),("salsa",4,"tbsp")],[
  "Cook the grated sweet potato in a dry non-stick pan over a medium heat for 5 minutes until soft.",
  "Stir in the cumin and beans, lightly crushing the beans, then tip into a bowl.",
  "Spread the filling over two tortillas, scatter with cheese and top with the other tortillas.",
  "Cook one at a time in the pan for 2–3 minutes on each side until crisp and melting.",
  "Cut into wedges and serve with the salsa."], meal=L),
]

SNACKS = [
R("hummus-veg-sticks","Hummus with veg sticks","🥕","Middle Eastern",["quickEasy","healthyish"],[],10,0,4,False,[
  ("carrot",2,"piece"),("cucumber",0.5,"piece"),("bell-pepper",1,"piece"),("hummus",200,"g")],[
  "Cut the carrots, cucumber and pepper into sticks.",
  "Spoon the hummus into a bowl and serve with the veg for dipping."], meal=S),

R("apple-peanut-butter","Apple slices with peanut butter","🍎","American",["quickEasy","family"],[],5,0,4,False,[
  ("apple",2,"piece"),("peanut-butter",4,"tbsp"),("cinnamon",1,"pinch")],[
  "Core the apples and cut each into 8 slices.",
  "Spoon the peanut butter into a small bowl and dust with cinnamon.",
  "Serve the apple slices with the peanut butter for dipping."], meal=S),

R("paprika-popcorn","Stovetop paprika popcorn","🍿","American",["quickEasy","family","lowCalorie"],["stovetop"],1,5,4,False,[
  ("vegetable-oil",1,"tbsp"),("popcorn-kernels",80,"g"),("paprika",0.5,"tsp"),("salt",1,"pinch")],[
  "Heat the oil in a large pan with a lid over a medium-high heat with 3 kernels in it.",
  "When they pop, add the rest of the kernels, cover and shake the pan.",
  "Cook for 2–3 minutes, shaking often, until the popping slows to a few seconds apart.",
  "Tip into a bowl and toss with the paprika and salt."], meal=S),

R("oat-raisin-energy-balls","Oat & raisin energy balls","🟤","Other",["batchFriendly","family"],[],15,0,4,True,[
  ("rolled-oats",100,"g"),("peanut-butter",4,"tbsp"),("honey",2,"tbsp"),("raisins",40,"g"),("chia-seeds",1,"tbsp")],[
  "Mix everything together in a bowl until it clumps.",
  "Roll into 12 small balls with damp hands.",
  "Chill for 20 minutes to firm up.",
  "Keep in a sealed box in the fridge for up to 5 days."], meal=S),

R("yogurt-berry-pots","Yogurt & berry pots","🍓","Other",["quickEasy","healthyish"],[],5,0,4,False,[
  ("berries-frozen",200,"g"),("greek-yogurt",400,"g"),("honey",1,"tbsp")],[
  "Thaw the berries in a bowl for 10 minutes and lightly crush half of them.",
  "Layer the yogurt and berries in four small glasses or pots.",
  "Drizzle with honey before serving."], meal=S),

R("avocado-rice-cakes","Rice cakes with avocado & chilli","🍘","Other",["quickEasy","healthyish"],[],5,0,4,False,[
  ("avocado",2,"piece"),("lime",1,"piece"),("salt",1,"pinch"),("rice-cakes",8,"piece"),("chili-flakes",1,"pinch")],[
  "Mash the avocado with the lime juice and salt.",
  "Spread over the rice cakes.",
  "Finish with a pinch of chilli flakes."], meal=S),

R("crispy-spiced-chickpeas","Crispy spiced chickpeas","🫘","Middle Eastern",["batchFriendly","healthyish"],["oven"],5,30,4,True,[
  ("chickpeas",480,"g","drained"),("olive-oil",1,"tbsp"),("paprika",1,"tsp"),("cumin",0.5,"tsp"),("salt",1,"pinch")],[
  "Heat the oven to 200°C (400°F).",
  "Pat the chickpeas very dry with a clean tea towel.",
  "Toss with the oil, paprika, cumin and salt on a baking tray.",
  "Roast for 25–30 minutes, shaking the tray halfway, until crisp.",
  "Leave to cool on the tray: they crisp up more as they cool."], meal=S),

R("devilled-eggs","Devilled eggs","🥚","American",["highProtein","family"],["stovetop"],10,10,4,False,[
  ("eggs",4,"piece"),("mayonnaise",2,"tbsp"),("dijon-mustard",1,"tsp"),("paprika",1,"pinch")],[
  "Lower the eggs into a pan of boiling water and cook for 10 minutes.",
  "Cool in cold water, then peel and halve lengthways.",
  "Mash the yolks with the mayonnaise and mustard until smooth.",
  "Spoon back into the whites and dust with paprika."], meal=S),
]
