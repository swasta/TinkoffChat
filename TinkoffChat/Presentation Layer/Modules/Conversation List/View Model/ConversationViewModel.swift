//
//  ConversationViewModel.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 29/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class ConversationViewModel {
    enum State {
        case read
        case unread
    }
    let id: String
    let userName: String
    var isOnline = true
    private(set) var messages = [MessageViewModel]()
    private(set) var hasUnreadMessages = true
    
    var lastMessageDate: String? {
        return messages.last?.date
    }
    
    init(id: String, userName: String) {
        self.id = id
        self.userName = userName
    }
    
    func append(_ message: MessageViewModel) {
        messages.append(message)
    }
    
    func markAs(_ state: State) {
        switch state {
        case .read:
            hasUnreadMessages = false
        case .unread:
            hasUnreadMessages = true
        }
    }
}
