//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Dan Smith on 20/06/2022.
//

import UIKit
import CoreData
import EssentialFeed
import EssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	let localFeedStoreURL = NSPersistentContainer
		.defaultDirectoryURL()
		.appendingPathComponent("feed-store.sqlite")


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let _ = (scene as? UIWindowScene) else { return }

		let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

		let remoteClient = makeRemoteClient()
		let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
		let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

		let localStore = try! CoreDataFeedStore(storeURL: localFeedStoreURL)
		let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
		let localImageLoader = LocalFeedImageDataLoader(store: localStore)

		window?.rootViewController = FeedUIComposer.feedComposedWith(
			feedLoader: FeedLoaderWithFallbackComposite(
				primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader,
																					cache: localFeedLoader),
				fallback: localFeedLoader),
			imageLoader: FeedImageDataLoaderWithFallbackComposite(
				primary: localImageLoader,
				fallback: FeedImageDataLoaderDecorator(decoratee: remoteImageLoader,
																							 cache: localImageLoader)))
			}
	// MARK: - Helpers

	func makeRemoteClient() -> HTTPClient {
		return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
	}

}
