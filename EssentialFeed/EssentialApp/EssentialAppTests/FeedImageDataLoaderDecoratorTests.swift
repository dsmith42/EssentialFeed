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

final class FeedImageDataLoaderDecoratorTests: XCTestCase {

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

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoaderDecorator, loader: LoaderSpy) {
		let loader = LoaderSpy()
		let sut = FeedImageDataLoaderDecorator(decoratee: loader)
		trackForMemoryLeaks(loader)
		trackForMemoryLeaks(sut)
		return (sut, loader)
	}

	private class LoaderSpy: FeedImageDataLoader {
		private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
		var loadedURLs: [URL] {
			return messages.map { $0.url }
		}

		private (set) var cancelledURLs = [URL]()

		private struct Task: FeedImageDataLoaderTask {
			let callback: () -> Void
			func cancel() { callback() }

		}

		func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
			messages.append((url, completion))
			return Task { [weak self] in
				self?.cancelledURLs.append(url)
			}
		}

		func complete(with error: Error, at index: Int = 0) {
			messages[index].completion(.failure(error))
		}

		func complete(with data: Data, at index: Int = 0) {
			messages[index].completion(.success(data))
		}
	}
}
