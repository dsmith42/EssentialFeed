//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 27/05/2022.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {
	var isShowingLocation: Bool {
		return !locationContainer.isHidden
	}

	var isShowingImageLoadingIndicator: Bool {
		return feedImageContainer.isShimmering
	}

	var isShowingRetryAction: Bool {
		return !feedImageRetryButton.isHidden
	}

	var locationText: String? {
		return locationLabel.text
	}

	var descriptionText: String? {
		return descriptionLabel.text
	}

	var renderedImage: Data? {
		return feedImageView.image?.pngData()
	}

	func simulateRetryAction() {
		feedImageRetryButton.simulateTap()
	}
}
