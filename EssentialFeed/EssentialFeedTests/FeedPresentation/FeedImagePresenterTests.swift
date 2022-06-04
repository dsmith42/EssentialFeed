//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 04/06/2022.
//

import XCTest
import EssentialFeed

protocol FeedImageView {
	associatedtype Image

	func display(_ model: FeedImageViewModel<Image>)
}

struct FeedImageViewModel<Image> {
	let description: String?
	let location: String?
	let image: Image?
	let isLoading: Bool
	let shouldRetry: Bool
	var hasLocation: Bool { location != nil }
}

final class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
	private var view: View
	private let imageTransformer: (Data) -> Image?

	init(view: View, imageTransformer: @escaping (Data) -> Image?) {
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
		let image = imageTransformer(data)
		view.display(FeedImageViewModel(description: model.description,
																		location: model.location,
																		image: image,
																		isLoading: false,
																		shouldRetry: image == nil))
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

		sut.didFinishLoadingImageData(with: Data(), for: image)

		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
		XCTAssertEqual(message?.description, image.description)
		XCTAssertEqual(message?.location, image.location)
		XCTAssertEqual(message?.isLoading, false)
		XCTAssertEqual(message?.shouldRetry, true)
		XCTAssertNil(message?.image)
	}

	func test_didFinishLoadingImageData_displaysImageWhenTransformationSucceeds() {
		let image = uniqueImage()
		let transformedData = AnyImage()
		let (sut, view) = makeSUT(imageTransformer: { _ in transformedData })

		sut.didFinishLoadingImageData(with: Data(), for: image)

		let message = view.messages.first
		XCTAssertEqual(view.messages.count, 1)
		XCTAssertEqual(message?.description, image.description)
		XCTAssertEqual(message?.location, image.location)
		XCTAssertEqual(message?.isLoading, false)
		XCTAssertEqual(message?.shouldRetry, false)
		XCTAssertEqual(message?.image, transformedData)
	}


	// MARK: - Helpers -

	private func makeSUT(imageTransformer: @escaping (Data) -> AnyImage? = { _ in nil },
											 file: StaticString = #file,
											 line: UInt = #line) -> (sut: FeedImagePresenter<ViewSpy, AnyImage>, view: ViewSpy) {
		let view = ViewSpy()

		let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
		trackForMemoryLeaks(view, file: file, line: line)
		trackForMemoryLeaks(sut, file: file, line: line)
		return (sut, view)
	}

	private var fail: (Data) -> AnyImage? {
		return { _ in nil }
	}

	private struct AnyImage: Equatable {}

	private class ViewSpy: FeedImageView {
		var messages = [FeedImageViewModel<AnyImage>]()

		func display(_ model: FeedImageViewModel<AnyImage>) {
			messages.append(model)
		}
	}
}

