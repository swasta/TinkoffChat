//
//  ConversationsListModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ConversationsListModel: IConversationsListModel {
    weak var delegate: IConversationsListModelDelegate?
    
    private let communicationService: ICommunicationService
    
    private static let defaultUserName = "Unknown"
    
    private var conversations = [ConversationViewModel]() {
        didSet {
            delegate?.setup(dataSource: conversations)
        }
    }
    
    init(communicationService: ICommunicationService) {
        self.communicationService = communicationService
    }
    
    func resumeListeningToCommunicationService() {
        communicationService.delegate = self
    }
    
    private func descendingDateAscendingNames(conversation1: ConversationViewModel,
                                              conversation2: ConversationViewModel) -> Bool {
        if let date1 = conversation1.lastMessageDate, let date2 = conversation2.lastMessageDate {
            return date1 > date2
        } else if conversation1.lastMessageDate == nil && conversation2.lastMessageDate != nil {
            return false
        } else if conversation2.lastMessageDate == nil && conversation1.lastMessageDate != nil {
            return true
        } else if conversation1.userName < conversation2.userName {
            return true
        } else {
            return false
        }
    }
    
    private func getConversationWith(userID: String) -> ConversationViewModel? {
        return conversations.filter {$0.id == userID}.first
    }
}

extension ConversationsListModel: ICommunicationServiceDelegate {
    func didFindUser(userID: String, userName: String?) {
        if let pastConversation = getConversationWith(userID: userID) {
            pastConversation.isOnline = true
            delegate?.setup(dataSource: conversations)
        } else {
            let newConversation = ConversationViewModel(id: userID, userName: userName ?? ConversationsListModel.defaultUserName)
            conversations.append(newConversation)
        }
    }
    
    func didLoseUser(userID: String) {
        guard let pastConversation = getConversationWith(userID: userID) else {
            return
        }
        pastConversation.isOnline = false
        delegate?.setup(dataSource: conversations)
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        guard let pastConversation = getConversationWith(userID: fromUser) else {
            assertionFailure("received message from unknown user")
            return
        }
        let receivedMessage = MessageViewModel(withText: text, date: Date().formattedForMessage(), type: .incoming)
        pastConversation.append(receivedMessage)
        pastConversation.markAs(.unread)
        delegate?.setup(dataSource: conversations)
    }
}
