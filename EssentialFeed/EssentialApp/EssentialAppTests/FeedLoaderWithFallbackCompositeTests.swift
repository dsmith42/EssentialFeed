//
//  FeedLoaderWithFallbackCompositeTests.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 20/06/2022.
//

import XCTest
import EssentialFeed
import EssentialApp

class FeedLoaderWithFallbackCompositeTests: XCTestCase {

	func test_load_deliversPrimaryFeedOnPrimaryLoaderSuccess() {
		let primaryFeed = uniqueFeed()
		let fallbackFeed = uniqueFeed()
		let sut = makeSUT(primaryResult: .success(primaryFeed), fallbackResult: .success(fallbackFeed))

		expect(sut, toCompleteWith: .success(primaryFeed))
	}

	func test_load_deliversFallbackFeedOnPrimaryFailure() {
		let fallbackFeed = uniqueFeed()
		let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .success(fallbackFeed))

		expect(sut, toCompleteWith: .success(fallbackFeed))
	}

	func test_load_deliversErrorOnBothPrimaryAndFallbackLoaderFailure() {
		let sut = makeSUT(primaryResult: .failure(anyNSError()), fallbackResult: .failure(anyNSError()))

		expect(sut, toCompleteWith: .failure(anyNSError()))
	}

	// MARK: - Helpers -

	private func makeSUT(primaryResult: FeedLoader.Result, fallbackResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) -> FeedLoader {
		let primaryLoader = FeedLoaderStub(result: primaryResult)
		let fallbackLoader = FeedLoaderStub(result: fallbackResult)
		let sut = FeedLoaderWithFallbackComposite(primary: primaryLoader, fallback: fallbackLoader)
		trackForMemoryLeaks(primaryLoader, file: file, line: line)
		trackForMemoryLeaks(fallbackLoader, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return sut
	}

}
