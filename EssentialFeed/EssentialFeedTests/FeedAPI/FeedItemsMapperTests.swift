//
//  FeedItemsMapperTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 19/02/2022.
//

import XCTest
import EssentialFeed

class FeedItemsMapperTests: XCTestCase {
	
	func test_map_throwsErrorOnNon200Response() throws {
		let json = makeItemsJSON([])
		let samples = [199, 201, 300, 400, 500]

		try samples.forEach { code in
			XCTAssertThrowsError(
				try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
			)
		}
	}
	
	func test_map_throwsErrorOn200ResponseWithInvadlidJSON() {
		let invalidJSON = Data("Any JSON".utf8)

		XCTAssertThrowsError(
			try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
		)
	}
	
	func test_map_deliversNoItemsOn200ResponseWithNoData() throws {
		let emptyListJSON = makeItemsJSON([])

		let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
		XCTAssertEqual(result, [])
	}
	
	func test_map_deliversItemsOn200ResponseWithValidData() throws {
		let item1 = makeItem(id: UUID(),
												 description: nil,
												 location: nil,
												 imageURL: URL(string: "https://any-url.com")!)
		
		let item2 = makeItem(id: UUID(),
												 description: "A description",
												 location: "A location",
												 imageURL: URL(string: "https://any-url.com")!)
		
		let items = [item1.model, item2.model]
		let json = makeItemsJSON([item1.json, item2.json])

		let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
		XCTAssertEqual(result, items)
	}

	// MARK: - Helpers
	
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

}
