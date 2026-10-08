import XCTest
@testable import ProductApp

final class ProductAppTests: XCTestCase {
    func testProgressCalculatorClampsInvalidCountsAndRoundsPercentage() {
        XCTAssertEqual(ProgressCalculator.percentage(completed: 2, total: 3), 67)
        XCTAssertEqual(ProgressCalculator.percentage(completed: 8, total: 4), 100)
        XCTAssertEqual(ProgressCalculator.percentage(completed: -1, total: 4), 0)
        XCTAssertEqual(ProgressCalculator.percentage(completed: 0, total: 0), 0)
    }
}
