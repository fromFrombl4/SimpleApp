import XCTest
@testable import SimpleApp

class ViewControllerTests: XCTestCase {
    var sut: ViewController!

    override func setUp() {
        super.setUp()

        sut = ViewController()
    }

    override func tearDown() {
        sut = nil

        super.tearDown()
    }

    func test_loading() {
        sut.loadViewIfNeeded()

        XCTAssertNotNil(sut.label)
    }
}
