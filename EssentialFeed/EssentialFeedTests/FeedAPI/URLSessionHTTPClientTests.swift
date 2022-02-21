//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Dan Smith on 20/02/2022.
//

import XCTest
import EssentialFeed

protocol HTTPSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask
}

protocol HTTPSessionTask {
    func resume()
}

class URLSessionHTTPClient {
    private let session: HTTPSession

    init(session: HTTPSession) {
        self.session = session
    }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "https://any-url.com")!
        let session = HTTPSessionSpy()
        let task = HTTPSessionTaskSpy()
        session.stub(url: url, task: task)

        let sut = URLSessionHTTPClient(session: session)

        sut.get(from: url) { _ in }

        XCTAssertEqual(task.resumeCallCount, 1)
    }

    func test_getFromURL_failsOnRequestError() throws {
        let url = URL(string: "https://any-url.com")!
        let session = HTTPSessionSpy()
        let error = NSError(domain: "An Error", code: 1)
        session.stub(url: url, error: error)

        let sut = URLSessionHTTPClient(session: session)

        let exp = expectation(description: "Wait for completion.")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("Expected failure with error: \(error), but got \(result) instead.")
            }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }

    // MARK: - Helpers

    private class HTTPSessionSpy: HTTPSession {
        private var stubs = [URL: Stub]()

        private struct Stub {
            let task: HTTPSessionTask
            let error: Error?
        }

        func stub(url: URL, task: HTTPSessionTask = FakeHTTPSessionTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }

        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> HTTPSessionTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }

    private class FakeHTTPSessionTask: HTTPSessionTask {
        func resume() {}
    }

    private class HTTPSessionTaskSpy: HTTPSessionTask {
        var resumeCallCount = 0

        func resume() {
            resumeCallCount += 1
        }
    }

}
