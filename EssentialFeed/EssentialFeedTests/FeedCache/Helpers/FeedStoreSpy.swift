//
//  FeedStoreSpy.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 14/03/2022.
//

import Foundation
import EssentialFeed

class FeedStoreSpy: FeedStore {
	var receivedMessages = [ReceivedMessage]()

	enum ReceivedMessage: Equatable {
		case deleteCachedFeed
		case insert([LocalFeedImage], Date)
		case retrieve
	}

	private var deletionCompletions = [DeletionCompletion]()
	private var insertionCompletions = [InsertionCompletion]()
	private var retrievalCompletions = [RetrievalCompletion]()

	func deleteCachedFeed(completion: @escaping DeletionCompletion) {
		deletionCompletions.append(completion)
		receivedMessages.append(.deleteCachedFeed)
	}

	func completeDeletion(with error: Error, at index: Int = 0) {
		deletionCompletions[index](.failure(error))
	}

	func completeDeletionSuccessfully(at index: Int = 0) {
		deletionCompletions[index](.success(()))
	}

	func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
		insertionCompletions.append(completion)
		receivedMessages.append(.insert(feed, timestamp))
	}

	func completeInsertion(with error: Error, at index: Int = 0) {
		insertionCompletions[index](.failure(error))
	}

	func completeInsertionSuccessfully(at index: Int = 0){
		insertionCompletions[index](.success(()))
	}

	func retrieve(completion: @escaping RetrievalCompletion) {
		retrievalCompletions.append(completion)
		receivedMessages.append(.retrieve)
	}

	func completeRetrieval(with error: Error, at index: Int = 0) {
		retrievalCompletions[index](.failure(error))
	}

	func completeRetrievalWithEmptyCache(at index: Int = 0) {
		retrievalCompletions[index](.success(nil))
	}

	func completeRetrieval(with feed: [LocalFeedImage], timestamp: Date, at index: Int = 0) {
		retrievalCompletions[index](.success(.some(CachedFeed(feed: feed, timestamp: timestamp))))
	}
}
