//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 28/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ConversationModel: IConversationModel {
    weak var delegate: IConversationModelDelegate?
    let communicationService: ICommunicationService
    
    private let conversation: ConversationViewModel
    
    var isEmpty: Bool {
        return conversation.messages.isEmpty
    }
    
    var userName: String {
        return conversation.userName
    }
    
    init(communicationService: ICommunicationService, conversation: ConversationViewModel) {
        self.communicationService = communicationService
        self.conversation = conversation
    }
    
    func markConversationAsRead() {
        conversation.markAs(.read)
    }
    
    func send(message: String, completionHandler: (() -> ())?) {
        communicationService.sendMessage(text: message, to: conversation.id) { [unowned self] (success: Bool, error: Error?) in
            switch error {
            case let error?:
                fatalError("Failed to send message: \(error)")
            case nil:
                if success {
                    let sentMessage = MessageViewModel(with: message, date: Date().formattedForMessage(), type: .outgoing)
                    self.conversation.append(sentMessage)
                } else {
                    fatalError("Failed to send message: unknown error")
                }
            }
            completionHandler?()
            self.delegate?.setup(dataSource: self.conversation.messages)
        }
    }
}

extension ConversationModel: ICommunicationServiceDelegate {
    func didFindUser(userID: String, userName: String?) {
        if conversation.id == userID {
            delegate?.userChangesStatusTo(online: true)
        }
    }
    
    func didLoseUser(userID: String) {
        if conversation.id == userID {
            delegate?.userChangesStatusTo(online: false)
        }
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        if conversation.id == fromUser {
            conversation.append(MessageViewModel(with: text, date: Date().formattedForMessage(), type: .incoming))
            delegate?.setup(dataSource: conversation.messages)
        }
    }
}
