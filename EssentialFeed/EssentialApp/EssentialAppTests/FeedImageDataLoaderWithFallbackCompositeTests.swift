//  
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 16/07/2022.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
	private class Task: FeedImageDataLoaderTask {
		func cancel() {}
	}

	init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {}

	func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		return Task()
	}
}

final class FeedImageDataLoaderWithFallbackCompositeTests: XCTestCase {

	func test_init_doesNotLoadImageData() {
		let primary = LoaderSpy()
		let fallback = LoaderSpy()
		_ = FeedImageDataLoaderWithFallbackComposite(primary: primary, fallback: fallback)

		XCTAssertTrue(primary.loadedURLs.isEmpty, "Expected no loaded URLs in the primary loader")
		XCTAssertTrue(fallback.loadedURLs.isEmpty, "Expected no loaded URLs in the fallback loader")
	}

	// MARK: - Helpers

	private class LoaderSpy: FeedImageDataLoader {
		private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
		var loadedURLs: [URL] {
			return messages.map { $0.url }
		}

		private struct Task: FeedImageDataLoaderTask {
			func cancel() {}
		}

		func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
			messages.append((url, completion))
			return Task()
		}
	}
}
