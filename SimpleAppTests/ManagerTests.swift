import XCTest
@testable import SimpleApp

class ManagerTests: XCTestCase {

    func test_loadIntems_limit5offset0_returns5Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Int]!

        Manager.shared
            .loadItems(offset: 0, limit: 5) {
                items = $0
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items, [0, 1, 2, 3, 4])
    }

    func test_loadIntems_limit5offset5_returns5Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Int]!

        Manager.shared
            .loadItems(offset: 5, limit: 5) {
                items = $0
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items, [5, 6, 7, 8, 9])
    }

    func test_loadIntems_limit10offset5_returns10Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Int]!

        Manager.shared
            .loadItems(offset: 5, limit: 10) {
                items = $0
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items, [5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    }

    func test_loadIntems_limit5offset96_returns4Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Int]!

        Manager.shared
            .loadItems(offset: 96, limit: 5) {
                items = $0
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items, [96, 97, 98, 99])
    }

    func test_loadIntems_limit5offset100_returns0Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Int]!

        Manager.shared
            .loadItems(offset: 96, limit: 5) {
                items = $0
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items, [])
    }
}
