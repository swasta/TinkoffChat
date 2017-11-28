//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 02/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation
import CoreData

protocol ICoreDataStack: class {
    var saveContext: NSManagedObjectContext { get }
    var mainContext: NSManagedObjectContext { get }
    var masterContext: NSManagedObjectContext { get }
    func performSave(in context: NSManagedObjectContext, completionHandler: (() -> Void)?)
}

class CoreDataStack: ICoreDataStack {
    // MARK: - API
    lazy var masterContext: NSManagedObjectContext = {
        let masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = persistentStoreCoordinator
        masterContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        masterContext.undoManager = nil
        return masterContext
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = masterContext
        mainContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        mainContext.undoManager = nil
        return mainContext
    }()
    
    lazy var saveContext: NSManagedObjectContext = {
        let saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = mainContext
        saveContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        saveContext.undoManager = nil
        return saveContext
    }()
    
    func performSave(in context: NSManagedObjectContext, completionHandler: (() -> Void)?) {
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                }
                if let parent = context.parent {
                    self.performSave(in: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
            } else {
                completionHandler?()
            }
        }
    }
    
    // MARK: - Private properties
    
    private static let modelName = "Model"
    
    private var persistentStoreURL: URL {
        let storeName = "\(CoreDataStack.modelName).sqlite"
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectoryURL.appendingPathComponent(storeName)
    }
    
    private let managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: CoreDataStack.modelName, withExtension: "momd") else {
            fatalError("Error getting model url")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: persistentStoreURL,
                                                              options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        return persistentStoreCoordinator
    }()
}
