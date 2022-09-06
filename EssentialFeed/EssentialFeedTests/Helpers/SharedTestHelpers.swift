//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 22/03/2022.
//

import Foundation

func anyNSError() -> NSError {
	NSError(domain: "A Domain", code: 1)
}

func anyURL() -> URL {
	URL(string: "https://any-url.com")!
}

func anyData() -> Data {
	return Data("any data".utf8)
}

func makeItemsJSON(_ items: [[String: Any]]) -> Data {
	let itemsJSON = ["items": items]
	return try! JSONSerialization.data(withJSONObject: itemsJSON)
}

extension HTTPURLResponse {
	convenience init(statusCode: Int) {
		self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
	}
}

extension Date {
	func adding(seconds: TimeInterval) -> Date {
		return self + seconds
	}

	func adding(minutes: Int) -> Date {
		return Calendar(identifier: .gregorian).date(byAdding: .minute, value: minutes, to: self)!
	}

	func adding(days: Int) -> Date {
		return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
	}
}
