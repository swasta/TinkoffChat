//
//  RootAssembly.swift
//  TinkoffChat
//
//  Created by Nikita Borodulin on 27/10/2017.
//  Copyright © 2017 com.nikitaborodulin. All rights reserved.
//

import Foundation

class RootAssembly {
    // This service is used by each module of the app to keep only one communicator on the Core layer, therefore made static.
    private static let communicationService: ICommunicationService = {
        let communicator = MultipeerCommunicator(MessageHandler(encoder: MessageEncoder(), decoder: MessageDecoder()))
        let communicationService = CommunicationService(communicator)
        communicator.delegate = communicationService
        return communicationService
    }()

    static let conversationsListAssembly: ConversationsListAssembly = {
        let conversationsListAssembly = ConversationsListAssembly(communicationService)
        return conversationsListAssembly
    }()

    static let conversationAssembly: ConversationAssembly = {
        let communicationAssembly = ConversationAssembly(communicationService)
        return communicationAssembly
    }()

    static let profileAssembly = ProfileAssembly()
}
