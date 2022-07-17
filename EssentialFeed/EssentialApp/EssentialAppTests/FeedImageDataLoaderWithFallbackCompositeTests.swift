//  
//  FeedImageDataLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 16/07/2022.
//

import XCTest
import EssentialFeed

class FeedImageDataLoaderWithFallbackComposite: FeedImageDataLoader {
	private let primary: FeedImageDataLoader
	private let fallback: FeedImageDataLoader

	private class Task: FeedImageDataLoaderTask {
		func cancel() {}
	}

	init(primary: FeedImageDataLoader, fallback: FeedImageDataLoader) {
		self.primary = primary
		self.fallback = fallback
	}

	func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		_ = primary.loadImageData(from: url) { _ in }
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

	func test_loadImageData_loadsFromPrimaryFirst() {
		let url = anyURL()
		let primaryLoader = LoaderSpy()
		let fallbackLoader = LoaderSpy()
		let sut = FeedImageDataLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)

		_ = sut.loadImageData(from: url) { _ in }

		XCTAssertEqual(primaryLoader.loadedURLs, [url])
		XCTAssertTrue(fallbackLoader.loadedURLs.isEmpty)
	}

	// MARK: - Helpers

	private func anyURL() -> URL {
		return URL(string: "https://any-url.com")!
	}

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
