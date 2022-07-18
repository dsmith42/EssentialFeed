//  
//  FeedImageDataLoaderDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 18/07/2022.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderDecorator: FeedImageDataLoader {
	private let decoratee: FeedImageDataLoader

	init(decoratee: FeedImageDataLoader) {
		self.decoratee = decoratee
	}

	func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		return decoratee.loadImageData(from: url, completion: completion)
	}

}

final class FeedImageDataLoaderDecoratorTests: XCTestCase, FeedImageDataLoaderTestCase {

	func test_init_doesNotLoadImageData() {
		let (_, loader) = makeSUT()

		XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
	}

	func test_loadImageData_loadsFromLoader() {
		let (sut, loader) = makeSUT()
		let url = anyURL()

		_ = sut.loadImageData(from: url) { _ in }

		XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
	}

	func test_cancelLoadImageData_cancelsLoaderTask() {
		let url = anyURL()
		let (sut, loader) = makeSUT()

		let task = sut.loadImageData(from: url) { _ in }
		task.cancel()

		XCTAssertEqual(loader.cancelledURLs, [url], "Expected to cancel URL loading from loader")
	}

	func test_loadImageData_deliversDataOnLoaderSuccess() {
		let imageData = anyData()
		let (sut, loader) = makeSUT()

		expect(sut, toCompleteWith: .success(imageData), when: {
			loader.complete(with: imageData)
		})
	}

	func test_loadImageData_deliversErrorOnLoaderFailure() {
		let (sut, loader) = makeSUT()

		expect(sut, toCompleteWith: .failure(anyNSError()), when: {
			loader.complete(with: anyNSError())
		})
	}

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoaderDecorator, loader: FeedImageDataLoaderSpy) {
		let loader = FeedImageDataLoaderSpy()
		let sut = FeedImageDataLoaderDecorator(decoratee: loader)
		trackForMemoryLeaks(loader)
		trackForMemoryLeaks(sut)
		return (sut, loader)
	}

}
