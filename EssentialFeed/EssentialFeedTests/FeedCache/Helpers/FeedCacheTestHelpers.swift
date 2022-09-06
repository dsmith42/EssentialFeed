//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 22/03/2022.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
	FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
	let models = [uniqueImage(), uniqueImage()]
	let local = models.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
	return (models: models, local: local)
}

extension Date {
	private var feedCacheMaxAgeInDays: Int { 7 }
	
	func minusFeedCacheMaxAge() -> Date {
		return adding(days: -feedCacheMaxAgeInDays)
	}
}
