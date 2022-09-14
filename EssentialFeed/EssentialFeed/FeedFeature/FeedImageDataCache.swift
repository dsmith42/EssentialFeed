//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Dan Smith on 18/07/2022.
//

import Foundation

public protocol FeedImageDataCache {
	func save(_ data: Data, for url: URL) throws
}
