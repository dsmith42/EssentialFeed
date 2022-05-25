//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Dan Smith on 14/03/2022.
//

import Foundation

public typealias CachedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
	typealias DeletionResult = Result<Void, Error>
	typealias DeletionCompletion = (DeletionResult) -> Void

	typealias InsertionResult = Result<Void, Error>
	typealias InsertionCompletion = (InsertionResult) -> Void

	typealias RetrievalResult = Result<CachedFeed?, Error>
	typealias RetrievalCompletion = (RetrievalResult) -> Void

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch on appropriate threads, if needed.
	func deleteCachedFeed(completion: @escaping DeletionCompletion)

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch on appropriate threads, if needed.
	func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion)

	/// The completion handler can be invoked in any thread.
	/// Clients are responsible to dispatch on appropriate threads, if needed.
	func retrieve(completion: @escaping RetrievalCompletion)
}
