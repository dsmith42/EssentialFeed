//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Dan Smith on 03/09/2022.
//

import Foundation

public final class LoadResourcePresenter {
	var errorView: FeedErrorView
	var loadingView: FeedLoadingView
	var feedView: FeedView

	public init(feedView: FeedView,
							errorView: FeedErrorView,
							loadingView: FeedLoadingView) {
		self.feedView = feedView
		self.errorView = errorView
		self.loadingView = loadingView
	}

	public static var feedLoadError: String {
		NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
											tableName: "Feed",
											bundle: Bundle(for: FeedPresenter.self),
											comment: "Error message displayed when we can't load the image feed from the server")
	}

	public func didStartLoading() {
		errorView.display(.noError)
		loadingView.display(FeedLoadingViewModel(isLoading: true))
	}

	public func didFinishLoadingFeed(with feed: [FeedImage]) {
		feedView.display(FeedViewModel(feed: feed))
		loadingView.display(FeedLoadingViewModel(isLoading: false))
	}

	public func didFinishLoadingFeed(with error: Error) {
		loadingView.display(FeedLoadingViewModel(isLoading: false))
		errorView.display(.error(message: FeedPresenter.feedLoadError))
	}

}
