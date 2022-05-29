//
//  FeedRefreshViewController.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 27/05/2022.
//

import UIKit

protocol FeedRefreshViewControllerDelegate {
	func didRequestFeedRefresh()
}

final class FeedRefreshViewController: NSObject, FeedLoadingView {
	@IBOutlet private var view: UIRefreshControl?

	var delegate: FeedRefreshViewControllerDelegate?

	@IBAction func refresh() {
		delegate?.didRequestFeedRefresh()
	}

	private func loadView() -> UIRefreshControl {
		let view = UIRefreshControl()
		view.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return view
	}

	func display(_ viewModel: FeedLoadingViewModel) {
		if viewModel.isLoading {
			view?.beginRefreshing()
		} else {
			view?.endRefreshing()
		}
	}
}
