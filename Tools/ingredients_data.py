# Ingredient table used to bootstrap ingredients.json / prices.json.
# Columns: id, name(US), plural, ukName, aisle, allergens, flags, macros(kcal,p,c,f,fib),
#          base unit, gramsPerUnit, pack(amount, metric display, imperial display, noun, nounPlural),
#          staple, emoji, proteinGroup, tags, prices(US USD, UK GBP, EU EUR) for the standard tier.
# Macros: approximate per 100 g, based on USDA FoodData Central values.
# Prices: rough 2026 estimates per pack — to be refined.

M = "isMeat"; F = "isFish"; A = "isAnimalProduct"

def I(id, name, plural, uk, aisle, allergens, flags, mac, base, gpu, pack, staple, emoji, protein=None, tags=None, prices=(1,1,1), gpm=None):
    d = {
        "id": id, "name": name, "pluralName": plural, "aisle": aisle,
        "allergens": allergens,
        "dietFlags": {"isMeat": M in flags, "isFish": F in flags, "isAnimalProduct": A in flags or M in flags or F in flags},
        "per100g": dict(zip(["kcal","protein","carbs","fat","fiber"], mac)),
        "baseUnit": base,
        "pack": {"amount": pack[0], "display": pack[1], "displayImperial": pack[2], "noun": pack[3], "nounPlural": pack[4]},
        "isPantryStaple": staple, "emoji": emoji, "tags": tags or [],
    }
    if uk: d["ukName"] = uk
    if gpu: d["gramsPerUnit"] = gpu
    if gpm: d["gramsPerMl"] = gpm
    if protein: d["proteinGroup"] = protein
    return d, {"US": prices[0], "UK": prices[1], "EU": prices[2]}

P, MF, DE, BK, PA, RG, TJ, SC, SH, OV, FR, BA, OT = ("Produce","Meat & Fish","Dairy & Eggs","Bakery","Pasta","Rice & Grains","Tins & Jars","Sauces & Condiments","Spices & Herbs","Oils & Vinegars","Frozen","Baking","Other")

def spice(id, name, uk, mac, tsp, emoji, prices=(3.49,1.00,1.49), tags=None, allergens=None, size=(40,"40 g jar","1.4 oz jar")):
    return I(id, name, name, uk, SH, allergens or [], "", mac, "g", {"tsp": tsp, "tbsp": tsp*3, "pinch": 0.4}, (size[0], size[1], size[2], "jar", "jars"), True, emoji, tags=tags, prices=prices)

ROWS = [
  # ---------- Produce ----------
  I("onion","onion","onions",None,P,[],"",(40,1.1,9.3,0.1,1.7),"g",{"piece":150},(1000,"1 kg bag","2 lb bag","bag","bags"),False,"🧅",prices=(2.49,0.95,1.29)),
  I("red-onion","red onion","red onions",None,P,[],"",(40,1.1,9.3,0.1,1.7),"g",{"piece":150},(500,"500 g bag","1 lb bag","bag","bags"),False,"🧅",prices=(1.99,0.85,1.19)),
  I("garlic","garlic","garlic",None,P,[],"",(149,6.4,33,0.5,2.1),"g",{"clove":5,"piece":50,"tsp":3},(50,"1 bulb","1 bulb","bulb","bulbs"),False,"🧄",prices=(0.69,0.35,0.45)),
  I("ginger","fresh ginger","fresh ginger",None,P,[],"",(80,1.8,18,0.8,2),"g",{"piece":15,"tsp":2,"tbsp":6},(100,"100 g piece","3.5 oz piece","piece","pieces"),False,"🫚",prices=(0.99,0.50,0.70)),
  I("carrot","carrot","carrots",None,P,[],"",(41,0.9,10,0.2,2.8),"g",{"piece":70},(1000,"1 kg bag","2 lb bag","bag","bags"),False,"🥕",prices=(1.49,0.70,0.99)),
  I("celery","celery","celery",None,P,[],"",(16,0.7,3,0.2,1.6),"g",{"piece":40},(450,"1 head","1 bunch","head","heads"),False,"🥬",prices=(1.99,0.75,1.29)),
  I("potato","potato","potatoes",None,P,[],"",(77,2,17,0.1,2.2),"g",{"piece":200},(2000,"2 kg bag","5 lb bag","bag","bags"),False,"🥔",prices=(4.49,1.60,2.49)),
  I("sweet-potato","sweet potato","sweet potatoes",None,P,[],"",(86,1.6,20,0.1,3),"g",{"piece":250},(1000,"1 kg bag","2 lb bag","bag","bags"),False,"🍠",prices=(2.99,1.20,1.99)),
  I("poblano-pepper","poblano pepper","poblano peppers","poblano chilli",P,[],"",(24,0.9,5.5,0.2,2),"g",{"piece":105},(210,"2 peppers","2 peppers","pack","packs"),False,"🫑",prices=(2.49,1.95,2.10)),
  I("bell-pepper","bell pepper","bell peppers","pepper",P,[],"",(31,1,6,0.3,2.1),"g",{"piece":150},(450,"3-pack","3-pack","pack","packs"),False,"🫑",prices=(3.49,1.60,1.99)),
  I("tomato","tomato","tomatoes",None,P,[],"",(18,0.9,3.9,0.2,1.2),"g",{"piece":120},(500,"500 g pack","1 lb pack","pack","packs"),False,"🍅",prices=(2.49,1.00,1.79)),
  I("cherry-tomatoes","cherry tomatoes","cherry tomatoes",None,P,[],"",(18,0.9,3.9,0.2,1.2),"g",{"piece":15,"cup":150},(250,"250 g punnet","10 oz pint","pack","packs"),False,"🍅",prices=(2.99,1.10,1.69)),
  I("cucumber","cucumber","cucumbers",None,P,[],"",(15,0.7,3.6,0.1,0.5),"g",{"piece":300},(300,"1 cucumber","1 cucumber","cucumber","cucumbers"),False,"🥒",prices=(0.89,0.75,0.79)),
  I("zucchini","zucchini","zucchini","courgette",P,[],"",(17,1.2,3.1,0.3,1),"g",{"piece":200},(500,"500 g pack","1 lb pack","pack","packs"),False,"🥒",prices=(1.99,1.10,1.49)),
  I("eggplant","eggplant","eggplants","aubergine",P,[],"",(25,1,6,0.2,3),"g",{"piece":300},(300,"1 aubergine","1 eggplant","piece","pieces"),False,"🍆",prices=(1.79,0.90,1.29)),
  I("broccoli","broccoli","broccoli",None,P,[],"",(34,2.8,7,0.4,2.6),"g",{"piece":350,"cup":90},(350,"1 head","1 head","head","heads"),False,"🥦",prices=(2.49,0.75,1.29)),
  I("cauliflower","cauliflower","cauliflowers",None,P,[],"",(25,1.9,5,0.3,2),"g",{"piece":600},(600,"1 head","1 head","head","heads"),False,"🥦",prices=(3.49,1.00,1.79)),
  I("spinach","spinach","spinach",None,P,[],"",(23,2.9,3.6,0.4,2.2),"g",{"cup":30},(200,"200 g bag","7 oz bag","bag","bags"),False,"🥬",prices=(2.99,1.30,1.69)),
  I("kale","kale","kale",None,P,[],"",(49,4.3,8.8,0.9,3.6),"g",{"cup":20},(200,"200 g bag","7 oz bag","bag","bags"),False,"🥬",prices=(2.99,1.00,1.79)),
  I("lettuce","romaine lettuce","romaine lettuces","romaine lettuce",P,[],"",(17,1.2,3.3,0.3,2.1),"g",{"piece":400},(400,"1 head","1 head","head","heads"),False,"🥬",prices=(2.29,0.90,1.19)),
  I("mushrooms","mushrooms","mushrooms",None,P,[],"",(22,3.1,3.3,0.3,1),"g",{"piece":18,"cup":70},(250,"250 g pack","8 oz pack","pack","packs"),False,"🍄",prices=(2.49,1.10,1.49)),
  I("green-beans","green beans","green beans",None,P,[],"",(31,1.8,7,0.2,2.7),"g",{"cup":100},(300,"300 g pack","10 oz bag","pack","packs"),False,"🫛",prices=(2.99,1.20,1.79)),
  I("avocado","avocado","avocados",None,P,[],"",(160,2,8.5,14.7,6.7),"g",{"piece":150},(150,"1 avocado","1 avocado","avocado","avocados"),False,"🥑",prices=(1.49,0.90,1.19)),
  I("lime","lime","limes",None,P,[],"",(30,0.7,10,0.2,2.8),"g",{"piece":65,"tbsp":15},(65,"1 lime","1 lime","lime","limes"),False,"🍋‍🟩",prices=(0.39,0.30,0.35)),
  I("orange","orange","oranges",None,P,[],"",(47,0.9,11.8,0.1,2.4),"g",{"piece":130},(520,"4-pack","4-pack","pack","packs"),False,"🍊",prices=(3.49,1.30,1.69)),
  I("lemon","lemon","lemons",None,P,[],"",(29,1.1,9,0.3,2.8),"g",{"piece":100,"tbsp":15},(100,"1 lemon","1 lemon","lemon","lemons"),False,"🍋",prices=(0.69,0.35,0.45)),
  I("cilantro","cilantro","cilantro","coriander",P,[],"",(23,2.1,3.7,0.5,2.8),"g",{"bunch":25,"tbsp":1,"cup":16},(25,"1 bunch","1 bunch","bunch","bunches"),False,"🌿",prices=(0.99,0.70,0.89)),
  I("parsley","parsley","parsley",None,P,[],"",(36,3,6,0.8,3.3),"g",{"bunch":25,"tbsp":1,"cup":30},(25,"1 bunch","1 bunch","bunch","bunches"),False,"🌿",prices=(0.99,0.70,0.89)),
  I("basil","basil","basil",None,P,[],"",(23,3.2,2.7,0.6,1.6),"g",{"bunch":25,"tbsp":1,"cup":20},(25,"1 bunch","1 bunch","bunch","bunches"),False,"🌿",prices=(2.49,0.85,1.29)),
  I("spring-onion","scallion","scallions","spring onion",P,[],"",(32,1.8,7.3,0.2,2.6),"g",{"piece":15},(100,"1 bunch","1 bunch","bunch","bunches"),False,"🧅",prices=(0.99,0.55,0.79)),
  I("chili-fresh","fresh chili","fresh chilies","fresh chilli",P,[],"",(40,1.9,9,0.4,1.5),"g",{"piece":10},(50,"50 g pack","2 oz pack","pack","packs"),False,"🌶️",tags=["spicy"],prices=(0.99,0.60,0.79)),
  I("cabbage","cabbage","cabbages",None,P,[],"",(25,1.3,5.8,0.1,2.5),"g",{"piece":900,"cup":70},(900,"1 head","1 head","head","heads"),False,"🥬",prices=(1.99,0.70,1.19)),
  I("pumpkin","cooking pumpkin","cooking pumpkins",None,P,[],"",(26,1,6.5,0.1,0.5),"g",None,(750,"750 g pack","1.65 lb pack","pack","packs"),False,"🎃",prices=(4.49,2.50,2.99)),
  I("butternut-squash","butternut squash","butternut squashes",None,P,[],"",(45,1,12,0.1,2),"g",{"piece":1000},(1000,"1 squash","1 squash","squash","squashes"),False,"🎃",prices=(3.49,1.20,1.99)),
  I("bean-sprouts","bean sprouts","bean sprouts",None,P,[],"",(30,3,6,0.2,1.8),"g",{"cup":100},(300,"300 g bag","10 oz bag","bag","bags"),False,"🌱",prices=(2.29,0.80,1.29)),
  I("bok-choy","bok choy","bok choy","pak choi",P,[],"",(13,1.5,2.2,0.2,1),"g",{"piece":125},(250,"250 g pack","9 oz pack","pack","packs"),False,"🥬",prices=(2.49,1.10,1.49)),
  I("arugula","arugula","arugula","rocket",P,[],"",(25,2.6,3.7,0.7,1.6),"g",{"cup":20},(100,"100 g bag","4 oz bag","bag","bags"),False,"🥗",prices=(2.99,1.00,1.29)),
  I("leek","leek","leeks",None,P,[],"",(61,1.5,14,0.3,1.8),"g",{"piece":150},(500,"500 g pack","1 lb pack","pack","packs"),False,"🥬",prices=(2.49,1.00,1.49)),
  I("apple","apple","apples",None,P,[],"",(52,0.3,14,0.2,2.4),"g",{"piece":180},(1000,"1 kg bag","2 lb bag","bag","bags"),False,"🍎",prices=(3.49,1.60,1.99)),
  I("red-cabbage","red cabbage","red cabbages",None,P,[],"",(31,1.4,7.4,0.2,2.1),"g",{"piece":900,"cup":70},(900,"1 head","1 head","head","heads"),False,"🥬",prices=(2.29,0.85,1.29)),
  I("mint","mint","mint",None,P,[],"",(70,3.8,15,0.9,8),"g",{"bunch":25,"tbsp":1},(25,"1 bunch","1 bunch","bunch","bunches"),False,"🌿",prices=(1.99,0.70,0.99)),
  I("asparagus","asparagus","asparagus",None,P,[],"",(20,2.2,3.9,0.1,2.1),"g",{"piece":16},(250,"250 g bunch","9 oz bunch","bunch","bunches"),False,"🌱",prices=(3.99,2.00,2.99)),
  I("corn-on-cob","corn on the cob","corn cobs","corn on the cob",P,[],"",(86,3.3,19,1.4,2),"g",{"piece":150},(300,"2 cobs","2 ears","pack","packs"),False,"🌽",prices=(1.49,1.25,1.49)),

  # ---------- Meat & Fish ----------
  # A 1.4 kg bone-in bird has roughly 975 g of edible raw meat and skin.
  I("whole-chicken","whole chicken","whole chickens",None,MF,[],M,(215,18.6,0,15.1,0),"g",{"piece":975},(975,"1 small whole chicken","1 small whole chicken","chicken","chickens"),False,"🍗","chicken",prices=(8.99,4.79,6.49)),
  I("turkey-breast","boneless turkey breast","boneless turkey breasts",None,MF,[],M,(114,23.7,0,1.5,0),"g",None,(800,"800 g turkey breast joint","1.75 lb turkey breast","joint","joints"),False,"🍗","turkey",prices=(12.99,8.50,10.99)),
  I("chicken-breast","chicken breast","chicken breasts",None,MF,[],M,(120,22.5,0,2.6,0),"g",{"piece":180},(500,"500 g pack","1 lb pack","pack","packs"),False,"🍗","chicken",prices=(4.99,3.90,5.49)),
  I("chicken-thighs","boneless chicken thighs","boneless chicken thighs",None,MF,[],M,(177,18,0,11,0),"g",{"piece":100},(500,"500 g pack","1 lb pack","pack","packs"),False,"🍗","chicken",prices=(4.49,3.60,4.99)),
  I("ground-beef","ground beef","ground beef","beef mince",MF,[],M,(215,18.6,0,15,0),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🥩","beef",prices=(5.99,2.90,4.49)),
  I("beef-steak","sirloin steak","sirloin steaks",None,MF,[],M,(180,20,0,11,0),"g",{"piece":200},(400,"400 g pack","14 oz pack","pack","packs"),False,"🥩","beef",prices=(8.99,5.00,7.99)),
  I("stewing-beef","beef chuck","beef chuck","stewing beef",MF,[],M,(176,19,0,11,0),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🥩","beef",prices=(6.99,4.50,5.99)),
  I("ground-pork","ground pork","ground pork","pork mince",MF,[],M,(263,17,0,21,0),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🥩","pork",prices=(4.99,2.50,3.99)),
  I("pork-tenderloin","pork tenderloin","pork tenderloins","pork fillet",MF,[],M,(120,21,0,3.5,0),"g",{"piece":400},(500,"500 g pack","1 lb pack","pack","packs"),False,"🥩","pork",prices=(6.99,4.00,5.99)),
  I("bacon","bacon","bacon","smoked bacon lardons",MF,[],M,(330,15,1,29,0),"g",{"slice":25},(200,"200 g pack","8 oz pack","pack","packs"),False,"🥓","pork",prices=(4.99,2.00,2.29)),
  I("sausages","pork sausages","pork sausages",None,MF,["gluten"],M,(300,13,3,26,0.5),"g",{"piece":75},(450,"6 sausages","6 sausages","pack","packs"),False,"🌭","pork",prices=(4.99,2.50,3.49)),
  I("chorizo","chorizo","chorizo",None,MF,[],M,(455,24,2,38,0),"g",None,(200,"200 g ring","7 oz link","pack","packs"),False,"🌭","pork",prices=(4.49,2.20,2.49)),
  I("ground-turkey","ground turkey","ground turkey","turkey mince",MF,[],M,(150,19.7,0,8.3,0),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🦃","turkey",prices=(5.49,3.50,4.99)),
  I("salmon-fillet","salmon fillet","salmon fillets",None,MF,["fish"],F,(208,20,0,13,0),"g",{"piece":120},(240,"2 fillets","2 fillets","pack","packs"),False,"🐟","fish",prices=(8.99,4.00,5.99)),
  I("white-fish","cod fillet","cod fillets",None,MF,["fish"],F,(82,18,0,0.7,0),"g",{"piece":140},(280,"2 fillets","2 fillets","pack","packs"),False,"🐟","fish",prices=(7.99,4.50,5.99)),
  I("white-crabmeat","cooked white crabmeat","cooked white crabmeat",None,MF,["shellfish"],F,(97,19.4,0,1.5,0),"g",None,(150,"150 g tub","5 oz tub","tub","tubs"),False,"🦀","shellfish",prices=(8.99,4.50,6.25)),
  I("shrimp","raw shrimp","raw shrimp","raw king prawns",MF,["shellfish"],F,(85,20,0,0.5,0),"g",None,(300,"300 g pack","10 oz bag","pack","packs"),False,"🍤","shellfish",prices=(8.99,3.50,5.99)),
  I("salami","cured salami","cured salami",None,MF,[],M,(407,22.6,1.6,33,0),"g",None,(125,"125 g pack","4.4 oz pack","pack","packs"),False,"🍖","pork",prices=(4.49,2.75,2.99)),
  I("ham","sliced ham","sliced ham",None,MF,[],M,(145,21,1.5,6,0),"g",{"slice":25},(150,"150 g pack","5 oz pack","pack","packs"),False,"🍖","pork",prices=(3.99,1.50,1.99)),
  I("lamb-mince","ground lamb","ground lamb","lamb mince",MF,[],M,(282,17,0,23,0),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🥩","lamb",prices=(7.99,4.50,6.49)),

  # ---------- Dairy & Eggs (incl. chilled tofu) ----------
  I("eggs","egg","eggs",None,DE,["egg"],A,(143,12.6,0.7,9.5,0),"piece",{"piece":50},(12,"12 eggs","1 dozen","box","boxes"),False,"🥚","egg",prices=(3.99,2.80,3.29)),
  I("butter","butter","butter",None,DE,["dairy"],A,(717,0.9,0.1,81,0),"g",{"tbsp":14,"tsp":5,"cup":227},(250,"250 g block","8 oz pack","pack","packs"),False,"🧈",prices=(4.49,2.20,2.79)),
  I("milk","milk","milk",None,DE,["dairy"],A,(61,3.2,4.8,3.3,0),"ml",{"cup":244,"tbsp":15},(1000,"1 litre","1 quart","carton","cartons"),False,"🥛",prices=(1.79,0.95,1.09),gpm=1.03),
  I("heavy-cream","heavy cream","heavy cream","double cream",DE,["dairy"],A,(340,2.8,2.7,36,0),"ml",{"cup":238,"tbsp":15},(300,"300 ml pot","10 fl oz carton","carton","cartons"),False,"🥛",prices=(2.99,1.40,1.29),gpm=1.0),
  I("greek-yogurt","plain Greek yogurt","plain Greek yogurt",None,DE,["dairy"],A,(97,9,3.9,5,0),"g",{"tbsp":15,"cup":245},(500,"500 g tub","16 oz tub","tub","tubs"),False,"🥣",prices=(4.49,1.80,2.29)),
  I("cheddar","cheddar","cheddar",None,DE,["dairy"],A,(403,25,1.3,33,0),"g",{"cup":113,"tbsp":7},(200,"200 g block","8 oz block","block","blocks"),False,"🧀","cheese",prices=(3.99,2.20,2.49)),
  I("parmesan","parmesan","parmesan",None,DE,["dairy"],A,(431,38,4,29,0),"g",{"tbsp":5,"cup":100},(100,"100 g wedge","3.5 oz wedge","wedge","wedges"),False,"🧀","cheese",prices=(3.99,2.25,2.49)),
  I("mozzarella","mozzarella","mozzarella",None,DE,["dairy"],A,(280,28,3,17,0),"g",{"piece":125,"cup":112},(125,"125 g ball","4.5 oz ball","ball","balls"),False,"🧀","cheese",prices=(2.49,0.85,0.99)),
  I("feta","feta","feta",None,DE,["dairy"],A,(264,14,4,21,0),"g",{"cup":150},(200,"200 g block","7 oz block","block","blocks"),False,"🧀","cheese",prices=(3.99,1.70,1.99)),
  I("sour-cream","sour cream","sour cream","soured cream",DE,["dairy"],A,(198,2.4,4.6,19,0),"g",{"tbsp":15,"cup":230},(250,"250 g tub","8 oz tub","tub","tubs"),False,"🥣",prices=(2.49,1.00,1.29)),
  I("cream-cheese","cream cheese","cream cheese","soft cheese",DE,["dairy"],A,(342,6,4,34,0),"g",{"tbsp":15},(200,"200 g tub","8 oz tub","tub","tubs"),False,"🧀",prices=(2.99,1.25,1.49)),
  I("halloumi","halloumi","halloumi",None,DE,["dairy"],A,(321,22,2,25,0),"g",None,(225,"225 g block","8 oz block","block","blocks"),False,"🧀","cheese",prices=(4.99,2.50,2.99)),
  I("paneer","paneer","paneer",None,DE,["dairy"],A,(321,21,3.6,25,0),"g",None,(225,"225 g block","8 oz block","block","blocks"),False,"🧀","cheese",prices=(4.49,2.75,2.99)),
  I("blue-cheese","blue cheese","blue cheese",None,DE,["dairy"],A,(353,21,2.3,29,0),"g",None,(150,"150 g wedge","5 oz wedge","wedge","wedges"),False,"🧀","cheese",prices=(3.99,2.00,2.29)),
  I("tofu","firm tofu","firm tofu",None,DE,["soy"],"",(144,15.8,3.5,8.7,2.3),"g",{"piece":400},(400,"400 g block","14 oz block","block","blocks"),False,"🧊","tofu",prices=(2.49,1.50,1.99)),
  I("coconut-yogurt","coconut yogurt","coconut yogurt",None,DE,[],"",(120,1,6,10,0.5),"g",{"tbsp":15},(400,"400 g tub","14 oz tub","tub","tubs"),False,"🥥",prices=(4.49,2.00,2.49)),

  # ---------- Bakery ----------
  I("tortillas","flour tortilla","flour tortillas","tortilla wrap",BK,["gluten"],"",(312,8.3,52,8,3),"g",{"piece":45},(360,"8 wraps","8 tortillas","pack","packs"),False,"🫓",prices=(2.99,1.25,1.79)),
  I("corn-tortillas","corn tortilla","corn tortillas",None,BK,[],"",(218,5.7,45,2.9,6.3),"g",{"piece":26},(312,"12 tortillas","12 tortillas","pack","packs"),False,"🫓",prices=(2.49,2.00,2.49)),
  I("crescent-dough","crescent roll dough","crescent roll dough","croissant dough",BK,["gluten","dairy"],A,(340,6,40,18,1.8),"g",None,(240,"240 g tube","8.5 oz tube","tube","tubes"),False,"🥐",prices=(3.79,2.25,2.69)),
  I("burger-buns","burger bun","burger buns",None,BK,["gluten","sesame"],"",(279,9.5,49,4.3,2.5),"g",{"piece":60},(240,"4 buns","4 buns","pack","packs"),False,"🍔",prices=(2.99,1.00,1.29)),
  I("naan","naan bread","naan breads",None,BK,["gluten","dairy"],A,(290,9,50,5.6,2.2),"g",{"piece":90},(180,"2 naans","2 naans","pack","packs"),False,"🫓",prices=(2.99,1.00,1.49)),
  I("baguette","baguette","baguettes",None,BK,["gluten"],"",(274,9,52,3,2.7),"g",{"piece":250,"slice":25},(250,"1 baguette","1 baguette","baguette","baguettes"),False,"🥖",prices=(2.49,0.75,0.99)),
  I("pita-bread","pita bread","pita breads","pitta bread",BK,["gluten"],"",(275,9,55,1.2,2.2),"g",{"piece":60},(360,"6 pitas","6 pitas","pack","packs"),False,"🫓",prices=(2.49,0.75,1.19)),
  I("breadcrumbs","panko breadcrumbs","panko breadcrumbs",None,BK,["gluten"],"",(395,13,72,5.5,3),"g",{"tbsp":7,"cup":60},(200,"200 g bag","7 oz box","pack","packs"),False,"🍞",prices=(2.49,0.90,1.29)),
  I("sourdough","sourdough loaf","sourdough loaves",None,BK,["gluten"],"",(270,10,52,2,2.5),"g",{"slice":45},(400,"1 loaf","1 loaf","loaf","loaves"),False,"🍞",prices=(4.99,2.00,2.99)),

  # ---------- Pasta & noodles ----------
  I("rigatoni","rigatoni","rigatoni",None,PA,["gluten"],"",(371,13,75,1.5,3.2),"g",None,(500,"500 g bag","1 lb box","pack","packs"),False,"🍝",prices=(1.79,0.85,1.19)),
  I("macaroni","elbow macaroni","elbow macaroni","macaroni",PA,["gluten"],"",(371,13,75,1.5,3.2),"g",None,(500,"500 g bag","1 lb box","pack","packs"),False,"🍝",prices=(1.69,0.85,1.19)),
  I("jumbo-pasta-shells","jumbo pasta shells","jumbo pasta shells","large pasta shells",PA,["gluten"],"",(371,13,75,1.5,3.2),"g",None,(340,"340 g box","12 oz box","box","boxes"),False,"🍝",prices=(2.89,2.00,2.29)),
  I("wonton-wrappers","wonton wrappers","wonton wrappers",None,PA,["gluten","egg"],A,(291,9.8,57,1.5,2.2),"g",None,(200,"200 g pack","7 oz pack","pack","packs"),False,"🥟",prices=(3.99,2.75,2.99)),
  I("fettuccine","fettuccine","fettuccine",None,PA,["gluten"],"",(371,13,75,1.5,3.2),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🍝",prices=(2.49,1.25,1.69)),
  I("spaghetti","spaghetti","spaghetti",None,PA,["gluten"],"",(371,13,75,1.5,3.2),"g",None,(500,"500 g pack","1 lb box","pack","packs"),False,"🍝",prices=(1.49,0.75,0.99)),
  I("penne","penne","penne",None,PA,["gluten"],"",(371,13,75,1.5,3.2),"g",{"cup":100},(500,"500 g pack","1 lb box","pack","packs"),False,"🍝",prices=(1.49,0.75,0.99)),
  I("egg-noodles","egg noodles","egg noodles",None,PA,["gluten","egg"],A,(384,14,71,4.4,3.3),"g",{"piece":50},(300,"6 nests","10 oz pack","pack","packs"),False,"🍜",prices=(2.49,1.20,1.49)),
  I("rice-noodles","rice noodles","rice noodles",None,PA,[],"",(364,6,80,0.6,1.6),"g",None,(250,"250 g pack","9 oz pack","pack","packs"),False,"🍜",prices=(2.49,1.50,1.79)),
  I("gnocchi","gnocchi","gnocchi",None,PA,["gluten"],"",(133,3.3,28,0.4,1.4),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🥟",prices=(2.99,1.00,1.49)),
  I("orzo","orzo","orzo",None,PA,["gluten"],"",(371,13,75,1.5,3.2),"g",{"cup":180},(500,"500 g pack","1 lb box","pack","packs"),False,"🍝",prices=(2.49,1.20,1.49)),
  I("lasagne-sheets","lasagna sheets","lasagna sheets","lasagne sheets",PA,["gluten"],"",(371,13,75,1.5,3.2),"g",{"piece":20},(250,"250 g box","9 oz box","box","boxes"),False,"🍝",prices=(2.29,0.95,1.29)),
  I("udon-noodles","udon noodles","udon noodles",None,PA,["gluten"],"",(125,3,26,0.5,1),"g",{"piece":200},(400,"2 x 200 g","2 portions","pack","packs"),False,"🍜",prices=(2.99,1.50,1.99)),

  # ---------- Rice & grains ----------
  I("long-grain-rice","long-grain rice","long-grain rice",None,RG,[],"",(365,7,80,0.7,1.3),"g",{"cup":185},(1000,"1 kg bag","2 lb bag","bag","bags"),False,"🍚",prices=(2.49,1.30,1.69)),
  I("sushi-rice","short-grain sushi rice","short-grain sushi rice",None,RG,[],"",(360,6.6,80,0.5,0.8),"g",None,(500,"500 g pack","1 lb pack","pack","packs"),False,"🍚",prices=(3.49,2.25,2.49)),
  I("basmati-rice","basmati rice","basmati rice",None,RG,[],"",(360,8,78,0.9,1.3),"g",{"cup":185},(1000,"1 kg bag","2 lb bag","bag","bags"),False,"🍚",prices=(3.99,2.20,2.49)),
  I("arborio-rice","arborio rice","arborio rice","risotto rice",RG,[],"",(350,6.5,79,0.6,1.5),"g",{"cup":200},(500,"500 g bag","1 lb bag","bag","bags"),False,"🍚",prices=(3.49,1.50,1.99)),
  I("microwave-rice","microwave rice pouch","microwave rice pouches",None,RG,[],"",(150,3,32,1.5,0.6),"g",{"piece":250},(250,"250 g pouch","8.8 oz pouch","pouch","pouches"),False,"🍚",prices=(1.99,1.00,1.29)),
  I("couscous","couscous","couscous",None,RG,["gluten"],"",(376,13,77,0.6,5),"g",{"cup":175},(500,"500 g bag","1 lb box","pack","packs"),False,"🍚",prices=(2.49,0.90,1.29)),
  I("quinoa","quinoa","quinoa",None,RG,[],"",(368,14,64,6,7),"g",{"cup":170},(500,"500 g bag","1 lb bag","bag","bags"),False,"🌾",prices=(4.99,2.50,2.99)),
  I("red-lentils","red lentils","red lentils",None,RG,[],"",(358,24,63,2.2,11),"g",{"cup":190},(500,"500 g bag","1 lb bag","bag","bags"),False,"🫘","legume",prices=(2.49,1.20,1.69)),
  I("rolled-oats","rolled oats","rolled oats",None,RG,["gluten"],"",(379,13,68,6.5,10),"g",{"cup":90},(1000,"1 kg bag","2 lb canister","bag","bags"),False,"🌾",prices=(3.49,1.00,1.49)),
  I("bulgur","bulgur wheat","bulgur wheat",None,RG,["gluten"],"",(342,12,76,1.3,12.5),"g",{"cup":140},(500,"500 g bag","1 lb bag","bag","bags"),False,"🌾",prices=(2.99,1.30,1.79)),

  # ---------- Tins & jars ----------
  I("chopped-tomatoes","diced tomatoes","diced tomatoes","chopped tomatoes",TJ,[],"",(32,1.6,5.5,0.3,1.5),"g",{"cup":240},(400,"400 g tin","14.5 oz can","tin","tins"),False,"🥫",prices=(1.29,0.45,0.79)),
  I("passata","tomato sauce (passata)","tomato sauce (passata)","passata",TJ,[],"",(30,1.3,5,0.2,1.2),"g",{"cup":245},(500,"500 g jar","17 oz jar","jar","jars"),False,"🥫",prices=(2.49,0.70,0.99)),
  I("tomato-paste","tomato paste","tomato paste","tomato purée",TJ,[],"",(82,4.3,19,0.5,4.1),"g",{"tbsp":16,"tsp":5},(140,"140 g tube","6 oz can","tube","tubes"),False,"🥫",prices=(1.29,0.65,0.89)),
  I("coconut-milk","coconut milk","coconut milk",None,TJ,[],"",(197,2,2.8,21,0),"ml",{"cup":240,"tbsp":15},(400,"400 ml tin","13.5 oz can","tin","tins"),False,"🥥",prices=(2.49,1.20,1.49),gpm=1.0),
  I("chickpeas","chickpeas","chickpeas",None,TJ,[],"",(139,7.1,22.5,2.6,6.4),"g",{"cup":165},(240,"400 g tin (240 g drained)","15 oz can","tin","tins"),False,"🫘","legume",prices=(1.19,0.65,0.85)),
  I("black-beans","black beans","black beans",None,TJ,[],"",(132,8.9,23.7,0.5,8.7),"g",{"cup":172},(240,"400 g tin (240 g drained)","15 oz can","tin","tins"),False,"🫘","legume",prices=(1.19,0.80,1.19)),
  I("pinto-beans","pinto beans","pinto beans",None,TJ,[],"",(143,9,26,0.65,9),"g",None,(240,"400 g tin (240 g drained)","15 oz can","tin","tins"),False,"🫘","legume",prices=(1.19,0.65,0.89)),
  I("pineapple-tin","pineapple chunks in juice","pineapple chunks in juice",None,TJ,[],"",(60,0.4,15,0.1,0.9),"g",None,(230,"400 g tin (230 g drained)","14 oz can","tin","tins"),False,"🍍",prices=(1.99,1.05,1.39)),
  I("kidney-beans","kidney beans","kidney beans",None,TJ,[],"",(127,8.7,22.8,0.5,6.4),"g",{"cup":177},(240,"400 g tin (240 g drained)","15 oz can","tin","tins"),False,"🫘","legume",prices=(1.19,0.55,0.89)),
  I("cannellini-beans","cannellini beans","cannellini beans",None,TJ,[],"",(114,7.6,20,0.4,6),"g",{"cup":180},(240,"400 g tin (240 g drained)","15 oz can","tin","tins"),False,"🫘","legume",prices=(1.29,0.65,0.89)),
  I("canned-tuna","canned tuna","canned tuna","tinned tuna",TJ,["fish"],F,(116,26,0,1,0),"g",None,(145,"145 g tin","5 oz can","tin","tins"),False,"🐟","fish",prices=(1.49,1.00,1.39)),
  I("olives","black olives","black olives",None,TJ,[],"",(115,0.8,6,10.7,3.2),"g",{"tbsp":9,"cup":135},(150,"150 g jar","5 oz jar","jar","jars"),False,"🫒",prices=(2.99,1.20,1.49)),
  I("pesto","basil pesto","basil pesto","green pesto",TJ,["dairy","treeNut"],A,(430,5,6,43,2),"g",{"tbsp":16},(190,"190 g jar","6.7 oz jar","jar","jars"),False,"🌿",prices=(3.49,1.75,2.29)),
  I("peanut-butter","peanut butter","peanut butter",None,TJ,["peanut"],"",(588,25,20,50,6),"g",{"tbsp":16,"tsp":5},(340,"340 g jar","12 oz jar","jar","jars"),False,"🥜",prices=(2.99,1.60,2.29)),
  I("tahini","tahini","tahini",None,TJ,["sesame"],"",(595,17,21,54,9),"g",{"tbsp":15},(300,"300 g jar","10 oz jar","jar","jars"),False,"🫙",prices=(5.99,2.50,3.49)),
  I("thai-curry-paste","Thai red curry paste","Thai red curry paste",None,TJ,["shellfish"],F,(140,2,15,7,3),"g",{"tbsp":15,"tsp":5},(115,"115 g jar","4 oz jar","jar","jars"),False,"🌶️",tags=["spicy"],prices=(2.99,1.50,1.99)),
  I("curry-paste","tikka curry paste","tikka curry paste",None,TJ,[],"",(300,4,15,25,4),"g",{"tbsp":15,"tsp":5},(280,"280 g jar","10 oz jar","jar","jars"),False,"🍛",prices=(2.99,1.50,1.99)),
  I("chipotles-in-adobo","chipotles in adobo","chipotles in adobo",None,TJ,[],"",(70,2,13,1.5,4),"g",None,(198,"198 g tin","7 oz can","tin","tins"),False,"🌶️",tags=["spicy"],prices=(2.69,2.25,2.79)),
  I("salsa","tomato salsa","tomato salsa",None,TJ,[],"",(36,1.5,7,0.2,1.8),"g",{"tbsp":16,"cup":260},(450,"450 g jar","16 oz jar","jar","jars"),False,"🍅",prices=(2.99,1.50,1.99)),
  I("pepperoncini","pickled pepperoncini","pickled pepperoncini",None,TJ,[],"",(27,1,5.3,0.4,2),"g",None,(180,"300 g jar (180 g drained)","10.6 oz jar","jar","jars"),False,"🌶️",prices=(3.29,2.45,2.59)),
  I("roasted-peppers","roasted red peppers","roasted red peppers",None,TJ,[],"",(28,1,5,0.3,1.5),"g",{"piece":50},(290,"290 g jar","10 oz jar","jar","jars"),False,"🫑",prices=(3.49,1.30,1.79)),
  I("sweetcorn-tin","canned sweetcorn","canned sweetcorn","tinned sweetcorn",TJ,[],"",(81,2.7,16,1.2,2.4),"g",{"cup":165},(200,"200 g tin (drained)","8.5 oz can","tin","tins"),False,"🌽",prices=(1.19,0.60,0.89)),
  I("kimchi","kimchi","kimchi",None,TJ,["fish"],F,(15,1.1,2.4,0.5,1.6),"g",{"cup":150},(300,"300 g jar","10 oz jar","jar","jars"),False,"🥬",tags=["spicy"],prices=(5.99,3.00,3.99)),

  # ---------- Stock ----------
  I("vegetable-stock","vegetable stock","vegetable stock",None,SC,[],"",(5,0.2,0.9,0.1,0),"ml",{"cup":240},(1000,"1 litre carton","32 fl oz carton","carton","cartons"),False,"🥣",prices=(2.49,1.00,1.29),gpm=1.0),
  I("chicken-stock","chicken stock","chicken stock",None,SC,[],M,(7,0.6,0.4,0.2,0),"ml",{"cup":240},(1000,"1 litre carton","32 fl oz carton","carton","cartons"),False,"🥣",prices=(2.49,1.20,1.49),gpm=1.0),

  # ---------- Sauces & condiments ----------
  I("soy-sauce","soy sauce","soy sauce",None,SC,["soy","gluten"],"",(53,8,4.9,0.6,0.8),"ml",{"tbsp":16,"tsp":5.3},(150,"150 ml bottle","5 fl oz bottle","bottle","bottles"),False,"🍶",prices=(2.49,1.30,1.79),gpm=1.07),
  I("honey","honey","honey",None,SC,[],A,(304,0.3,82,0,0.2),"g",{"tbsp":21,"tsp":7},(340,"340 g jar","12 oz jar","jar","jars"),False,"🍯",prices=(4.99,1.60,2.49)),
  I("maple-syrup","maple syrup","maple syrup",None,SC,[],"",(260,0,67,0.1,0),"ml",{"tbsp":20,"tsp":7},(250,"250 ml bottle","8 fl oz bottle","bottle","bottles"),False,"🍁",prices=(7.99,3.50,4.99),gpm=1.32),
  I("dijon-mustard","Dijon mustard","Dijon mustard",None,SC,[],"",(66,4,5,4,3),"g",{"tsp":5,"tbsp":15},(200,"200 g jar","7 oz jar","jar","jars"),False,"🟡",prices=(2.49,0.85,1.29)),
  I("mayonnaise","mayonnaise","mayonnaise",None,SC,["egg"],A,(680,1,0.6,75,0),"g",{"tbsp":14,"tsp":5},(400,"400 g jar","15 oz jar","jar","jars"),False,"🫙",prices=(3.99,1.50,1.99)),
  I("ketchup","ketchup","ketchup",None,SC,[],"",(101,1,27,0.1,0.3),"g",{"tbsp":17},(500,"500 g bottle","20 oz bottle","bottle","bottles"),False,"🍅",prices=(2.49,1.20,1.49)),
  I("sriracha","sriracha","sriracha",None,SC,[],"",(93,1.9,19,0.9,2.2),"g",{"tsp":6,"tbsp":17},(200,"200 ml bottle","7 oz bottle","bottle","bottles"),False,"🌶️",tags=["spicy"],prices=(2.99,1.75,2.29)),
  I("fish-sauce","fish sauce","fish sauce",None,SC,["fish"],F,(35,5,3.6,0,0),"ml",{"tbsp":18,"tsp":6},(200,"200 ml bottle","7 fl oz bottle","bottle","bottles"),False,"🐟",prices=(2.99,1.50,1.99),gpm=1.2),
  I("worcestershire","Worcestershire sauce","Worcestershire sauce",None,SC,["fish"],F,(78,0,19,0,0),"ml",{"tsp":5,"tbsp":15},(150,"150 ml bottle","5 fl oz bottle","bottle","bottles"),False,"🍶",prices=(2.49,1.20,1.69),gpm=1.1),
  I("hoisin-sauce","hoisin sauce","hoisin sauce",None,SC,["soy","gluten","sesame"],"",(220,3.3,44,3.4,2.8),"g",{"tbsp":16},(200,"200 g jar","7 oz jar","jar","jars"),False,"🍶",prices=(2.99,1.40,1.99)),
  I("miso-paste","white miso paste","white miso paste",None,SC,["soy"],"",(198,12,26,6,5.4),"g",{"tbsp":17,"tsp":6},(300,"300 g tub","10 oz tub","tub","tubs"),False,"🥣",prices=(4.99,2.75,3.49)),
  I("bbq-sauce","barbecue sauce","barbecue sauce",None,SC,[],"",(172,0.8,41,0.6,0.9),"g",{"tbsp":17,"cup":280},(500,"500 g bottle","18 oz bottle","bottle","bottles"),False,"🍖",prices=(2.49,1.25,1.79)),
  I("gochujang","gochujang","gochujang",None,SC,["soy","gluten"],"",(230,4,46,2,2.5),"g",{"tbsp":16,"tsp":6},(200,"200 g tub","7 oz tub","tub","tubs"),False,"🌶️",tags=["spicy"],prices=(4.49,2.50,2.99)),
  I("sweet-chili-sauce","sweet chili sauce","sweet chili sauce","sweet chilli sauce",SC,[],"",(230,0.3,56,0.2,0.5),"g",{"tbsp":18},(250,"250 ml bottle","8 fl oz bottle","bottle","bottles"),False,"🌶️",prices=(2.49,1.20,1.69)),
  I("hot-sauce","hot sauce","hot sauce",None,SC,[],"",(12,0.5,1.8,0.4,0.3),"ml",{"tsp":5},(150,"150 ml bottle","5 fl oz bottle","bottle","bottles"),False,"🌶️",tags=["spicy"],prices=(2.99,1.50,1.99),gpm=1.0),

  # ---------- Spices & herbs (pantry staples) ----------
  I("salt","salt","salt",None,SH,[],"",(0,0,0,0,0),"g",{"tsp":6,"tbsp":18,"pinch":0.4},(750,"750 g tub","26 oz canister","tub","tubs"),True,"🧂",prices=(1.29,0.65,0.49)),
  spice("black-pepper","black pepper",None,(251,10,64,3.3,25),2.3,"⚫️"),
  spice("cumin","ground cumin",None,(375,18,44,22,10),2,"🟤"),
  spice("paprika","smoked paprika",None,(282,14,54,13,35),2.3,"🔴"),
  spice("chili-flakes","red chili flakes",None,(318,12,57,17,27),1.8,"🌶️",tags=["spicy"]),
  spice("dried-oregano","dried oregano",None,(265,9,69,4,43),1,"🌿"),
  spice("curry-powder","curry powder",None,(325,14,58,14,53),2,"🟡"),
  spice("garam-masala","garam masala",None,(379,15,45,15,30),2,"🟤"),
  spice("turmeric","ground turmeric",None,(312,10,67,3,23),3,"🟡"),
  spice("cinnamon","ground cinnamon",None,(247,4,81,1.2,53),2.6,"🟤"),
  spice("chili-powder","chili powder",None,(282,13,50,14,35),2.7,"🌶️",tags=["spicy"]),
  spice("dried-thyme","dried thyme",None,(276,9,64,7.4,37),1,"🌿"),
  spice("italian-herbs","Italian seasoning",None,(270,10,60,6,40),1,"🌿"),
  spice("five-spice","Chinese five-spice",None,(350,10,60,10,30),2,"🟤"),
  spice("ground-coriander","ground coriander",None,(298,12,55,18,42),1.8,"🟤"),
  spice("garlic-powder","garlic powder",None,(331,17,73,0.7,9),3.1,"🧄"),
  spice("onion-powder","onion powder",None,(341,10,79,1,15),2.4,"🧅"),
  spice("bay-leaves","bay leaves",None,(313,7.6,75,8.4,26),0.6,"🍃",size=(10,"10 g jar","0.3 oz jar")),
  spice("sesame-seeds","sesame seeds",None,(573,18,23,50,12),3,"⚪️",allergens=["sesame"],size=(100,"100 g bag","3.5 oz jar")),
  spice("vegetable-bouillon","vegetable bouillon powder",None,(250,10,30,10,1),3,"🥣"),

  # ---------- Oils & vinegars ----------
  I("olive-oil","olive oil","olive oil",None,OV,[],"",(884,0,0,100,0),"ml",{"tbsp":13.5,"tsp":4.5},(500,"500 ml bottle","17 fl oz bottle","bottle","bottles"),True,"🫒",prices=(7.99,4.50,5.99),gpm=0.91),
  I("vegetable-oil","vegetable oil","vegetable oil",None,OV,[],"",(884,0,0,100,0),"ml",{"tbsp":13.6,"tsp":4.5},(1000,"1 litre bottle","32 fl oz bottle","bottle","bottles"),True,"🛢️",prices=(3.99,1.80,2.49),gpm=0.92),
  I("sesame-oil","toasted sesame oil","toasted sesame oil",None,OV,["sesame"],"",(884,0,0,100,0),"ml",{"tbsp":13.6,"tsp":4.5},(150,"150 ml bottle","5 fl oz bottle","bottle","bottles"),False,"🫙",prices=(3.99,2.00,2.49),gpm=0.92),
  I("balsamic-vinegar","balsamic vinegar","balsamic vinegar",None,OV,[],"",(88,0.5,17,0,0),"ml",{"tbsp":16,"tsp":5},(250,"250 ml bottle","8.5 fl oz bottle","bottle","bottles"),False,"🍶",prices=(3.49,1.50,1.99),gpm=1.06),
  I("rice-vinegar","rice vinegar","rice vinegar",None,OV,[],"",(18,0,0.5,0,0),"ml",{"tbsp":15,"tsp":5},(300,"300 ml bottle","10 fl oz bottle","bottle","bottles"),False,"🍶",prices=(2.99,1.50,1.99),gpm=1.0),
  I("red-wine-vinegar","red wine vinegar","red wine vinegar",None,OV,[],"",(19,0,0.3,0,0),"ml",{"tbsp":15,"tsp":5},(500,"500 ml bottle","16 fl oz bottle","bottle","bottles"),True,"🍷",prices=(2.99,1.00,1.29),gpm=1.0),

  # ---------- Frozen ----------
  I("peas-frozen","frozen peas","frozen peas",None,FR,[],"",(81,5.4,14,0.4,5.1),"g",{"cup":145},(500,"500 g bag","1 lb bag","bag","bags"),False,"🟢",prices=(1.99,1.00,1.49)),
  I("corn-frozen","frozen sweetcorn","frozen sweetcorn",None,FR,[],"",(86,3.3,19,1.4,2),"g",{"cup":145},(500,"500 g bag","1 lb bag","bag","bags"),False,"🌽",prices=(1.99,1.00,1.39)),
  I("mixed-veg-frozen","frozen stir-fry vegetables","frozen stir-fry vegetables",None,FR,[],"",(65,3.3,13,0.5,4),"g",{"cup":140},(750,"750 g bag","1.5 lb bag","bag","bags"),False,"🥦",prices=(2.99,1.00,1.69)),
  I("edamame-frozen","frozen edamame","frozen edamame",None,FR,["soy"],"",(121,12,9,5,5),"g",{"cup":155},(400,"400 g bag","14 oz bag","bag","bags"),False,"🫛","legume",prices=(2.99,2.00,2.49)),
  I("spinach-frozen","frozen spinach","frozen spinach",None,FR,[],"",(29,3.6,4.2,0.5,3),"g",{"cup":156},(450,"450 g bag","1 lb bag","bag","bags"),False,"🥬",prices=(2.49,1.00,1.29)),

  # ---------- Baking ----------
  I("flour","all-purpose flour","all-purpose flour","plain flour",BA,["gluten"],"",(364,10,76,1,2.7),"g",{"tbsp":8,"cup":125,"tsp":3},(1000,"1 kg bag","2 lb bag","bag","bags"),False,"🌾",prices=(1.99,0.75,0.89)),
  I("cornstarch","cornstarch","cornstarch","cornflour",BA,[],"",(381,0.3,91,0.1,0.9),"g",{"tbsp":8,"tsp":2.7},(400,"400 g box","16 oz box","box","boxes"),True,"🌽",prices=(2.29,1.00,1.29)),
  I("sugar","brown sugar","brown sugar",None,BA,[],"",(380,0,98,0,0),"g",{"tsp":4,"tbsp":12.5,"cup":220},(500,"500 g bag","1 lb bag","bag","bags"),True,"🍬",prices=(2.49,1.20,1.49)),
  I("baking-powder","baking powder","baking powder",None,BA,[],"",(53,0,28,0,0.2),"g",{"tsp":4},(170,"170 g tub","6 oz can","tub","tubs"),True,"🧁",prices=(2.49,1.00,1.29)),

  # ---------- Other ----------
  I("peanuts","roasted peanuts","roasted peanuts",None,OT,["peanut"],"",(585,24,21,50,8),"g",{"tbsp":9,"cup":145},(200,"200 g bag","7 oz bag","bag","bags"),False,"🥜",prices=(2.99,1.20,1.49)),
  I("cashews","cashews","cashews",None,OT,["treeNut"],"",(553,18,30,44,3.3),"g",{"tbsp":9,"cup":130},(150,"150 g bag","5 oz bag","bag","bags"),False,"🌰",prices=(4.49,2.25,2.99)),
  I("walnuts","walnuts","walnuts",None,OT,["treeNut"],"",(654,15,14,65,6.7),"g",{"tbsp":8,"cup":100},(150,"150 g bag","5 oz bag","bag","bags"),False,"🌰",prices=(4.99,2.25,2.99)),
  I("tempeh","tempeh","tempeh",None,OT,["soy"],"",(192,20,7.6,11,0),"g",None,(200,"200 g block","7 oz block","block","blocks"),False,"🟫","tofu",prices=(3.99,2.75,2.99)),
  I("raisins","raisins","raisins",None,OT,[],"",(299,3.1,79,0.5,3.7),"g",{"tbsp":9},(250,"250 g bag","9 oz box","bag","bags"),False,"🍇",prices=(2.99,1.00,1.49)),
  I("dark-chocolate","dark chocolate","dark chocolate",None,OT,["dairy","soy"],A,(546,4.9,61,31,7),"g",{"piece":10},(100,"100 g bar","3.5 oz bar","bar","bars"),False,"🍫",prices=(2.99,1.50,1.79)),

  # ---------- Breakfast, lunch & snacks (Nov 2026) ----------
  I("banana","banana","bananas",None,P,[],"",(89,1.1,23,0.3,2.6),"g",{"piece":120},(720,"bunch of 6","bunch of 6","bunch","bunches"),False,"🍌",prices=(1.69,0.95,1.29)),
  I("berries-frozen","frozen mixed berries","frozen mixed berries",None,FR,[],"",(50,0.7,12,0.3,2.4),"g",{"cup":140},(500,"500 g bag","16 oz bag","bag","bags"),False,"🫐",prices=(4.49,2.00,2.79)),
  I("chia-seeds","chia seeds","chia seeds",None,OT,[],"",(486,17,42,31,34),"g",{"tbsp":12,"tsp":4},(200,"200 g bag","7 oz bag","bag","bags"),False,"🌱",prices=(5.99,2.50,3.49)),
  I("hummus","hummus","hummus",None,DE,["sesame"],"",(166,7.9,14,9.6,6),"g",{"tbsp":15,"cup":246},(200,"200 g tub","8 oz tub","tub","tubs"),False,"🫘",prices=(2.99,1.20,1.79)),
  I("wholemeal-bread","whole wheat bread","whole wheat bread","wholemeal bread",BK,["gluten"],"",(247,13,41,3.4,7),"g",{"slice":40},(800,"800 g loaf","24 oz loaf","loaf","loaves"),False,"🍞",prices=(3.49,1.30,1.79)),
  I("soy-milk","soy milk","soy milk",None,DE,["soy"],"",(54,3.3,6,1.8,0.6),"ml",{"cup":243,"tbsp":15},(1000,"1 L carton","32 fl oz carton","carton","cartons"),False,"🥛",prices=(2.99,1.20,1.49),gpm=1.01),
  I("saltine-crackers","saltine crackers","saltine crackers","cream crackers",BK,["gluten"],"",(421,9,74,9,2.8),"g",None,(200,"200 g pack","7 oz pack","pack","packs"),False,"🍘",prices=(2.69,1.25,1.79)),
  I("rice-cakes","rice cakes","rice cakes",None,OT,[],"",(387,8,81,2.8,4.2),"g",{"piece":9},(130,"130 g pack","4.5 oz pack","pack","packs"),False,"🍘",prices=(2.49,1.00,1.29)),
  I("popcorn-kernels","popcorn kernels","popcorn kernels",None,OT,[],"",(387,13,78,4.5,15),"g",{"tbsp":12,"cup":200},(500,"500 g bag","16 oz bag","bag","bags"),False,"🍿",prices=(3.49,1.50,1.99)),

  # ---------- Trending recipes (Nov 2026) ----------
  I("cottage-cheese","cottage cheese","cottage cheese",None,DE,["dairy"],A,(98,11,3.4,4.3,0),"g",{"tbsp":15,"cup":225},(300,"300 g tub","10 oz tub","tub","tubs"),False,"🥣","cheese",prices=(2.99,1.20,1.49)),
  I("mango","mango","mangoes",None,P,[],"",(60,0.8,15,0.4,1.6),"g",{"piece":200,"cup":165},(400,"2 mangoes","2 mangoes","pack","packs"),False,"🥭",prices=(2.49,1.50,1.99)),
  I("grapes","grapes","grapes",None,P,[],"",(69,0.7,18,0.2,0.9),"g",{"cup":150},(500,"500 g punnet","1 lb bag","pack","packs"),False,"🍇",prices=(3.99,1.75,2.29)),
  I("nori","nori sheets","nori sheets",None,OT,[],"",(290,41,40,2,36),"g",{"piece":2.5},(25,"10 sheets","10 sheets","pack","packs"),False,"🟩",prices=(3.49,2.00,2.49)),
  I("rice-paper","rice paper wrappers","rice paper wrappers",None,OT,[],"",(333,6,80,0.5,1),"g",{"piece":9},(200,"200 g pack","7 oz pack","pack","packs"),False,"⚪",prices=(3.49,2.00,2.29)),
]
