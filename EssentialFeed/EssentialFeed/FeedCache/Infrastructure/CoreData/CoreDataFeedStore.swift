//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Dan Smith on 27/03/2022.
//

import CoreData

public final class CoreDataFeedStore {
	private let container: NSPersistentContainer
	private let context: NSManagedObjectContext
	
	public init(storeURL url: URL) throws {
		let bundle = Bundle(for: CoreDataFeedStore.self)
		container = try NSPersistentContainer.load(url: url, modelName: "FeedStore", in: bundle)
		context = container.newBackgroundContext()
	}
	
	func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
		let context = self.context
		context.perform { action(context) }
	}
}
