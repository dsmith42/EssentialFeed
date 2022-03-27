//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Dan Smith on 19/02/2022.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedImage])
    case failure(Error)
}

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
