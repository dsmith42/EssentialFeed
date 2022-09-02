//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Dan Smith on 02/09/2022.
//

import Foundation

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
	convenience init(url: URL, client: HTTPClient) {
		self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
	}
}
