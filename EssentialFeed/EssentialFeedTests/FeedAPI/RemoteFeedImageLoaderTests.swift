//  
//  RemoteFeedImageLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 05/06/2022.
//

import XCTest

class RemoteFeedImageDataLoader {
	init(client: Any) {}
}

final class RemoteFeedImageLoaderTests: XCTestCase {

	func test_init_doesNotPerformAnyURLRequest() {
		let (_, client) = makeSUT()

		XCTAssertTrue(client.requestedURLs.isEmpty)
	}

	// MARK: - Helpers -

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedImageDataLoader(client: client)
		trackForMemoryLeaks(client, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, client)
	}

	final class HTTPClientSpy {
		var requestedURLs = [URL]()
	}
}
