//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 04/06/2022.
//

import XCTest
import EssentialFeed

protocol FeedImageView {
	func display(_ model: FeedImageViewModel)
}

struct FeedImageViewModel {
	let description: String?
	let location: String?
	let image: Any?
	let isLoading: Bool
	let shouldRetry: Bool
	var hasLocation: Bool { location != nil }
}

 final class FeedImagePresenter {
	private var view: FeedImageView
	init(view: FeedImageView) {
		self.view = view
	}

	func didStartLoadingImageData(for model: FeedImage) {
		view.display(FeedImageViewModel(
			description: model.description,
			location: model.location,
			image: nil,
			isLoading: true,
			shouldRetry: false))
	}
}

final class FeedImagePresenterTests: XCTestCase {

	func test_init_noImageIsLoaded() {
		let (_, view) = makeSUT()

		XCTAssertTrue(view.messages.isEmpty, "Expected no messages to be sent to the view")
	}

	func test_didStartLoading_displaysLoadingImage() {
		let (sut, view) = makeSUT()
		let image = uniqueImage()

		sut.didStartLoadingImageData(for: image)

		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
		XCTAssertEqual(message?.description, image.description)
		XCTAssertEqual(message?.location, image.location)
		XCTAssertEqual(message?.isLoading, true)
		XCTAssertEqual(message?.shouldRetry, false)
		XCTAssertNil(message?.image)
	}

	// MARK: - Helpers -

	private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
		let view = ViewSpy()
		let sut = FeedImagePresenter(view: view)
		trackForMemoryLeaks(view, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, view)
	}

	private class ViewSpy: FeedImageView {
		var messages = [FeedImageViewModel]()

		func display(_ model: FeedImageViewModel) {
			messages.append(model)
		}
	}
}

