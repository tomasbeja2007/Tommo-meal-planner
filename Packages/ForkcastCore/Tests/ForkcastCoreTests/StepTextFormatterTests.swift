import XCTest
@testable import ForkcastCore

final class StepTextFormatterTests: XCTestCase {
    func testPairedTemperatureKeepsTheReadersHalf() {
        XCTAssertEqual(StepTextFormatter.string("Heat the oven to 200°C (400°F).", system: .metric), "Heat the oven to 200°C.")
        XCTAssertEqual(StepTextFormatter.string("Heat the oven to 200°C (400°F).", system: .imperial), "Heat the oven to 400°F.")
        XCTAssertEqual(StepTextFormatter.string("Bake at 350°F (180°C) for 20 minutes.", system: .metric), "Bake at 180°C for 20 minutes.")
    }

    func testLoneTemperaturesConvert() {
        XCTAssertEqual(StepTextFormatter.string("Air fry at 180°C.", system: .imperial), "Air fry at 350°F.")
        XCTAssertEqual(StepTextFormatter.string("Cook to 75°C inside.", system: .imperial), "Cook to 165°F inside.")
        XCTAssertEqual(StepTextFormatter.string("Roast at 425°F.", system: .metric), "Roast at 220°C.")
    }

    func testVolumes() {
        XCTAssertEqual(StepTextFormatter.string("Pour 350 ml boiling water over.", system: .imperial), "Pour 1½ cups boiling water over.")
        XCTAssertEqual(StepTextFormatter.string("Add 1.5 litres water.", system: .imperial), "Add 6¼ cups water.")
        XCTAssertEqual(StepTextFormatter.string("Cover with 150 ml water.", system: .imperial), "Cover with ⅔ cup water.")
        XCTAssertEqual(StepTextFormatter.string("Add 2 cups stock.", system: .metric), "Add 480 ml stock.")
        XCTAssertEqual(StepTextFormatter.string("Pour 350 ml boiling water over.", system: .metric), "Pour 350 ml boiling water over.")
    }

    func testLengthsAndMasses() {
        XCTAssertEqual(StepTextFormatter.string("Spread about 1 cm thick.", system: .imperial), "Spread about ½ inch thick.")
        XCTAssertEqual(StepTextFormatter.string("Roll into a 20 cm circle.", system: .imperial), "Roll into an 8-inch circle.")
        XCTAssertEqual(StepTextFormatter.string("Use an 8-inch pan.", system: .metric), "Use a 20 cm pan.")
        XCTAssertEqual(StepTextFormatter.string("Slice into 1 cm pinwheels.", system: .imperial), "Slice into ½-inch pinwheels.")
        XCTAssertEqual(StepTextFormatter.string("Add 400 g chicken.", system: .imperial), "Add 14 oz chicken.")
    }

    func testWordsThatLookLikeUnitsAreLeftAlone() {
        let text = "Fill the lettuce cups, add 2 large eggs, 1 lime and 3 garlic cloves."
        XCTAssertEqual(StepTextFormatter.string(text, system: .metric), text)
        XCTAssertEqual(StepTextFormatter.string(text, system: .imperial), text)
        XCTAssertEqual(StepTextFormatter.string("Cut into 2–3 cm pieces.", system: .imperial), "Cut into 2–3 cm pieces.")
    }

    func testEveryBundledRecipeReadsInOneSystem() {
        for recipe in FoodCatalog.bundled.recipes {
            for step in recipe.steps {
                let metric = StepTextFormatter.string(step, system: .metric)
                let imperial = StepTextFormatter.string(step, system: .imperial)
                XCTAssertFalse(metric.contains("°F"), "\(recipe.id): \(metric)")
                XCTAssertFalse(imperial.contains("°C"), "\(recipe.id): \(imperial)")
                XCTAssertNil(imperial.range(of: #"\d\s*(ml|cm|litres?)\b"#, options: .regularExpression), "\(recipe.id): \(imperial)")
            }
        }
    }
}
