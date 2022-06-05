//
//  URLSessionHTTPClient.swift
//  EssentialFeed
//
//  Created by Dan Smith on 27/02/2022.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
	private let session: URLSession
	
	public init(session: URLSession = .shared) {
		self.session = session
	}
	
	private struct UnexpectedValuesRepresetentation: Error {}
	
	private struct URLSessionTaskWrapper: HTTPClientTask {
		let wrapped: URLSessionTask
		
		func cancel() {
			wrapped.cancel()
		}
	}
	
	public func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask{
		let task = session.dataTask(with: url) { data, response, error in
			completion(Result {
				if let error = error {
					throw error
				} else if let data = data, let response = response as? HTTPURLResponse {
					return (data, response)
				} else {
					throw UnexpectedValuesRepresetentation()
				}
			})
		}
		task.resume()
		return URLSessionTaskWrapper(wrapped: task)
	}
}
