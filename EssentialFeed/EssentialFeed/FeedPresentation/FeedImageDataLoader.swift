//
//  FeedImageDataLoader.swift
//  EssentialFeed
//
//  Created by Dan Smith on 27/05/2022.
//

import Foundation

public protocol FeedImageDataLoaderTask{
	func cancel()
}

public protocol FeedImageDataLoader {
	typealias Result = Swift.Result<Data, Error>
	func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
