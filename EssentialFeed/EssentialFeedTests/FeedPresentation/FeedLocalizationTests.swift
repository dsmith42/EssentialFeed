//
//  FeedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 29/05/2022.
//

import XCTest
import EssentialFeed

final class FeedLocalizationTests: XCTestCase {

	func test_localizationStrings_haveKeysAndValuesForAllSupportedLocalizations() {
		let table = "Shared"
		let bundle = Bundle(for: FeedPresenter.self)

		assertLocalizedKeyAndValuesExist(in: bundle, table)
	}

}
