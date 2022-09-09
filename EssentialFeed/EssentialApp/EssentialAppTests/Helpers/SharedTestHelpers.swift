//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 17/07/2022.
//

import Foundation
import EssentialFeed

func anyURL() -> URL {
	return URL(string: "https://any-url.com")!
}

func anyNSError() -> NSError {
	return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
	return Data("any data".utf8)
}

func uniqueFeed() -> [FeedImage] {
	return [FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())]
}

var feedTitle: String {
	FeedPresenter.title
}

var commentsTitle: String {
	ImageCommentsPresenter.title
}

var loadError: String {
	LoadResourcePresenter<Any, DummyView>.loadError
}

class DummyView: ResourceView {
	func display(_ viewModel: Any) {}
}
