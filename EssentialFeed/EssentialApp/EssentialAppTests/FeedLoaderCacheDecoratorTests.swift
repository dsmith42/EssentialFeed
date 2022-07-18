//  
//  FeedLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 18/07/2022.
//

import XCTest
import EssentialFeed

class FeedLoaderCacheDecorator: FeedLoader {
	private let decoratee: FeedLoader

	init(decoratee: FeedLoader) {
		self.decoratee = decoratee
	}

	func load(completion: @escaping (FeedLoader.Result) -> Void) {
		decoratee.load(completion: completion)
	}
}

final class FeedLoaderCacheDecoratorTests: XCTestCase {

	func test_load_deliversFeedOnLoaderSuccess() {
		let feed = uniqueFeed()
		let loader = FeedLoaderStub(result: .success(feed))
		let sut = FeedLoaderCacheDecorator(decoratee: loader)

		expect(sut, toCompleteWith: .success(feed))
	}

	func test_load_deliversErrorOnLoaderFailure() {
		let loader = FeedLoaderStub(result: .failure(anyNSError()))
		let sut = FeedLoaderCacheDecorator(decoratee: loader)

		expect(sut, toCompleteWith: .failure(anyNSError()))
	}

}
