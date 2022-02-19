//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 19/02/2022.
//

import XCTest

class RemoteFeedLoader {
    let client: HTTPClient

    init(client: HTTPClient) {
        self.client = client
    }

    func load() { }
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader(client: client)

        XCTAssertNil(client.requestedURL)
    }

}
