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
    private static let fetchRequestUserByIDAttributeName = "id"
    
    static func findOrInsertUserWith(id: String, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            assertionFailure("Model is not available in context")
            return nil
        }
        var user: User?
        let fetchRequest = User.fetchRequestUserBy(id: id, model: model)
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch User with id: \(id) \(error)")
        }
        if user == nil {
            user = User.insertUserWith(id: id, in: context)
        }
        return user
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
