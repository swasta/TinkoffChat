//
//  MessageHandler.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

protocol IMessageHandler {
    func prepareForSend(text: String) -> Data?
    func getMessage(from data: Data) -> String?
}

class MessageHandler: IMessageHandler {
    private let encoder: IMessageEncoder
    private let decoder: IMessageDecoder
    
    init(encoder: IMessageEncoder, decoder: IMessageDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }
    
    func prepareForSend(text: String) -> Data? {
        return encoder.prepareForSend(text: text)
    }
    
    func getMessage(from data: Data) -> String? {
        return decoder.getMessage(from: data)
    }
}
