//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class Conversation {
    let id: String
    let name: String?
    var messages = [Message]()
    var isOnline: Bool
    
    var hasUnreadMessages: Bool {
        return messages.filter { !$0.isRead }.count > 0
    }
    
    var lastMessageDate: Date? {
        return messages.last?.date
    }
    
    init(id: String, name: String?, isOnline: Bool) {
        self.id = id
        self.name = name
        self.isOnline = isOnline
    }
    
    func append(_ message: Message) {
        messages.append(message)
    }
}
