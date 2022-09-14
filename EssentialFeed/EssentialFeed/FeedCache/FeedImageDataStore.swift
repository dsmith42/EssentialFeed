//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Dan Smith on 08/06/2022.
//

import Foundation

public protocol FeedImageDataStore {
	func insert(_ data: Data, for url: URL) throws
	func retrieve(dataForURL url: URL) throws -> Data?
}
