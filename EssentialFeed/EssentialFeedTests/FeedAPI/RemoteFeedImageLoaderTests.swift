//  
//  RemoteFeedImageLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 05/06/2022.
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
	var client: HTTPClient

	init(client: HTTPClient) {
		self.client = client
	}

	func loadImageData(from url: URL, completion: @escaping (Any) -> Void) {
		client.get(from: url) { _ in }
	}
}

final class RemoteFeedImageLoaderTests: XCTestCase {

	func test_init_doesNotPerformAnyURLRequest() {
		let (_, client) = makeSUT()

		XCTAssertTrue(client.requestedURLs.isEmpty)
	}

	func test_loadImageDataFromURL_requestsDataFromURL() {
		let url = URL(string: "https://a-test-url.com")!
		let (sut, client) = makeSUT()

		sut.loadImageData(from: url) { _ in }

		XCTAssertEqual(client.requestedURLs, [url])
	}

	// MARK: - Helpers -

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedImageDataLoader(client: client)
		trackForMemoryLeaks(client, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, client)
	}

	final class HTTPClientSpy: HTTPClient {
		var requestedURLs = [URL]()

		func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
			requestedURLs.append(url)
		}
	}
}
