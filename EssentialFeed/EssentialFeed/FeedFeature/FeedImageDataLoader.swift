//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Dan Smith on 27/05/2022.
//

import Foundation

public protocol FeedImageDataLoader {
	func loadImageData(from url: URL) throws -> Data
}
