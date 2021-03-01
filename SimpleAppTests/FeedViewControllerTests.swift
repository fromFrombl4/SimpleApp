import XCTest
@testable import SimpleApp

class FeedViewControllerTests: XCTestCase {
    var sut: FeedViewController!
    var fetcher: FetcherProtocolMock!

    override func setUp() {
        super.setUp()

        fetcher = FetcherProtocolMock()
        sut = FeedViewController(fetcher: fetcher)
    }

    override func tearDown() {
        sut = nil

        fetcher = nil
        super.tearDown()
    }

    func test_viewWillAppear_always_shouldCallFetcher() {
        sut.loadViewIfNeeded()
        sut.viewWillAppear(false)

        XCTAssertEqual(fetcher.loadItemsOffsetLimitCompletionCalled, true)
    }
}
