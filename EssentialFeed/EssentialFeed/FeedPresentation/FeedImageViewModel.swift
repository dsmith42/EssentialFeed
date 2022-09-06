//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Dan Smith on 04/06/2022.
//

public struct FeedImageViewModel {
	public let description: String?
	public let location: String?

	public var hasLocation: Bool {
		location != nil
	}
}
