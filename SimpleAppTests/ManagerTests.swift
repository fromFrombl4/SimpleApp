import XCTest
@testable import SimpleApp

class ManagerTests: XCTestCase {
    private func make100Posts() -> [Post] {
        return (0..<100).map { Post.mock(userId: $0, id: $0) }
    }

    override func setUp() {
        super.setUp()
        Manager.shared.failureChance = 0
        Manager.shared.updateDataSource(using: make100Posts())
    }

    override func tearDown() {
        Manager.shared.failureChance = 0.2
        Manager.shared.resetDataSource()
        super.tearDown()
    }

    func test_loadIntems_limit5offset0_returns5Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Post]!

        Manager.shared
            .loadItems(offset: 0, limit: 5) {
                switch $0 {
                case .failure:
                    items = []
                case .success(let feed):
                    items = feed
                }
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(items.map { $0.id }, [0, 1, 2, 3, 4])
    }

    func test_loadIntems_limit5offset5_returns5Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Post]!

        Manager.shared
            .loadItems(offset: 5, limit: 5) {
                switch $0 {
                case .failure:
                    items = []
                case .success(let feed):
                    items = feed
                }
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items.map { $0.id }, [5, 6, 7, 8, 9])
    }

    func test_loadIntems_limit10offset5_returns10Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Post]!

        Manager.shared
            .loadItems(offset: 5, limit: 10) {
                switch $0 {
                case .failure:
                    items = []
                case .success(let feed):
                    items = feed
                }
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items.map { $0.id }, [5, 6, 7, 8, 9, 10, 11, 12, 13, 14])
    }

    func test_loadIntems_limit5offset96_returns4Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Post]!

        Manager.shared
            .loadItems(offset: 96, limit: 5) {
                switch $0 {
                case .failure:
                    items = []
                case .success(let feed):
                    items = feed
                }
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items.map { $0.id }, [96, 97, 98, 99])
    }

    func test_loadIntems_limit5offset100_returns0Items() {
        let expectation = self.expectation(description: "loadItems")
        var items: [Post]!

        Manager.shared
            .loadItems(offset: 100, limit: 5) {
                switch $0 {
                case .failure:
                    items = []
                case .success(let feed):
                    items = feed
                }
                expectation.fulfill()
            }
        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(items.map { $0.id }, [])
    }
}
