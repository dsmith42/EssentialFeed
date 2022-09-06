//  
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 06/09/2022.
//

import XCTest
import EssentialFeed

final class ImageCommentsLocalizationTests: XCTestCase {

	func test_localizationStrings_haveKeysAndValuesForAllSupportedLocalizations() {
		let table = "ImageComments"
		let bundle = Bundle(for: ImageCommentsPresenter.self)

		assertLocalizedKeyAndValuesExist(in: bundle, table)
	}

}
