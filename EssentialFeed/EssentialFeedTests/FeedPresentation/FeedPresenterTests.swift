//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 04/06/2022.
//

import XCTest
import EssentialFeed

protocol FeedLoadingView {
	func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedErrorView {
	func display(_ viewModel: FeedErrorViewModel)
}

protocol FeedView {
	func display(_ viewModel: FeedViewModel)
}

struct FeedLoadingViewModel {
	let isLoading: Bool
}

struct FeedErrorViewModel {
	let message: String?

	static var noError: FeedErrorViewModel {
		return FeedErrorViewModel(message: nil)
	}

	static func error(message: String) -> FeedErrorViewModel {
		return FeedErrorViewModel(message: message)
	}
}

struct FeedViewModel {
	let feed: [FeedImage]
}

final class FeedPresenter {
	var errorView: FeedErrorView
	var loadingView: FeedLoadingView
	var feedView: FeedView

	init(feedView: FeedView,
			 errorView: FeedErrorView,
			 loadingView: FeedLoadingView) {
		self.feedView = feedView
		self.errorView = errorView
		self.loadingView = loadingView
	}

	func didStartLoadingFeed() {
		errorView.display(.noError)
		loadingView.display(FeedLoadingViewModel(isLoading: true))
	}

	func didFinishLoadingFeed(with feed: [FeedImage]) {
		feedView.display(FeedViewModel(feed: feed))
		loadingView.display(FeedLoadingViewModel(isLoading: false))
	}

}

class FeedPresenterTests: XCTestCase {

	func test_init_doesNotSendMessagesToView() {
		let (_, view) = makeSUT()

		XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
	}

	func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
		let (sut, view) = makeSUT()

		sut.didStartLoadingFeed()

		XCTAssertEqual(view.messages, [
			.display(errorMessage: .none),
			.display(isLoading: true)
		])
	}

	func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
		let (sut, view) = makeSUT()
		let feed = uniqueImageFeed().models

		sut.didFinishLoadingFeed(with: feed)

		XCTAssertEqual(view.messages, [
			.display(isLoading: false),
			.display(feed: feed)
		])
	}

	// MARK: - Helpers -

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
		let view = ViewSpy()
		let sut = FeedPresenter(feedView: view, errorView: view, loadingView: view)
		trackForMemoryLeaks(view, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, view)
	}

	private class ViewSpy: FeedErrorView, FeedLoadingView, FeedView {
		enum Message: Hashable {
			case display(errorMessage: String?)
			case display(isLoading: Bool)
			case display(feed: [FeedImage])
		}

		var messages = Set<Message>()

		func display(_ viewModel: FeedErrorViewModel) {
			messages.insert(.display(errorMessage: viewModel.message))
		}

		func display(_ viewModel: FeedLoadingViewModel) {
			messages.insert(.display(isLoading: viewModel.isLoading))
		}

		func display(_ viewModel: FeedViewModel) {
			messages.insert(.display(feed: viewModel.feed))
		}
	}

}
