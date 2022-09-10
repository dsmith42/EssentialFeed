//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Dan Smith on 09/09/2022.
//

import Foundation

public enum FeedEndpoint {
	case get

	public func url(baseURL: URL) -> URL {
		switch self {
		case .get:
			return baseURL.appendingPathComponent("/v1/feed")
		}
	}
}
