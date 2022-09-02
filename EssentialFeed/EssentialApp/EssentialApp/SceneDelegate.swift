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
		let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
		
		let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: httpClient)
		let remoteImageLoader = RemoteFeedImageDataLoader(client: httpClient)
		
		let localFeedLoader = LocalFeedLoader(store: feedStore, currentDate: Date.init)
		let localImageLoader = LocalFeedImageDataLoader(store: feedStore)
		
		window?.rootViewController = UINavigationController(
			rootViewController: FeedUIComposer.feedComposedWith(
				feedLoader: FeedLoaderWithFallbackComposite(
					primary: FeedLoaderCacheDecorator(decoratee: remoteFeedLoader,
																						cache: localFeedLoader),
					fallback: localFeedLoader),
				imageLoader: FeedImageDataLoaderWithFallbackComposite(
					primary: localImageLoader,
					fallback: FeedImageDataLoaderDecorator(decoratee: remoteImageLoader,
																								 cache: localImageLoader))))
		window?.makeKeyAndVisible()
	}
	
	func sceneWillResignActive(_ scene: UIScene) {
		localFeedLoader.validateCache { _ in }
	}
}
