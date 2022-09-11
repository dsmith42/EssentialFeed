//
//  ListViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 27/05/2022.
//

import UIKit
@testable import EssentialFeediOS

extension ListViewController {
	override public func loadViewIfNeeded() {
		super.loadViewIfNeeded()

		tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
	}

	var isShowingLoadingIndicator: Bool {
		refreshControl?.isRefreshing == true
	}

	func simulateUserInitiatedReload() {
		refreshControl?.simulatePullToRefresh()
	}

	func simulateErrorViewTap() {
		errorView.simulateTap()
	}

	var errorMessage: String? {
		return errorView.message
	}

	func numberOfRows(in section: Int) -> Int {
		tableView.numberOfSections > section ? tableView.numberOfRows(inSection: section): 0
	}

	func cell(row: Int, section: Int) -> UITableViewCell? {
		guard numberOfRows(in: section) > row else {
			return nil
		}
		let ds = tableView.dataSource
		let index = IndexPath(row: row, section: section)
		return ds?.tableView(tableView, cellForRowAt: index)
	}

}

extension ListViewController {

	@discardableResult
	func simulateFeedImageViewVisible(at index: Int = 0) -> FeedImageCell? {
		return feedImageView(at: index) as? FeedImageCell
	}

	@discardableResult
	func simulateFeedImageViewNotVisible(at index: Int = 0) -> FeedImageCell? {
		let view = simulateFeedImageViewVisible(at: index)

		let delegate = tableView.delegate
		let indexPath = IndexPath(row: index, section: feedImagesSection)
		delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: indexPath)
		return view
	}

	func simulateFeedImageViewNearVisible(at row: Int) {
		let ds = tableView.prefetchDataSource
		let index = IndexPath(row: row, section: feedImagesSection)
		ds?.tableView(tableView, prefetchRowsAt: [index])
	}

	func simulateFeedImageViewNotNearVisible(at row: Int) {
		simulateFeedImageViewNearVisible(at: row)

		let ds = tableView.prefetchDataSource
		let index = IndexPath(row: row, section: feedImagesSection)
		ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
	}

	func simulateLoadMoreFeedAction() {
		guard let view = cell(row: 0, section: feedLoadMoreSection) else { return }

		let delegate = tableView.delegate
		let indexPath = IndexPath(row: 0, section: feedLoadMoreSection)
		delegate?.tableView?(tableView, willDisplay: view, forRowAt: indexPath)
	}

	var isShowingLoadMoreFeedIndicator: Bool {
		loadMoreFeedCell()?.isLoading == true
	}

	var loadMoreFeedErrorMessage: String? {
		loadMoreFeedCell()?.message
	}

	private func loadMoreFeedCell() -> LoadMoreCell? {
		return cell(row: 0, section: feedLoadMoreSection) as? LoadMoreCell
	}

	func renderedFeedImageData(at index: Int) -> Data? {
		return simulateFeedImageViewVisible(at: index)?.renderedImage
	}

	func feedImageView(at row: Int) -> UITableViewCell? {
		cell(row: row, section: feedImagesSection)
	}

	func numberOfRenderedFeedImageViews() -> Int {
		numberOfRows(in: feedImagesSection)
	}

	private var feedImagesSection: Int {
		return 0
	}

	private var feedLoadMoreSection: Int {
		return 1
	}

	func simulateTapOnFeedImage(at row: Int) {
		let delegate = tableView.delegate
		let indexPath = IndexPath(row: row, section: feedImagesSection)
		delegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}

}

extension ListViewController {
	func numberOfRenderedComments() -> Int {
		numberOfRows(in: commentsSection)
	}

	private var commentsSection: Int {
		return 0
	}

	private func commentView(at row: Int) -> ImageCommentCell? {
		cell(row: row, section: commentsSection) as? ImageCommentCell
	}

	func commentMessage(at row: Int) -> String? {
		return commentView(at: row)?.messageLabel.text
	}

	func commentDate(at row: Int) -> String? {
		return commentView(at: row)?.dateLabel.text
	}

	func commentUsername(at row: Int) -> String? {
		return commentView(at: row)?.usernameLabel.text
	}

}
