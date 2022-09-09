//
//  FeedViewController+TestHelpers.swift
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

	func renderedFeedImageData(at index: Int) -> Data? {
		return simulateFeedImageViewVisible(at: index)?.renderedImage
	}

	func feedImageView(at row: Int) -> UITableViewCell? {
		guard numberOfRenderedFeedImageViews() > row else {
			return nil
		}
		let ds = tableView.dataSource
		let indexPath = IndexPath(row: row, section: feedImagesSection)
		return ds?.tableView(tableView, cellForRowAt: indexPath)

	}

	func numberOfRenderedFeedImageViews() -> Int {
		tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: feedImagesSection)
	}

	private var feedImagesSection: Int {
		return 0
	}

	func simulateTapOnFeedImage(at row: Int) {
		simulateFeedImageViewNearVisible(at: row)

		let delegate = tableView.delegate
		let indexPath = IndexPath(row: row, section: feedImagesSection)
		delegate?.tableView?(tableView, didSelectRowAt: indexPath)
	}

}

extension ListViewController {
	func numberOfRenderedComments() -> Int {
		tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: commentsSection)
	}

	private var commentsSection: Int {
		return 0
	}

	private func commentView(at row: Int) -> ImageCommentCell? {
		guard numberOfRenderedComments() > row else {
			return nil
		}
		let ds = tableView.dataSource
		let indexPath = IndexPath(row: row, section: commentsSection)
		return ds?.tableView(tableView, cellForRowAt: indexPath) as? ImageCommentCell
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
