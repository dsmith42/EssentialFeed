//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Dan Smith on 19/02/2022.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
