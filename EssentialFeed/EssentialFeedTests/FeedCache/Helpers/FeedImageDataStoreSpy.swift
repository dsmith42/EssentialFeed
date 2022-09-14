//
//  FeedImageDataStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 11/06/2022.
//

import Foundation
import EssentialFeed

class FeedImageDataStoreSpy: FeedImageDataStore {
	enum Message: Equatable {
		case retrieve(dataFor: URL)
		case insert(data: Data, for: URL)
	}

	private(set) var receivedMessages = [Message]()
	private var insertionResult: Result<Void, Error>?
	private var retrievalResult: Result<Data?, Error>?

	func insert(_ data: Data, for url: URL) throws {
		receivedMessages.append(.insert(data: data, for: url))
		try insertionResult?.get()
	}

	func completeInsertion(with error: Error) {
		insertionResult = .failure(error)
	}

	func completeInsertionSuccessfully() {
		insertionResult = .success(())
	}

	func retrieve(dataForURL url: URL) throws -> Data? {
		receivedMessages.append(.retrieve(dataFor: url))
		return try retrievalResult?.get()
	}

	func completeRetrieval(with error: Error, at index: Int = 0) {
		retrievalResult = .failure(error)
	}

	func completeRetrieval(with data: Data?, at index: Int = 0) {
		retrievalResult = .success(data)
	}

}
