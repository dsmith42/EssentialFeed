//  
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 22/05/2022.
//

import XCTest
import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewControllerTests: XCTestCase {

	func test_loadFeedActions_requestFeedFromLoader() throws {
		let (sut, loader) = makeSUT()
		XCTAssertEqual(loader.loadCallCount, 0)

		sut.loadViewIfNeeded()
		XCTAssertEqual(loader.loadCallCount, 1)

		sut.refreshControl?.simulatePullToRefresh()
		XCTAssertEqual(loader.loadCallCount, 2)

		sut.refreshControl?.simulatePullToRefresh()
		XCTAssertEqual(loader.loadCallCount, 3)
	}

	func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() throws {
		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()
		XCTAssertTrue(sut.isShowingLoadingIndicator)

		loader.completeFeedLoading(at: 0)
		XCTAssertFalse(sut.isShowingLoadingIndicator)

		sut.simulateUserInitiatedFeedReload()
		XCTAssertTrue(sut.isShowingLoadingIndicator)

		loader.completeFeedLoading(at: 1)
		XCTAssertFalse(sut.isShowingLoadingIndicator)
	}

	// MARK: - Helpers -

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = FeedViewController(loader: loader)
		trackForMemoryLeaks(loader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, loader)
	}

	class LoaderSpy: FeedLoader {
		private var completions = [(FeedLoader.Result) -> Void]()

		var loadCallCount: Int {
			return completions.count
		}

		func load(completion: @escaping (FeedLoader.Result) -> Void) {
			completions.append(completion)
		}

		func completeFeedLoading(at index: Int) {
			completions[index](.success([]))
		}
	}
}

private extension FeedViewController {
	var isShowingLoadingIndicator: Bool {
		refreshControl?.isRefreshing == true
	}

	func simulateUserInitiatedFeedReload() {
		refreshControl?.simulatePullToRefresh()
	}
}

private extension UIRefreshControl {
	func simulatePullToRefresh() {
		allTargets.forEach { target in
			actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
				(target as NSObject).perform(Selector($0))
			}
		}
	}
}
