//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialAppTests
//
//  Created by Dan Smith on 17/07/2022.
//

import XCTest

extension XCTestCase {

	func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
		addTeardownBlock { [weak instance] in
			XCTAssertNil(instance, "Instance should have been deallocated.  Potential memory leak.", file: file, line: line)
		}
	}
}
