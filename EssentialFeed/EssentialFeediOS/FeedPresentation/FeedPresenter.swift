//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 28/05/2022.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
	func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
	func display(_ viewModel: FeedViewModel)
}

struct FeedErrorViewModel {
	let message: String
}

protocol FeedErrorView {
	func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
  var feedView: FeedView
	var loadingView: FeedLoadingView
	var errorView: FeedErrorView

	static var title: String {
		NSLocalizedString("FEED_VIEW_TITLE",
											tableName: "Feed",
											bundle: Bundle(for: FeedPresenter.self),
											comment: "Title for the feed view")
	}

	static var feedLoadError: String {
		NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
											tableName: "Feed",
											bundle: Bundle(for: FeedPresenter.self),
											comment: "Error message displayed when we can't load the image feed from the server")
	}

	init(feedView: FeedView, loadingView: FeedLoadingView, errorView: FeedErrorView) {
		self.feedView = feedView
		self.loadingView = loadingView
		self.errorView = errorView
	}

	func didStartLoadingFeed() {
		loadingView.display(FeedLoadingViewModel(isLoading: true))
	}

	func didFinishLoadingFeed(with feed: [FeedImage]) {
		feedView.display(FeedViewModel(feed: feed))
		loadingView.display(FeedLoadingViewModel(isLoading: false))
	}

	func didFinishLoadingFeed(with error: Error) {
		loadingView.display(FeedLoadingViewModel(isLoading: false))
		errorView.display(FeedErrorViewModel(message: FeedPresenter.feedLoadError))
	}
}

