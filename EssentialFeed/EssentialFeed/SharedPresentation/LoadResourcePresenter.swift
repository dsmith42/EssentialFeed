//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Dan Smith on 03/09/2022.
//

import Foundation

public protocol ResourceView {
	func display(_ viewModel: String)
}

public final class LoadResourcePresenter {
	public typealias Mapper = (String) -> String

	private let errorView: FeedErrorView
	private let loadingView: FeedLoadingView
	private let resourceView: ResourceView
	private let mapper: Mapper

	public init(resourceView: ResourceView,
							errorView: FeedErrorView,
							loadingView: FeedLoadingView,
							mapper: @escaping Mapper) {
		self.resourceView = resourceView
		self.errorView = errorView
		self.loadingView = loadingView
		self.mapper = mapper
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

	public func didFinishLoading(with resource: String) {
		resourceView.display(mapper(resource))
		loadingView.display(FeedLoadingViewModel(isLoading: false))
	}

	public func didFinishLoadingFeed(with error: Error) {
		loadingView.display(FeedLoadingViewModel(isLoading: false))
		errorView.display(.error(message: FeedPresenter.feedLoadError))
	}

}
