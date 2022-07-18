//
//  FeedImageDataLoaderDecorator.swift
//  EssentialApp
//
//  Created by Dan Smith on 18/07/2022.
//

import Foundation
import EssentialFeed

public final class FeedImageDataLoaderDecorator: FeedImageDataLoader {
	private let decoratee: FeedImageDataLoader
	private let cache: FeedImageDataCache

	public init(decoratee: FeedImageDataLoader, cache: FeedImageDataCache) {
		self.decoratee = decoratee
		self.cache = cache
	}

	public func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
		return decoratee.loadImageData(from: url) { [weak self] result in
			completion(result.map { data in
				self?.cache.saveIgnoringResult(data, for: url) { _ in }
				return data
			})
		}
	}

}

extension FeedImageDataCache {
	func saveIgnoringResult(_ data: Data, for url: URL, completion: @escaping (FeedImageDataCache.Result) -> Void) {
		save(data, for: url) { _ in }
	}
}
