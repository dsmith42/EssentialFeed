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

	func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
		let image0 = makeImage(description: "A description", location: "A location")
		let image1 = makeImage(description: nil, location: "Another location")
		let image2 = makeImage(description: "A description", location: nil)
		let image3 = makeImage(description: nil, location: nil)

		let (sut, loader) = makeSUT()

		sut.loadViewIfNeeded()

		loader.completeFeedLoading(with: [image0], at: 0)
		assertThat(sut, isRendering: [image0])

		sut.simulateUserInitiatedFeedReload()
		loader.completeFeedLoading(with: [image0, image1, image2, image3], at: 1)
		assertThat(sut, isRendering: [image0, image1, image2, image3])
	}

	// MARK: - Helpers -

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = FeedViewController(loader: loader)
		trackForMemoryLeaks(loader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, loader)
	}

	private func makeImage(description: String? = nil, location: String? = nil, url: URL = anyURL()) -> FeedImage {
		return FeedImage(id: UUID(), description: description, location: location, url: url)
	}

	private func assertThat(_ sut: FeedViewController, isRendering feed: [FeedImage], file: StaticString = #file, line: UInt = #line) {
		guard sut.numberOfRenderedFeedImageViews() == feed.count else {
			return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedFeedImageViews()) instead.", file: file, line: line)
		}

		feed.enumerated().forEach { index, image in
			assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
		}
	}

	private func assertThat(_ sut: FeedViewController, hasViewConfiguredFor image: FeedImage, at index: Int, file: StaticString = #file, line: UInt = #line) {
		let view = sut.feedImageView(at: index)

		guard let cell = view as? FeedImageCell else {
			return XCTFail("Expected \(FeedImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
		}

		let shouldLocationBeVisible = (image.location != nil)
		XCTAssertEqual(cell.isShowingLocation, shouldLocationBeVisible, "Expected `isShowingLocation` to be \(shouldLocationBeVisible) for image view at index (\(index))", file: file, line: line)

		XCTAssertEqual(cell.locationText, image.location, "Expected location text to be \(String(describing: image.location)) for image view at index (\(index))", file: file, line: line)

		XCTAssertEqual(cell.descriptionText, image.description, "Expected description text to be \(String(describing: image.description)) for image view at index (\(index))", file: file, line: line)
	}

	class LoaderSpy: FeedLoader {
		private var completions = [(FeedLoader.Result) -> Void]()

		var loadCallCount: Int {
			return completions.count
		}

		func load(completion: @escaping (FeedLoader.Result) -> Void) {
			completions.append(completion)
		}

		func completeFeedLoading(with feed: [FeedImage] = [], at index: Int = 0) {
			completions[index](.success(feed))
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

	func feedImageView(at row: Int) -> UITableViewCell? {
		let ds = tableView.dataSource
		let indexPath = IndexPath(row: row, section: feedImagesSection)
		return ds?.tableView(tableView, cellForRowAt: indexPath)

	}

	func numberOfRenderedFeedImageViews() -> Int {
		return tableView.numberOfRows(inSection: feedImagesSection)
	}

	private var feedImagesSection: Int {
		return 0
	}
}

private extension FeedImageCell {
	var isShowingLocation: Bool {
		return !locationContainer.isHidden
	}

	var locationText: String? {
		return locationLabel.text
	}

	var descriptionText: String? {
		return descriptionLabel.text
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
