//
//  User.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 03/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData

extension User {
    private static let fetchRequestUserByIDTemplateName = "UserByID"
    private static let fetchRequestUserByIDAttributeName = "userID"
    
    static func findOrInsertUserWith(id: String, in context: NSManagedObjectContext) -> User {
        if let fetchedUser = fetchUserWith(id: id, in: context) {
            return fetchedUser
        } else {
            let newUser = User.insertUserWith(id: id, in: context)
            return newUser
        }
    }
    
    private static func fetchUserWith(id: String, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            preconditionFailure("Model is not available in context")
        }
        let fetchRequest = User.fetchRequestUserBy(id: id, model: model)
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found")
            return results.first
        } catch {
            fatalError("Failed to fetch User with id: \(id) \(error)")
        }
    }
    
    private static func insertUserWith(id: String, in context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.userID = id
        return user
    }
    
    private static func fetchRequestUserBy(id: String, model: NSManagedObjectModel) -> NSFetchRequest<User> {
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: fetchRequestUserByIDTemplateName, substitutionVariables: [fetchRequestUserByIDAttributeName: id]) as? NSFetchRequest<User> else {
            preconditionFailure("No template with \(fetchRequestUserByIDTemplateName) name")
        }
        return fetchRequest
    }
}
