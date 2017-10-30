//
//  MessageEncoder.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IMessageEncoder {
    func prepareForSend(text: String) -> Data?
}

class MessageEncoder: IMessageEncoder {
    private static let messageEventTypeKey = "eventType"
    private static let messageEventTypeDescription = "TextMessage"
    private static let messageIdKey = "messageId"
    private static let messageTextKey = "text"
    
    func prepareForSend(text: String) -> Data? {
        let message = [MessageEncoder.messageEventTypeKey: MessageEncoder.messageEventTypeDescription,
                       MessageEncoder.messageIdKey: IdentifierGenerator.generateIdentifier(),
                       MessageEncoder.messageTextKey: text]
        do {
            let messageData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            return messageData
        } catch {
            print("Error creating message json: \(error.localizedDescription)")
        }
        return nil
    }
}
