//
//  Message.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 29/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class MessageViewModel {
    enum MessageType {
        case incoming
        case outgoing
    }
    
    let type: MessageType
    let text: String
    let date: String
    
    init(with text: String, date: String, type: MessageType) {
        self.text = text
        self.date = date
        self.type = type
    }
}
