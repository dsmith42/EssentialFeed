//  
//  LoadImageCommentsFromRemoteUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 02/09/2022.
//

import XCTest
import EssentialFeed

final class LoadImageCommentsFromRemoteUseCaseTests: XCTestCase {

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

		let item1 = makeItem(
			id: UUID(),
			message: "a message",
			createdAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
			username: "a username")

		let item2 = makeItem(
			id: UUID(),
			message: "another message",
			createdAt: (Date(timeIntervalSince1970: 1577881882), "2020-01-01T12:31:22+00:00"),
			username: "another username")

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

	private func makeItem(id: UUID, message: String, createdAt: (date: Date, iso8601String: String), username: String) -> (model: ImageComment, json: [String: Any]) {
		let item = ImageComment(id: id, message: message, createdAt: createdAt.date, username: username)

		let json: [String: Any] = [
			"id": id.uuidString,
			"message": message,
			"created_at": createdAt.iso8601String,
			"author": [
				"username": username
			]
		]

		return (item, json)
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
