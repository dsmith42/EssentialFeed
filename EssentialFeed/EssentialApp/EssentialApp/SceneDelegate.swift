//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Dan Smith on 20/06/2022.
//

import UIKit
import Combine
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	private lazy var httpClient: HTTPClient = {
		URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
	}()

	private lazy var feedStore: FeedStore & FeedImageDataStore = {
		try! CoreDataFeedStore.init(
			storeURL: NSPersistentContainer
				.defaultDirectoryURL()
				.appendingPathComponent("feed-store.sqlite"))
	}()

	private lazy var localFeedLoader: LocalFeedLoader = {
		LocalFeedLoader(store: feedStore, currentDate: Date.init)
	}()

	private lazy var navigationController = UINavigationController(
			rootViewController: FeedUIComposer.feedComposedWith(
				feedLoader: makeRemoteFeedLoaderWithLocalFallback,
				imageLoader: makeLocalImageLoaderWithRemoteFallback,
				selection: showComments))

	private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!

	convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore) {
		self.init()
		self.httpClient = httpClient
		self.feedStore = store
	}

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let scene = (scene as? UIWindowScene) else { return }

		window = UIWindow(windowScene: scene)

		configureWindow()
	}

	func configureWindow() {
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
	}

	func sceneWillResignActive(_ scene: UIScene) {
		localFeedLoader.validateCache { _ in }
	}

	private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<[FeedImage], Error> {
		let remoteURL = baseURL.appendingPathComponent("/v1/feed")
		return httpClient.getPublisher(url: remoteURL)
			.tryMap(FeedItemsMapper.map)
			.caching(to: localFeedLoader)
			.fallback(to: localFeedLoader.loadPublisher)
	}

	private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
		let localImageLoader = LocalFeedImageDataLoader(store: feedStore)
		return localImageLoader
			.loadImageDataPublisher(from: url)
			.fallback(to: { [httpClient] in
				httpClient
					.getPublisher(url: url)
					.tryMap(FeedImageDataMapper.map)
					.caching(to: localImageLoader, using: url)
			})
	}

	private func showComments(for image: FeedImage) {
		let url = baseURL.appendingPathComponent("/v1/image/\(image.id)/comments")
		let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
		navigationController.pushViewController(comments, animated: true)
	}

	private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
		return { [httpClient] in
			return httpClient
				.getPublisher(url: url)
				.tryMap(ImageCommentsMapper.map)
				.eraseToAnyPublisher()
		}
	}

}
