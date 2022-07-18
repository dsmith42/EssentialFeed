//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Dan Smith on 20/06/2022.
//

import UIKit
import EssentialFeed
import EssentialFeediOS
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let _ = (scene as? UIWindowScene) else { return }

		let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

		let session = URLSession(configuration: .ephemeral)
		let remoteClient = URLSessionHTTPClient(session: session)
		let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
		let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)

		let localStoreURL = NSPersistentContainer
			.defaultDirectoryURL()
			.appendingPathComponent("feed-store.sqlite")

		let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
		let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
		let localImageLoader = LocalFeedImageDataLoader(store: localStore)

		let feedloaderComposite = FeedLoaderWithFallbackComposite(primary: remoteFeedLoader, fallback: localFeedLoader)
		let feedImageLoaderComposite = FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader, fallback: remoteImageLoader)

		window?.rootViewController = FeedUIComposer.feedComposedWith(feedLoader: feedloaderComposite, imageLoader: feedImageLoaderComposite)
	}

}

