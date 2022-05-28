//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Dan Smith on 28/05/2022.
//

import UIKit
import EssentialFeed

final class FeedImageViewModel {
	typealias Observer<T> = (T) -> Void

	private let model: FeedImage
	private let imageLoader: FeedImageDataLoader
	private var task: FeedImageDataLoaderTask?

	init(model: FeedImage, imageLoader: FeedImageDataLoader) {
		self.model = model
		self.imageLoader = imageLoader
	}

	var location: String? { model.location }
	var description: String? { model.description }
	var hasLocation: Bool { location != nil }

	var onImageLoad: Observer<UIImage>?
	var onImageLoadingStateChange: Observer<Bool>?
	var onShouldRetryImageLoadStateChange: Observer<Bool>?

	func loadImageData() {
		onImageLoadingStateChange?(true)
		onShouldRetryImageLoadStateChange?(false)
		task = imageLoader.loadImageData(from: model.url) { [weak self] result in
			self?.handle(result)
		}
	}

	private func handle(_ result: FeedImageDataLoader.Result) {
		if let image = (try? result.get()).flatMap(UIImage.init) {
			onImageLoad?(image)
		} else {
			onShouldRetryImageLoadStateChange?(true)
		}
		onImageLoadingStateChange?(false)
	}

	func cancelImageDataLoad() {
		task?.cancel()
		task = nil
	}
}
