//
//  ListViewController.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 25/05/2022.
//

import UIKit
import EssentialFeed

public final class ListViewController: UITableViewController, UITableViewDataSourcePrefetching, ResourceLoadingView, ResourceErrorView {

	@IBOutlet private(set) public var errorView: ErrorView?

	private var loadingControllers = [IndexPath: CellController]()

	private var tableModel = [CellController]() {
		didSet { tableView.reloadData() }
	}

	public var onRefresh: (() -> Void)?

	public override func viewDidLoad() {
		super.viewDidLoad()

		refresh()
	}

	public override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		tableView.sizeTableHeaderToFit()
	}

	@IBAction private func refresh() {
		onRefresh?()
	}

	public func display(_ cellControllers: [CellController]) {
		loadingControllers = [:]
		tableModel = cellControllers
	}

	public func display(_ viewModel: ResourceLoadingViewModel) {
		refreshControl?.update(isRefreshing: viewModel.isLoading)
	}

	public func display(_ viewModel: ResourceErrorViewModel) {
		errorView?.message = viewModel.message
	}

	public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableModel.count
	}

	public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let dataSource =  cellController(forRowAt: indexPath).dataSource
		return dataSource.tableView(tableView, cellForRowAt: indexPath)
	}

	public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let delegate = removeLoadingController(forRowAt: indexPath)?.delegate
		delegate?.tableView?(tableView, didEndDisplaying: cell, forRowAt: indexPath)
	}

	public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach { indexPath in
			let dataSourcePrefetching = cellController(forRowAt: indexPath).dataSourcePrefetching
			dataSourcePrefetching?.tableView(tableView, prefetchRowsAt: [indexPath])
		}
	}

	public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
		indexPaths.forEach {
			let dataSourcePrefetching = removeLoadingController(forRowAt: $0)?.dataSourcePrefetching
			dataSourcePrefetching?.tableView?(tableView, cancelPrefetchingForRowsAt: [$0])
		}
	}

	private func cellController(forRowAt indexPath: IndexPath) -> CellController {
		let controller = tableModel[indexPath.row]
		loadingControllers[indexPath] = controller
		return controller
	}

	private func removeLoadingController(forRowAt indexPath: IndexPath) -> CellController? {
		let controller = loadingControllers[indexPath]
		loadingControllers[indexPath] = nil
		return controller
	}

}
