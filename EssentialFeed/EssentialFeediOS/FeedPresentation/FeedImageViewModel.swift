//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 28/05/2022.
//

import EssentialFeed

struct FeedImageViewModel<Image> {
	let description: String?
	let location: String?
	let image: Image?
	let isLoading: Bool
	let shouldRetry: Bool
	var hasLocation: Bool { location != nil }
}
