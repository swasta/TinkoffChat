//
//  Message.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class Message {
    let type: MessageType
    let text: String
    let date: Date
    private(set) var isRead = false
    
    init(with text: String, date: Date, type: MessageType) {
        self.text = text
        self.date = date
        self.type = type
    }
    
    func markAsRead() {
        isRead = true
    }
}
