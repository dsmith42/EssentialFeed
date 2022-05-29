//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 25/05/2022.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
	@IBOutlet private(set) public var locationContainer: UIView!
	@IBOutlet private(set) public var locationLabel: UILabel!
	@IBOutlet private(set) public var descriptionLabel: UILabel!
	@IBOutlet private(set) public var feedImageContainer: UIView!
	@IBOutlet private(set) public var feedImageRetryButton: UIButton!
	@IBOutlet private(set) public var feedImageView: UIImageView!

	var onRetry: (() -> Void)?

	@IBAction private func retryButtonTapped() {
		onRetry?()
	}
}
