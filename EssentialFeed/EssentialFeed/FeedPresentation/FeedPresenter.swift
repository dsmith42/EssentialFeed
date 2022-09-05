//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Dan Smith on 04/06/2022.
//

import Foundation

public protocol FeedLoadingView {
	func display(_ viewModel: FeedLoadingViewModel)
}

public protocol FeedErrorView {
	func display(_ viewModel: FeedErrorViewModel)
}

public protocol FeedView {
	func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
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

	public static var title: String {
		NSLocalizedString("FEED_VIEW_TITLE",
											tableName: "Feed",
											bundle: Bundle(for: FeedPresenter.self),
											comment: "Title for the feed view")
	}

	public static var feedLoadError: String {
		NSLocalizedString("GENERIC_VIEW_CONNECTION_ERROR",
											tableName: "Shared",
											bundle: Bundle(for: FeedPresenter.self),
											comment: "Error message displayed when we can't load the image feed from the server")
	}

	public func didStartLoadingFeed() {
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
