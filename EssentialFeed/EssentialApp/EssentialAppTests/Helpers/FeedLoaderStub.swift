//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 18/07/2022.
//

import EssentialFeed

class FeedLoaderStub {
	private let result: Swift.Result<[FeedImage], Error>

	init(result: Swift.Result<[FeedImage], Error>) {
		self.result = result
	}

	func load(completion: @escaping (Swift.Result<[FeedImage], Error>) -> Void) {
		completion(result)
	}
}
