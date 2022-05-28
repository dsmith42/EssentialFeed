//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 27/05/2022.
//

import UIKit

final class FeedRefreshViewController: NSObject, FeedLoadingView {
	private(set) lazy var view = loadView()

	private let loadFeed: () -> Void

	init(loadFeed: @escaping () -> Void) {
		self.loadFeed = loadFeed
	}

	@objc func refresh() {
		loadFeed()
	}

	private func loadView() -> UIRefreshControl {
		let view = UIRefreshControl()
		view.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return view
	}

	func display(_ viewModel: FeedLoadingViewModel) {
		if viewModel.isLoading {
			view.beginRefreshing()
		} else {
			view.endRefreshing()
		}
	}
}
