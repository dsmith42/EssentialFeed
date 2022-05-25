//  
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 22/05/2022.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UIViewController {
	private var loader: FeedLoader?

	convenience init(loader: FeedLoader) {
		self.init()
		self.loader = loader
	}

	override func loadViewIfNeeded() {
		loader?.load() { _ in}
	}
}

final class FeedViewControllerTests: XCTestCase {

	func test_init_doesNotLoadFeed() throws {
		let loader = LoaderSpy()
		_ = FeedViewController(loader: loader)

		XCTAssertEqual(loader.loadCallCount, 0)
	}

	func test_viewDidLoad_loadsFeed() throws {
		let loader = LoaderSpy()
		let sut = FeedViewController(loader: loader)

		sut.loadViewIfNeeded()

		XCTAssertEqual(loader.loadCallCount, 1)
	}

	// MARK: - Helpers -

	class LoaderSpy: FeedLoader {
		private(set) var loadCallCount: Int = 0

		func load(completion: @escaping (FeedLoader.Result) -> Void) {
			loadCallCount += 1
		}
	}
}
