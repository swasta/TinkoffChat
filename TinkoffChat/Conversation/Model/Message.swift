//
//  Message.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 06/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

struct Message {
    enum MessageType {
        case incoming
        case outgoing
    }
    let type: MessageType
    let text: String
}
