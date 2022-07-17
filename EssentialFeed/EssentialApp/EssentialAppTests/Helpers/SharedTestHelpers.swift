//
//  SharedTestHelpers.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 17/07/2022.
//

import Foundation

func anyURL() -> URL {
	return URL(string: "https://any-url.com")!
}

func anyNSError() -> NSError {
	return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
	return Data("any data".utf8)
}
