//
//  XCTestCase+FeedLoader.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 18/07/2022.
//

import XCTest
import EssentialFeed

extension XCTestCase {

	func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.Result, file: StaticString = #file, line: UInt = #line) {
		let exp = expectation(description: "Wait for load completion")

		sut.load { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(receievedFeed), .success(expectedFeed)):
				XCTAssertEqual(receievedFeed, expectedFeed, file: file, line: line)

			case (.failure, .failure):
				break

			default:
				XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
			}

			exp.fulfill()
		}
		wait(for: [exp], timeout: 1.0)
	}

}
