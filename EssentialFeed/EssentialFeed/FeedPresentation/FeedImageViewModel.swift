//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Dan Smith on 04/06/2022.
//

public struct FeedImageViewModel<Image> {
	public let description: String?
	public let location: String?
	public let image: Image?
	public let isLoading: Bool
	public let shouldRetry: Bool
	public var hasLocation: Bool { location != nil }
}
