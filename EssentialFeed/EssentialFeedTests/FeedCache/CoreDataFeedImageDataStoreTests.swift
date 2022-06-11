//  
//  CoreDataFeedImageDataStoreTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 12/06/2022.
//

import XCTest
import EssentialFeed

extension CoreDataFeedStore: FeedImageDataStore {
	public func insert(_ data: Data, for url: URL, completion: @escaping (FeedImageDataStore.InsertionResult) -> Void) {

	}

	public func retrieve(dataForURL url: URL, completion: @escaping (FeedImageDataStore.RetrievalResult) -> Void) {
		completion(.success(.none))
	}
}


final class CoreDataFeedImageDataStoreTests: XCTestCase {

	func test_retrieveImageData_deliversNotFoundWhenEmpty() {
		let sut = makeSUT()

		expect(sut, toCompleteRevrievalWith: .success(.none), for: anyURL())
	}

	// MARK: - Helpers

	func makeSUT() -> CoreDataFeedStore {
		let storeBundle = Bundle(for: CoreDataFeedStore.self)
		let storeURL = URL(fileURLWithPath: "/dev/null")
		let sut = try! CoreDataFeedStore(storeURL: storeURL, bundle: storeBundle)
		trackForMemoryLeaks(sut)

		return sut
	}

	func expect(_ sut: FeedImageDataStore, toCompleteRevrievalWith expectedResult: FeedImageDataStore.RetrievalResult, for url: URL, file: StaticString = #file, line: UInt = #line) {
		let exp = expectation(description: "Wait for load completion")
		sut.retrieve(dataForURL: url) { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(receivedData), .success(expectedData)):
				XCTAssertEqual(receivedData, expectedData, file: file, line: line)

			default:
				XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
			}
			exp.fulfill()
		}
		wait(for: [exp], timeout: 1.0)
	}

}
