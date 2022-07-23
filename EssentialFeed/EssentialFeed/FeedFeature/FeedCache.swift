//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Dan Smith on 18/07/2022.
//

public protocol FeedCache {
	typealias Result = Swift.Result<Void, Error>

	func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}

