//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 27/05/2022.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
	private init() {}

	public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
		let presenter = FeedPresenter(feedLoader: feedLoader)
		let refreshController = FeedRefreshViewController(presenter: presenter)
		let feedController = FeedViewController(refreshController: refreshController)
		presenter.loadingView = refreshController
		presenter.feedView = FeedViewAdapter(controller: feedController, loader: imageLoader)
		return feedController
	}
}

private final class FeedViewAdapter: FeedView {
	private weak var controller: FeedViewController?
	private var loader: FeedImageDataLoader

	init(controller: FeedViewController, loader: FeedImageDataLoader) {
		self.controller = controller
		self.loader = loader
	}

	func display(feed: [FeedImage]) {
		controller?.tableModel = feed.map { model in
			FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
		}
	}
}
