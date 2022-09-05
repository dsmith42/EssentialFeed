//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Dan Smith on 03/09/2022.
//

import Foundation

public protocol ResourceView {
	associatedtype ResourceViewModel

	func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
	public typealias Mapper = (Resource) -> View.ResourceViewModel

	private let errorView: ResourceErrorView
	private let loadingView: ResourceLoadingView
	private let resourceView: View
	private let mapper: Mapper

	public init(resourceView: View,
							errorView: ResourceErrorView,
							loadingView: ResourceLoadingView,
							mapper: @escaping Mapper) {
		self.resourceView = resourceView
		self.errorView = errorView
		self.loadingView = loadingView
		self.mapper = mapper
	}

	public static var loadError: String {
		NSLocalizedString("GENERIC_VIEW_CONNECTION_ERROR",
											tableName: "Shared",
											bundle: Bundle(for: Self.self),
											comment: "Error message displayed when we can't load the resource from the server")
	}

	public func didStartLoading() {
		errorView.display(.noError)
		loadingView.display(ResourceLoadingViewModel(isLoading: true))
	}

	public func didFinishLoading(with resource: Resource) {
		resourceView.display(mapper(resource))
		loadingView.display(ResourceLoadingViewModel(isLoading: false))
	}

	public func didFinishLoadingFeed(with error: Error) {
		loadingView.display(ResourceLoadingViewModel(isLoading: false))
		errorView.display(.error(message: Self.loadError))
	}

}
