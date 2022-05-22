//  
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 22/05/2022.
//

import XCTest

final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {}
}

final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() throws {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: - Helpers -

    class LoaderSpy {
        private(set) var loadCallCount: Int = 0
    }
}
