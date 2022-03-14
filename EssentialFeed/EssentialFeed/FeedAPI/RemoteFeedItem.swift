//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Dan Smith on 14/03/2022.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
