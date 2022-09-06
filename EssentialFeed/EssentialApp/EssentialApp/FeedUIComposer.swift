//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 27/05/2022.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
	private init() {}

	private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>
	public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> FeedViewController {
		let presentationAdapter = FeedPresentationAdapter( loader: { feedLoader().dispatchOnMainQueue() } )

		let feedController = makeFeedViewController(
			delegate: presentationAdapter,
			title: FeedPresenter.title)

		presentationAdapter.presenter = LoadResourcePresenter(
			resourceView: FeedViewAdapter(controller: feedController,
																imageLoader: { imageLoader($0).dispatchOnMainQueue() }),
			loadingView: WeakRefVirtualProxy(feedController),
			errorView: WeakRefVirtualProxy(feedController),
			mapper: FeedPresenter.map
		)


		return feedController
	}

	static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
		let bundle = Bundle(for: FeedViewController.self)
		let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
		let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
		feedController.delegate = delegate
		feedController.title = title
		return feedController
	}
}
