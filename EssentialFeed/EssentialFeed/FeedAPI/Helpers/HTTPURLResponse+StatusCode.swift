//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 05/06/2022.
//

import Foundation

extension HTTPURLResponse {
	private static var OK_200: Int { return 200 }

	var isOK: Bool {
		return statusCode == HTTPURLResponse.OK_200
	}
}
