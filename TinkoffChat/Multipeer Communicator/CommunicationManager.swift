//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol CommunicationManagerDelegate: class {
    func updateUI()
}

class CommunicationManager {
    weak var delegate: CommunicationManagerDelegate?
    
    private let multipeerCommunicator: MultipeerCommunicator
    private var conversations = [Conversation]()
    
    init(with communicator: MultipeerCommunicator) {
        self.multipeerCommunicator = communicator
        multipeerCommunicator.delegate = self
    }
    
    private func getConversationFor(_ userID: String) -> Conversation? {
        return conversations.filter { $0.id == userID }.first
    }
    
    // MARK: - API
    
    func getConversations(online: Bool) -> [Conversation] {
        return conversations.filter { $0.isOnline == online }
    }
    
    func enableCommunicationServices(_ flag: Bool) {
        multipeerCommunicator.online = flag
    }
    
    func sendMessage(text: String, to conversation: Conversation) {
        let message = Message(with: text, date: Date(), type: .outgoing)
        message.markAsRead()
        conversation.append(message)
        multipeerCommunicator.sendMessage(string: text, to: conversation.id, completionHandler: nil)
        delegate?.updateUI()
    }
}

extension CommunicationManager: CommunicatorDelegate {
    func didFindUser(userID: String, userName: String?) {
        if let conversation = getConversationFor(userID) {
            conversation.isOnline = true
        } else {
            let conversation = Conversation(id: userID, name: userName, isOnline: true)
            conversations.append(conversation)
        }
        delegate?.updateUI()
    }
    
    func didLoseUser(userID: String) {
        if let conversation = getConversationFor(userID) {
            conversation.isOnline = false
            delegate?.updateUI()
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if let conversation = getConversationFor(fromUser) {
            let message = Message(with: text, date: Date(), type: .incoming)
            conversation.append(message)
            delegate?.updateUI()
        }
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print("\(error)")
    }
    
    func failedToStartAdvertising(error: Error) {
        print("\(error)")
    }
}
