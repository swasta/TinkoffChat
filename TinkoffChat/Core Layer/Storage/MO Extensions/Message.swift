//
//  Message.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 12/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData

extension Message {
    private static let fetchRequestMessageByIDTemplateName = "MessagesByConversationID"
    private static let fetchRequestMessageByIDAttributeName = "id"
    
    static func fetchRequestMessage(withConversationID conversationID: String, in context: NSManagedObjectContext) -> NSFetchRequest<Message> {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            preconditionFailure("Model is not available in context")
        }
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: fetchRequestMessageByIDTemplateName, substitutionVariables: [fetchRequestMessageByIDAttributeName: conversationID]) as? NSFetchRequest<Message> else {
            preconditionFailure("No template with \(fetchRequestMessageByIDTemplateName) name")
        }
        return fetchRequest
    }
}
