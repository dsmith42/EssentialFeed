//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Dan Smith on 04/06/2022.
//

import Foundation

public final class FeedImagePresenter {

	public static func map(_ image: FeedImage) -> FeedImageViewModel {
		FeedImageViewModel(
			description: image.description,
			location: image.location)
	}

}
