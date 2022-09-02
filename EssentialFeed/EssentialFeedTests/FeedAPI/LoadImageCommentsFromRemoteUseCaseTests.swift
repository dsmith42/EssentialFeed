//  
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 02/09/2022.
//

import XCTest
import EssentialFeed

final class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let (_, client) = makeSUT()

		XCTAssertTrue(client.requestedURLs.isEmpty)
	}

	func test_load_requestsDataFromURL() {
		let url = URL(string: "https://a-given-url")!
		let (sut, client) = makeSUT(url: url)

		sut.load() { _ in }

		XCTAssertEqual(client.requestedURLs, [url])
	}

	func test_loadTwice_requestsDataFromURLTwice() {
		let url = URL(string: "https://a-given-url")!
		let (sut, client) = makeSUT(url: url)

		sut.load() { _ in }
		sut.load() { _ in }

		XCTAssertEqual(client.requestedURLs, [url, url])
	}

	func test_load_deliversErrorOnClientError() {
		let (sut, client) = makeSUT()

		expect(sut, toCompleteWithResult: failure(.connectivity), when: {
			let clientError = NSError(domain: "Test", code: 0)
			client.complete(with: clientError)
		})
	}

	func test_load_deliversErrorOnNon2xxResponse() {
		let (sut, client) = makeSUT()

		let samples = [150, 199, 300, 400, 500]
		samples.enumerated().forEach { index, code in
			let json = makeItemsJSON([])
			expect(sut, toCompleteWithResult: failure(.invalidData), when: {
				client.complete(withStatusCode: code, data: json, at: index)
			})
		}
	}

	func test_load_deliversErrorOn2xxResponseWithInvadlidJSON()
	{
		let (sut, client) = makeSUT()
		let samples = [200, 201, 250, 280, 299]
		samples.enumerated().forEach { index, code in
			expect(sut, toCompleteWithResult: failure(.invalidData), when: {
				let invalidJSON = Data("Any JSON".utf8)
				client.complete(withStatusCode: code, data: invalidJSON, at: index)
			})
		}
	}

	func test_load_deliversNoItemsOn2xxResponseWithNoData() {
		let (sut, client) = makeSUT()

		let samples = [200, 201, 250, 280, 299]
		samples.enumerated().forEach { index, code in
			expect(sut, toCompleteWithResult: .success([]), when: {
				let emptyListJSON = makeItemsJSON([])
				client.complete(withStatusCode: code, data: emptyListJSON, at: index)
			})
		}
	}

	func test_load_deliversItemsOn2xxResponseWithValidData() {
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
		let samples = [200, 201, 250, 280, 299]

		samples.enumerated().forEach { index, code in
			expect(sut, toCompleteWithResult: .success(items), when: {
				let json = makeItemsJSON([item1.json, item2.json])
				client.complete(withStatusCode: code, data: json, at: index)
			})
		}
	}

	func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() throws {
		let url = URL(string: "http://any-url.com")!
		let client = HTTPClientSpy()
		var sut: RemoteImageCommentsLoader? = RemoteImageCommentsLoader(url: url, client: client)

		var capturedResults = [RemoteImageCommentsLoader.Result]()
		sut?.load() { capturedResults.append($0) }

		sut = nil
		client.complete(withStatusCode: 200, data: makeItemsJSON([]))

		XCTAssertTrue(capturedResults.isEmpty)
	}

	// MARK: - Helpers

	private func makeSUT(url: URL = URL(string: "https://any-url.com")!) -> (sut: RemoteImageCommentsLoader, client: HTTPClientSpy) {
		let client = HTTPClientSpy()
		let sut = RemoteImageCommentsLoader(url: url, client: client)
		trackForMemoryLeaks(sut)
		trackForMemoryLeaks(client)
		return (sut, client)
	}

	private func failure(_ error: RemoteImageCommentsLoader.Error) -> RemoteImageCommentsLoader.Result {
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

	private func expect(_ sut: RemoteImageCommentsLoader,
											toCompleteWithResult expectedResult: RemoteImageCommentsLoader.Result,
											when action: () -> Void,
											file: StaticString = #filePath,
											line: UInt = #line) {

		let exp = expectation(description: "Wait for completion.")
		sut.load { receivedResult in
			switch (receivedResult, expectedResult) {
			case let (.success(receivedItems), .success(expectedItems)):
				XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
			case let (.failure(receivedError as RemoteImageCommentsLoader.Error), .failure(expectedError as RemoteImageCommentsLoader.Error)):
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
