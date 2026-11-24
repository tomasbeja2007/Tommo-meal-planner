import XCTest
@testable import ForkcastCore

final class RecipeTextParserTests: XCTestCase {
    func testCaptionWithHeadersAndBullets() {
        let caption = """
        Creamy garlic tuscan chicken 🍗✨
        Serves 4 · ready in 30 mins
        Ingredients:
        - 2 chicken breasts
        - 1 tbsp olive oil
        - 3 cloves garlic, minced
        - 200ml double cream
        - 100g spinach
        - salt and pepper to taste
        Method:
        1. Season and fry the chicken for 6 minutes each side.
        2. Add the garlic and cook for 1 minute.
        3. Pour in the cream and simmer for 5 minutes.
        4. Stir in the spinach and serve.
        #dinner #easyrecipes @chefsomeone
        """
        let parsed = RecipeTextParser.parse(caption)
        XCTAssertEqual(parsed.title, "Creamy garlic tuscan chicken")
        XCTAssertEqual(parsed.servings, 4)
        XCTAssertEqual(parsed.minutes, 30)
        XCTAssertEqual(parsed.ingredients.count, 6)
        XCTAssertEqual(parsed.ingredients[0].amount, 2)
        XCTAssertEqual(parsed.ingredients[0].name, "chicken breasts")
        XCTAssertEqual(parsed.ingredients[2].unit, .clove)
        XCTAssertEqual(parsed.ingredients[3].amount, 200)
        XCTAssertEqual(parsed.ingredients[3].unit, .ml)
        XCTAssertEqual(parsed.ingredients[3].name, "double cream")
        XCTAssertEqual(parsed.ingredients[4].unit, .g)
        XCTAssertEqual(parsed.ingredients[5].unit, .toTaste)
        XCTAssertEqual(parsed.steps.count, 4)
        XCTAssertTrue(parsed.steps[0].hasPrefix("Season and fry"))
        XCTAssertFalse(parsed.steps.joined().contains("#dinner"))
    }

    func testUnicodeFractionsAndEmojiBullets() {
        let caption = """
        5 minute peanut noodles
        You'll need
        ✅ 150g rice noodles
        ✅ 2 tbsp peanut butter
        ✅ ½ lime
        ✅ 1½ tbsp soy sauce
        Steps
        👉 Soak the noodles in boiling water.
        👉 Whisk the sauce and toss everything together.
        """
        let parsed = RecipeTextParser.parse(caption)
        XCTAssertEqual(parsed.title, "5 minute peanut noodles")
        XCTAssertEqual(parsed.ingredients.count, 4)
        XCTAssertEqual(parsed.ingredients[2].amount ?? 0, 0.5, accuracy: 0.001)
        XCTAssertEqual(parsed.ingredients[2].name, "lime")
        XCTAssertEqual(parsed.ingredients[3].amount ?? 0, 1.5, accuracy: 0.001)
        XCTAssertEqual(parsed.ingredients[3].unit, .tbsp)
        XCTAssertEqual(parsed.steps.count, 2)
    }

    func testNoHeadersClassifiesLines() {
        let caption = """
        Easy lentil soup
        1 onion
        2 carrots
        200 g red lentils
        1 litre vegetable stock
        Fry the onion and carrots for 5 minutes.
        Add the lentils and stock and simmer for 20 minutes.
        Blend until smooth and season.
        """
        let parsed = RecipeTextParser.parse(caption)
        XCTAssertEqual(parsed.title, "Easy lentil soup")
        XCTAssertEqual(parsed.ingredients.map { $0.name }, ["onion", "carrots", "red lentils", "vegetable stock"])
        XCTAssertEqual(parsed.ingredients[3].unit, .l)
        XCTAssertEqual(parsed.steps.count, 3)
    }

    func testSingleLineCaptionWithInlineIngredients() {
        let caption = "Midweek fajitas 🌯 Ingredients: 2 peppers, 1 red onion, 500g chicken breast, 8 tortillas • Method: slice everything. Roast for 20 minutes. Wrap and eat."
        let parsed = RecipeTextParser.parse(caption)
        XCTAssertEqual(parsed.title, "Midweek fajitas")
        XCTAssertEqual(parsed.ingredients.count, 4)
        XCTAssertEqual(parsed.ingredients[2].amount, 500)
        XCTAssertEqual(parsed.ingredients[2].unit, .g)
        XCTAssertEqual(parsed.ingredients[2].name, "chicken breast")
        XCTAssertEqual(parsed.steps.count, 3)
    }

    func testVideoOnlyCaptionFindsNothing() {
        let caption = "the best pasta I've ever made 😭🍝 recipe in the video! #pasta #foodtok #fyp"
        let parsed = RecipeTextParser.parse(caption)
        XCTAssertEqual(parsed.title, "the best pasta I've ever made")
        XCTAssertFalse(parsed.hasContent)
    }

    func testIngredientLineParsing() {
        let a = RecipeTextParser.parseIngredientLine("1 1/2 cups of milk")
        XCTAssertEqual(a?.amount ?? 0, 1.5, accuracy: 0.001)
        XCTAssertEqual(a?.unit, .cup)
        XCTAssertEqual(a?.name, "milk")
        let b = RecipeTextParser.parseIngredientLine("Salt")
        XCTAssertNil(b?.amount)
        XCTAssertEqual(b?.name, "Salt")
        let c = RecipeTextParser.parseIngredientLine("2-3 tablespoons honey")
        XCTAssertEqual(c?.amount, 2)
        XCTAssertEqual(c?.unit, .tbsp)
        XCTAssertNil(RecipeTextParser.parseIngredientLine("   "))
    }
}
