//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 20/02/2022.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)

        let sut = URLSessionHTTPClient(session: session)

        sut.get(from: url)

        XCTAssertEqual(task.resumeCallCount, 1)
    }

    // MARK: - Helpers

    private class URLSessionSpy: URLSession {
        private var stubs = [URL: URLSessionDataTask]()

        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task
        }

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return stubs[url] ?? FakeURLSessionDataTask()
        }
    }

    private class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }

    private class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0

        override func resume() {
            resumeCallCount += 1
        }
    }

}
