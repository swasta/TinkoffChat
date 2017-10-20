//
//  MessageSerializer.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 19/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class MessageSerializer {
    private static let messageEventTypeKey = "eventType"
    private static let messageEventTypeDescription = "TextMessage"
    private static let messageIdKey = "messageId"
    private static let messageTextKey = "text"
    
    func serializeMessageWith(_ text: String) throws -> Data  {
        let message = [MessageSerializer.messageEventTypeKey: MessageSerializer.messageEventTypeDescription,
                       MessageSerializer.messageIdKey: IdentifierGenerator.generateIdentifier(),
                       MessageSerializer.messageTextKey: text]
        return try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
    }
    
    func deserializeMessageFrom(_ data: Data) throws -> String? {
        let peerMessage =  try JSONSerialization.jsonObject(with: data, options:[] ) as? [String: String]
        return peerMessage?[MessageSerializer.messageTextKey]
    }
}
