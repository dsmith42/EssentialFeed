//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Dan Smith on 19/02/2022.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping ([LoadFeedResult]) -> Void)
}
