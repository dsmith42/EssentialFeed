//
//  FeedErrorViewModel.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 04/06/2022.
//

struct FeedErrorViewModel {
	let message: String?

	static var noError: FeedErrorViewModel {
		return FeedErrorViewModel(message: nil)
	}

	static func error(message: String) -> FeedErrorViewModel {
		return FeedErrorViewModel(message: message)
	}
}
