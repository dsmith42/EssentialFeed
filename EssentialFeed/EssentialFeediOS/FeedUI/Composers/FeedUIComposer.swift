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
		let feedViewModel = FeedViewModel(feedLoader: feedLoader)
		let refreshController = FeedRefreshViewController(viewModel: feedViewModel)
		let feedController = FeedViewController(refreshController: refreshController)
		feedViewModel.onFeedLoad = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
		return feedController
	}

	private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedImage]) -> Void {
		return { [weak controller] feed in
			controller?.tableModel = feed.map { model in
				FeedImageCellController(viewModel: FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init))
			}
		}
	}
	// [FeedImage] -> Adapt -> [FeedImageCellController]
}
