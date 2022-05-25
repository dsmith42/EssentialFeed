//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Dan Smith on 14/03/2022.
//

import Foundation

struct RemoteFeedItem: Decodable {
	let id: UUID
	let description: String?
	let location: String?
	let image: URL
}
