//
//  CommunicationService.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol ICommunicationService: class {
    func sendMessage(text: String, to userID: String)
}

class CommunicationService: ICommunicationService {
    private let communicator: ICommunicator
    private let storageManager: IStorageManager
    
    init(_ communicator: ICommunicator, _ storageManager: IStorageManager) {
        self.communicator = communicator
        self.storageManager = storageManager
        self.storageManager.setAllConversationsOffline()
    }
    
    // MARK: - API
    
    func sendMessage(text: String, to userID: String) {
        do {
            try communicator.sendMessage(text: text, to: userID)
            storageManager.handleSentMessageWith(text: text, toConversationWithID: userID)
        } catch MultipeerCommunicator.MultipeerCommunicatorError.communicatorInternalError {
            print("Multipeer internal error")
        } catch MultipeerCommunicator.MultipeerCommunicatorError.communicatorMessageEncodingError {
            print("Failed to encode message with text: \(text)")
        } catch {
            print("Unknown error sending message \(error)")
        }
    }
}

// MARK: - ICommunicationServiceDelegate

extension CommunicationService: ICommunicatorDelegate {
    func didFindUser(userID: String, userName: String?) {
        storageManager.handleFoundUserWith(id: userID, userName: userName)
    }
    
    func didLoseUser(userID: String) {
        storageManager.handleLostUserWith(id: userID)
    }
    
    func didReceiveMessage(text: String, fromUser sender: String, toUser receiver: String) {
        
        storageManager.handleReceivedMessageWith(text: text, fromUserID: sender)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        fatalError("\(error)")
    }
    
    func failedToStartAdvertising(error: Error) {
        fatalError("\(error)")
    }
}
