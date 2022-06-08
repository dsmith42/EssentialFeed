//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Dan Smith on 08/06/2022.
//

import Foundation

public protocol FeedImageDataStore {
	typealias Result = Swift.Result<Data?, Error>

	func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
