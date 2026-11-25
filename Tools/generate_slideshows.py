#!/usr/bin/env python3
"""Builds the TikTok / Reels slideshow kit for the trending recipes.

    python3 Tools/generate_slideshows.py

Writes Marketing/slideshows/<id>.md (slide copy, caption, hashtags, ChatGPT image prompts per slide),
Marketing/slideshows/README.md (index + how to use) and Marketing/chatgpt-recipe-photo-prompts.md
(the square in-app photos, named recipe-<id>, ready to drop into Assets.xcassets).
Numbers (kcal, protein, minutes, servings) come from the same tables as the app.
"""
import os, sys
sys.path.insert(0, os.path.dirname(__file__))
from ingredients_data import ROWS
from recipes_data import RECIPES
TRENDING = [r for r in RECIPES if "trending" in r.get("tags", [])]

ROOT = os.path.join(os.path.dirname(__file__), "..")
OUT = os.path.join(ROOT, "Marketing", "slideshows")
ING = {d["id"]: d for d, _ in ROWS}

PHOTO_STYLE = ("Realistic food photography, natural window light from the left, warm cream linen and light oak surface, "
               "soft shadows, shallow depth of field, appetising and a little messy (crumbs, drips), "
               "warm palette with tomato red #E8553D and saffron #F2B544 accents in props, no text, no logos, "
               "no brand packaging, no hands unless the prompt says so, no people's faces.")

def grams(item):
    d = ING[item["ingredientId"]]; u = item["unit"]; a = item["amount"]
    if u == "g": return a
    if u == "ml": return a * d.get("gramsPerMl", 1)
    return a * (d.get("gramsPerUnit") or {}).get(u, 0)

def per_serving(r):
    kcal = prot = 0
    for it in r["ingredients"]:
        g = grams(it); m = ING[it["ingredientId"]]["per100g"]
        kcal += g * m["kcal"] / 100; prot += g * m["protein"] / 100
    s = r["baseServings"]
    return round(kcal / s / 10) * 10, round(prot / s)

def fmt_amount(it):
    a = it["amount"]; a = int(a) if float(a).is_integer() else a
    unit = {"piece": "", "clove": " cloves" if a != 1 else " clove", "slice": " slices" if a != 1 else " slice"}.get(it["unit"], f" {it['unit']}")
    d = ING[it["ingredientId"]]
    name = d["pluralName"] if it["unit"] == "piece" and a != 1 else d["name"]
    return f"{a}{unit} {name}".replace("  ", " ")

def hook(r, kcal, prot, mins):
    v = set(r["vibes"]); t = r["title"]
    if r["mealType"] == "snack":
        return f"the {mins}-minute snack I make every week"
    if prot >= 35:
        return f"{prot} g protein, {mins} minutes: {lower_first(t)}"
    if "fakeaway" in v:
        return f"better than takeout, ready in {mins} minutes"
    if "batchFriendly" in v and r["isLeftoverFriendly"]:
        return f"make it Sunday, eat it till Wednesday: {lower_first(t)}"
    if "onePan" in v:
        return f"one pan, {mins} minutes, almost no washing up"
    if kcal <= 450:
        return f"{kcal} calories and actually filling"
    return f"the {mins}-minute {r['mealType']} on repeat in my house"

def vessel(r):
    t = r["title"].lower()
    if any(w in t for w in ("sheet-pan", "skillet", "sushi bake")):
        return "served straight from the baking dish or pan"
    if any(w in t for w in ("bowl", "salad", "soup", "oats", "pudding", "rice", "noodle", "pasta", "orzo", "gnocchi", "curry", "edamame")):
        return "served in a wide ceramic bowl"
    if any(w in t for w in ("sandwich", "wrap", "toast", "roll", "taco", "sushi", "bites", "pancakes", "chips")):
        return "served on a plate or wooden board"
    if any(w in t for w in ("bake", "skillet", "sheet-pan", "tray")):
        return "served straight from the baking dish or pan"
    return "served the way you'd eat it at home"

def short_step(step):
    text = step.split(". ")[0].split(", then ")[0].split(" until ")[0].rstrip(".")
    return text

def lower_first(text):
    return text[:1].lower() + text[1:]

def chunk_steps(steps, n=3):
    k, m = divmod(len(steps), n)
    out, i = [], 0
    for j in range(n):
        size = k + (1 if j < m else 0)
        if size: out.append(steps[i:i + size])
        i += size
    return out

FRESH_HERBS = {"cilantro", "parsley", "basil", "mint"}

HIDDEN_AISLES = {"Sauces & Condiments", "Spices & Herbs", "Oils & Vinegars", "Baking"}

def main_ingredient_names(r, n=4, visible_only=False):
    skip = {"salt", "black-pepper", "olive-oil", "vegetable-oil", "sesame-oil", "garlic", "sugar"}
    names = [ING[i["ingredientId"]]["name"] for i in r["ingredients"] if i["ingredientId"] not in skip
             and not (visible_only and ING[i["ingredientId"]]["aisle"] in HIDDEN_AISLES and i["ingredientId"] not in FRESH_HERBS)]
    return ", ".join(names[:n])

def write_recipe(r):
    kcal, prot = per_serving(r)
    mins = r["prepMinutes"] + r["cookMinutes"]
    title = r["title"]; rid = r["id"]
    ings = "\n".join(f"- {fmt_amount(i)}" + (f", {i['note']}" if i.get("note") else "") for i in r["ingredients"])
    groups = chunk_steps(r["steps"])
    hero = (f"Tall portrait photo, 2:3 (1024×1536), with the main subject in the middle so it crops cleanly to 9:16. Hero shot of {title}, {vessel(r)}, shot 45° from above, "
            f"leaving the top third of the frame calm and uncluttered for a text overlay. {PHOTO_STYLE}")
    flat = (f"Tall portrait photo, 2:3 (1024×1536), with the main subject in the middle so it crops cleanly to 9:16. Overhead flat lay of the raw ingredients for {title}: {main_ingredient_names(r, 8)}, "
            f"neatly arranged in small bowls and loose on the surface, prepped as a recipe would start. {PHOTO_STYLE}")
    slides = [
        ("1 · Hook", hook(r, kcal, prot, mins), f"{mins} min · {kcal} kcal · {prot} g protein per serving", hero),
        ("2 · What you need", f"what you need (serves {r['baseServings']})", "list the ingredients on screen, smallest font that's still readable", flat),
    ]
    for n, g in enumerate(groups, start=3):
        first = sum(len(x) for x in groups[:n - 3]) + 1
        text = " / ".join(f"{first + k}. {lower_first(short_step(x))}" for k, x in enumerate(g))
        scene = g[-1].rstrip(".")
        slides.append((f"{n} · Step", text, " ".join(g),
                       f"Tall portrait photo, 2:3 (1024×1536), with the main subject in the middle so it crops cleanly to 9:16. Close-up of the moment in making {title} where you {lower_first(scene)}. "
                       f"Show exactly what the food looks like at this stage, in whatever pan, tray, board or bowl fits. {PHOTO_STYLE}"))
    n = len(slides) + 1
    slides.append((f"{n} · Money shot", "done. dig in.", "save this for your weekly plan",
                   f"Tall portrait photo, 2:3 (1024×1536), with the main subject in the middle so it crops cleanly to 9:16. Extreme close-up of a bite of {title} lifted just above the plate, "
                   f"sauce glossy, toppings in focus. {PHOTO_STYLE}"))
    slides.append((f"{n + 1} · Call to action", "plan it, shop it, cook it in Tommo",
                   "Tommo builds your week of dinners around your supermarket and budget",
                   "No AI image: use a real screen recording or screenshot of this recipe in the Tommo app (search the title on Discover)."))

    caption = (f"{title} 🔥 {mins} minutes, {kcal} kcal and {prot} g protein per serving. "
               f"Full recipe is free in Tommo, and it adds the shopping list for you. Save this for next week.")
    tags = ["#easyrecipes", "#healthyrecipes", "#mealprep", "#dinnerideas", "#weeknightdinner", "#budgetmeals"]
    if r["mealType"] == "dinner" and "bowl" in title.lower(): tags.insert(0, "#bowlrecipes")
    if prot >= 30: tags.append("#highprotein")
    if r["mealType"] in ("breakfast", "snack"): tags[3] = f"#{r['mealType']}ideas"

    lines = [f"# {title}", "",
             f"`{rid}` · {r['mealType']} · {r['cuisine']} · {mins} min · serves {r['baseServings']} · ~{kcal} kcal · ~{prot} g protein per serving", "",
             "## Slides (9:16, 1080×1920 in the editor)", "",
             "Put the text on in CapCut or the TikTok editor, not in the image. Keep it to the top third.", ""]
    for name, big, small, prompt in slides:
        lines += [f"### {name}", f"**On screen:** {big}", f"**Small text:** {small}", "", "**ChatGPT image prompt:**", "", "```text", prompt, "```", ""]
    lines += ["## Caption", "", caption, "", " ".join(tags), "",
              "## Recipe", "", ings, "", *[f"{i}. {s}" for i, s in enumerate(r["steps"], start=1)], "",
              "## In-app photo", "",
              f"Asset name `recipe-{rid}`, square, opaque. See `Marketing/chatgpt-recipe-photo-prompts.md`.", ""]
    with open(os.path.join(OUT, f"{rid}.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    return kcal, prot, mins

def app_photo_prompt(r):
    return (f"Square 1:1 photo (1024×1024) of {r['title']}, top-down or 45°, the whole dish in frame on a warm neutral surface, "
            f"natural light, no hands, no text. Key ingredients visible: {main_ingredient_names(r, 5, visible_only=True)}. {PHOTO_STYLE}")

def main():
    os.makedirs(OUT, exist_ok=True)
    rows = []
    for r in TRENDING:
        kcal, prot, mins = write_recipe(r)
        rows.append(f"| [{r['title']}]({r['id']}.md) | {r['mealType']} | {mins} min | {kcal} | {prot} g |")
    readme = ["# Slideshow kit: trending recipes", "",
              f"{len(TRENDING)} easy, healthy-ish recipes for TikTok / Instagram photo slideshows. Every one is also in the app",
              "(Discover → **Going viral**), so the call to action is real: people can search the title in Tommo.", "",
              "## How to make one post", "",
              "1. Open the recipe's file below.",
              "2. Open a **new ChatGPT chat per recipe** and paste the style message below once. Then paste each slide's prompt (the copy",
              "   button on each grey box), one message per slide, hero first. ChatGPT makes 2:3 portraits (1024×1536): in CapCut or",
              "   TikTok set the canvas to 9:16 and zoom the photo to fill it. The prompts keep the food centred so nothing is lost.",
              "3. Add the **On screen** text (a \" / \" means start a new line) in CapCut or the TikTok editor (SF Pro Rounded Bold, cream `#FBF6EE` text on a tomato `#E8553D` pill looks on-brand).",
              "4. The last slide is a real screenshot of the recipe in Tommo, never an AI image of the app.",
              "5. Paste the caption and hashtags.", "",
              "## Style message (paste once at the start of each chat)", "", "```text",
              "I'm making a set of matching photos of one dish for a recipe slideshow. Keep the same bowl, props, surface and light in every image I ask for in this chat. "
              "Photorealistic, no text or lettering anywhere in the image, no logos, no brand packaging. Make every image a tall 2:3 portrait unless I say square.",
              "```", "",
              "## Rules", "",
              "- No fake reviews, no \"as seen on\" claims, no creator names. Numbers on the slides come from the app's own nutrition maths.",
              "- No text, logos or brand packaging inside the generated images.",
              "- Regenerate this folder after editing recipes: `python3 Tools/generate_slideshows.py`.", "",
              "## Recipes", "", "| Recipe | Meal | Time | kcal | Protein |", "|---|---|---|---|---|", *rows, ""]
    with open(os.path.join(OUT, "README.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(readme))

    photos = ["# ChatGPT prompts: in-app recipe photos (trending set)", "",
              "Square, opaque. ChatGPT makes them 1024×1024, which is fine for the app (1200×1200 if you upscale).",
              "Drop each one into `Forkcast/Resources/Assets.xcassets` as an",
              "**Image Set named with the recipe ID below**. Use `illustrative-recipe-<id>` for generated photography so the hero labels it as illustrative.",
              "Match the existing 40 dinner photos: same warm neutral surface, natural light, no hands, no text.", "",
              "Save each image with the asset name as the file name, so it's easy to drop in.", ""]
    for r in TRENDING:
        photos += [f"## `recipe-{r['id']}`", r["title"], "", "```text", app_photo_prompt(r), "```", ""]
    with open(os.path.join(ROOT, "Marketing", "chatgpt-recipe-photo-prompts.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(photos).rstrip() + "\n")
    print(f"{len(TRENDING)} slideshow scripts written to Marketing/slideshows/")

if __name__ == "__main__":
    main()
