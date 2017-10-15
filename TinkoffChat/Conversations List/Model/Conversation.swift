//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    var messages: [Message]
    var isOnline: Bool
    var hasUnreadMessages: Bool
    var lastMessageDate: Date?
}
