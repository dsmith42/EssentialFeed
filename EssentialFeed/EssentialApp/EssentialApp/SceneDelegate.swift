//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Dan Smith on 20/06/2022.
//

import os
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

	private lazy var logger = Logger(subsystem: "com.dsmith42.EssentialFeediOS", category: "main")

	private lazy var feedStore: FeedStore & FeedImageDataStore = {
		do {
			return try CoreDataFeedStore.init(
				storeURL: NSPersistentContainer
					.defaultDirectoryURL()
					.appendingPathComponent("feed-store.sqlite"))
		} catch {
			assertionFailure("Failed to instantiate core data store with error: \(error.localizedDescription)")
			logger.fault("Failed to instantiate core data store with error: \(error.localizedDescription)")
			return NullStore()
		}
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

	private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
		makeRemoteFeedLoader()
			.caching(to: localFeedLoader)
			.fallback(to: localFeedLoader.loadPublisher)
			.map(makeFirstPage)
			.eraseToAnyPublisher()
	}


	private func makeRemoteLoadMoreLoader(last: FeedImage?) -> AnyPublisher<Paginated<FeedImage>, Error> {
		makeRemoteFeedLoader(after: last)
			.zip(localFeedLoader.loadPublisher())
			.map { (newItems, cachedItems) in
				(cachedItems + newItems, newItems.last)
			}.map(makePage)
			.caching(to: localFeedLoader)
	}

	private func makeRemoteFeedLoader(after: FeedImage? = nil) -> AnyPublisher<[FeedImage], Error> {
		let url = FeedEndpoint.get(after: after).url(baseURL: baseURL)

		return httpClient
			.getPublisher(url: url)
			.tryMap(FeedItemsMapper.map)
			.eraseToAnyPublisher()
	}

	private func makeFirstPage(items: [FeedImage]) -> Paginated<FeedImage> {
		makePage(items: items, last: items.last)
	}

	private func makePage(items: [FeedImage], last: FeedImage?) -> Paginated<FeedImage> {
		Paginated(items: items, loadMorePublisher: last.map { last in
			{ self.makeRemoteLoadMoreLoader(last: last) }
			})
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
		let url = ImageCommentsEndpoint.get(image.id).url(baseURL: baseURL)
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
