//  
//  FeedEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 09/09/2022.
//

import XCTest
import EssentialFeed

final class FeedEndpointTests: XCTestCase {

    func test_feed_endpointURL() {
			let baseURL = URL(string: "http://base-url.com")!

			let received = FeedEndpoint.get.url(baseURL: baseURL)
			let expected = URL(string: "http://base-url.com/v1/feed")!

			XCTAssertEqual(received, expected)
		}

}
