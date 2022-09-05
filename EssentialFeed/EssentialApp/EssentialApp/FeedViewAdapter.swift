//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 29/05/2022.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewAdapter: ResourceView {
	private weak var controller: FeedViewController?
	private var imageLoader: (URL) -> FeedImageDataLoader.Publisher

	init(controller: FeedViewController, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
		self.controller = controller
		self.imageLoader = imageLoader
	}

	func display(_ viewModel: FeedViewModel) {
		controller?.display(viewModel.feed.map { model in
			let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
			let view = FeedImageCellController(delegate: adapter)

			adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view),
																						 imageTransformer: UIImage.init)

			return view
		})
	}
}
