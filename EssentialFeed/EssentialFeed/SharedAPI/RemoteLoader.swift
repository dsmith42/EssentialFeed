//
//  RemoteLoader.swift
//  EssentialFeed
//
//  Created by Dan Smith on 02/09/2022.
//

import Foundation

public final class RemoteLoader: FeedLoader {
	private let url: URL
	private let client: HTTPClient

	public typealias Result = FeedLoader.Result

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.url = url
		self.client = client
	}

	public func load(completion: @escaping (Result) -> Void) {
		client.get(from: url) { [weak self] result in
			guard self != nil else { return }

			switch result {
			case let .success((data, response)):
				completion(RemoteLoader.map(data: data, from: response))
			case .failure:
				completion(.failure(Error.connectivity))
			}
		}
	}

	private static func map(data: Data, from response: HTTPURLResponse) -> Result {
		do {
			let items = try FeedItemsMapper.map(data, from: response)
			return .success(items)
		} catch {
			return .failure(Error.invalidData)
		}
	}
}

