//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Dan Smith on 04/06/2022.
//

public struct ResourceErrorViewModel {
	public let message: String?

	static var noError: ResourceErrorViewModel {
		return ResourceErrorViewModel(message: nil)
	}

	static func error(message: String) -> ResourceErrorViewModel {
		return ResourceErrorViewModel(message: message)
	}
}
