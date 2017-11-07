//
//  AppUser.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 03/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData
import UIKit

extension AppUser {
    private static let fetchRequestAppUserTemplateName = "AppUser"
    private static let appUserDefaultID = UIDevice.current.identifierForVendor!.uuidString
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            preconditionFailure("Model is not available in context")
            
        }
        var foundAppUser: AppUser?
        
        let fetchRequest = AppUser.fetchRequestAppUser(model: model)
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found")
            foundAppUser = results.first
        } catch {
            print("Failed to fetch AppUser \(error)")
        }
        return foundAppUser ?? AppUser.insertAppUser(in: context)
    }
    
    private static func insertAppUser(in context: NSManagedObjectContext) -> AppUser {
        let appUser = AppUser(context: context)
        appUser.currentUser = User.findOrInsertUserWith(id: appUserDefaultID, in: context)
        return appUser
    }
    
    private static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser> {
        guard let fetchRequest = model.fetchRequestTemplate(forName: fetchRequestAppUserTemplateName) as? NSFetchRequest<AppUser> else {
            preconditionFailure("No template with \(fetchRequestAppUserTemplateName) name")
        }
        return fetchRequest
    }
}
