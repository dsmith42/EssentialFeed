//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 05/06/2022.
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
	func retrieve(dataForURL url: URL)
}

final class LocalFeedImageDataLoader {
	private struct Task: FeedImageDataLoaderTask {
		func cancel() {}
	}

	private let store: FeedImageDataStore

	init(store: FeedImageDataStore) {
		self.store = store
	}

	func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		store.retrieve(dataForURL: url)
		return Task()
	}
}

class LocalFeedImageDataLoaderTests: XCTestCase {

	func test_init_doesNotMessageStoreUponCreation() {
		let (_, store) = makeSUT()

		XCTAssertTrue(store.receivedMessages.isEmpty)
	}

	func test_LoadImageDataFromURL_requestsStoredDataForURL() {
		let (sut, store) = makeSUT()
		let url = anyURL()

		_ = sut.loadImageData(from: url) { _ in }

		XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
	}

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
		let store = StoreSpy()
		let sut = LocalFeedImageDataLoader(store: store)
		trackForMemoryLeaks(store, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, store)
	}

	private class StoreSpy: FeedImageDataStore {
		enum Message: Equatable {
			case retrieve(dataFor: URL)
		}

		private(set) var receivedMessages = [Message]()

		func retrieve(dataForURL url: URL) {
			receivedMessages.append(.retrieve(dataFor: url))
		}
	}
}
