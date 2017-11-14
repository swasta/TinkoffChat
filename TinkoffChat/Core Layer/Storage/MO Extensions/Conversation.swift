//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 10/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData

extension Conversation {
    private static let fetchRequestConversationByIDTemplateName = "ConversationByID"
    private static let fetchRequestConversationByIDAttributeName = "conversationID"
    
    static func findOrInsertConversationWith(id: String, in context: NSManagedObjectContext) -> Conversation {
        if let fetchedConversation = fetchConversationWith(id: id, in: context) {
            return fetchedConversation
        } else {
            let newConversation = Conversation.insertConversationWith(id: id, in: context)
            return newConversation
        }
    }
    
    private static func fetchConversationWith(id: String, in context: NSManagedObjectContext) -> Conversation? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            preconditionFailure("Model is not available in context")
        }
        let fetchRequest = Conversation.fetchRequestConversationBy(id: id, model: model)
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple Conversations found for id: \(id)")
            return results.first
        } catch {
            fatalError("Failed to fetch User with id: \(id) \(error)")
        }
    }
    
    private static func insertConversationWith(id: String, in context: NSManagedObjectContext) -> Conversation {
        let newConversation = Conversation(context: context)
        newConversation.conversationID = id
        return newConversation
    }
    
    private static func fetchRequestConversationBy(id: String, model: NSManagedObjectModel) -> NSFetchRequest<Conversation> {
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: fetchRequestConversationByIDTemplateName, substitutionVariables: [fetchRequestConversationByIDAttributeName: id]) as? NSFetchRequest<Conversation> else {
            preconditionFailure("No template with \(fetchRequestConversationByIDTemplateName) name")
        }
        return fetchRequest
    }
}
