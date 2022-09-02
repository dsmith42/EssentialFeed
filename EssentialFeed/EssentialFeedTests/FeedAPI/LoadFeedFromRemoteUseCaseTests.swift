//
//  LoadFeedFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 19/02/2022.
//

import XCTest
import EssentialFeed

class LoadFeedFromRemoteUseCaseTests: XCTestCase {
	
		func test_load_deliversErrorOnNon200Response() {
		let (sut, client) = makeSUT()
		
		let samples = [199, 201, 300, 400, 500]
		samples.enumerated().forEach { index, code in
			let json = makeItemsJSON([])
			expect(sut, toCompleteWithResult: failure(.invalidData), when: {
				client.complete(withStatusCode: code, data: json, at: index)
			})
		}
	}
	
	func test_load_deliversErrorOn200ResponseWithInvadlidJSON()
	{
		let (sut, client) = makeSUT()
		
		expect(sut, toCompleteWithResult: failure(.invalidData), when: {
			let invalidJSON = Data("Any JSON".utf8)
			client.complete(withStatusCode: 200, data: invalidJSON)
		})
	}
	
	func test_load_deliversNoItemsOn200ResponseWithNoData() {
		let (sut, client) = makeSUT()
		
		expect(sut, toCompleteWithResult: .success([]), when: {
			let emptyListJSON = makeItemsJSON([])
			client.complete(withStatusCode: 200, data: emptyListJSON)
		})
	}
	
	func test_load_deliversItemsOn200ResponseWithValidData() {
		let (sut, client) = makeSUT()
		
		let item1 = makeItem(id: UUID(),
							 description: nil,
							 location: nil,
							 imageURL: URL(string: "https://any-url.com")!)
		
		let item2 = makeItem(id: UUID(),
							 description: "A description",
							 location: "A location",
							 imageURL: URL(string: "https://any-url.com")!)
		
		let items = [item1.model, item2.model]
		
		expect(sut, toCompleteWithResult: .success(items), when: {
			client.complete(withStatusCode: 200, data: makeItemsJSON([item1.json, item2.json]))
		})
	}

	// MARK: - Helpers
	
	private func makeSUT(url: URL = URL(string: "https://any-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(url: url, client: client)
		trackForMemoryLeaks(sut)
		trackForMemoryLeaks(client)
		return (sut, client)
	}
	
	private func failure(_ error: RemoteFeedLoader.Error) -> RemoteFeedLoader.Result {
		return .failure(error)
	}
	
	private func makeItem(id: UUID = UUID(),
						  description: String? = nil,
						  location: String? = nil,
						  imageURL: URL = URL(string: "https://any-url.com")!) -> (model: FeedImage, json: [String: Any]) {
		let model = FeedImage(id: id, description: description, location: location, url: imageURL)
		let json = ["id": id.uuidString,
					"description": description,
					"location": location,
					"image": imageURL.absoluteString]
			.compactMapValues { $0 }
		return (model, json)
	}
	
	private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
		let itemsJSON = ["items": items]
		return try! JSONSerialization.data(withJSONObject: itemsJSON)
	}
	
	private func expect(_ sut: RemoteFeedLoader,
						toCompleteWithResult expectedResult: RemoteFeedLoader.Result,
						when action: () -> Void,
						file: StaticString = #filePath,
						line: UInt = #line) {
		
		let exp = expectation(description: "Wait for completion.")
		sut.load { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(receivedItems), .success(expectedItems)):
				XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
			case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
				XCTAssertEqual(receivedError, expectedError, file: file, line: line)
			default:
				XCTFail("Expected result \(expectedResult) got \(receivedResult) instead.")
			}
			exp.fulfill()
		}
		
		action()
		
		wait(for: [exp], timeout: 1.0)
	}
	
}
