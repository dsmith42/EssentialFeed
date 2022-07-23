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

		let feedCells = app.cells.matching(identifier: "feed-image-cell")
		XCTAssertEqual(feedCells.count, 22)

		let feedImage = app.images.matching(identifier: "feed-image-view").firstMatch
		XCTAssertTrue(feedImage.exists)
	}

	func test_onLaunch_displaysCachedRemoteFeed_whenCustomerHasNoConnectivity() {
		let onlineApp = XCUIApplication()
		onlineApp.launch()

		let offlineApp = XCUIApplication()
		offlineApp.launchArguments = ["-connectivity", "offline"]
		offlineApp.launch()

		let feedCells = offlineApp.cells.matching(identifier: "feed-image-cell")
		XCTAssertEqual(feedCells.count, 22)

		let feedImage = offlineApp.images.matching(identifier: "feed-image-view").firstMatch
		XCTAssertTrue(feedImage.exists)
	}
}
