//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Dan Smith on 19/02/2022.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {
    private let url: URL
    private let client: HTTPClient

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (RemoteFeedLoader.Error) -> Void) {
        client.get(from: url) { result in
            switch result {
            case .failure:
                completion(.connectivity)
            case .success:
                completion(.invalidData)
            }
        }
    }
}
