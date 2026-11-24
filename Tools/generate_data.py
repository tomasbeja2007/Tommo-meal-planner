#!/usr/bin/env python3
"""Bootstraps the bundled JSON reference data for ForkcastCore.

The JSON files in Packages/ForkcastCore/Sources/ForkcastCore/Resources are the
source of truth shipped in the app. This script only exists to make it easy to
regenerate them from the tables in ingredients_data.py / recipes_data.py.

    python3 Tools/generate_data.py
"""
import json, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from ingredients_data import ROWS
from recipes_data import RECIPES

OUT = os.path.join(os.path.dirname(__file__), "..", "Packages", "ForkcastCore", "Sources", "ForkcastCore", "Resources")

COUNTRIES = [
    # id, name, flag, currency, units, price key, price multiplier (vs. the price table currency), note
    ("us", "United States", "🇺🇸", "USD", "imperial", "US", 1.0, None),
    ("gb", "United Kingdom", "🇬🇧", "GBP", "metric", "UK", 1.0, None),
    ("ie", "Ireland", "🇮🇪", "EUR", "metric", "EU", 1.0, None),
    ("pt", "Portugal", "🇵🇹", "EUR", "metric", "EU", 0.92, None),
    ("es", "Spain", "🇪🇸", "EUR", "metric", "EU", 0.95, None),
    ("fr", "France", "🇫🇷", "EUR", "metric", "EU", 1.05, None),
    ("de", "Germany", "🇩🇪", "EUR", "metric", "EU", 1.0, None),
    ("nl", "Netherlands", "🇳🇱", "EUR", "metric", "EU", 1.03, None),
    ("it", "Italy", "🇮🇹", "EUR", "metric", "EU", 1.0, None),
    ("be", "Belgium", "🇧🇪", "EUR", "metric", "EU", 1.05, None),
    ("at", "Austria", "🇦🇹", "EUR", "metric", "EU", 1.05, None),
    ("ca", "Canada", "🇨🇦", "CAD", "metric", "US", 1.37, "Prices are rough conversions from US estimates."),
    ("au", "Australia", "🇦🇺", "AUD", "metric", "US", 1.52, "Prices are rough conversions from US estimates."),
]

EU_OTHER = ["ie", "be", "at"]
STORES = [
    # id, name, countries, tier, colour
    ("walmart", "Walmart", ["us", "ca"], "budget", "#0071CE"),
    ("kroger", "Kroger", ["us"], "standard", "#134B97"),
    ("aldi", "Aldi", ["us", "gb", "pt", "es", "fr", "de", "nl", "au"] + EU_OTHER, "budget", "#00205B"),
    ("target", "Target", ["us"], "standard", "#CC0000"),
    ("costco", "Costco", ["us", "ca"], "budget", "#E31837"),
    ("trader-joes", "Trader Joe's", ["us"], "standard", "#BA0C2F"),
    ("whole-foods", "Whole Foods", ["us"], "premium", "#00674B"),
    ("publix", "Publix", ["us"], "standard", "#3F8F29"),
    ("safeway", "Safeway", ["us"], "standard", "#E21A2C"),
    ("heb", "H-E-B", ["us"], "standard", "#EE3124"),
    ("tesco", "Tesco", ["gb"], "standard", "#00539F"),
    ("sainsburys", "Sainsbury's", ["gb"], "standard", "#F06C00"),
    ("asda", "Asda", ["gb"], "budget", "#5D9732"),
    ("lidl", "Lidl", ["gb", "pt", "es", "fr", "de", "nl", "it"] + EU_OTHER, "budget", "#0050AA"),
    ("morrisons", "Morrisons", ["gb"], "standard", "#00563F"),
    ("waitrose", "Waitrose", ["gb"], "premium", "#4B6B2F"),
    ("marks-spencer", "M&S", ["gb"], "premium", "#2B2B2B"),
    ("coop-uk", "Co-op", ["gb"], "standard", "#00A1CC"),
    ("continente", "Continente", ["pt"], "standard", "#E30613"),
    ("pingo-doce", "Pingo Doce", ["pt"], "standard", "#4C9A2A"),
    ("auchan", "Auchan", ["pt", "fr"], "standard", "#E2001A"),
    ("mercadona", "Mercadona", ["pt", "es"], "budget", "#00843D"),
    ("intermarche", "Intermarché", ["pt", "fr"], "standard", "#D52B1E"),
    ("carrefour", "Carrefour", ["es", "fr", "it"] + EU_OTHER, "standard", "#004E9E"),
    ("dia", "Dia", ["es"], "budget", "#E4032E"),
    ("leclerc", "E.Leclerc", ["fr"], "budget", "#0066B3"),
    ("edeka", "Edeka", ["de"], "standard", "#1B4C9C"),
    ("rewe", "Rewe", ["de"], "standard", "#CC071E"),
    ("kaufland", "Kaufland", ["de"], "budget", "#E10915"),
    ("penny", "Penny", ["de"], "budget", "#CD1719"),
    ("albert-heijn", "Albert Heijn", ["nl"], "standard", "#00A0E2"),
    ("jumbo", "Jumbo", ["nl"], "standard", "#EEB111"),
    ("plus", "Plus", ["nl"], "standard", "#6CB33F"),
    ("esselunga", "Esselunga", ["it"], "premium", "#E4022D"),
    ("coop-it", "Coop", ["it"], "standard", "#E3001B"),
    ("conad", "Conad", ["it"], "standard", "#E30613"),
    ("local", "My local store", [c[0] for c in COUNTRIES], "standard", "#E8553D"),
]

def main():
    os.makedirs(OUT, exist_ok=True)
    countries = []
    for c in COUNTRIES:
        d = {"id": c[0], "name": c[1], "flagEmoji": c[2], "currencyCode": c[3], "unitSystem": c[4],
             "regionPriceKey": c[5], "priceMultiplier": c[6]}
        if c[7]: d["priceNote"] = c[7]
        countries.append(d)
    stores = [{"id": s[0], "name": s[1], "countryIds": s[2], "tier": s[3], "brandColorHex": s[4]} for s in STORES]
    ingredients = [r[0] for r in ROWS]
    prices = {r[0]["id"]: r[1] for r in ROWS}
    def dump(name, obj):
        with open(os.path.join(OUT, name), "w", encoding="utf-8") as f:
            json.dump(obj, f, ensure_ascii=False, indent=1)
            f.write("\n")
    dump("countries.json", countries)
    dump("stores.json", stores)
    dump("ingredients.json", ingredients)
    dump("prices.json", prices)
    dump("recipes.json", RECIPES)
    print(f"{len(countries)} countries, {len(stores)} stores, {len(ingredients)} ingredients, {len(RECIPES)} recipes")

if __name__ == "__main__":
    main()
