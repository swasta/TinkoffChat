//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 05/11/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import UIKit
import CoreData

protocol IStorageManager: class {
    func loadProfile(completionHandler: @escaping (ProfileStorageModel) -> Void)
    func save(profileStorageModel: ProfileStorageModel, completionHandler: @escaping () -> Void)
    func handleFoundUserWith(id: String, userName: String?)
    func handleLostUserWith(id: String)
    func handleSentMessageWith(text: String, toConversationWithID conversationID: String)
    func handleReceivedMessageWith(text: String, fromUserID: String)
    func handleReadConversationWith(id: String)
    func getUserNameForConversationWith(conversationID: String) -> String?
    func isOnline(conversationID: String) -> Bool
    func setAllConversationsOffline()
    var mainContext: NSManagedObjectContext { get }
}

class StorageManager: IStorageManager {
    private let coreDataStack: ICoreDataStack
    private let identifierGenerator: IIdentifierGenerator
    
    init(_ coreDataStack: ICoreDataStack, _ identifierGenerator: IIdentifierGenerator) {
        self.coreDataStack = coreDataStack
        self.identifierGenerator = identifierGenerator
    }
    
    // MARK: - API
    
    var mainContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    func getUserNameForConversationWith(conversationID: String) -> String? {
        let user = User.findOrInsertUserWith(id: conversationID, in: coreDataStack.mainContext)
        return user.name
    }
    
    func isOnline(conversationID: String) -> Bool {
        let conversation = Conversation.findOrInsertConversationWith(id: conversationID, in: coreDataStack.mainContext)
        return conversation.isOnline
    }
    
    func setAllConversationsOffline() {
        let masterContext = coreDataStack.masterContext
        masterContext.performAndWait {
            let asyncBatchUpdateRequest = NSBatchUpdateRequest(entity: Conversation.entity())
            asyncBatchUpdateRequest.propertiesToUpdate = ["isOnline": NSNumber(value: false)]
            asyncBatchUpdateRequest.resultType = .updatedObjectIDsResultType
            do {
                guard let objectIDsResult = try masterContext.execute(asyncBatchUpdateRequest) as? NSBatchUpdateResult else {
                    assertionFailure("Failed batch updating for conversations")
                    return
                }
                guard let objectIDs = objectIDsResult.result as? [NSManagedObjectID] else {
                    assertionFailure("Wrong type of NSBatchResult was expected")
                    return
                }
                let mainContext = self.coreDataStack.mainContext
                mainContext.performAndWait {
                    for objectID in objectIDs {
                        let object = mainContext.object(with: objectID)
                        mainContext.refresh(object, mergeChanges: true)
                    }
                    self.coreDataStack.performSave(in: mainContext, completionHandler: nil)
                }
            } catch {
                print("Failed batch updating for conversations")
            }
        }
    }
    
    // MARK: User
    
    func handleFoundUserWith(id: String, userName: String?) {
        print("Handling found user!")
        let saveContext = self.coreDataStack.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversationWith(id: id, in: saveContext)
            conversation.isOnline = true
            let user = User.findOrInsertUserWith(id: id, in: saveContext)
            user.name = userName
            user.isOnline = true
            user.conversation = conversation
            conversation.participant = user
            self.coreDataStack.performSave(in: saveContext, completionHandler: nil)
        }
    }
    
    func handleLostUserWith(id: String) {
        print("Handling lost user!")
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let user = User.findOrInsertUserWith(id: id, in: saveContext)
            user.isOnline = false
            let conversation = Conversation.findOrInsertConversationWith(id: id, in: saveContext)
            conversation.isOnline = false
            self.coreDataStack.performSave(in: saveContext, completionHandler: nil)
        }
    }
    
    // MARK: Message
    
    func handleSentMessageWith(text: String, toConversationWithID conversationID: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let message = self.createMessageWith(text: text, in: saveContext)
            message.isOutgoing = true
            let conversation = Conversation.findOrInsertConversationWith(id: conversationID, in: saveContext)
            message.conversation = conversation
            conversation.addToMessages(message)
            conversation.lastMessage = message
            self.coreDataStack.performSave(in: saveContext, completionHandler: nil)
        }
    }
    
    func handleReceivedMessageWith(text: String, fromUserID: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversationWith(id: fromUserID, in: saveContext)
            let message = self.createMessageWith(text: text, in: saveContext)
            message.isOutgoing = false
            message.conversation = conversation
            conversation.lastMessage = message
            conversation.isUnread = true
            conversation.addToMessages(message)
            self.coreDataStack.performSave(in: saveContext, completionHandler: nil)
        }
    }
    
    // MARK: Conversation
    
    func handleReadConversationWith(id: String) {
        let saveContext = coreDataStack.saveContext
        saveContext.perform {
            let conversation = Conversation.findOrInsertConversationWith(id: id, in: saveContext)
            conversation.isUnread = false
            self.coreDataStack.performSave(in: saveContext, completionHandler: nil)
        }
    }
    
    // MARK: Profile
    
    func loadProfile(completionHandler: @escaping (ProfileStorageModel) -> Void) {
        let masterContext = coreDataStack.masterContext
        let mainContext = coreDataStack.mainContext
        masterContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: masterContext)
            guard let currentUser = appUser.currentUser else {
                assertionFailure("Failed to find or create a current user")
                return
            }
            let currentUserObjectID = currentUser.objectID
            mainContext.perform {
                guard let currentUser = mainContext.object(with: currentUserObjectID) as? User else {
                    assertionFailure("Failed to get current user from master contexr")
                    return
                }
                var profileImage: UIImage?
                if let imageData = currentUser.profileImage {
                    profileImage = UIImage(data: imageData)
                }
                let profile = ProfileStorageModel(name: currentUser.name, userInfo: currentUser.info, profileImage: profileImage)
                completionHandler(profile)
            }
        }
    }
    
    func save(profileStorageModel: ProfileStorageModel, completionHandler: @escaping () -> Void) {
        let masterContext = coreDataStack.masterContext
        masterContext.perform {
            let appUser = AppUser.findOrInsertAppUser(in: masterContext)
            guard let currentUser = appUser.currentUser else {
                assertionFailure("Failed to find or create a current user")
                return
            }
            currentUser.name = profileStorageModel.name
            currentUser.info = profileStorageModel.userInfo
            if let profileImage = profileStorageModel.profileImage {
                currentUser.profileImage = UIImageJPEGRepresentation(profileImage, 1.0)
            }
            self.coreDataStack.performSave(in: masterContext, completionHandler: completionHandler)
        }
    }
    
    // MARK: - Private methods
    
    func createMessageWith(text: String, in context: NSManagedObjectContext) -> Message {
        let message = Message(context: context)
        message.messageID = identifierGenerator.generateIdentifier()
        message.date = Date()
        message.text = text
        return message
    }
}
