//  
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 05/09/2022.
//

import XCTest
import EssentialFeed

final class SharedLocalizationTests: XCTestCase {

	func test_localizationStrings_haveKeysAndValuesForAllSupportedLocalizations() {
		let table = "Shared"
		let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)

		assertLocalizedKeyAndValuesExist(in: bundle, table)
	}

	private class DummyView: ResourceView {
		func display(_ viewModel: Any) {}
	}

}
