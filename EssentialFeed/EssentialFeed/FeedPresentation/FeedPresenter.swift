//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Dan Smith on 04/06/2022.
//

import Foundation

public protocol FeedView {
	func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
	var errorView: ResourceErrorView
	var loadingView: ResourceLoadingView
	var feedView: FeedView

	public init(feedView: FeedView,
			 errorView: ResourceErrorView,
			 loadingView: ResourceLoadingView) {
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
		loadingView.display(ResourceLoadingViewModel(isLoading: true))
	}

	public func didFinishLoadingFeed(with feed: [FeedImage]) {
		feedView.display(Self.map(feed))
		loadingView.display(ResourceLoadingViewModel(isLoading: false))
	}

	public func didFinishLoadingFeed(with error: Error) {
		loadingView.display(ResourceLoadingViewModel(isLoading: false))
		errorView.display(.error(message: FeedPresenter.feedLoadError))
	}

	public static func map(_ feed: [FeedImage]) -> FeedViewModel {
		FeedViewModel(feed: feed)
	}

}
