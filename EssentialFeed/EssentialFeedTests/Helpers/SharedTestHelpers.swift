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
