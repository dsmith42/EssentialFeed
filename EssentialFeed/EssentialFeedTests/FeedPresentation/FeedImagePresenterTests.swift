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
	private let imageTransformer: (Data) -> Any?

	init(view: FeedImageView, imageTransformer: @escaping (Data) -> Any?) {
		self.view = view
		self.imageTransformer = imageTransformer
	}

	func didStartLoadingImageData(for model: FeedImage) {
		view.display(FeedImageViewModel(
			description: model.description,
			location: model.location,
			image: nil,
			isLoading: true,
			shouldRetry: false))
	}

	func didFinishLoadingImageData(with data: Data, for model: FeedImage) {
		view.display(FeedImageViewModel(description: model.description,
																		location: model.location,
																		image: imageTransformer(data),
																		isLoading: false,
																		shouldRetry: true))
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

	func test_didFinishLoadingImageData_displaysRetryOnFailedImageTransformation() {
		let (sut, view) = makeSUT(imageTransformer: fail)
		let image = uniqueImage()
		let data = Data()

		sut.didFinishLoadingImageData(with: data, for: image)

		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
		XCTAssertEqual(message?.description, image.description)
		XCTAssertEqual(message?.location, image.location)
		XCTAssertEqual(message?.isLoading, false)
		XCTAssertEqual(message?.shouldRetry, true)
		XCTAssertNil(message?.image)
	}

	// MARK: - Helpers -

	private func makeSUT(imageTransformer: @escaping (Data) -> Any? = { _ in nil },
											 file: StaticString = #file,
											 line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
		let view = ViewSpy()

		let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
		trackForMemoryLeaks(view, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, view)
	}

	private var fail: (Data) -> Any? {
		return { _ in nil }
	}

	private class ViewSpy: FeedImageView {
		var messages = [FeedImageViewModel]()

		func display(_ model: FeedImageViewModel) {
			messages.append(model)
		}
	}
}

