//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Dan Smith on 23/07/2022.
//

import XCTest

class EssentialAppUIAcceptanceTests: XCTestCase {

	func test_onLaunch_displaysRemoteFeed_whenCustomerHasConnectivity() {
		let app = XCUIApplication()

		app.launch()

		XCTAssertEqual(app.cells.count, 22)
		XCTAssertEqual(app.cells.firstMatch.images.count, 1)
	}

}
