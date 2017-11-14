//
//  ConversationStorageService.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 12/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import CoreData

protocol IConversationStorageService: class {
    func getUserNameForConversationWith(conversationID: String) -> String?
    func isOnline(conversationID: String) -> Bool
    func markAsReadConversationWith(id: String)
    var mainContext: NSManagedObjectContext { get }
}

class ConversationStorageService: IConversationStorageService {
    private let storageManager: IStorageManager
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    var mainContext: NSManagedObjectContext {
        return storageManager.mainContext
    }
    
    func markAsReadConversationWith(id: String) {
        storageManager.handleReadConversationWith(id: id)
    }
    
    func isOnline(conversationID: String) -> Bool {
        return storageManager.isOnline(conversationID: conversationID)
    }
    
    func getUserNameForConversationWith(conversationID: String) -> String? {
        return storageManager.getUserNameForConversationWith(conversationID: conversationID)
    }
}
