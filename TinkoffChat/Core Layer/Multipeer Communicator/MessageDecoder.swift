//
//  MessageDecoder.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IMessageDecoder: class {
    func getMessage(from data: Data) -> String?
}

class MessageDecoder: IMessageDecoder {
    private static let messageTextKey = "text"
    
    func getMessage(from data: Data) -> String? {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []),
            let peerMessage = json as? [String: String] {
            return peerMessage[MessageDecoder.messageTextKey]
        } else {
            return nil
        }
    }
}
