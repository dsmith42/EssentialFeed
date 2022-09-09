//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeediOSTests
//
//  Created by Dan Smith on 29/05/2022.
//

import XCTest
import EssentialFeed
import EssentialApp

extension FeedUIIntegrationTests {

	private class DummyView: ResourceView {
		func display(_ viewModel: Any) {}
	}

	var feedTitle: String {
		FeedPresenter.title
	}

	var loadError: String {
		LoadResourcePresenter<Any, DummyView>.loadError
	}

	var commentsTitle: String {
		ImageCommentsPresenter.title
	}

}
