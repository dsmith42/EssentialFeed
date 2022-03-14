import XCTest

class FeedStore {
    var deleteCacheCallCount = 0
}

class LocalFeedLoader {
    init(store: FeedStore) {}
}

final class CacheFeedUseCaseTests: XCTestCase {

    func test() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)

        XCTAssertEqual(store.deleteCacheCallCount, 0)
    }
}
